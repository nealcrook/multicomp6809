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
-- TODO describe the VGA timing
-- TODO if 2 VGA outputs, allow them to be swapped so that it's OK
-- to attach a single display.
--
-- NEXT:
-- - unpick attribute data. Keep RGB for now to aid testing on current PCB
-- - add memory-mapped read-write port
-- - instance 1K and 2K video RAM; common paths, separate chip selects
--   and (for efficient timing) separate read data output
-- - instance bigger char gen and change to 16 rows per character
-- - instance in chip top-level instead of old VDU; add files, replace
--   existing videoRAM, make sure sims still work.
-- - try on PCB: display will be corrupt becasue it's set up for 80x25
--   but it should display OK and show the char set OK. 



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
	generic(
		constant EXTENDED_CHARSET : integer := 1; -- 1 = 256 chars, 0 = 128 chars
		-- VGA 640x480 Default values
		constant VERT_CHARS : integer := 25;
		constant HORIZ_CHARS : integer := 80;
		constant CLOCKS_PER_SCANLINE : integer := 1600; -- NTSC/PAL = 3200
		constant DISPLAY_TOP_SCANLINE : integer := 35+40;
		constant DISPLAY_LEFT_CLOCK : integer := 288; -- NTSC/PAL = 600+
		constant VERT_SCANLINES : integer := 525; -- NTSC=262, PAL=312
		constant VSYNC_SCANLINES : integer := 2; -- NTSC/PAL = 4
		constant HSYNC_CLOCKS : integer := 192;  -- NTSC/PAL = 235
		constant VERT_PIXEL_SCANLINES : integer := 2; -- [NAC HACK 2020Nov21] for scan line duplication? but not quite
                                                              -- right.. maybe coz rows-per-character is effectively hard-coded
                                                              -- at 16. Want to add a constant for that and then reduce this to 1
		constant CLOCKS_PER_PIXEL : integer := 2; -- min = 2
		constant H_SYNC_ACTIVE : std_logic := '0';
		constant V_SYNC_ACTIVE : std_logic := '0';

		constant DEFAULT_ATT : std_logic_vector(7 downto 0) := "00001111" -- background iBGR | foreground iBGR (i=intensity)
	);
	port (
		n_reset	: in  std_logic;
		clk    	: in  std_logic;
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
		vSync  	: buffer  std_logic;

		-- Monochrome video signals
		video	: buffer std_logic;
		sync  	: out  std_logic
 );
end nasVDU;

architecture rtl of nasVDU is

--VGA 640x400
--constant VERT_CHARS : integer := 25;
--constant HORIZ_CHARS : integer := 80;
--constant CLOCKS_PER_SCANLINE : integer := 1600;
--constant DISPLAY_TOP_SCANLINE : integer := 35;
--constant DISPLAY_LEFT_CLOCK : integer := 288;
--constant VERT_SCANLINES : integer := 448;
--constant VSYNC_SCANLINES : integer := 2;
--constant HSYNC_CLOCKS : integer := 192;
--constant VERT_PIXEL_SCANLINES : integer := 2;
--constant CLOCKS_PER_PIXEL : integer := 2; -- min = 2
--constant H_SYNC_ACTIVE : std_logic := '0';
--constant V_SYNC_ACTIVE : std_logic := '1';

constant HORIZ_CHAR_MAX : integer := HORIZ_CHARS-1;
constant VERT_CHAR_MAX : integer := VERT_CHARS-1;
constant CHARS_PER_SCREEN : integer := HORIZ_CHARS*VERT_CHARS;

	signal	vActive   : std_logic := '0';
	signal	hActive   : std_logic := '0';

	signal	pixelClockCount: std_logic_vector(3 DOWNTO 0);
	signal	pixelCount: std_logic_vector(2 DOWNTO 0);

	signal	horizCount: std_logic_vector(11 DOWNTO 0);
	signal	vertLineCount: std_logic_vector(9 DOWNTO 0);

	signal	charVert: integer range 0 to VERT_CHAR_MAX; --unsigned(4 DOWNTO 0);
	signal	charScanLine: std_logic_vector(3 DOWNTO 0);

