-- memory-mapped VDU for NASCOM, driving VGA output
-- implements 2 different setups:
-- NASCOM 48 character x 16 row memory-mapped VDU (1Kbyte video RAM)
-- MAP80  80 character x 25 row memory-mapped VDU (2Kbyte video RAM)
--
-- In both cases, the character is 8 pixels wide by 16 scan lines high.
--
-- VGA timing from http://tinyvga.com/vga-timing
--
-- This module provides 1K and 2K video RAM, with separate input selects,
-- so that both screens can co-exist without corruption.
--
-- There is 1 video output (or maybe two??) and an input select to switch
-- between them
--
-- A single character generator is used. It is a "ROM" pre-loaded with
-- the NAS-AN and NAS-GRA characters. Because ROMs in this FPGA technology
-- are simply pre-loaded RAMs, there is a write-path to the character
-- generator, allowing the character set to be replaced with the MAP
-- character set, or even reprogrammed on a character-by-character basis
-- (or, for example, to use the SARGON graphics).
--
-- TODO describe the VGA timing
-- TODO if 2 VGA outputs, allow them to be swapped so that it's OK
-- to attach a single display.


-- This code is derived from Grant Searle's SBCTextDisplayRGB for multicomp
-- (actually, derived from my version of that code that fixed a couple of
-- bugs and cleaned up the clocking somewhat).
-- foofoobedoo@gmail.com November 2020

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned.all;

entity nasVDU is
	port (
		n_reset	: in  std_logic; -- TODO remove
		clk    	: in  std_logic;

                video_map80vfc : in std_logic;

                -- 0: 256 characters are available
                -- 1: characters 128-255 are inverse-video versions of characters 0-127
                inv_map80vfc   : in std_logic;

                -- cursor control (VFC only)
                -- TODO: NOT CURRENTLY USED; WORK IN PROGRESS
                cursorAddr     : in std_logic_vector(11 downto 0);
                cursorStart    : in std_logic_vector(6 downto 0);
                cursorEnd      : in std_logic_vector(4 downto 0);

                -- use 12 bits (4K) to address character generator, 11 bits (2K) to address
                -- VFC video RAM and 10 bits (1K) to address NASCOM video RAM
                addr    : in  std_logic_vector(11 downto 0);
                n_nasCS : in  std_logic; -- NASCOM 1Kbyte video RAM
                n_mapCS : in  std_logic; -- MAP80 2Kbyte video RAM
                n_charGenCS : in  std_logic; -- select character generator (write-only)
		n_memWr : in  std_logic;
		dataIn	: in  std_logic_vector(7 downto 0);
		dataOut	: out std_logic_vector(7 downto 0);

		-- RGB video signals for Primary and Secondary output
		PriHsync: out std_logic;
		PriVsync: out std_logic; -- TODO previously the sync signals were defined as 'buffer'
		PriVideo: out std_logic;
		SecHsync: out std_logic;
		SecVsync: out std_logic;
		SecVideo: out std_logic
 );
end nasVDU;

architecture rtl of nasVDU is

	signal 	charAddr : std_logic_vector(11 downto 0);
	signal 	vcharAddr : std_logic_vector(11 downto 0);
	signal 	ncharAddr : std_logic_vector(11 downto 0);
	signal	charData : std_logic_vector(7 downto 0);

        signal  wren_charGen : std_logic;

        signal  dataOutMap : std_logic_vector(7 downto 0);
        signal  dataOutNas : std_logic_vector(7 downto 0);

        signal  ncharAccess : std_logic;

        signal  vvideo : std_logic;
        signal  nvideo : std_logic;

        signal  vvSync : std_logic;
        signal  nvSync : std_logic;

        signal  vhSync : std_logic;
        signal  nhSync : std_logic;

begin

        wren_charGen <= not(n_MemWr or n_charGenCS);

        -- route correct video RAM out for CPU read
        dataOut   <= dataOutMap when n_mapCS='0' else dataOutNas;

        -- Read-access to the character generator is shared between the NASCOM and MAP vdu render state
        -- machines. Both renderers supply an address; the read data is sent to both. Both renderers
        -- have a charAccess output and a charClash input.
        -- The NASCOM renderer has priority. Its charAccess output is asserted for 1 cycle to force
        -- the address MUX so its address goes to the character generator. Char data come out on the
        -- next cycle. Its charAccess output also goes to the charClash input of the MAP renderer.
        -- There, it is used to show that an access (if it co-incided) failed. In this case, the MAP
        -- renderer repeats its access on the next cycle.
        -- The charClash input to the NASCOM renderer is tied low, because it has priority.
        -- The charAccess output from the MAP renderer is unused.
        -- This works because each renderer accesses once per 8 pixels so neither can access on
        -- consecutive cycles.
        -- Both renderer use character generator data with the same timing, as though it was
        -- delayed by a clash. In other words:
        -- If the NASCOM renderer drives address on cycle N it will get data on N+1 and register it on
        -- N+2 but not use it until N+4.
        -- If the MAP renderer drives address on cycle P it will get data on P+1 (no clash) or
        -- P+2 (clash) and register it on P+2 or P+3 and use it on P+4.
        -- Write-access to the character generator from CPU when decoded at top-level; takes
        -- priority over vdu render and no arbitration so may see some "snow" during writes.
        charAddr <= addr when wren_charGen = '1' else ncharAddr when ncharAccess = '1' else vcharAddr;

        -- route correct video signal out
        -- [NAC HACK 2021Mar19] maybe allow same output on both monitors?
        vid_mux: process (video_map80vfc, vvideo, nvideo, vhSync, nhSync, vvSync, nvSync)
        begin
            if (video_map80vfc = '1') then
                PriHsync <= vhSync;
                PriVsync <= vvSync;
                PriVideo <= vvideo;
                SecHsync <= nhSync;
                SecVsync <= nvSync;
                SecVideo <= nvideo;
            else
                PriHsync <= nhsync;
                PriVsync <= nvsync;
                PriVideo <= nvideo;
                SecHsync <= vhsync;
                SecVsync <= vvsync;
                SecVideo <= vvideo;
            end if;
        end process;

