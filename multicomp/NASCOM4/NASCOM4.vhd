-- FPGA implementation of the NASCOM2
-- with external RAM, Flash/ROM and peripherals.
-- Goal is to be 100% software compatible with plain NASCOM 2
-- and 99.9% compatible with a NASCOM system comprising:
-- * NASCOM2 board
-- * MAP80 256K RAM board
-- * MAP80 VFC
--
-- The "99.9%" is because I do not reproduce the 6845 on the VFC but
-- have a fixed hardware setup for that video control.
--
-- Lots of ideas and some bits of code from Grant Searle's FPGA "Microcomp"
-- design, which is copyright by Grant Searle 2014: http://www.searle.wales/
-- http://searle.x10host.com/Multicomp/index.html
--
-- Also, some bits of code from my extended 6809 design.
--
-- On the FPGA:
-- * 2KROM "NAS-SYS3" at location 0.
--   - Can be re-written (TBD how) to contain other monitors
-- * 1K video RAM at location 0x800
-- * 1K ws RAM at location 0xc00
--
-- * I/O port 0     - keyboard and single-step control
-- * I/O port 1     - unused.
-- * I/O port 2,3   - 6402 compatible UART
--
-- * I/O port E4    - VFC FDC drive select etc.
-- * I/O port E6    - VFC "parallel" keyboard (maybe; from PS/2 keyboard)
-- * I/O port E8    - VFC Alarm (beeper?) output - TBD to external buzzer?
-- * I/O port EC    - VFC mapping register (write-only)
-- * I/O port EE    - VFC write to select VFC video on output
-- * I/O port EF    - VFC write to select NASCOM video on output

-- * I/O port FE    - RAM paging/memory mapping (write-only)


-- TBD port for memory-mapping control
-- * NASCOM video RAM in low memory or (for NASCOM CP/M) high memory
--   -- write-only? Reads come from RAM?
-- * ROM paging..
-- * Disable NAS-SYS
-- * Alternate boot ROM?
-- * Possible write-protect of RAM? Or would this be too fiddly with paged MAP80 RAM "underneath"?
-- could this be port 1?
-- emulate NASCOM keyboard via PS/2?
-- SDcard support? Could be instead of Flash ROM..
-- could implement the MAP80 VFC ROM (2Kbyte - VFC occupies programmable 4Kbyte page in address space)


-- Connection off-chip to:
-- * VGA video drive
-- * Serial in/out and optional serial clock in (via level translators)
-- * Keyboard connector (via level translators)
-- * 256Kbyte RAM (TBD device)
-- * 256Kbyte FLASH (TBD device) TBD how programmed/bootstrapped
-- * I/O bus for PIO, FDC
-- * Data-bus buffer/level translator with control signals
-- * FDC drive select, data ready/intrq, fm/mfm select

-- decide what to do wrt integrated SDcard controller vs NAScas/arduino hookup.
-- could put in a separate // port for connecting? And sw select of the serial
-- source allowing tape loading.. but then, would want to use this to do the
-- ROM load as well, and not use the integrated SDcard controller.


-- External port addressing:
-- * I/O port 4,5,6,7 - External PIO
-- * I/O port E0-E3   - 2797 FDC


-- V1: get the CPU executing code. Put the memory in place for rom/ws
-- but don't worry about video. Null out the kbd and UART ports or don't
-- bother because we won't simulate for that long
-- -> in sim see screen clear, NAS-SYS banner, cursor flash and
--    port 0 access for keyboard scan
--
-- V2: code i/o port write and readback. Force kbd readback to ff
-- to mimic no-key-pressed and ensure full scan occurs (scan is
-- aborted on reading key(s) pressed). Mock up UART to return
-- char available and to return a string. First, mock a small
-- T command. Next, mock a S command. Look at timing and generate
-- the NMI logic.
--
-- next: split out port0 write signals for clarity
--       generate synchroniser and pulse generator for
--       NMI push button and test in simulation.
--
-- V3: change VDU to be memory-mapped. Change to NASCOM timing.
-- make test ROM to exercise the VDU. Test on real HW
--
-- V4: implement 6402 UART and port 0 stuff. Null out keyboard
-- on real system with NAS-SYS3 and serial adaptor should be able
-- to start up via "X" command and do memory dump etc. and single
-- step and run "Lollipop".
--
-- V5: as above but with MAP80 paged 256K RAM
--
-- V6: get 80-col video working, and video switch port
--
-- V7: clean up the clocking and design control state machine
-- to allow off-chip memory read/write and off-chip I/O cycles
-- at nominal 4MHZ with control for I/O buffer that includes
-- intack cycles.
--
-- V8: do control logic for FDC (drive select etc).





