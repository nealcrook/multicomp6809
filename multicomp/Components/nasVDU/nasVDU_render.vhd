library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned.all;

entity nasVDU_render is
	generic(
		constant HWCURSOR : boolean := FALSE;
		-- VGA 640x480 Default values
		constant VERT_CHARS : integer := 25;
		constant HORIZ_CHARS : integer := 80;
		constant HORIZ_STRIDE : integer := 80;
		constant HORIZ_OFFSET : integer := 0;
		constant LINE_OFFSET : integer := 0;
		constant CLOCKS_PER_SCANLINE : integer := 1600; -- NTSC/PAL = 3200
		constant DISPLAY_TOP_SCANLINE : integer := 35+40;
		constant DISPLAY_LEFT_CLOCK : integer := 288; -- NTSC/PAL = 600+ -- seems to be (hsync+hback)*2
		constant VERT_SCANLINES : integer := 525; -- NTSC=262, PAL=312
		constant VSYNC_SCANLINES : integer := 2; -- NTSC/PAL = 4
		constant HSYNC_CLOCKS : integer := 192;  -- NTSC/PAL = 235
		constant SCANLINES_PER_CHAR : integer := 16; -- Number of rows (scanlines) per character in the CharGen ROM
                -- vertical scanline duplication. Values of 1 and 2 work. For other values need to
                -- revisit the character generator addressing (charScanLine)
		constant VERT_PIXEL_SCANLINES : integer := 1;
                -- clocks by which to make hACTIVE assert early to compensate for the video pipeline
                constant VPIPE : integer := 4;

		constant CLOCKS_PER_PIXEL : integer := 2; -- min = 2
		constant H_SYNC_ACTIVE : std_logic := '0';
		constant V_SYNC_ACTIVE : std_logic := '0'
	);
	port (
		clk    	: in  std_logic;

                addr    : in  std_logic_vector(10 downto 0); -- 2Kbytes address range
                n_CS    : in  std_logic;
		n_memWr : in  std_logic;
		dataIn	: in  std_logic_vector(7 downto 0);
		dataOut	: out std_logic_vector(7 downto 0);

                -- Character generator access
                charAddr : out std_logic_vector(11 downto 0);
                charData : in  std_logic_vector(7 downto 0);
                charAccess: out std_logic;    -- See description in nasVDU.vhd
                charClash: in std_logic;      -- See description in nasVDU.vhd

                -- Video signals
		video	: out std_logic;
		hSync  	: buffer  std_logic;
		vSync  	: buffer  std_logic

 );
end nasVDU_render;

architecture rtl of nasVDU_render is

constant HORIZ_CHAR_MAX : integer := HORIZ_CHARS-1;
constant VERT_CHAR_MAX : integer := VERT_CHARS-1;
constant CHARS_PER_SCREEN : integer := HORIZ_STRIDE*VERT_CHARS;

	signal	vActive   : std_logic := '0';
	signal	hActive   : std_logic := '0';

	signal	pixelClockCount: std_logic_vector(3 DOWNTO 0);
	-- Index the 8 bits of data loaded from the character generator to generate the video output
	signal	pixelCount: std_logic_vector(2 DOWNTO 0);

	signal	horizCount: std_logic_vector(11 DOWNTO 0);
	signal	vertLineCount: std_logic_vector(9 DOWNTO 0) := "0000000000";

	signal	charVert: integer range 0 to VERT_CHAR_MAX;
	signal	charScanLine: std_logic_vector(4 DOWNTO 0) := "00000"; -- needs to accommodate char rows and VERT_PIXEL_SCANLINES

-- functionally this only needs to go to HORIZ_CHAR_MAX. However, at the end of a line
-- it goes 1 beyond in the hblank time. It could be avoided but it's fiddly with no
-- benefit. Without the +1 the design synthesises and works fine but gives a fatal
-- error in RTL simulation when the signal goes out of range.
	signal	charHoriz: integer range 0 to 1+HORIZ_CHAR_MAX;

	-- top left-hand corner of the display is 0,0 aka "home".
	signal	cursorVert: integer range 0 to VERT_CHAR_MAX :=0;
	signal	cursorHoriz: integer range 0 to HORIZ_CHAR_MAX :=0;

	signal 	dispAddr : integer range 0 to CHARS_PER_SCREEN;

	signal	dispCharData : std_logic_vector(7 downto 0);

        -- Registered data from character generator ROM. Loaded at one or other of two
        -- successive clock cycles depending on charClash.
	signal	charDataR : std_logic_vector(7 downto 0);

	-- Pipe forward 2 cycles to determine which data to load into charData
	signal	charClashR : std_logic;
	signal	charClashRR : std_logic;

	signal	cursorOn : std_logic := '0';
	signal	cursBlinkCount : unsigned(25 downto 0);

	-- "globally static" versions of signals for use within generate
        -- statements below. Without these intermediate signals the simulator
        -- reports an error (even though the design synthesises OK)
	signal	dispAddr_xx: std_logic_vector(10 downto 0); -- raster access

        signal  wren : std_logic;

begin

	dispAddr_xx <= std_logic_vector(to_unsigned(dispAddr,11));
        wren <= not(n_memWr or n_CS);