-- functionally this only needs to go to HORIZ_CHAR_MAX. However, at the end of a line
-- it goes 1 beyond in the hblank time. It could be avoided but it's fiddly with no
-- benefit. Without the +1 the design synthesises and works fine but gives a fatal
-- error in RTL simulation when the signal goes out of range.
	signal	charHoriz: integer range 0 to 1+HORIZ_CHAR_MAX; --unsigned(6 DOWNTO 0);
	signal	charBit: std_logic_vector(3 DOWNTO 0);

	-- top left-hand corner of the display is 0,0 aka "home".
	signal	cursorVert: integer range 0 to VERT_CHAR_MAX :=0;
	signal	cursorHoriz: integer range 0 to HORIZ_CHAR_MAX :=0;

	signal 	cursAddr : integer range 0 to CHARS_PER_SCREEN;
	signal 	dispAddr : integer range 0 to CHARS_PER_SCREEN;

	signal 	charAddr : std_logic_vector(11 downto 0);

	signal	dispCharData : std_logic_vector(7 downto 0);
	signal	dispCharWRData : std_logic_vector(7 downto 0);
	signal	dispCharRDData : std_logic_vector(7 downto 0);

	signal	dispAttData : std_logic_vector(7 downto 0) :=DEFAULT_ATT; -- iBGR(back) iBGR(text)

	signal	charData : std_logic_vector(7 downto 0);

	signal	cursorOn : std_logic := '1';
	signal	dispWR : std_logic := '0';
	signal	cursBlinkCount : unsigned(25 downto 0);

	-- "globally static" versions of signals for use within generate
        -- statements below. Without these intermediate signals the simulator
        -- reports an error (even though the design synthesises OK)
	signal	dispAddr_xx: std_logic_vector(10 downto 0); -- raster access

        signal  wren_nas : std_logic;
        signal  wren_map : std_logic;
        signal  wren_charGen : std_logic;

begin

	dispAddr_xx <= std_logic_vector(to_unsigned(dispAddr,11));

        wren_nas     <= not(n_MemWr or n_nasCS);
        wren_map     <= not(n_MemWr or n_mapCS);
        wren_charGen <= not(n_MemWr or n_charGenCS);

        -- clone CGABoldRom and expand from 2k (11 address lines) to 4k (12 address lines)

-- DISPLAY ROM (CHARACTER GENERATOR)
-- was 11 address lines broken up as 8,3 for char,row
-- now 12 address lines broken up as 8,4 for char,row
GEN_EXT_CHARS: if (EXTENDED_CHARSET=1) generate
begin
	fontRom : entity work.nasCharGenRom4K -- 256 chars, 8 bits x 16 lines (4K)
        port map(
		address => charAddr, -- 12-bit: 8 (1-of-256 characters) + 4 (1-of-16 rows)
		clock => clk,
		q => charData
	);
end generate GEN_EXT_CHARS;


-- DISPLAY RAM
GEN_2KRAM: if (CHARS_PER_SCREEN >1024) generate
begin
-- [NAC HACK 2020Nov20] got this one at the moment; want to have 2K and 1K but map 1K here for now..
-- [NAC HACK 2020Nov20] add the other two memories and write paths, and use the CS to MUX the
-- [NAC HACK 2020Nov20] read data paths back.

        dispCharRam: entity work.DisplayRam2K -- For 80x25 display character storage
	port map
	(
		clock	=> clk,

		address_b => addr(10 downto 0),  -- CPU access port
		data_b => dataIn,
		q_b => dataOut,
		wren_b => wren_nas,

		address_a => dispAddr_xx(10 downto 0),
		data_a => (others => '0'),
		q_a => dispCharData,
		wren_a => '0'
	);
end generate GEN_2KRAM;

GEN_1KRAM: if (CHARS_PER_SCREEN <1025) generate
begin
 	dispCharRam: entity work.DisplayRam1K -- For 40x25 display character storage
	port map
	(
		clock	=> clk,

		address_b => addr(9 downto 0),
		data_b => dispCharWRData,
		q_b => dispCharRDData,
		wren_b => dispWR,

		address_a => dispAddr_xx(9 downto 0),
		data_a => (others => '0'),
		q_a => dispCharData,
		wren_a => '0'
	);