--
-- Modifications to Grant's original design by foofoobedoo@gmail.com
-- In summary:
-- * Deploy 6809 modified to use async active-low reset, posedge clock
-- * Clock 6809 from master (50MHz) clock and control execution rate by
--   asserting HOLD
-- * Speed up clock cycle when no external access (VMA=0)
-- * Generate external SRAM control signals synchronously rather than with
--   gated clock
-- * Deploy VDU design modified to fix scroll bug and changed to run only on
--   posedge clock (submitted to Grant but not yet published by him)
-- * Deploy SDcard design modified to run on posedge clock and to support
--   SDHC as wall as SDSC.
-- * Replace BASIC ROM with ROM for CamelForth
-- * Add 2nd serial port ($FFD4-$FFD5)
-- * Reset baud rate generator and generate enable rather than async
--   clock. Associated changes to UART. Change UART to use posedge of clk.
-- * Add GPIO unit
--   For detailed description and programming details, refer to the
--   detailed comments in the header of gpio.vhd)
-- * Add mk2 memory mapper unit that is a functional super-set of the COCO
--   design. Has the following capabilities:
--   * Can address upto 1024KByte (2 512KByte SRAM chips)
--   * Can page any 8Kbyte SRAM region into any 8KByte region of processor
--     address space
--   * Can write-protect any region
--   * Can enable/disable ROM in the top 8Kbyte region
--   * Includes a 50Hz timer interrupt with efficient register interface
--   * Includes a NMI generator for code single-step
--   For detailed description and programming details, refer to the
--   detailed comments in the header of mem_mapper2.vhd)
-- * PIN3 is output: SD DRIVE LED
-- * PIN7 is output LED (unused)
-- * PIN9 is output LED (unused.. echoes back the state of input pin 48
-- * vduffd0 (pin 48) is input, selects I/O assignment:
--   OFF: PS2/VGA is UART0 at address $FFD0-$FFD1, SERIALA is UART1 at $FFD2-$FFD3
--   ON : PS2/VGA is UART0 at address $FFD2-$FFD3, SERIALA is UART1 at $FFD0-$FFD1
--
-- The pin assignments here are designed to match up with James Moxham's
-- multicomp PCB. The support for devices on that PCB is summaried below:
-- LED pin 3  - connected, controlled by SDcard
-- LED pin 7  - unused. LED off.
-- LED pin 9  - unused. LED off.
-- I/O pin 48 - vduffd0 (see description above).
-- I/O - not connected; most pins assigned for GPIO unit.
-- Refer to Microcomputer.qsf for GPIO (and any other) pinout details.
-- VGA - connected and used as 1st (primary) I/O device: 80x25 colour video
-- MONO - connected.
-- SD1 - connected.
-- PROTO - not connected
-- TOUCH - not connected
-- KBD - connected
-- SERIAL A - connected and used as 2nd I/O device
-- SERIAL B - connected and used as 3rd I/O device
-- MEMORY 512K - connected. Accessible through memory paging unit.
-- SECOND MEMORY - connected. Accessible through memory paging unit.
--

library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity NASCOM4 is
    port(
	     -- these are connected on the base FPGA board
        n_reset     : in std_logic;
        clk         : in std_logic;

        -- LEDs on base FPGA board and duplicated on James Moxham's PCB.
        -- Set LOW to illuminate. 3rd LED is "driveLED" output.
        n_LED7        : out std_logic := '1';
        n_LED9        : out std_logic := '1';  -- HALT

        -- External pull-up so this defaults to 1. When pulled to gnd
        -- this swaps the address decodes so that the Serial A port is
        -- decoded at $FFD0 and the VDU at $FFD2.
        vduffd0     : in std_logic;

        sRamData        : inout std_logic_vector(7 downto 0);
        sRamAddress     : out std_logic_vector(18 downto 0); -- 18:0 -> 512KByte
        n_sRamWE        : out std_logic;
        n_sRamCS        : out std_logic;                     -- lower blocks
        n_sRamCS2       : out std_logic;                     -- upper blocks
        n_sRamOE        : out std_logic;

        rxd1            : in std_logic;
        txd1            : out std_logic;
        rts1            : out std_logic;

        rxd2		: in std_logic;
        txd2		: out std_logic;
        rts2		: out std_logic;

        videoSync   : out std_logic;
        video       : out std_logic;

        videoR0     : out std_logic;
        videoG0     : out std_logic;
        videoB0     : out std_logic;
        videoR1     : out std_logic;
        videoG1     : out std_logic;
        videoB1     : out std_logic;
        hSync       : out std_logic;
        vSync       : out std_logic;

        ps2Clk      : inout std_logic;
        ps2Data     : inout std_logic;

        -- 3 GPIO mapped to "group A" connector. Pin 1..3 of that connector
        -- assigned to bit 0..2 of gpio0.
        -- Intended for connection to DS1302 RTC as follows:
        -- bit 2: CE          (FPGA PIN 42)
        -- bit 1: SCLK        (FPGA PIN 41)
        -- bit 0: I/O (Data)  (FPGA PIN 40)
        gpio0       : inout std_logic_vector(2 downto 0);
        -- 8 GPIO mapped to "group B" connector. Pin 1..8 of that connector
        -- assigned to bit 0..7 of gpio2.
        gpio2       : inout std_logic_vector(7 downto 0);

        sdCS        : out std_logic;
        sdMOSI      : out std_logic;
        sdMISO      : in std_logic;
        sdSCLK      : out std_logic;
        -- despite its name this needs to be LOW to illuminate the LED.
        driveLED    : out std_logic :='1'
    );
end NASCOM4;

architecture struct of NASCOM4 is

    signal n_WR                   : std_logic;
    signal n_RD                   : std_logic;
    signal n_cpuWr                : std_logic;
    signal hold                   : std_logic;
    signal vma                    : std_logic;
    signal state                  : std_logic_vector(2 downto 0);
    signal cpuAddress             : std_logic_vector(15 downto 0);
    signal cpuDataOut             : std_logic_vector(7 downto 0);
    signal cpuDataIn              : std_logic_vector(7 downto 0);
    signal sRamAddress_i          : std_logic_vector(18 downto 0);
    signal n_sRamCSHi_i           : std_logic;
    signal n_sRamCSLo_i           : std_logic;

    signal nasRomDataOut          : std_logic_vector(7 downto 0);
    signal nasWSRamDataOut        : std_logic_vector(7 downto 0);
    signal nasVidRamDataOut       : std_logic_vector(7 downto 0);
    signal interface1DataOut      : std_logic_vector(7 downto 0);
    signal interface2DataOut      : std_logic_vector(7 downto 0);
    signal interface3DataOut      : std_logic_vector(7 downto 0);
    signal gpioDataOut            : std_logic_vector(7 downto 0);
    signal sdCardDataOut          : std_logic_vector(7 downto 0);
    signal mmDataOut              : std_logic_vector(7 downto 0);

    signal irq                    : std_logic;
    signal nmi                    : std_logic;
    signal n_int1                 : std_logic :='1';
    signal n_int2                 : std_logic :='1';
    signal n_int3                 : std_logic :='1';
    signal n_tint                 : std_logic;

    signal n_nasWSRamCS           : std_logic :='1';
    signal n_nasVidRamCS          : std_logic :='1';
    signal n_nasRomCS             : std_logic :='1';
    signal n_interface1CS         : std_logic :='1';
    signal n_interface2CS         : std_logic :='1';
    signal n_interface3CS         : std_logic :='1';
    signal n_sdCardCS             : std_logic :='1';
    signal n_gpioCS               : std_logic :='1';

    signal serialClkCount         : std_logic_vector(15 downto 0) := x"0000";
    signal serialClkCount_d       : std_logic_vector(15 downto 0);
    signal serialClkEn            : std_logic;

    signal n_WR_uart              : std_logic := '1';
    signal n_RD_uart              : std_logic := '1';
    signal n_WR_uart2             : std_logic := '1';
    signal n_RD_uart2             : std_logic := '1';

    signal n_WR_sd                : std_logic := '1';
    signal n_RD_sd                : std_logic := '1';

    signal n_WR_gpio              : std_logic := '1';

    signal n_WR_vdu               : std_logic := '1';
    signal n_RD_vdu               : std_logic := '1';

    signal wren_nasWSRam          : std_logic := '1';
    signal wren_nasVidRam         : std_logic := '1';

    signal romInhib               : std_logic := '0';
    signal ramWrInhib             : std_logic := '0';

    signal gpio_dat0_i            : std_logic_vector(2 downto 0);
    signal gpio_dat0_o            : std_logic_vector(2 downto 0);
    signal n_gpio_dat0_oe         : std_logic_vector(2 downto 0);

    signal gpio_dat2_i            : std_logic_vector(7 downto 0);
    signal gpio_dat2_o            : std_logic_vector(7 downto 0);
    signal n_gpio_dat2_oe         : std_logic_vector(7 downto 0);

--[NAC HACK 2020Nov15] new to be tidied/integrated
    signal cpuClock               : std_logic := '1';
    signal n_MREQ                 : std_logic := '1';
    signal n_IORQ                 : std_logic := '1';
    signal n_HALT                 : std_logic;
    signal n_M1                   : std_logic;

    signal port00wr               : std_logic_vector(7 downto 0);
    signal portE4wr               : std_logic_vector(7 downto 0);
    signal portE8wr               : std_logic_vector(7 downto 0);
    signal portECwr               : std_logic_vector(7 downto 0);
    -- Writes to EE/EF
    signal video_map80vfc         : std_logic := '0';
    signal portFEwr               : std_logic_vector(7 downto 0);

    -- ff means no key detected
    signal port00rd               : std_logic_vector(7 downto 0) := x"ff";
    -- temp uart read
    signal port01rd               : std_logic_vector(7 downto 0) := x"00"; -- data
    -- 7    6    5    4    3   2    1    0
    -- DR   TRE  -    -    FE  PE  OE    -
    -- DR =data received
    -- TRE=transmit register empty
    signal port02rd               : std_logic_vector(7 downto 0) := x"80"; -- status -> always has data
    -- disk control
    signal porte4rd               : std_logic_vector(7 downto 0) := x"00";
    -- parallel keyboard
    signal porte6rd               : std_logic_vector(7 downto 0) := x"00";

    -- combine from misc ports (and UART?)
    signal nasLocalIODataOut      : std_logic_vector(7 downto 0);

    -- temp to drive UART
    signal uartcnt                : std_logic_vector(7 downto 0) := x"00";

    -- enable readback
    signal nasLocalIOCS           : std_logic;

    -- NMI to CPU and NMI state machine
    signal n_NMI                  : std_logic;
    signal nmi_state              : std_logic_vector(2 downto 0);

begin

    n_LED9 <= n_HALT;

-- ____________________________________________________________________________________
-- CPU CHOICE GOES HERE

    irq <= not(n_tint and n_int1 and n_int2 and n_int3);

    cpuClock <= clk; -- [NAC HACK 2020Nov15] fix.. this is 50MHz?

    cpu1 : entity work.T80s
      generic map(mode => 1, t2write => 1, iowait => 0)
      port map(
            clk_n   => cpuClock, -- or just clk??
            reset_n => n_reset,
            wait_n  => '1',
            int_n   => '1', -- TODO
            nmi_n   => n_NMI, -- from single-step logic
            busrq_n => '1', -- TODO probably unused
            halt_n  => n_HALT,
            m1_n    => n_M1,   -- TODO to s/step
            mreq_n  => n_MREQ, -- TODO rw => n_cpuWr,
            iorq_n  => n_IORQ, -- TODO vma => vma,
            rd_n    => n_RD,
            wr_n    => n_WR,
            a       => cpuAddress,
            di      => cpuDataIn,
            do      => cpuDataOut);

-- ____________________________________________________________________________________
-- ROM GOES HERE
    rom1 : entity work.Z80_NASSYS3_ROM -- 2KB ROM
    port map(
            address => cpuAddress(10 downto 0),
            clock => clk,
            q => nasRomDataOut);

-- ____________________________________________________________________________________
-- RAM GOES HERE

-- Assign to pins. Set the address width to match external RAM/pin assignments
    sRamAddress(18 downto 0) <= sRamAddress_i(18 downto 0);
    n_sRamCS  <= n_sRamCSLo_i;
    n_sRamCS2 <= n_sRamCSHi_i;

-- External RAM - high-order address lines come from the mem_mapper
    sRamAddress_i(12 downto 0) <= cpuAddress(12 downto 0);
    sRamData <= cpuDataOut when n_WR='0' else (others => 'Z');


-- Internal 1K WorkSpace RAM
    wren_nasWSRam <= not(n_MREQ or n_WR or n_nasWSRamCS);

    WSRam: entity work.InternalRam1K
    port map(
             address => cpuAddress(9 downto 0),
             clock => clk,
             data => cpuDataOut,
             wren => wren_nasWSRam,
             q => nasWSRamDataOut);

-- Internal 1K Video RAM
    wren_nasVidRam <= not(n_MREQ or n_WR or n_nasVidRamCS);

    VidRam: entity work.InternalRam1K
    port map(
             address => cpuAddress(9 downto 0),
             clock => clk,
             data => cpuDataOut,
             wren => wren_nasVidRam,
             q => nasVidRamDataOut);


-- ____________________________________________________________________________________
-- INPUT/OUTPUT DEVICES GO HERE

    -- Miscellaneous I/O port write
    proc_iowr: process(clk, n_reset)
    begin
      if (n_reset='0') then
        port00wr <= x"00";
        portE4wr <= x"00";
        portE8wr <= x"00";
        portECwr <= x"00";
        video_map80vfc <= '0';
        portFEwr <= x"00";
      elsif rising_edge(clk) then
        if cpuAddress(7 downto 0) = x"00" and n_IORQ = '0' and n_WR = '0' then
          port00wr <= cpuDataOut;
        end if;
        if cpuAddress(7 downto 0) = x"e4" and n_IORQ = '0' and n_WR = '0' then
          portE4wr <= cpuDataOut;
        end if;
        if cpuAddress(7 downto 0) = x"e8" and n_IORQ = '0' and n_WR = '0' then
          portE8wr <= cpuDataOut;
        end if;
        if cpuAddress(7 downto 0) = x"ec" and n_IORQ = '0' and n_WR = '0' then
          portECwr <= cpuDataOut;
        end if;
        if cpuAddress(7 downto 0) = x"ee" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '1';
        end if;
        if cpuAddress(7 downto 0) = x"ef" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '0';
        end if;
        if cpuAddress(7 downto 0) = x"fe" and n_IORQ = '0' and n_WR = '0' then
          portFEwr <= cpuDataOut;
        end if;
      end if;
    end process;

    -- [NAC HACK 2020Nov16] here, I drive data for any IO request -- will need changing for real local UART and for external IO read
    -- [NAC HACK 2020Nov16] and interrupt ack
    -- I/O port read..
    -- 00 read from input pins
    -- E4 read from stuff.. disk control
    -- E6 parallel keyboard synthesised from PS/2 kbd
    -- Miscellaneous I/O port write
    proc_iord: process(cpuAddress)
    begin
      if cpuAddress(7 downto 0) = x"00" then
        nasLocalIODataOut  <= port00rd;
      elsif cpuAddress(7 downto 0) = x"01" then
        nasLocalIODataOut  <= port01rd; -- data
      elsif cpuAddress(7 downto 0) = x"02" then
        nasLocalIODataOut  <= port02rd; -- status
      elsif cpuAddress(7 downto 0) = x"e4" then
        nasLocalIODataOut  <= porte4rd;
      elsif cpuAddress(7 downto 0) = x"e6" then
        nasLocalIODataOut  <= porte6rd;
      else
        nasLocalIODataOut  <= x"00";
      end if;
    end process;

    proc_uartcnt: process(clk, n_reset)
    begin
      if (n_reset='0') then
        uartcnt <= x"00";
      elsif rising_edge(clk) then
        if cpuAddress(7 downto 0) = x"01" and n_IORQ = '0' and n_RD = '0' then
          uartcnt <= uartcnt + x"01";
        end if;
      end if;
    end process;

    port01rd <= x"53" when uartcnt = 0 else -- SC80<newline><newline>
                x"43" when uartcnt = 1 else
                x"38" when uartcnt = 2 else
                x"30" when uartcnt = 3 else
                x"0d" when uartcnt = 4 else
                x"0d" when uartcnt = 5 else
                x"0d" when uartcnt = 6 else
                x"20";

    -- Single-step logic
    -- Write to Port 0. Then, M1 cycles:
    -- 0x472 F1    POP AF
    -- 0x473 ED
    -- 0x474 45    RETN (2 M1 cycles)
    -- 0x??? the target address of the single-step
    -- By wave inspection, this seems to work correctly: two
    -- single-step commands in a row start execution at
    -- successive addresses.
    proc_sstep: process(clk, n_reset)
    begin
      if (n_reset='0') then
        n_NMI <= '1';
        nmi_state <= "000";
      elsif rising_edge(clk) then
        -- only assert NMI for 1 cycle
        if (n_NMI = '0') then
          n_NMI <= '1';
        end if;
        if (port00wr(3) = '0') then
          nmi_state <= "000";
        elsif n_M1 = '0' and n_RD = '0' then
          if (nmi_state = "011") then
            n_NMI <= '0';
          end if;
          if (nmi_state /= "111") then
            nmi_state <= nmi_state + "001";
          end if;
        end if;
      end if;
    end process;


    n_WR_vdu <= n_interface1CS or n_WR;
    n_RD_vdu <= n_interface1CS or n_RD;

    io1 : entity work.SBCTextDisplayRGB

    generic map(
      -- Select one or other (NOT BOTH!) sets

      -- 80x25 uses all the internal RAM
      DISPLAY_TOP_SCANLINE => 35,
      VERT_SCANLINES => 448,
      V_SYNC_ACTIVE => '1'

      -- 40x25 leaves resource for internal 2k RAM

--      HORIZ_CHARS => 40,
--      CLOCKS_PER_PIXEL => 4
    )

    port map (
            n_reset => n_reset,
            clk => clk,

            -- RGB video signals
            hSync => hSync,
            vSync => vSync,
            videoR0 => videoR0,
            videoR1 => videoR1,
            videoG0 => videoG0,
            videoG1 => videoG1,
            videoB0 => videoB0,
            videoB1 => videoB1,

            -- Monochrome video signals (when using TV timings only)
            sync => videoSync,
            video => video,

            n_wr => n_WR_vdu,
            n_rd => n_RD_vdu,
            n_int => n_int1,
            regSel => cpuAddress(0),
            dataIn => cpuDataOut,
            dataOut => interface1DataOut,
            ps2Clk => ps2Clk,
            ps2Data => ps2Data);



    n_WR_uart <= n_interface2CS or n_WR;
    n_RD_uart <= n_interface2CS or n_RD;

    io2 : entity work.bufferedUART
    port map(
            clk => clk,
            n_wr => n_WR_uart,
            n_rd => n_RD_uart,
            n_int => n_int2,
            regSel => cpuAddress(0),
            dataIn => cpuDataOut,
            dataOut => interface2DataOut,
            rxClkEn => serialClkEn,
            txClkEn => serialClkEn,
            rxd => rxd1,
            txd => txd1,
            n_cts => '0',
            n_dcd => '0',
            n_rts => rts1);

    n_WR_uart2 <= n_interface3CS or n_WR;
    n_RD_uart2 <= n_interface3CS or n_RD;

    io3 : entity work.bufferedUART
    port map(
            clk => clk,
            n_wr => n_WR_uart2,
            n_rd => n_RD_uart2,
            n_int => n_int3,
            regSel => cpuAddress(0),
            dataIn => cpuDataOut,
            dataOut => interface3DataOut,
            rxClkEn => serialClkEn,
            txClkEn => serialClkEn,
            rxd => rxd2,
            txd => txd2,
            n_cts => '0',
            n_dcd => '0',
            n_rts => rts2);

    n_WR_sd <= n_sdCardCS or n_WR;
    n_RD_sd <= n_sdCardCS or n_RD;

    sd1 : entity work.sd_controller
    generic map(
        CLKEDGE_DIVIDER => 25 -- edges at 50MHz/25 = 2MHz ie 1MHz sdSCLK
    )
    port map(
            sdCS => sdCS,
            sdMOSI => sdMOSI,
            sdMISO => sdMISO,
            sdSCLK => sdSCLK,
            n_wr => n_WR_sd,
            n_rd => n_RD_sd,
            n_reset => n_reset,
            dataIn => cpuDataOut,
            dataOut => sdCardDataOut,
            regAddr => cpuAddress(2 downto 0),
            driveLED => driveLED,
            clk => clk
    );

    mm1 : entity work.mem_mapper2
    port map(
            n_reset => n_reset,
            clk => clk,
            hold => hold,
            n_wr => n_WR_sd,

            dataIn => cpuDataOut,
            dataOut => mmDataOut,
            regAddr => cpuAddress(2 downto 0),

            cpuAddr => cpuAddress(15 downto 9),
            ramAddr => sRamAddress_i(18 downto 13),
            ramWrInhib => ramWrInhib,
            romInhib => romInhib,

            n_ramCSHi => n_sRamCSHi_i,
            n_ramCSLo => n_sRamCSLo_i,

            n_tint => n_tint,
            nmi => nmi,
            frt => n_LED7 -- debug
    );

    n_WR_gpio <= n_gpioCS or n_WR;

    gpio1 : entity work.gpio
    port map(
            n_reset => n_reset,
            clk => clk,
            hold => hold,
            n_wr => n_WR_gpio,

            dataIn => cpuDataOut,
            dataOut => gpioDataOut,
            regAddr => cpuAddress(0),

            dat0_i => gpio_dat0_i,
            dat0_o => gpio_dat0_o,
            n_dat0_oe => n_gpio_dat0_oe,

            dat2_i => gpio_dat2_i,
            dat2_o => gpio_dat2_o,
            n_dat2_oe => n_gpio_dat2_oe
    );

    -- pin control. There's probably an easier way of doing this??
    gpio_dat0_i <= gpio0;
    pad_ctl_gpio0: process(gpio_dat0_o, n_gpio_dat0_oe)
    begin
      for gpio_bit in 0 to 2 loop
        if n_gpio_dat0_oe(gpio_bit) = '0' then
          gpio0(gpio_bit) <= gpio_dat0_o(gpio_bit);
        else
          gpio0(gpio_bit) <= 'Z';
        end if;
      end loop;
    end process;

    gpio_dat2_i <= gpio2;
    pad_ctl_gpio2: process(gpio_dat2_o, n_gpio_dat2_oe)
    begin
      for gpio_bit in 0 to 7 loop
        if n_gpio_dat2_oe(gpio_bit) = '0' then
          gpio2(gpio_bit) <= gpio_dat2_o(gpio_bit);
        else
          gpio2(gpio_bit) <= 'Z';
        end if;
      end loop;
    end process;

-- ____________________________________________________________________________________
-- MEMORY READ/WRITE LOGIC GOES HERE

-- ____________________________________________________________________________________
-- CHIP SELECTS GO HERE

    -- Nascom code ROM and workspace RAM
    n_nasRomCS    <= '0' when cpuAddress(15 downto 11) = "00000" and romInhib='0' else '1'; -- 2K at bottom of memory
    n_nasWSRamCS  <= '0' when cpuAddress(15 downto 10) = "000011" else '1'; -- 1K at 0C00
    n_nasVidRamCS <= '0' when cpuAddress(15 downto 10) = "000010" else '1'; -- 1K at 0800

    -- vduffd0 swaps the assignment. Internal pullup means it is 1 by default
    n_interface1CS <= '0' when ((cpuAddress(15 downto 1) = "111111111101000" and vduffd0 = '1')  -- 2 bytes FFD0-FFD1
                              or(cpuAddress(15 downto 1) = "111111111101001" and vduffd0 = '0')) -- 2 bytes FFD2-FFD3
                      else '1';
    n_interface2CS <= '0' when ((cpuAddress(15 downto 1) = "111111111101000" and vduffd0 = '0')  -- 2 bytes FFD0-FFD1
                              or(cpuAddress(15 downto 1) = "111111111101001" and vduffd0 = '1')) -- 2 bytes FFD2-FFD3
                      else '1';

    n_interface3CS <= '0' when cpuAddress(15 downto 1) = "111111111101010" else '1'; -- 2 bytes FFD4-FFD5
    n_gpioCS       <= '0' when cpuAddress(15 downto 1) = "111111111101011" else '1'; -- 2 bytes FFD6-FFD7
    n_sdCardCS     <= '0' when cpuAddress(15 downto 3) = "1111111111011"   else '1'; -- 8 bytes FFD8-FFDF
    -- experimented with allowing RAM to be written to "underneath" ROM but
    -- there is no advantage vs repaging the region, and it causes problems because
    -- it's necessary to avoid writing to the I/O space.

-- ____________________________________________________________________________________
-- BUS ISOLATION GOES HERE

--    cpuDataIn <=
--                        interface1DataOut    when n_interface1CS = '0' else
--                        interface2DataOut    when n_interface2CS = '0' else
--                        interface3DataOut    when n_interface3CS = '0' else
--                        gpioDataOut          when n_gpioCS = '0'       else
--                        sdCardDataOut or mmDataOut  when n_sdCardCS = '0' else
--                        basRomData           when n_basRomCS = '0' else
--                        internalRam1DataOut when n_internalRam1CS= '0' else
--                        sRamData;
    cpuDataIn <=
                        nasLocalIODataOut       when n_IORQ        = '0' else
                        nasRomDataOut           when n_nasRomCS    = '0' else
                        nasWSRamDataOut         when n_nasWSRamCS  = '0' else
                        nasVidRamDataOut        when n_nasVidRamCS = '0' else
                        sRamData;

-- ____________________________________________________________________________________
-- SYSTEM CLOCKS GO HERE


    -- Serial clock DDS. With 50MHz master input clock:
    -- Baud   Increment
    -- 115200 2416
    -- 38400  805
    -- 19200  403
    -- 9600   201
    -- 4800   101
    -- 2400   50
    baud_div: process (serialClkCount_d, serialClkCount)
    begin
        serialClkCount_d <= serialClkCount + 2416;
    end process;

    baud_clk: process(clk)
    begin
        if rising_edge(clk) then
        end if;
    end process;

-- SUB-CIRCUIT CLOCK SIGNALS
    clk_gen: process (clk) begin
    if rising_edge(clk) then
        -- Enable for baud rate generator
        serialClkCount <= serialClkCount_d;
        if serialClkCount(15) = '0' and serialClkCount_d(15) = '1' then
            serialClkEn <= '1';
        else
            serialClkEn <= '0';
        end if;

        -- CPU clock control. The CPU input clock is 50MHz and the HOLD input acts
		  -- as a clock enable. When the CPU is executing internal cycles (indicated by
		  -- VMA=0), HOLD asserts on alternate cycles so that the effective clock rate
		  -- is 25MHz. When the CPU is performing memory accesses (VMA=1), HOLD asserts
		  -- for 4 cycles in 5 so that the effective clock rate is 10MHz. The slower
		  -- cycle time is calculated to meet the access time for the external RAM.
		  -- The n_WR, n_RD signals (and the SRAM WE/OE signals) are asserted for the
		  -- last 4 cycles of the 5-cycle access; these are not the critical path for
		  -- the access: the critical path is the addresss and chip select, which are
		  -- nominally valid for all 5 cycles.
		  -- The clock control is implemented by a counter, which tracks VMA. The
		  -- HOLD and n_WR, n_RD controls are a synchronous decode from the counter.
		  -- When VMA=0, state transitions 0,4,0,4,0,4...
		  -- When VMA=1, state transitions 0,1,2,3,4,0,1,2,3,4...
		  --
		  -- In both cases, HOLD is negated (clock runs) when state=4 and so the CPU
		  -- address (and VMA) transitions when state goes 4->0.
		  --
		  -- Speed-up options (if your RAM can take it)
		  -- - You can easily take 1 or 2 cycles out of this timing (eg to remove 1 cycle
		  --   change 3 to 2 and 4 to 3 in the logic below).
		  -- - Theoretically, since the 6809 timing-closes at 50MHz, you can eliminate
		  --   the wait state from the VMA=0 cycles. However, that would mean generating
		  --   HOLD combinatorially from VMA which might introduce a timing loop.

        -- state control - counter influenced by VMA
        if state = 0 and vma = '0' then
            state <= "100";
        else
            if state < 4 then
                state <= state + 1;
            else
                -- this gives the 4->0 transition and also provides
                -- synchronous reset.
                state <= (others=>'0');
            end if;
        end if;

        -- decode HOLD from state and VMA
        if state = 3 or (state = 0 and vma = '0') then
            hold <= '0'; -- run the clock
        else
            hold <= '1'; -- pause the clock
        end if;

        -- decode memory and RW control from state etc.
        if (state = 1 or state = 2 or state = 3) then
            if n_cpuWr = '0' then
--                n_WR <= '0';
                n_sRamWE <= (n_sRamCSHi_i and n_sRamCSLo_i) or ramWrInhib ; -- synchronous and glitch-free
            else
--                n_RD <= '0';
                n_sRamOE <= n_sRamCSHi_i and n_sRamCSLo_i; -- synchronous and glitch-free
            end if;
        else
--            n_WR <= '1';
--            n_RD <= '1';
            n_sRamWE <= '1';
            n_sRamOE <= '1';
        end if;
    end if;
    end process;

end;
