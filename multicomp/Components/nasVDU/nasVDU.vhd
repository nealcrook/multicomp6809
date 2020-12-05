-- memory-mapped VDU for NASCOM, driving VGA output
-- implements 2 different setups:
-- NASCOM 48 character x 16 row memory-mapped VDU (1Kbyte video RAM)
-- MAP80  80 character x 25 row memory-mapped VDU (2Kbyte video RAM)
--
-- In both cases, the character is 8 pixels wide by 16 scan lines high.
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
-- TODO how to map the character generator into the address space.
-- -> use "tools->megawizard plug-in manager" to create RAM that has
-- pre-initialised content.
-- TODO describe the VGA timing
-- TODO if 2 VGA outputs, allow them to be swapped so that it's OK
-- to attach a single display.
-- TODO generate debug signals to indicate when the char-gen
-- memories are being read; work out if the char-gen can easily be shared
-- between two render-engines, allowing dual VGA output.

--
-- NEXT:
-- add char gen write path?

--
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
		n_reset	: in  std_logic;
		clk    	: in  std_logic;

                video_map80vfc : in std_logic;

                addr    : in  std_logic_vector(10 downto 0); -- 2Kbytes address range
                n_nasCS : in  std_logic; -- NASCOM 1Kbyte video RAM
                n_mapCS : in  std_logic; -- MAP80 2Kbyte video RAM
                n_charGenCS : in  std_logic; -- 2Kbyte character gen space>> or need 4k??
		n_memWr : in  std_logic;
		dataIn	: in  std_logic_vector(7 downto 0);
		dataOut	: out std_logic_vector(7 downto 0);

		-- RGB video signals
		videoR0	: out std_logic;
		videoR1	: out std_logic;
		videoG0	: out std_logic;
		videoG1	: out std_logic;
		videoB0	: out std_logic;
		videoB1	: out std_logic;
		hSync  	: buffer  std_logic;
		vSync  	: buffer  std_logic
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

        signal  vgimmeChar : std_logic;
        signal  ngimmeChar : std_logic;

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

        -- route address to char gen based on which vdu is selected
        -- [NAC HACK 2020Nov30] implement arbitration scheme
        charAddr <= vcharAddr when video_map80vfc='1' else ncharAddr;

        -- route correct video signal out
        -- [NAC HACK 2020Nov30] later have 2 sets of outputs and only 1 "colour" out
        -- and make this swap them so that 1 or 2 external monitors could be used.
        vid_mux: process (video_map80vfc, vvideo, nvideo, vhSync, nhSync, vvSync, nvSync)
        begin
          if (video_map80vfc = '1') then
            videoR0 <= vvideo;
            videoR1 <= vvideo;
            videoG0 <= vvideo;
            videoG1 <= vvideo;
            videoB0 <= vvideo;
            videoB1 <= vvideo;
            hSync   <= vhSync;
            vSync   <= vvSync;
          else
            videoR0 <= nvideo;
            videoR1 <= nvideo;
            videoG0 <= nvideo;
            videoG1 <= nvideo;
            videoB0 <= nvideo;
            videoB1 <= nvideo;
            hSync   <= nhSync;
            vSync   <= nvSync;
          end if;
        end process;

-- COMMON CHARACTER GENERATOR
    fontRom : entity work.nasCharGenRom4K -- 4Kx8 for 256 characters x 16rows x 8pixels
      port map(
            clock => clk,

            address => charAddr, -- 12-bit: 8 (1-of-256 characters) + 4 (1-of-16 rows)
            q => charData
            );

-- RAM AND RENDER ENGINE FOR NASCOM 48x16 SCREEN
    nas_render : entity work.nasVDU_render
      generic map(
            HWCURSOR => FALSE,

            -- Uses 800x600 mode at half rats so that the effective clock
            -- is 25MHz, the same as the 80x25 mode.
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
            n_reset => n_reset,
            clk  => clk,

            -- memory access to video RAM
            addr        => addr(10 downto 0),
            n_CS        => n_nasCS,
            n_memWr     => n_memWr,
            dataIn      => dataIn,
            dataOut     => dataOutNas,

            -- access to shared character generator
            charAddr    => ncharAddr(11 downto 0),
            charData    => charData(7 downto 0),
            gimmeChar   => ngimmeChar,

            -- video signals
            hSync       => nhSync,
            vSync       => nvSync,
            video       => nvideo
            );


-- RAM AND RENDER ENGINE FOR MAP80 VFC 80x25 SCREEN
    vfc_render : entity work.nasVDU_render
      generic map(
            HWCURSOR => TRUE,

            -- 80x25 uses all the internal RAM
            -- This selects 640x400 rather than the default of 640x480
            DISPLAY_TOP_SCANLINE => 35,
            VERT_SCANLINES => 448,
            V_SYNC_ACTIVE => '1'
            )
      port map(
            n_reset => n_reset,
            clk  => clk,

            -- memory access to video RAM
            addr        => addr(10 downto 0),
            n_CS        => n_mapCS,
            n_memWr     => n_memWr,
            dataIn      => dataIn,
            dataOut     => dataOutMap,

            -- access to shared character generator
            charAddr    => vcharAddr(11 downto 0),
            charData    => charData(7 downto 0),
            gimmeChar   => vgimmeChar,

            -- video signals
            hSync       => vhSync,
            vSync       => vvSync,
            video       => vvideo
            );

end rtl;