-- DISPLAY RAMS
GEN_RAM2K: if (CHARS_PER_SCREEN > 1024) generate
begin
      dispRam2K: entity work.DisplayRam2K -- For MAP80 VFC 80x25 display
      port map(
            clock => clk,

            address_b => addr(10 downto 0),  -- R/W CPU access port
            data_b => dataIn,
            q_b => dataOut,
            wren_b => wren,

            address_a => dispAddr_xx(10 downto 0), -- RO Display port
            data_a => (others => '0'),
            q_a => dispCharData,
            wren_a => '0'
            );
end generate GEN_RAM2K;

GEN_RAM1K: if (CHARS_PER_SCREEN < 1025) generate
begin
      dispRam1K: entity work.DisplayRam1K -- For NASCOM 48x16 display
      port map(
            clock => clk,

            address_b => addr(9 downto 0), -- R/W CPU access port
            data_b => dataIn,
            q_b => dataOut,
            wren_b => wren,

            address_a => dispAddr_xx(9 downto 0), -- RO Display port
            data_a => (others => '0'),
            q_a => dispCharData,
            wren_a => '0'
            );
end generate GEN_RAM1K;

        -- Character generator memory addressing
        -- dispCharData contributes 8 bits to select 1-of-256 characters.
        -- charScanLine contributes 4 bits to select 1-of-16 rows of the character.
        -- When VERT_PIXEL_SCANLINES=1 there is 1 scanline for each row of the character; charScanLine
        -- counts from 0..15 and the addressing here uses bits 3..0
        -- When VERT_PIXEL_SCANLINES=2 there are 2 scanlines for each row of the character; charScanLine
        -- counts from 0..31 and the addressing here used bits 4..1
        -- Other power-of-2 values of VERT_PIXEL_SCANLINES are probably OK; anything else will need
        -- adjustment here (and maybe elsewhere, too).
        charAddr <= dispCharData & charScanLine(3+VERT_PIXEL_SCANLINES-1 downto 0+VERT_PIXEL_SCANLINES-1);

        -- Display memory addressing
        dispAddr <= (charHoriz  +((charVert   + LINE_OFFSET) * HORIZ_STRIDE)+HORIZ_OFFSET) mod CHARS_PER_SCREEN;

	-- SCREEN RENDERING
	screen_render: process (clk)
	begin
		if rising_edge(clk) then
			charClashR <= charClash;
			charClashRR <= charClashR;
			if horizCount < CLOCKS_PER_SCANLINE then
				horizCount <= horizCount + 1;
				if (horizCount < DISPLAY_LEFT_CLOCK + VPIPE) or (horizCount >= (DISPLAY_LEFT_CLOCK + HORIZ_CHARS*CLOCKS_PER_PIXEL*8 + 3 + VPIPE)) then
					hActive <= '0';
				else
					hActive <= '1';
				end if;
			else
				horizCount<= (others => '0');
				pixelCount<= (others => '0'); -- reset at end of line; should be just for initialisation
				charHoriz<= 0; -- reset at end of line, held at 0 between lines.
				if vertLineCount > (VERT_SCANLINES-1) then
					vertLineCount <= (others => '0');
				else
					if vertLineCount < DISPLAY_TOP_SCANLINE or vertLineCount > (DISPLAY_TOP_SCANLINE + SCANLINES_PER_CHAR * VERT_PIXEL_SCANLINES * VERT_CHARS - 1) then
						vActive <= '0';
						charVert <= 0;
						charScanLine <= (others => '0');
					else
						vActive <= '1';
						if charScanLine = (SCANLINES_PER_CHAR * VERT_PIXEL_SCANLINES - 1) then
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
                                if pixelCount = 0 and pixelClockCount = 0 then
                                    charAccess <= '1';
                                else
                                    charAccess <= '0';
                                end if;

                                if pixelCount = 7 and pixelClockCount = 0 then
                                    -- Data from character generator is good iff charClashR is low
                                    -- but OK to grab it unconditionally
                                    charDataR <= charData;
                                end if;

                                if pixelClockCount <(CLOCKS_PER_PIXEL-1) then
					pixelClockCount <= pixelClockCount+1;
                                else
					pixelClockCount <= (others => '0');
--					if cursorOn = '1' and cursorVert = charVert and cursorHoriz = charHoriz and charScanLine = (SCANLINES_PER_CHAR * VERT_PIXEL_SCANLINES - 1) then
						-- Override character generator value with cursor
--						video <= '1'; -- Monochrome video out
--					else
--						video <= charData(7-to_integer(unsigned(pixelCount))); -- Monochrome video out
--					end if;

					if pixelCount = 1 then
                                            charHoriz <= charHoriz+1;
					end if;

                                        if pixelCount = 7 and charClashRR = '1' then
                                            -- Data from character generator was delayed due to clash and
                                            -- is now good. Grab it and send the 1st bit out
                                            charDataR <= charData(6 downto 0) & '0';
                                            video <= charData(7);
                                        else
                                            video <= charDataR(7);
                                            charDataR <= charDataR(6 downto 0) & '0';
                                        end if;

                                        pixelCount <= pixelCount - 1;
				end if;
			else
                            video <= '0';
                            pixelClockCount <= (others => '0');
			end if;
		end if;
	end process;

OPT_HWCURSOR: if (HWCURSOR = TRUE) generate
begin
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
end generate;

end rtl;