end generate GEN_1KRAM;


        -- address character generator with 8 rows (scan lines) per character.
        -- 7 high-order bits select the character, 3 low-order bits select the scan line
        -- using charScanLine(3..1) so that the LSB of charScanLine does not affect the
        -- char gen: the data is duplicated for odd and even scan lines.
        -- To get 16 rows-per-character should just need to change VERT_PIXEL_SCANLINES
        -- from 2 to 1 but that doesn't work out: would get charScanLines(2..0) which
        -- still only gives 8 rows-per-character. I think the MSB should be fixed at 3
        -- rather than being a factor of VERT_PIXEL_SCANLINES
        -- [NAC HACK 2020Nov21] need to restore manifest constants when I have added
        -- rows-per-char or somesuch
        charAddr <= dispCharData & charScanLine(3 downto 0);

	dispAddr <= (charHoriz+(charVert * HORIZ_CHARS)) mod CHARS_PER_SCREEN;
	cursAddr <= (cursorHoriz+(cursorVert * HORIZ_CHARS)) mod CHARS_PER_SCREEN;

	sync <= vSync and hSync; -- composite sync for mono video out

	-- SCREEN RENDERING
	screen_render: process (clk)
	begin
		if rising_edge(clk) then
			if horizCount < CLOCKS_PER_SCANLINE then
				horizCount <= horizCount + 1;
				if (horizCount < DISPLAY_LEFT_CLOCK) or (horizCount >= (DISPLAY_LEFT_CLOCK + HORIZ_CHARS*CLOCKS_PER_PIXEL*8)) then
					hActive <= '0';
				else
					hActive <= '1';
				end if;
			else
				horizCount<= (others => '0');
				pixelCount<= (others => '0');
				charHoriz<= 0;
				if vertLineCount > (VERT_SCANLINES-1) then
					vertLineCount <= (others => '0');
				else
					if vertLineCount < DISPLAY_TOP_SCANLINE or vertLineCount > (DISPLAY_TOP_SCANLINE + 8 * VERT_PIXEL_SCANLINES * VERT_CHARS - 1) then
						vActive <= '0';
						charVert <= 0;
						charScanLine <= (others => '0');
					else
						vActive <= '1';
						if charScanLine = (VERT_PIXEL_SCANLINES*8-1) then
							charScanLine <= (others => '0');
							charVert <= charVert+1;
						else
							if vertLineCount /= DISPLAY_TOP_SCANLINE then
								charScanLine <= charScanLine+1;
							end if;
						end if;
					end if;
					vertLineCount <=vertLineCount+1;
				end if;
			end if;
			if horizCount < HSYNC_CLOCKS then
				hSync <= H_SYNC_ACTIVE;
			else
				hSync <= not H_SYNC_ACTIVE;
			end if;
			if vertLineCount < VSYNC_SCANLINES then
				vSync <= V_SYNC_ACTIVE;
			else
				vSync <= not V_SYNC_ACTIVE;
			end if;

			if hActive='1' and vActive = '1' then
				if pixelClockCount <(CLOCKS_PER_PIXEL-1) then
					pixelClockCount <= pixelClockCount+1;
				else
					pixelClockCount <= (others => '0');
					if cursorOn = '1' and cursorVert = charVert and cursorHoriz = charHoriz and charScanLine = (VERT_PIXEL_SCANLINES*8-1) then
					   -- Cursor (use current colour because cursor cell not yet written to)
						if dispAttData(3)='1' then -- BRIGHT
							videoR0 <= dispAttData(0);
							videoG0 <= dispAttData(1);
							videoB0 <= dispAttData(2);
						else
							videoR0 <= '0';
							videoG0 <= '0';
							videoB0 <= '0';
						end if;
						videoR1 <= dispAttData(0);
						videoG1 <= dispAttData(1);
						videoB1 <= dispAttData(2);

						video <= '1'; -- Monochrome video out
					else
						if charData(7-to_integer(unsigned(pixelCount))) = '1' then
						-- Foreground
							if dispAttData (3 downto 0) = "1000" then -- special case = GREY
								videoR0 <= '1';
								videoG0 <= '1';
								videoB0 <= '1';
								videoR1 <= '0';
								videoG1 <= '0';
								videoB1 <= '0';
							else
								if dispAttData(3)='1' then -- BRIGHT
									videoR0 <= dispAttData(0);
									videoG0 <= dispAttData(1);
									videoB0 <= dispAttData(2);
								else
									videoR0 <= '0';
									videoG0 <= '0';
									videoB0 <= '0';
								end if;
								videoR1 <= dispAttData(0);
								videoG1 <= dispAttData(1);
								videoB1 <= dispAttData(2);
							end if;
						else
						-- Background
							if dispAttData (7 downto 4) = "1000" then -- special case = GREY
								videoR0 <= '1';
								videoG0 <= '1';
								videoB0 <= '1';
								videoR1 <= '0';
								videoG1 <= '0';
								videoB1 <= '0';
							else
								if dispAttData(7)='1' then -- BRIGHT
									videoR0 <= dispAttData(4);
									videoG0 <= dispAttData(5);
									videoB0 <= dispAttData(6);
								else
									videoR0 <= '0';
									videoG0 <= '0';
									videoB0 <= '0';
								end if;
								videoR1 <= dispAttData(4);
								videoG1 <= dispAttData(5);
								videoB1 <= dispAttData(6);
							end if;
						end if;
						video <= charData(7-to_integer(unsigned(pixelCount))); -- Monochrome video out
					end if;
					if pixelCount = 6 then -- move output pipeline back by 1 clock to allow readout on posedge
						charHoriz <= charHoriz+1;
					end if;
					pixelCount <= pixelCount+1;
				end if;
			else
				videoR0 <= '0';
				videoG0 <= '0';
				videoB0 <= '0';
				videoR1 <= '0';
				videoG1 <= '0';
				videoB1 <= '0';

				video <= '0'; -- Monochrome video out
                                pixelClockCount <= (others => '0');
			end if;
		end if;
	end process;


	-- Hardware cursor blink -- TODO may need this for MAP80?? May need to emulate 6845 cursor register.
	cursor_blink: process(clk)
	begin
		if rising_edge(clk) then
			if cursBlinkCount < 49999999 then
				cursBlinkCount <= cursBlinkCount + 1;
			else
				cursBlinkCount <= (others=>'0');
			end if;
			if cursBlinkCount < 25000000 then
				cursorOn <= '0';
			else
				cursorOn <= '1';
			end if;
		end if;
	end process;

end rtl;
