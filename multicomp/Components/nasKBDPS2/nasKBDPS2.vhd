-- Connect to a PS/2 keyboard and converts the keyboard code to behave like
-- a NASCOM keyboard.
--
-- NASCOM keyboard scan is 1 high-going pulse on kbdrst followed by (upto) 8
-- high-going pulses on kbdclk. Internal to the keyboard, these signals
-- control a counter which sequences 1-of-8 DRIVE lines using a decode of
-- a 3-bit counter. Because it's 3 bits it counts 0 (on reset) then 1..7
-- and back to 0 on the 8 kbdclk pulses.
-- The scan can be aborted early eg once a keypress is detected, but I'm
-- not sure of the details (consult NAS-SYS source code..) I thought
-- that drive0 is always scanned (in order to check the state of
-- the shift key) then the scan aborted after the first found key, but
-- I don't think that can be accurate, because drive0 contains SHIFT
-- and CTRL but not GRA.
--
-- The real keyboard uses LICON pulse transformer switches. There are
-- 7 SENSE lines which drive latches. The kbdrst and kbdclk pulses both
-- clear all of the latches and then the transformer effect in the keys
-- causes a depressed key on the current DRIVE line to set the latch
-- on the associated SENSE line.
--
-- The latch outputs drive the kbddata outputs back to the NASCOM where
-- they are read through a buffer which is enabled on I/O port 0 read.
-- The latch outputs are 1 by default and 0 when a key is pressed.
-- kbddata[7] has a pullup on the keyboard and is permanently 1.
--
-- Although the kbdrst and kbdclk are normally-low and pulse high, it
-- is the falling edge that triggers the activity.
--
-- For this PS/2 version, the keyboard is scanned autonomously to generate
-- a stream of keycodes: depress and release codes. An array of flops
-- 8 drive x 6 sense represents a map of the NASCOM keyboard matrix. The
-- keycodes are translated into locations in the matrix, and a location is
-- set on key-press and cleared on key-release.
-- The current drive value is tracked and used to output the corresponding
-- map sense bits onto kbddata.
--
-- The code requires some key-cap markup of a regular PS/2 keyboard,
-- because, although a couple of keys are in different positions compared
-- to a NASCOM keyboard, all of the unshifted/shifted relationships follow
-- the NASCOM keyboard. For example, = is unshifted on a PS/2 keyboard but
-- shifted on a NASCOM keyboard.
--
-- TODO
-- Test the event interface and integrate it into the NASCOM
-- Do something with these unused keys: to-the-left-of-1, to-the-left-of-backspace
-- to-the-left-of-z
-- Decode the prefix byte and handle the extra cursor keys
-- Consider decoding the numeric pad and the cursor pad
--
--
-- Modifications by foofoobedoo@gmail.com
--
-- Based on the PS/2 code from Grant Searle's SBCTextDisplayRGB design
-- which is:
-- "copyright Grant Searle 2014
-- You are free to use this file in your own projects but must never charge for it nor use it without
-- acknowledgement."
--

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.std_logic_unsigned.all;

entity nasKBDPS2 is
    generic(
        constant DEBUG : boolean := FALSE
	);
    port (
        n_reset	: in std_logic;
        clk    	: in  std_logic;

        -- PS/2 Keyboard signals
        ps2Clk	: inout std_logic;
        ps2Data	: inout std_logic;

        -- Fn keys generate a single-cycle Event and a 4-bit EventCode. EventCode persists until next
        -- event or until EventClear.
        Event	: out std_logic;
        EventCode : out std_logic_vector(3 downto 0);
        ClearEvent : in std_logic;

        -- Pretend to be NASCOM keyboard
        kbdrst 	: in  std_logic;
        kbdclk  : in  std_logic;
        kbddata	: out std_logic_vector(7 downto 0)
 );
end nasKBDPS2;