-- COMMON CHARACTER GENERATOR
-- Initialised RAM created using "tools->megawizard plug-in manager"
    fontRom : entity work.nasCharGenRam4K -- 4Kx8 for 256 characters x 16rows x 8pixels
      port map(
            clock => clk,

            address => charAddr, -- 12-bit: 8 (1-of-256 characters) + 4 (1-of-16 rows)
            data => dataIn,      -- to reprogram character generator
            q => charData,
            wren => wren_charGen
            );

-- RAM AND RENDER ENGINE FOR NASCOM 48x16 SCREEN
    nas_render : entity work.nasVDU_render
      generic map(
            HWCURSOR => FALSE,

            -- Need 48*8 pixels horizontally, 16*16 lines ie 384pixels x 256 lines
            -- Use a 800x600@50MHz mode and use 2pixels x 2 lines for each native NASCOM
            -- pixel. CLOCKS_PER_PIXEL=2 does the horizontal doubling, VERT_PIXEL_SCANLINES=2
            -- does the vertical doubling.
            -- ..this is actually the 49.5MHz timing (not sure why, given that VGA also
            -- defines a 50MHz timing setup)
            -- http://tinyvga.com/vga-timing/800x600@75Hz
            VERT_CHARS => 16,
            HORIZ_CHARS => 48,
            HORIZ_STRIDE => 64, -- for NASCOM screen, stride of 64 locations per row
            HORIZ_OFFSET => 10, -- for NASCOM screen, ignore first 10 and last 6
            LINE_OFFSET => 15,  -- for NASCOM screen, offset by 15 lines so top line is line 16
            CLOCKS_PER_SCANLINE => 1056,
            DISPLAY_TOP_SCANLINE => 40+30, -- at least vfront+vsync+vback then pad to centralise display
            DISPLAY_LEFT_CLOCK => 240+2, -- (HSYNC + HBACK)*2
            VERT_SCANLINES => 625,
            VSYNC_SCANLINES => 3,
            HSYNC_CLOCKS => 80,
            VERT_PIXEL_SCANLINES => 2,
            H_SYNC_ACTIVE => '1',
            V_SYNC_ACTIVE => '1'
            )
      port map(
            clk  => clk,

            -- memory access to video RAM
            addr        => addr(10 downto 0),
            n_CS        => n_nasCS,
            n_memWr     => n_memWr,
            dataIn      => dataIn,
            dataOut     => dataOutNas,

            -- Characters 128-255 are inverse video versions of characters 0-127
            charInv     => '0',

            -- access to shared character generator
            charAddr    => ncharAddr(11 downto 0),
            charData    => charData(7 downto 0),
            charAccess  => ncharAccess,
            charClash   => '0',                -- nascom video has priority so never sees a clash

            -- video signals
            hSync       => nhSync,
            vSync       => nvSync,
            video       => nvideo
            );


-- RAM AND RENDER ENGINE FOR MAP80 VFC 80x25 SCREEN
    vfc_render : entity work.nasVDU_render
      generic map(
            HWCURSOR => TRUE,

            -- Need 80x8 pixels horizontally, 25*16 lines ie 640pixels x  400 lines
            -- Use a 640x400@25.175MHz mode
            -- Actual clock is 50MHz so have to double all the horizontal counts and
            -- set CLOCKS_PER_PIXEL=2.
            -- This selects 640x400 rather than the default of 640x480
            -- http://tinyvga.com/vga-timing/640x400@70Hz
            DISPLAY_TOP_SCANLINE => 35,
            VERT_SCANLINES => 448,
            V_SYNC_ACTIVE => '1'
            )
      port map(
            clk  => clk,

            -- memory access to video RAM
            addr        => addr(10 downto 0),
            n_CS        => n_mapCS,
            n_memWr     => n_memWr,
            dataIn      => dataIn,
            dataOut     => dataOutMap,

            -- Characters 128-255 are inverse video versions of characters 0-127
            charInv     => inv_map80vfc,

            -- access to shared character generator
            charAddr    => vcharAddr(11 downto 0),
            charData    => charData(7 downto 0),
            charClash   => ncharAccess,        -- signal that nascom video used the char gen

            -- video signals
            hSync       => vhSync,
            vSync       => vvSync,
            video       => vvideo
            );

end rtl;