architecture rtl of nasKBDPS2 is

    signal	func_reset: std_logic := '0';

    -- 2 ways of doing the PS/2 keyboard map: could end up with a 3-bit drive code and 3-bit sense code (which
    -- would allow 8 sense lines)
    -- OR could store an index for the 56 key grid positions - both require 6 bits of storage.
    -- Cleaner to use the 3-bit + 3-bit. Can then use the unused sense code value as a way of
    -- encoding the special keys: the function keys.


    -- keyboard map       DRIVE                       SENSE
    type t_kmap is array (0 to 7) of std_logic_vector(6 downto 0);
    signal  kmap : t_kmap := (others => (others => '0'));
    -- track the current drive line
    signal	drv: std_logic_vector(2 downto 0);
    signal  kbdrst_d1: std_logic;
    signal  kbdclk_d1: std_logic;

    -- decode of current ps2ConvertedDS
    signal  kbdSense: integer range 0 to 7;
    signal  kbdDrive: integer range 0 to 7;
    signal  kbdMask: std_logic_vector(6 downto 0);
    signal  msk6 : std_logic_vector(6 downto 0)   := "0000001";

    signal	kbWatchdogTimer : integer range 0 to 50000000 :=0;
    signal	kbWriteTimer :    integer range 0 to 50000000 :=0;

    signal	n_int_internal   : std_logic := '1';
    signal	statusReg : std_logic_vector(7 downto 0) := (others => '0');

    signal	ps2Byte: std_logic_vector(7 DOWNTO 0);
    signal	ps2ByteD1: std_logic_vector(7 DOWNTO 0);
    signal	ps2ByteD2: std_logic_vector(7 DOWNTO 0);
    signal	ps2ConvertedDS: std_logic_vector(5 DOWNTO 0);
    signal	ps2ClkCount : integer range 0 to 10 :=0;
    signal	ps2WriteClkCount : integer range 0 to 20 :=0;
    signal	ps2WriteByte: std_logic_vector(7 DOWNTO 0) := x"FF";
    signal	ps2WriteByte2: std_logic_vector(7 DOWNTO 0):= x"FF";
    signal	ps2PrevClk: std_logic := '1';
    signal 	ps2ClkFilter : integer range 0 to 50;
    signal 	ps2ClkFiltered : std_logic := '1';

    -- TODO probably unstitch and remove some or all of the code associated with these
    signal	ps2Caps: std_logic := '1';
    signal	ps2Num: std_logic := '0';
    signal	ps2Scroll: std_logic := '0';

    signal	ps2DataOut: std_logic := '1';
    signal	ps2ClkOut: std_logic := '1';
    signal	n_kbWR: std_logic := '1'; -- TODO WTF - change to active high
    signal	kbWRParity: std_logic := '0';

    type	kbDataArray is array (0 to 131) of std_logic_vector(5 downto 0);

    -- the key codes are expressed as (drive,sense) each is a 3-bit value and
    -- they are combined to get a 6-bit value
    function t (
        drive: integer range 0 to 7;
        sense: integer range 0 to 7
        ) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(drive*8 + sense,6)); -- 6-bit value
    end t;

    -- scan code set 2 (8-bit hex) from (eg) https://wiki.osdev.org/PS/2_Keyboard
    --
    --                       PRESS                         RELEASE
    -- easy stuff            00                            F0 00
    --                       ..
    --                       86                            F0 86              I only have lookup for 00..83
    --                                                                        codes 84..86 are used on scan code set 1
    --
    -- simple E0 prefix      E0 ??                         E0 F0 ??
    --
    -- applies to these:
    -- l-WINDOWS, r-ALT r-WINDOWS MENU r-CTRL INSERT HOME PgUP DELETE END PgDOWN UP-ARR LEFT-ARR DOWN-ARR RIGH-ARR KP/  KPENTER
    -- 0x1f       0x11  0x27           0x14   0x70   0x6c 0x7d 0x71   0x69 0x7a  0x75   0x6b     0x72     0x74     0x4a 0x5a
    --
    -- final fiddly ones:
    --
    -- print screen          E0 12 E0 7C                   E0 F0 7C E0 F0 12
    -- pause break           E1 14 77 E1 F0 14 F0 77       (none) (no auto-repeat)
    --
    -- print screen just looks like 2 keys pressed and released in succession; easy to ignore like any other ignored E0 ?? pair.
    --
    -- all keys except pause/break auto-repeat and there seems no way to turn it off at the keyboard.
    -- TODO could I eliminate repeating keys here? Not very easily..

    -- Read the table like this: SPACE is PS/2 keyboard code 92. On the NASCOM it is on drive line 7, sense line 4 and is coded
    -- here as t(7,4) which is converted into a 6-bit value by function t (see definition, above). Shift is treated/encoded like
    -- any other key. Legal drive values are 0-7. Legal sense values are 0-6. The illegal value 7,7 is used to represent a key
    -- that has no corresponding key on the NASCOM keyboard (it is ignored). The function keys F1-F12 do not affect the NASCOM
    -- keyboard but their DEPRESSION creates a hardware strobe (release is ignored)
    --       code   lookup  event
    -- F1    05   t(0,7)    0000
    -- F2    06     1,7     0001
    -- F3    04     2,7     0010
    -- F4    0c     3,7     0011
    -- F5    03     0,7     0100
    -- F6    0b     1,7     0101
    -- F7    83     2,7     0110
    -- F8    0a     3,7     0111
    -- F9    01     0,7     1000
    -- F10   09     1,7     1001
    -- F11   78     2,7     1010
    -- F12   07     3,7     1011
    --                      1111 -- no event
    --
    -- converted codes repeat so need to part-decode the scan code[7:0] to generate the high two bits of the event code
    --
    -- leaves codes (7,7) for NO KEY and (4,7) (5,7) (6,7) for SOME OTHER SPECIAL THINGs (currently unused)

    constant kbUnshifted : kbDataArray := (
	--  0        1        2        3        4        5        6        7        8        9        A        B        C        D        E        F
	--       F9                F5       F3       F1       F2       F12               F10      F8       F6       F4       TAB      `
	t(7,7),  t(0,7),  t(7,7),  t(0,7),  t(2,7),  t(0,7),  t(1,7),  t(3,7),  t(7,7),  t(1,7),  t(3,7),  t(1,7),  t(3,7),  t(5,6),  t(7,7),  t(7,7), -- 0
	--       l-ALT    l-SHIFT           l-CTRL   q        1                                   z        s        a        w        2
	t(7,7),  t(1,6),  t(0,4),  t(7,7),  t(0,3),  t(5,4),  t(6,4),  t(7,7),  t(7,7),  t(7,7),  t(2,4),  t(3,4),  t(4,4),  t(4,3),  t(6,3),  t(7,7), -- 1
	--       c        x        d        e        4        3                          SPACE    v        f        t        r        5
	t(7,7),  t(7,3),  t(1,4),  t(2,3),  t(3,3),  t(7,2),  t(5,3),  t(7,7),  t(7,7),  t(7,4),  t(7,1),  t(1,3),  t(1,5),  t(7,5),  t(1,2),  t(7,7), -- 2
	--       n        b        h        g        y        6                                   m        j        u        7        8
	t(7,7),  t(2,1),  t(1,1),  t(1,0),  t(7,0),  t(2,5),  t(2,2),  t(7,7),  t(7,7),  t(7,7),  t(3,1),  t(2,0),  t(3,5),  t(3,2),  t(4,2),  t(7,7), -- 3
	--       ,        k        i        o        0        9                          .        /        l        ;        p        -
	t(7,7),  t(4,1),  t(3,0),  t(4,5),  t(5,5),  t(6,2),  t(5,2),  t(7,7),  t(7,7),  t(5,1),  t(6,1),  t(4,0),  t(5,0),  t(6,5),  t(0,2),  t(7,7), -- 4
	--                '                 [        =                          CAPLOCK  r-SHIFT  ENTER    ]                 #~
	t(7,7),  t(7,7),  t(6,0),  t(7,7),  t(6,6),  t(0,5),  t(7,7),  t(7,7),  t(7,7),  t(0,4),  t(0,1),  t(7,6),  t(7,7),  t(0,6),  t(7,7),  t(7,7), -- 5
	--       \|                                           BACKSP                     KP1               KP4      KP7
	t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(0,0),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7), -- 6
	-- KP0   KP.      KP2      KP5      KP6      KP8      ESC      NUMLCK   F11      KP+      KP3      KP-      KP*      KP9      SCRLCK
	t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(2,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7),  t(7,7), -- 7
	--                         F7
	t(7,7),  t(7,7),  t(7,7),  t(2,7) -- 8
	);

begin
    -- [NAC HACK 2021Jan10] clean up the reset; recode as async
    func_reset <= not n_reset;

    track_drv: process(clk)
    begin
        if rising_edge(clk) then
            kbdrst_d1 <= kbdrst;
            kbdclk_d1 <= kbdclk;

            if kbdrst='1' and kbdrst_d1='0' then
                drv <= "000";
            end if;
            if kbdclk='1' and kbdclk_d1='0' then
                drv <= drv + "001";
            end if;
        end if;
    end process;

    data_out: process(drv, kmap)
    begin
        -- in the kmap, 1 represents a depressed key. At the output, 0 represents a
        -- depressed key.
        kbddata <= not('0' & kmap(to_integer(unsigned(drv))));
    end process;

    -- PROCESS DATA FROM PS2 KEYBOARD
    ps2Data <= ps2DataOut when ps2DataOut='0' else 'Z';
    ps2Clk <= ps2ClkOut when ps2ClkOut='0' else 'Z';

    -- Decode most recent byte
    kbdSense <= to_integer(unsigned(ps2ConvertedDS(2 downto 0)));
    kbdDrive <= to_integer(unsigned(ps2ConvertedDS(5 downto 3)));
    -- thing being shifted needs to be the same width as the output
    -- ..for some reason.
    kbdMask  <= std_logic_vector( shift_left(unsigned(msk6), kbdSense) );


    -- PS2 clock de-glitcher - important because the FPGA is very sensistive
    -- Filtered clock will not switch low to high until there is 50 more high samples than lows
    -- hysteresis will then not switch high to low until there is 50 more low samples than highs.
    -- Introduces a minor (1uS) delay with 50MHz clock
    kbd_filter: process(clk)
    begin
        if rising_edge(clk) then
            if ps2Clk = '1' and ps2ClkFilter=50 then
                ps2ClkFiltered <= '1';
            end if;
            if ps2Clk = '1' and ps2ClkFilter /= 50 then
                ps2ClkFilter <= ps2ClkFilter+1;
            end if;
            if ps2Clk = '0' and ps2ClkFilter=0 then
                ps2ClkFiltered <= '0';
            end if;
            if ps2Clk = '0' and ps2ClkFilter/=0 then
                ps2ClkFilter <= ps2ClkFilter-1;
            end if;
        end if;
    end process;

    kbd_ctl: process( clk, func_reset )
    -- 11 bits
    -- start(0) b0 b1 b2 b3 b4 b5 b6 b7 parity(odd) stop(1)
    begin
        if rising_edge(clk) then

            if func_reset = '1' or ClearEvent = '1' then
                EventCode <= "1111";
            end if;

            -- Asserts for 1 cycle so always kick it low here.
            Event <= '0';

            ps2PrevClk <= ps2ClkFiltered;

            if n_kbWR = '0' and kbWriteTimer<25000 then
                ps2WriteClkCount<= 0;
                kbWRParity <= '1';
                kbWriteTimer<=kbWriteTimer+1;
            -- wait
            elsif n_kbWR = '0' and kbWriteTimer<50000 then
                ps2ClkOut <= '0';
                kbWriteTimer<=kbWriteTimer+1;
            elsif n_kbWR = '0' and kbWriteTimer<75000 then
                ps2DataOut <= '0';
                kbWriteTimer<=kbWriteTimer+1;
            elsif n_kbWR = '0' and kbWriteTimer=75000 then
                ps2ClkOut <= '1';
                kbWriteTimer<=kbWriteTimer+1;
            elsif n_kbWR = '0' and kbWriteTimer<76000 then
                kbWriteTimer<=kbWriteTimer+1;
            elsif  n_kbWR = '1' and ps2PrevClk = '1' and ps2ClkFiltered='0' then -- start of high-to-low cleaned ps2 clock
                kbWatchdogTimer<=0;
                if ps2ClkCount=0 then -- start
                    ps2Byte <= (others =>'0');
                    ps2ClkCount<=ps2ClkCount+1;
                elsif ps2ClkCount<9 then -- data
                    ps2Byte <= ps2Data & ps2Byte(7 downto 1);
                    ps2ClkCount<=ps2ClkCount+1;
                elsif ps2ClkCount=9 then -- parity - use this time to decode
                    if (ps2Byte<132) then
                        ps2ConvertedDS <= kbUnshifted (to_integer(unsigned(ps2Byte)));
                    else
                        ps2ConvertedDS <= t(7,7);
                    end if;
                    ps2ClkCount<=ps2ClkCount+1;
                else -- stop bit - use this time to store
                    if ps2ConvertedDS = t(0,7) or ps2ConvertedDS = t(1,7) or ps2ConvertedDS = t(2,7) or ps2ConvertedDS = t(3,7) then
                        -- On press of Fn1-Fn12 keys, generate an output strobe "Event" with an associated "EventCode".
                        -- The strobe is 1 clock wide. The EventCode persists until input ClearEvent is sampled high.
                        -- The release of the Fn keys is ignored.
                        -- The lookup codes for these keys use (0,7)-(3,7) - repeated 3 times. They form the low
                        -- two bits of the event code; the high 2 bits comes from decoding the PS/2 scan codes
                        -- (which I hope will munge down to some efficiently small amount of logic)
                        Event <= '1';
                        EventCode(1 downto 0) <= ps2ConvertedDS(4 downto 3);
                        if ps2Byte = x"03" or ps2Byte = x"0b" or ps2Byte = x"83" or ps2Byte = x"0a" then
                            EventCode(2) <= '1';
                        else
                            EventCode(2) <= '0';
                        end if;
                        if ps2Byte = x"01" or ps2Byte = x"09" or ps2Byte = x"78" or ps2Byte = x"07" then
                            EventCode(3) <= '1';
                        else
                            EventCode(3) <= '0';
                        end if;

                    elsif ps2Byte = x"AA" then
                        ps2WriteByte <= x"ED";
                        ps2WriteByte2(0) <= ps2Scroll;
                        ps2WriteByte2(1) <= ps2Num;
                        ps2WriteByte2(2) <= ps2Caps;
                        ps2WriteByte2(7 downto 3) <= "00000";
                        n_kbWR <= '0';
                        kbWriteTimer<=0;
                    -- SCROLL-LOCK pressed - set flags and
                    -- update LEDs
                    elsif ps2Byte = x"7E" then
                        if ps2ByteD1 /= x"F0" then
                            ps2Scroll <= not ps2Scroll;
                            ps2WriteByte <= x"ED";
                            ps2WriteByte2(0) <= not ps2Scroll;
                            ps2WriteByte2(1) <= ps2Num;
                            ps2WriteByte2(2) <= ps2Caps;
                            ps2WriteByte2(7 downto 3) <= "00000";
                            n_kbWR <= '0';
                            kbWriteTimer<=0;
                        end if;
                    -- NUM-LOCK pressed - set flags and
                    -- update LEDs
                    elsif ps2Byte = x"77" then
                        if ps2ByteD1 /= x"F0" then
                            ps2Num <= not ps2Num;
                            ps2WriteByte <= x"ED";
                            ps2WriteByte2(0) <= ps2Scroll;
                            ps2WriteByte2(1) <= not ps2Num;
                            ps2WriteByte2(2) <= ps2Caps;
                            ps2WriteByte2(7 downto 3) <= "00000";
                            n_kbWR <= '0';
                            kbWriteTimer<=0;
                        end if;
                    -- CAPS-LOCK pressed - set flags and
                    -- update LEDs
                    elsif ps2Byte = x"58" then
                        if ps2ByteD1 /= x"F0" then
                            ps2Caps <= not ps2Caps;
                            ps2WriteByte <= x"ED";
                            ps2WriteByte2(0) <= ps2Scroll;
                            ps2WriteByte2(1) <= ps2Num;
                            ps2WriteByte2(2) <= not ps2Caps;
                            ps2WriteByte2(7 downto 3) <= "00000";
                            n_kbWR <= '0';
                            kbWriteTimer<=0;
                        end if;
                    -- ACK (from SET-LEDs)
                    elsif ps2Byte = x"FA" then
                        if ps2WriteByte /= x"FF" then
                            n_kbWR <= '0';
                            kbWriteTimer<=0;
                        end if;
                    -- ASCII key press - store it in the kbBuffer.
                    elsif ps2ConvertedDS /= t(7,7) then
                        if ps2ByteD1 = x"F0" then
                            -- RELEASE key so CLEAR bit in kmap
                            kmap(kbdDrive) <= kmap(kbdDrive) and (not kbdMask);
                        else
                            -- PRESS key so SET bit in kmap
                            kmap(kbdDrive) <= kmap(kbdDrive) or kbdMask;
                        end if;
                    end if;
                    ps2ByteD1<=ps2Byte;   -- previous byte
                    ps2ByteD2<=ps2ByteD1; -- previous previous byte
                    ps2ClkCount<=0;
                end if;

            -- write to keyboard
            elsif  n_kbWR = '0' and ps2PrevClk = '1' and  ps2ClkFiltered='0' then -- start of high-to-low cleaned ps2 clock
                kbWatchdogTimer<=0;
                if ps2WriteClkCount <8 then
                    if (ps2WriteByte(ps2WriteClkCount)='1') then
                        ps2DataOut <= '1';
                        kbWRParity <= not kbWRParity;
                    else
                        ps2DataOut <= '0';
                    end if;
                    ps2WriteClkCount<=ps2WriteClkCount+1;
                elsif ps2WriteClkCount = 8 then
                    ps2DataOut <= kbWRParity;
                    ps2WriteClkCount<=ps2WriteClkCount+1;
                elsif ps2WriteClkCount = 9 then
                    ps2WriteClkCount<=ps2WriteClkCount+1;
                    ps2DataOut <= '1';
                elsif ps2WriteClkCount = 10 then
                    ps2WriteByte <= ps2WriteByte2;
                    ps2WriteByte2 <= x"FF";
                    n_kbWR<= '1';
                    ps2WriteClkCount <= 0;
                    ps2DataOut <= '1';
                end if;
            else
                -- COMMUNICATION ERROR
                -- if no edge then increment the timer
                -- if a large time has elapsed since the last pulse was read then
                -- re-sync the keyboard
                if kbWatchdogTimer>30000000 then
                    kbWatchdogTimer<=0;
                    ps2ClkCount<=0;
                    if n_kbWR = '0' then
                        ps2WriteByte <= x"ED";
                        ps2WriteByte2(0) <= ps2Scroll;
                        ps2WriteByte2(1) <= ps2Num;
                        ps2WriteByte2(2) <= ps2Caps;
                        ps2WriteByte2(7 downto 3) <= "00000";
                        kbWriteTimer<=0;
                    end if;
                else
                    kbWatchdogTimer<=kbWatchdogTimer+1;
                end if;
            end if;
        end if;
    end process;

end rtl;
