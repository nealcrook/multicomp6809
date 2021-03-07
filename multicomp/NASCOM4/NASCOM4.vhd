-- TODO/BUGS
-- Consider changing ROMs to be a single model with an initialisation file
--   and put them in a generic folder.
-- Change char gen to an initialised RAM and add control port for writes
-- Review compilation warnings and fix
-- Do gate-count estimate for adding GM813 memory-mapper
-- Make sure input-only pins can have internal pullups
--
-- Next..
-- add cursor key support to keyboard
-- add fn key support to keyboard, with clear-down
-- existing reset pin needs to set a bit in the reason register
-- new soft-reset needs to set a bit in the reason register
-- write to reason register OR NMI needs to clear bits in
-- reason register, back to kbd.
--
-- Allow the image loader to load exact image sizes
-- (maybe??) so that loading the memory test doesn't
-- result in stack corruption

-- "javino store" for rt-angle push buttons with footprint
-- "jc electronic components" for rocker push button with
-- LED. But then need break-off strip on edge of PCB.
-- RESET/SDACTIVE SOFT/DRIVE NMI/HALT
--
-- Need a soft reset of the kbd to avoid the
-- reported input letter after menu boot.. or
-- a delay: the menu items that load lots of stuff do
-- not suffer from the problem. Maybe: make the clear
-- reason code also clear the keyboard map; that would
-- fix the problem.

-- NEXT STEPS
-- modify kbd to generate cursor and FN keys
-- bodge on push-buttons for cold/warm/nmi and
-- add debounce and cleardown and reason code.
-- BUG: cannot warm-start PASCAL: it HALTs. Why?
-- modify baud to be input or local, add slower divisors,
-- control from new register at $1D
-- add (programmable) support for 2 stop bits in the UART.

-----------------------------------------------------


-- FPGA implementation of the NASCOM2
-- with external RAM, Flash/ROM and peripherals.
-- Goal is to be 100% software compatible with plain NASCOM 2
-- and 99.9% compatible with a NASCOM system comprising:
-- * NASCOM2 board
-- * MAP80 256K RAM board
-- * MAP80 VFC
--
-- The "99.9%" is because I do not reproduce the 6845 on the VFC but
-- have a fixed hardware setup for that video control..
--
-- Lots of ideas and some bits of code from Grant Searle's FPGA "Multicomp"
-- design, which is copyright by Grant Searle 2014: http://www.searle.wales/
-- http://searle.x10host.com/Multicomp/index.html
--
-- Also, some bits of code from my extended 6809 design.
--
-- Memory and I/O map:
-- * 2KROM "NAS-SYS3" at location 0.
--   - can be paged out via I/O write, allowing it to be replaced
--     or patched or breakpointed
-- * 1K video RAM at location 0x800
--   - can be paged out via I/O write
--   - can be decoded at 0xF800 instead, for NASCOM CP/M
-- * 1K ws RAM at location 0xc00
--   - can be paged out via I/O write
-- * 1K "Special Boot ROM" at location 0x1000.
--   - always enabled at reset, and takes control through
--     jump-on-reset circuit
--   - can be paged out via I/O write; delayed disable allows the
--     code that disables it to be contained in the ROM
-- * Write-protect register allows memory regions to appear
--   ROM-like
-- * 2K MAP80 VFC ROM.
--   - can be decoded at the start of any 4Kbyte block
--     or disabled, via write to port 0xEC.
-- * 2K MAP80 VFC video RAM.
--   - can be decoded at the end of any 4Kbyte block
--     or disabled, via write to port 0xEC.
-- * 4K bytes character generator ROM.
--   - 256 characters, each 8 pixels wide by 16 rows.
--   - can be re-written (TBD how)
-- * 512/1024Kbyte RAM EXTERNAL
--   - mapped as 64Kbyte 32Kbyte pages, controlled
--     through port 0xFE like two/four MAP80 256Kbyte RAM cards.
-- * SDcard interface with high-level block read/write (no bit-banging)
--   allows ROM images to be loaded on reset under the control of the
--   Special Boot ROM.
--
-- * I/O port 0     - keyboard and single-step control
-- * I/O port 1,2   - 6402 compatible UART
-- * I/O port 4-7   - EXTERNAL Z80 PIO (matches NASCOM 1/2)
-- * I/O port 8-B   - EXTERNAL Z80 CTC (matches NASCOM I/O board)
-- * I/O port 10-14 - NEW SDcard controller
-- * I/O port 18    - NEW controls paging of ROM/RAM/VDU
-- * I/O port 19    - NEW controls RAM write-protect
-- * I/O port 1A    - NEW memory stall control
-- * I/O port 1B    - NEW por high byte (controlled by SBROM)
-- * I/O port 1C    - NEW reset reason (controlled by reset/fn keys)
-- * I/O port E0-E3 - EXTERNAL WD2797 Floppy Disk Controller
-- * I/O port E4    - VFC FDC drive select etc.
-- * I/O port E6    - VFC "parallel" keyboard (maybe; from PS/2 keyboard) - NOT IMPLEMENTED
-- * I/O port E8    - VFC Alarm (beeper?) output - NOT IMPLEMENTED
-- * I/O port EA    - VFC MC6845 register select - NOT IMPLEMENTED
-- * I/O port EB    - VFC MC6845 data - NOT IMPLEMENTED
-- * I/O port EC    - VFC mapping register (write-only)
-- * I/O port EE    - VFC write to select VFC video on output
-- * I/O port EF    - VFC write to select NASCOM video on output
-- * I/O port FE    - MAP80 256KRAM paging/memory mapping (write-only)


-- Connection off-chip to:
-- * VGA video drive
-- * Serial in/out and optional serial clock in (via level translators)
-- * NASCOM-compatible Keyboard connector (via level translators)
-- * PS/2 keyboard connector (not authentic but more available)
-- * 256Kbyte RAM (TBD device)
-- * SDcard for loading "ROM" images
-- * I/O bus for PIO, FDC
-- * Data-bus buffer/level translator with control signals
-- * FDC drive select, data ready/intrq, fm/mfm select

-- decide what to do wrt integrated SDcard controller vs NAScas/arduino hookup.
-- could put in a separate // port for connecting? And sw select of the serial
-- source allowing tape loading.. but then, would want to use this to do the
-- ROM load as well, and not use the integrated SDcard controller.
--
-- The "Special boot ROM" (SBootROM) is decoded at address $1000. It is always
-- enabled at reset but can be paged out later. It takes control through a bit
-- of jump-on-reset logic (rather like a real NASCOM2). It looks at a "reason"
-- register to choose between a cold reset and a warm reset. In the case of a
-- warm reset it tries to touch as little hardware as possible and restarts to
-- the entry point from the last cold reset, paging itself out on the way.
-- In the case of a cold reset, it initialises NAS-SYS (so that it can use the
-- NAS-SYS restarts and other I/O routines) and presents a boot menu that is
-- read from SDcard. There are upto 26 menu items, selected using letters A-Z.
-- Each menu item runs a small script (also stored on SDcard) called a "profile".
-- A profile can load images and modify memory and I/O and terminates by
-- writing to the mapping register (usually to disable SBootROM) and jumping
-- somwhere. The SDcard contents is managed on a PC using a script make_sdcard_image.
--
-- The format of the profile is documented in make_sdcard_image and also in
-- the source code for the SBootROM.


-- I/O assignment/reassignment:

-- Current         New
-- gpio0(2)        in, NMI button
-- gpio0(1)        in, warm/cold reset (actually using VFUFFD0 pin currently)
-- gpio0(0)        in,
--
-- n_LED7          out, DRIVE - [NAC HACK 2020Nov25] not yet coded.
-- n_LED9          out, HALT
-- gpio2(7)        out, nascom kbd clk
-- gpio2(6)        out, nascom kbd rst
-- gpio2(5)        out, /M1 (for int ack)
-- gpio2(4)        out, CLK (for PIO)
-- gpio2(3)        out, IORQ (for PIO)
-- gpio2(2)        out, RD (for PIO)
-- gpio2(1)        out, WR (for PIO)
-- gpio2(0)        in, INT (for PIO)
-- vduffd0         out, buf oe (for I/O bus buffer)
-- rxd2            out, buf dir (for I/O bus buffer)
-- txd2            out, ioclk for motor on/drive select/fm~mfm register
-- rt2s            out iooe for reading 3 FDC status signals: INT/DAV/BUSY
-- videoSync       out iooe for reading NASCOM kbd data
-- txd1            out UART TXD
-- rxd1            in UART RXD
-- rts1            in UART TXRXCLK
-- video           out FDC chip select
--                 out PIO chip select
--
-- .. may run out of pins..
-- currently this allows me to keep the 5 pins assigned to SDcard and its LED
-- and the PS/2 keyboard connection
-- and the 8 pins for VGA. VGA could be reduced to 3 pins freeing 5
-- if I have 2 VGA ports, using 6 pins, I'll still free 2 pins.. one for the PIO
-- chip select and one spare (FDC clock?? Reset??)
--
-- ..just hope I did not forget anything!
-- mitigation is to put Port0 output latch externally:
-- add 1 control signal, remove connections for LED, KBD-reset, KBD-clock
-- and so save 2 pins. Still do the single-step bit internally but also publish it in the I/O write.



------
-- Work out how to do shared video access to char gen:
-- add debug signals to show reads of video/chargen RAM
------
-- Add write port to char gen.. how to decode? Whole of VFC space?
-- Code synchroniser and pulse generator for NMI push button
-- Work out what's needed for FDC miscellaneous control
-- Look at clocking, implement external RAM interface, allow
-- slow-down for I/O cycles. Allow operation at a lower clock speed.
-- Work out external pin mapping.
-- Consider Arduino interface; 1 or 2 external SDcards..

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
    generic( constant RTLSIM_UART : boolean := FALSE
    );
    port(
	-- these are connected on the base FPGA board
        n_reset       : in std_logic;
        clk           : in std_logic;

        -- LEDs on base FPGA board and duplicated on James Moxham's PCB.
        -- Set LOW to illuminate. 3rd LED is "driveLED" output from SDcard
        n_LED7        : out std_logic := '1';  -- DRIVE (tape)
        n_LED9        : out std_logic := '1';  -- HALT

        -- External pull-up so this defaults to 1. When pulled to gnd
        -- SBootROM will do a COLD reset. Otherwise, warm reset
        vduffd0         : in std_logic;

        sRamData        : inout std_logic_vector(7 downto 0);
        sRamAddress     : out std_logic_vector(18 downto 0); -- 18:0 -> 512KByte
        n_sRamWE        : out std_logic;
        n_sRamCS        : out std_logic;                     -- lower blocks [NAC HACK 2020Dec08] rename CSLo
        n_sRamCS2       : out std_logic;                     -- upper blocks [NAC HACK 2020Dec08] rename CSHi
        n_sRamOE        : out std_logic;

        rxd1            : in std_logic;
        txd1            : out std_logic;
        rts1            : out std_logic; -- [NAC HACK 2020Dec04] unused

        rxd2		: in std_logic; -- [NAC HACK 2020Dec04] unused.. now used for CPU INT
        txd2		: out std_logic; -- [NAC HACK 2020Dec04] unused
        rts2		: out std_logic; -- [NAC HACK 2020Dec04] unused

        videoSync   : out std_logic; -- [NAC HACK 2020Dec04] unused
        video       : out std_logic; -- [NAC HACK 2020Dec04] unused

        videoR0     : out std_logic;
        videoG0     : out std_logic;
        videoB0     : out std_logic;
        videoR1     : out std_logic;
        videoG1     : out std_logic;
        videoB1     : out std_logic;
        hSync       : out std_logic;
        vSync       : out std_logic;

        ps2Clk      : inout std_logic; -- [NAC HACK 2020Dec04] currently unused, reserved
        ps2Data     : inout std_logic; -- [NAC HACK 2020Dec04] currently unused, reserved

        -- 3 GPIO mapped to "group A" connector. Pin 1..3 of that connector
        -- assigned to bit 0..2 of gpio0.
        -- Intended for connection to DS1302 RTC as follows:
        -- bit 2: CE          (FPGA PIN 42)
        -- bit 1: SCLK        (FPGA PIN 41)
        -- bit 0: I/O (Data)  (FPGA PIN 40)
        gpio0       : in std_logic_vector(2 downto 0); --[NAC HACK 2020Nov25] was bootmode now unused
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
    signal hold                   : std_logic;
    signal cpuAddress             : std_logic_vector(15 downto 0);
    signal cpuDataOut             : std_logic_vector(7 downto 0);
    signal cpuDataIn              : std_logic_vector(7 downto 0);
    signal n_sRamCSHi_i           : std_logic;
    signal n_sRamCSLo_i           : std_logic;

    signal nasRomDataOut          : std_logic_vector(7 downto 0);
    signal vfcRomDataOut          : std_logic_vector(7 downto 0);
    signal sbootRomDataOut        : std_logic_vector(7 downto 0);
    signal nasWSRamDataOut        : std_logic_vector(7 downto 0);
    signal VDURamDataOut          : std_logic_vector(7 downto 0);
    signal UartDataOut            : std_logic_vector(7 downto 0);
    signal sdCardDataOut          : std_logic_vector(7 downto 0);

    signal irq                    : std_logic;

    signal n_nasWSRamCS           : std_logic :='1';
    signal n_nasVidRamCS          : std_logic :='1';
    signal n_nasRomCS             : std_logic :='1';

    signal n_vfcVidRamCS          : std_logic :='1';
    signal n_vfcRomCS             : std_logic :='1';

    signal n_sbootRomCS           : std_logic :='1';
    signal n_UartCS               : std_logic :='1';
    signal n_sdCardCS             : std_logic :='1';

    signal serialClkCount         : std_logic_vector(15 downto 0) := x"0000";
    signal serialClkCount_d       : std_logic_vector(15 downto 0);
    signal serialClkEn            : std_logic;

    signal n_WR_uart              : std_logic := '1';
    signal n_RD_uart              : std_logic := '1';

    signal n_WR_sd                : std_logic := '1';
    signal n_RD_sd                : std_logic := '1';

    signal n_WR_gpio              : std_logic := '1';

    signal wren_nasWSRam          : std_logic := '1';

--[NAC HACK 2020Nov15] new to be tidied/integrated

    -- Event interface to PS/2 keyboard
    signal KbdEvent               : std_logic;
    signal KbdEventCode           : std_logic_vector(3 downto 0);
    signal KbdClearEvent          : std_logic := '0';

    -- synchronise reset and generate control for jump-on-reset
    signal n_reset_s1             : std_logic;
    signal n_reset_s2             : std_logic;
    signal n_reset_clean          : std_logic;
    signal post_reset_rd_cnt      : std_logic_vector(1 downto 0);
    signal reset_jump             : std_logic;

    signal n_WAIT                 : std_logic;
    signal cpuClock               : std_logic := '1';
    signal n_MREQ                 : std_logic := '1';
    signal n_IORQ                 : std_logic := '1';
    signal n_HALT                 : std_logic;
    signal n_M1                   : std_logic;

    signal n_memWr                : std_logic;


    ------------------------------------------------------------------
    -- To the outside world. Can go from here once I tidy up the
    -- top-level ports list
    signal clk4                   : std_logic;
    signal clk1                   : std_logic;
    signal io_reset_n             : std_logic;
    signal pio_cs_n               : std_logic;
    signal ctc_cs_n               : std_logic;
    signal fdc_cs_n               : std_logic;
    signal porte4_wr              : std_logic;
    signal port00_rd_n            : std_logic;
    signal BrM1_n                 : std_logic;
    signal BrIORQ_n               : std_logic;
    signal BrRD_n                 : std_logic;
    signal BrWR_n                 : std_logic;
    signal BrBufOE_n              : std_logic;
    signal BrBufWr                : std_logic;

    -- TODO these will be inputs and go to the read path of the E4 port
    signal FdcIntr                : std_logic;
    signal FdcDrq                 : std_logic;
    signal FdcRdy_n               : std_logic;

    -- internal signals for bridge
    signal BridgeRdData           : std_logic_vector(7 downto 0);


    ------------------------------------------------------------------
    -- Port 0: NASCOM keyboard and NMI control

    -- NASCOM implements 6 bits but only uses 4. The two unused bits
    -- are wired to the NASCOM2 keyboard connector
    signal iopwr00NasDrive        : std_logic; -- bit 4
    signal iopwr00NasNMI          : std_logic; -- bit 3
    signal iopwr00NasKbdRst       : std_logic; -- bit 1
    signal iopwr00NasKbdClk       : std_logic; -- bit 0
    -- ff means no key detected
    signal ioprd00                : std_logic_vector(7 downto 0) := x"ff";


    ------------------------------------------------------------------
    -- Ports 1,2: UART
    --
    -- Only used when RTLSIM_UART is TRUE
    signal ioprd01                : std_logic_vector(7 downto 0) := x"00"; -- UART data
    signal ioprd02                : std_logic_vector(7 downto 0) := x"80"; -- UART status -> always has data
    signal uartcnt                : std_logic_vector(7 downto 0) := x"00";

    ------------------------------------------------------------------
    -- Port 4,5,6,7: PIO (external)

    ------------------------------------------------------------------
    -- Port 10-17: Decoded for SDcard (only 10,11,12,13,14 used)

    ------------------------------------------------------------------
    -- Port 18: new for FPGA implementation (R/W)
    -- NOT RESET to allow warm reset flow in SBROM
    -- The initial states below allow a warm reset from SBROM in
    -- RTL simulation.
    -- B7          unused, read 0
    -- B6          unused, read 0
    -- B5          MAP80 VFC autoboot
    -- B4          1: enable NASCOM WS RAM
    -- B3          0: disable NAS-SYS  1: enable NAS-SYS
    -- B2          0: disable SBootROM 1: enable SBootROM
    -- B1          0: VRAM@800, 1:VRAM@F800 (for CP/M)
    -- B0          1: enable NASCOM VRAM
    --
    -- The autoboot bit controls the VFC ROM enable:
    -- autoboot=0 : after reset, the ROM is disabled; writing a 1
    --              enables the ROM.
    -- autoboot=1 : after reset, the ROM is enabled; writing a 1
    --              disables the ROM.
    --
    -- Implementation:
    -- * register bit iopwrECRomEnable is reset to a 0.
    -- * ROM enable is autoboot XOR iopwrECRomEnable

    signal iopwr18MAP80AutoBoot   : std_logic := '0'; -- bit 5
    signal iopwr18NasWsRam        : std_logic := '1'; -- bit 4
    signal iopwr18NasSysRom       : std_logic := '1'; -- bit 3
    signal iopwr18SBootRom        : std_logic := '1'; -- bit 2
    signal iopwr18NasVidHigh      : std_logic := '0'; -- bit 1
    signal iopwr18NasVidRam       : std_logic := '1'; -- bit 0
    signal ioprd18                : std_logic_vector(7 downto 0);

    signal SBootRomState          : std_logic_vector(1 downto 0);

    ------------------------------------------------------------------
    -- Port 19: RAM write protect
    -- Ef8k means: from E000 for 8K

    signal iopwr19ProtEf8k        : std_logic; -- bit 6 Protect BASIC
    signal iopwr19ProtDf4k        : std_logic; -- bit 5 Protect ZEAP etc
    signal iopwr19ProtCf4k        : std_logic; -- bit 4 Protect ??
    signal iopwr19ProtBf4k        : std_logic; -- bit 3 Protect ??
    signal iopwr19ProtAf4k        : std_logic; -- bit 2 Protect ??
    signal iopwr19Prot0f2k        : std_logic; -- bit 0 Protect NAS-SYS
    signal ioprd19                : std_logic_vector(7 downto 0);
    signal sRamProtect            : std_logic;

    ------------------------------------------------------------------
    -- Port 1A: Memory stalls
    -- Write-only. N means N+1 stalls

    signal iopwr1aStalls          : std_logic_vector(7 downto 0);

    ------------------------------------------------------------------
    -- Port 1B: PORPage
    -- Read/Write with no hardware side-effect. Managed by SBootROM

    signal iopwr1bPOR             : std_logic_vector(7 downto 0) := x"00";
    signal ioprd1b                : std_logic_vector(7 downto 0);

    ------------------------------------------------------------------
    -- Port 1C: Reason
    -- Read-only bits to distinguish hard from soft reset, either from push
    -- buttons or from the PS/2 keyboard FN keys
    -- TODO not yet implemented
    -- TODO need a write-any-data-to-clear (already done in the SBootROM
    -- but has no effect here yet).

    signal ioprd1c                : std_logic_vector(7 downto 0);

    ------------------------------------------------------------------
    -- Port E4: MAP80 VFC disk control
    signal portE4wr               : std_logic_vector(7 downto 0);  -- TODO remove this is will be external
    signal portE4rd               : std_logic_vector(7 downto 0) := x"00"; -- TODO connect FDC signals to this

    ------------------------------------------------------------------
    -- Port E6: MAP80 VFC parallel keyboard
    signal portE6rd               : std_logic_vector(7 downto 0) := x"00";

    ------------------------------------------------------------------
    -- Port E8/E9: MAP80 VFC
    signal portE8wr               : std_logic_vector(7 downto 0);

    ------------------------------------------------------------------
    -- Port EC/ED: MAP80 VFC Video Control
    signal iopwrECVfcPage         : std_logic_vector(3 downto 0);
    signal iopwrECRomEnable       : std_logic;
    signal iopwrECRamEnable       : std_logic;
    signal iopwrECRomEnable_gated : std_logic;
-- [NAC HACK 2020Nov22] TODO char gen 1 vs 2, inverse video vs upper char set.

    ------------------------------------------------------------------
    -- Port EE/EF: MAP80 VFC
    signal video_map80vfc         : std_logic := '0';

    ------------------------------------------------------------------
    -- Port FE: MAP80 256KRAM
    signal iopwrFE32kPages        : std_logic := '0';
    signal iopwrFEUpper32k        : std_logic := '0';
    signal iopwrFEPageSel         : std_logic_vector(5 downto 0) := "000000";

    -- combine IO read data from misc ports (and UART, SDcard)
    signal nasLocalIODataOut      : std_logic_vector(7 downto 0);

    -- enable readback
    signal nasLocalIOCS           : std_logic;

    -- NMI to CPU and NMI state machine
    signal n_NMI                  : std_logic;
    signal nmi_state              : std_logic_vector(2 downto 0);

begin

    n_LED9 <= n_HALT;
    n_LED7 <= not iopwr00NasDrive;

-- ____________________________________________________________________________________
-- CPU CHOICE GOES HERE

    cpuClock <= clk; -- [NAC HACK 2020Nov15] fix.. this is 50MHz?

    cpu1 : entity work.T80s
      generic map(mode => 1, t2write => 1, iowait => 0)
      port map(
            clk_n   => cpuClock, -- or just clk??
            reset_n => n_reset_clean,
            wait_n  => n_WAIT,
            int_n   => rxd2,   -- TODO from external I/O sub-system
            nmi_n   => n_NMI, -- from single-step logic
            busrq_n => '1',   -- unused
            halt_n  => n_HALT,
            m1_n    => n_M1,
            mreq_n  => n_MREQ,
            iorq_n  => n_IORQ,
            rd_n    => n_RD,
            wr_n    => n_WR,
            a       => cpuAddress,
            di      => cpuDataIn,
            do      => cpuDataOut);

-- ____________________________________________________________________________________
-- ROMS GO HERE
    rom1 : entity work.Z80_NASSYS3_ROM -- 2KB ROM
    port map(
            address => cpuAddress(10 downto 0),
            clock => clk,
            q => nasRomDataOut);

    rom2 : entity work.Z80_MAP80VFC_ROM -- 2KB ROM
    port map(
            address => cpuAddress(10 downto 0),
            clock => clk,
            q => vfcRomDataOut);

    rom3 : entity work.Z80_SBOOT_ROM -- 1KB ROM (insufficient resource to make this 2K)
    port map(
            address => cpuAddress(9 downto 0),
            clock => clk,
            q => sbootRomDataOut);

-- ____________________________________________________________________________________
-- RAM GOES HERE

-- External RAM. This implements memory paging compatible with the MAP80 256K RAM board.
-- Decode chip selects for 2 external RAMs, each 512Kbyte. Probably will only have
-- space for 1, but another could be piggy-backed sharing all pins except the /CS.
-- The MAP80 paging scheme supports 32K or 64K pages.
-- 1 512Kbyte chip provides 8 64K pages or 16 32Kpages on 19 address lines.
--
-- The decode looks like this:
--
-- 32kpages Upper32k   cpu(15) |  sRAM(18:15)
-------------------------------+-----------
--   0        x          x          PageSel(4:1),cpu(15)
--   1        0          0          0        (page0; chip0)
--   1        0          1          PageSel(4:1),cpu(15)
--   1        1          0          PageSel(4:1),cpu(15)
--   1        1          1          0        (page0; chip0)


    -- 18:0 addresses 8*64=512K, then the chip select decoding provides
    -- another doubling to 1MByte; equivalent to 4 MAP80 256K RAM cards.
    -- PageSel(5) is unused. The MAP80 documentation seems contradictory
    -- about whether 1MByte or 2MByte is the maximum capacity but it
    -- "only" shows configuration options for upto 4 cards.

    proc_sramadr: process(cpuAddress, iopwrFEPageSel, iopwrFEUpper32k, iopwrFE32kPages)
    begin
      if (iopwrFE32kPages = '0') then
        -- 64K paging. 16 address lines from CPU, 3 from the page register.
        sRamAddress  <= iopwrFEPageSel(3 downto 1) & cpuAddress(15 downto 0);
        n_sRamCSLo_i <=     iopwrFEPageSel(4);
        n_sRamCSHi_i <= not(iopwrFEPageSel(4));
      elsif (iopwrFEUpper32k = cpuAddress(15)) then
        -- 32K paging. Select page 0 in the lower or upper half of the address space
        sRamAddress  <= "000" & cpuAddress(15 downto 0);
        n_sRamCSLo_i <= '0';
        n_sRamCSHi_i <= '1';
      else
        -- 32K paging. Select the addressed 32K page
        sRamAddress  <= iopwrFEPageSel(3 downto 0) & cpuAddress(14 downto 0);
        n_sRamCSLo_i <=     iopwrFEPageSel(4);
        n_sRamCSHi_i <= not(iopwrFEPageSel(4));
      end if;
    end process;

    -- Assign chip selects to pins
    n_sRamCS  <= n_sRamCSLo_i;
    n_sRamCS2 <= n_sRamCSHi_i;


    -- Control for external data bus [NAC HACK 2020Dec08] this will get more complex
    -- once the external buffered I/O bus is factored in
    sRamData <= cpuDataOut when n_WR = '0' else (others => 'Z');


    sRamProtect <= '1' when (iopwr19ProtEf8k = '1' and cpuAddress(15 downto 13) = "111")
                         or (iopwr19ProtDf4k = '1' and cpuAddress(15 downto 12) = "1101")
                         or (iopwr19ProtCf4k = '1' and cpuAddress(15 downto 12) = "1100")
                         or (iopwr19ProtBf4k = '1' and cpuAddress(15 downto 12) = "1011")
                         or (iopwr19ProtAf4k = '1' and cpuAddress(15 downto 12) = "1010")
                         or (iopwr19Prot0f2k = '1' and cpuAddress(15 downto 11) = "00000") else '0';


    -- Inhibit WRITES to external SRAM when the CPU address corresponds to the MAP80 VFC
    -- video RAM or NASCOM video RAM or workspace RAM or to a protected address region.
    n_sRamWE <= '0' when n_WR = '0' and n_MREQ = '0'
                and n_vfcVidRamCS = '1' and n_nasVidRamCS = '1' and n_nasWSRamCS = '1' and sRamProtect = '0' else '1';
    n_sRamOE <= '0' when n_RD = '0' and n_MREQ = '0' else '1';


    -- Internal 1K WorkSpace RAM
    wren_nasWSRam <= not(n_MREQ or n_WR or n_nasWSRamCS);

    WSRam: entity work.InternalRam1K
    port map(
             address => cpuAddress(9 downto 0),
             clock => clk,
             data => cpuDataOut,
             wren => wren_nasWSRam,
             q => nasWSRamDataOut);

-- ____________________________________________________________________________________
-- INPUT/OUTPUT DEVICES GO HERE

    -- Control for SBootROM
    -- Enable at reset
    -- Enable on write 1 to port18 bit(1)
    -- Delayed disable on write 0 to port18 bit(2)
    -- The delay is designed so that, if the following code executes from the
    -- SBootROM and the OUT sets bit(2) to 0, the ROM will remain enabled until
    -- the JMP and its operands have been read from the SBootROM:
    --    OUT (port18), A
    --    JP  (HL)
    iopwr18SBootRom <= SBootRomState(1);

    proc_sboot: process(clk, n_reset_clean)
    begin
      if n_reset_clean='0' then
        SBootRomState <= "10"; -- MSB is the ROM enable
      elsif rising_edge(clk) then
        case SBootRomState is
          when "10" =>
            if cpuAddress(7 downto 0) = x"18" and n_IORQ = '0' and n_WR = '0' and cpuDataOut(2) = '0' then
              -- Start the process of disabling the ROM
              SBootRomState <= "11";
            end if;

          when "11" =>
            if n_MREQ = '0' and n_RD = '0' and n_WAIT = '1' then
              -- The JP (HL) instruction fetch.. complete the process of disabling the ROM
              SBootRomState <= "00";
            end if;

          when "00" =>
            if cpuAddress(7 downto 0) = x"18" and n_IORQ = '0' and n_WR = '0' and cpuDataOut(2) = '1' then
              -- Enable the ROM
              SBootRomState <= "10";
            end if;

          when others =>
            SBootRomState <= "10";
        end case;
      end if;
    end process;


    -- Miscellaneous I/O port write
    proc_iowr_rst: process(clk, n_reset_clean)
    begin
      if n_reset_clean='0' then
        iopwr00NasDrive  <= '0';
        iopwr00NasNMI    <= '0';
        iopwr00NasKbdClk <= '0';
        iopwr00NasKbdRst <= '0';

        -- Originally I tried to NOT reset this, so that it would be
        -- maintained across soft reset, but I got very weird behaviour
        -- on silicon, even though it seemed to work fine in simulation.
--        iopwr1aStalls <= x"20";
        iopwr1aStalls <= x"04";

        portE4wr <= x"00";
        portE8wr <= x"00";

        iopwrECRomEnable  <= '0';
        iopwrECRamEnable  <= '0';
        iopwrECVfcPage    <= x"0";

        iopwrFE32kPages   <= '0';
        iopwrFEUpper32k   <= '0';
        iopwrFEPageSel    <= "000000";

      elsif rising_edge(clk) then
        if cpuAddress(7 downto 0) = x"00" and n_IORQ = '0' and n_WR = '0' then
          iopwr00NasDrive  <= cpuDataOut(4);
          iopwr00NasNMI    <= cpuDataOut(3);
          iopwr00NasKbdRst <= cpuDataOut(1);
          iopwr00NasKbdClk <= cpuDataOut(0);
        end if;

        if cpuAddress(7 downto 0) = x"1a" and n_IORQ = '0' and n_WR = '0' then
          iopwr1aStalls <= cpuDataOut(7 downto 0);
        end if;

        if cpuAddress(7 downto 0) = x"e4" and n_IORQ = '0' and n_WR = '0' then
          portE4wr <= cpuDataOut;
        end if;

        if cpuAddress(7 downto 0) = x"e8" and n_IORQ = '0' and n_WR = '0' then
          portE8wr <= cpuDataOut;
        end if;

        if cpuAddress(7 downto 0) = x"ec" and n_IORQ = '0' and n_WR = '0' then
          iopwrECVfcPage    <= cpuDataOut(7 downto 4);
          iopwrECRomEnable  <= cpuDataOut(1);
          iopwrECRamEnable  <= cpuDataOut(0);
        end if;

        if cpuAddress(7 downto 0) = x"fe" and n_IORQ = '0' and n_WR = '0' then
          iopwrFE32kPages   <= cpuDataOut(7);
          iopwrFEUpper32k   <= cpuDataOut(6);
          iopwrFEPageSel    <= cpuDataOut(5 downto 0);
        end if;

      end if;
    end process;


    -- Miscellaneous I/O port write that are NOT reset, so that a reset
    -- with the "warm" bit set can retain as much of the previous state
    -- as possible.
    proc_iowr: process(clk)
    begin
      if rising_edge(clk) then
        if cpuAddress(7 downto 0) = x"18" and n_IORQ = '0' and n_WR = '0' then
          iopwr18MAP80AutoBoot <= cpuDataOut(5);
          iopwr18NasWsRam      <= cpuDataOut(4);
          iopwr18NasSysRom     <= cpuDataOut(3);
          -- bit (2) is handled elsewhere
          iopwr18NasVidHigh    <= cpuDataOut(1);
          iopwr18NasVidRam     <= cpuDataOut(0);
        end if;

        if cpuAddress(7 downto 0) = x"19" and n_IORQ = '0' and n_WR = '0' then
          iopwr19ProtEf8k <= cpuDataOut(6);
          iopwr19ProtDf4k <= cpuDataOut(5);
          iopwr19ProtCf4k <= cpuDataOut(4);
          iopwr19ProtBf4k <= cpuDataOut(3);
          iopwr19ProtAf4k <= cpuDataOut(2);
          iopwr19Prot0f2k <= cpuDataOut(0);
        end if;

        if cpuAddress(7 downto 0) = x"1b" and n_IORQ = '0' and n_WR = '0' then
          iopwr1bPOR <= cpuDataOut(7 downto 0);
        end if;

        if cpuAddress(7 downto 0) = x"ee" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '1';
        end if;

        if cpuAddress(7 downto 0) = x"ef" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '0';
        end if;

      end if;
    end process;

    -- Readback for port18
    ioprd18 <= "00" & iopwr18MAP80AutoBoot & iopwr18NasWsRam
          & iopwr18NasSysRom & iopwr18SBootRom & iopwr18NasVidHigh & iopwr18NasVidRam;

    -- Readback for port19
    ioprd19 <= '0' & iopwr19ProtEf8k & iopwr19ProtDf4k & iopwr19ProtCf4k & iopwr19ProtBf4k
          & iopwr19ProtAf4k & '0' & iopwr19Prot0f2k;

    -- Readback for port1b
    ioprd1b <= iopwr1bPOR;

    -- Readback for port1c
    -- TODO add other reason bits
    ioprd1c <= vduffd0 & "0000000";


    -- [NAC HACK 2020Nov16] here, I drive data for any IO request -- will need changing for external IO read
    -- [NAC HACK 2020Nov16] and for interrupt ack cycle
    -- I/O port read..
    -- 00 read from input pins
    -- E4 read from stuff.. disk control
    -- E6 parallel keyboard synthesised from PS/2 kbd
    -- Miscellaneous I/O port write
    proc_iord: process(cpuAddress, ioprd00, UartDataOut, ioprd18, ioprd19, sdCardDataOut, porte4rd, porte6rd)
    begin
      if cpuAddress(7 downto 0) = x"00" then
        nasLocalIODataOut  <= ioprd00;
      elsif cpuAddress(7 downto 0) = x"01" or cpuAddress(7 downto 0) = x"02" then
        nasLocalIODataOut  <= UartDataOut;
      elsif cpuAddress(7 downto 3) = "00010" then
        nasLocalIODataOut  <= sdCardDataOut;
      elsif cpuAddress(7 downto 0) = x"18" then
        nasLocalIODataOut  <= ioprd18;
      elsif cpuAddress(7 downto 0) = x"19" then
        nasLocalIODataOut  <= ioprd19;
      elsif cpuAddress(7 downto 0) = x"1b" then
        nasLocalIODataOut  <= ioprd1b;
      elsif cpuAddress(7 downto 0) = x"1c" then
        nasLocalIODataOut  <= ioprd1c;
      elsif cpuAddress(7 downto 0) = x"e4" then
        nasLocalIODataOut  <= porte4rd;
      elsif cpuAddress(7 downto 0) = x"e6" then
        nasLocalIODataOut  <= porte6rd;
      else
        nasLocalIODataOut  <= x"00";
      end if;
    end process;

    -- Single-step logic
    -- Write to Port 0. Then, M1 cycles:
    -- 0x472 F1    POP AF
    -- 0x473 ED
    -- 0x474 45    RETN (2 M1 cycles)
    -- 0x??? the target address of the single-step
    -- By wave inspection, this seems to work correctly: two
    -- single-step commands in a row start execution at
    -- successive addresses.
    proc_sstep: process(clk, n_reset_clean)
    begin
      if (n_reset_clean='0') then
        n_NMI <= '1';
        nmi_state <= "000";
      elsif rising_edge(clk) then
        -- only assert NMI for 1 cycle
        if n_NMI = '0' then
          n_NMI <= '1';
        end if;
        if iopwr00NasNMI = '0' then
          nmi_state <= "000";
        elsif n_M1 = '0' and n_RD = '0' and n_WAIT = '1' then
          if nmi_state = "011" then
            n_NMI <= '0';
          end if;
          if nmi_state /= "111" then
            nmi_state <= nmi_state + "001";
          end if;
        end if;
      end if;
    end process;

    n_memWr <= n_MREQ or n_WR;

    io1 : entity work.nasVDU
    port map (
            n_reset => n_reset_clean,
            clk => clk,

            -- select which video
            video_map80vfc => video_map80vfc,

            -- memory access to video RAM
            addr        => cpuAddress(10 downto 0),
            n_nasCS     => n_nasVidRamCS,
            n_mapCS     => n_vfcVidRamCS,
            n_charGenCS => '1',    -- TODO paged address space for chargen write path
            n_memWr     => n_memWr,
            dataIn      => cpuDataOut,
            dataOut     => VDURamDataOut,

            -- RGB video signals
            hSync       => hSync,
            vSync       => vSync,
            videoR0     => videoR0,
            videoR1     => videoR1,
            videoG0     => videoG0,
            videoG1     => videoG1,
            videoB0     => videoB0,
            videoB1     => videoB1);


    n_WR_uart <= n_UartCS or n_WR or n_IORQ;
    n_RD_uart <= n_UartCS or n_RD or n_IORQ;

OPT_SIM: if (RTLSIM_UART = TRUE) generate
begin
    UartDataOut <= ioprd01 when cpuAddress(1) = '0' else ioprd02;

    proc_uartcnt: process(clk, n_reset_clean)
    begin
      if (n_reset='0') then
        uartcnt <= x"0a";
      elsif rising_edge(clk) then
        if n_RD_uart = '0' and cpuAddress(1) = '0' and uartcnt /= x"ff" then
            uartcnt <= uartcnt + x"01";
        end if;
      end if;
    end process;

    ioprd01  <= x"53" when uartcnt = x"0a" else -- SC80<newline><newline>
                x"43" when uartcnt = x"0b" else
                x"38" when uartcnt = x"0c" else
                x"30" when uartcnt = x"0d" else
                x"0d" when uartcnt = x"0e" else
                x"0d" when uartcnt = x"0f" else
                x"0d" when uartcnt = x"10" else
                x"00"; -- null -> ignored by NAS-SYS

    -- starting non-zero means that, when I send uartcnt, I don't get non-printing characters like clear-screen
    -- messing up the sign-on screen.
--    ioprd01  <= x"4d" when uartcnt = x"0a" else -- MBCA<newline>B6/BF9<newline>B5.<newline>
--                x"42" when uartcnt = x"0b" else -- to put characters top left/right on line 16
--                x"43" when uartcnt = x"0c" else
--                x"41" when uartcnt = x"0d" else
--                x"0d" when uartcnt = x"0e" else
--                x"42" when uartcnt = x"0f" else
--                x"36" when uartcnt = x"10" else
--                x"2f" when uartcnt = x"11" else
--                x"42" when uartcnt = x"12" else
--                x"46" when uartcnt = x"13" else
--                x"39" when uartcnt = x"14" else
--                x"0d" when uartcnt = x"15" else
--                x"42" when uartcnt = x"16" else
--                x"35" when uartcnt = x"17" else
--                x"2e" when uartcnt = x"18" else
--                x"0d" when uartcnt = x"19" else
--                x"54" when uartcnt = x"1a" else -- T0 28<newline>
--                x"30" when uartcnt = x"1b" else
--                x"20" when uartcnt = x"1c" else
--                x"32" when uartcnt = x"1d" else
--                x"38" when uartcnt = x"1e" else
--                x"0d" when uartcnt = x"1f" else
--                uartcnt when uartcnt /= x"ff" else -- (most of the) char set
--                x"00"; -- null -> ignored by NAS-SYS
end generate;

OPT_NOSIM: if (RTLSIM_UART = FALSE) generate
begin

    io2 : entity work.bufferedUART6402
    port map(
            n_reset => n_reset_clean,
            clk => clk,

            n_wr => n_WR_uart,
            n_rd => n_RD_uart,
            regSel => cpuAddress(0),
            dataIn => cpuDataOut,
            dataOut => UartDataOut,
            rxClkEn => serialClkEn,
            txClkEn => serialClkEn,
            rxd => rxd1,
            txd => txd1);
end generate;



    io3 : entity work.nasKBDPS2
    port map(
            n_reset => n_reset_clean,
            clk     => clk,

            ps2Clk  => ps2Clk,
            ps2Data => ps2Data,

            Event     => KbdEvent,
            EventCode => KbdEventCode,
            ClearEvent  => KbdClearEvent,

            kbdrst => iopwr00NasKbdRst,
            kbdclk => iopwr00NasKbdClk,

            kbddata => ioprd00 -- [NAC HACK 2021Jan13] need to combine with real NASCOM kbd data in from the outside
            );


    n_WR_sd <= n_sdCardCS or n_WR or n_IORQ;
    n_RD_sd <= n_sdCardCS or n_RD or n_IORQ;

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
            n_reset => n_reset_clean,
            dataIn => cpuDataOut,
            dataOut => sdCardDataOut,
            regAddr => cpuAddress(2 downto 0),
            driveLED => driveLED,
            clk => clk
    );


-- -----------------------------------------------------------------------------------
-- BRIDGE TO EXTERNAL I/O BUS
-- -----------------------------------------------------------------------------------

    br1: entity work.nasBridge
      port map(
        n_reset => n_reset_clean,
        clk     => clk,

        iopwr1aStalls => iopwr1aStalls,

        -- Z80 bus
        addr    => cpuAddress(7 downto 0),
        n_M1    => n_M1,
        n_IORQ  => n_IORQ,
        n_MREQ  => n_MREQ,
        n_RD    => n_RD,
        n_WR    => n_WR,
        n_WAIT  => n_WAIT,       -- cycle length control for ALL accesses
        cpuWrData  => cpuDataOut,     -- In  to   bridge
        cpuRdData  => cpuDataIn,      -- In  to   bridge
        BridgeRdData => BridgeRdData, -- Out from bridge - contributes to cpuRdData

        -- To the outside world
        clk4           => clk4,
        clk1           => clk1,
        pio_cs_n       => pio_cs_n,
        ctc_cs_n       => ctc_cs_n,
        fdc_cs_n       => fdc_cs_n,

        porte4_wr      => porte4_wr,
        port00_rd_n    => port00_rd_n,

        BrReset_n      => io_reset_n,
        BrM1_n         => BrM1_n,
        BrIORQ_n       => BrIORQ_n,
        BrRD_n         => BrRD_n,
        BrWR_n         => BrWR_n,

        BrBufOE_n      => BrBufOE_n,
        BrBufWr        => BrBufWr
    );


-- ____________________________________________________________________________________
-- MEMORY READ/WRITE LOGIC GOES HERE

-- ____________________________________________________________________________________
-- CHIP SELECTS GO HERE

    -- Nascom code ROM is 2Kbytes at 0x0000
    n_nasRomCS    <= '0' when cpuAddress(15 downto 11) = "00000"  and iopwr18NasSysRom='1' else '1';
    -- [NAC HACK 2020Dec21] should this decode high when CP/M is in use?
    -- Nascom workspace RAM is 1Kbytes at 0x0C00
    n_nasWSRamCS  <= '0' when cpuAddress(15 downto 10) = "000011" and iopwr18NasWsRam = '1' else '1';
    -- Nascom video RAM is 1Kbytes at 0x0800 usually, can be at 0xF800 for NASCOM CP/M
    n_nasVidRamCS <= '0' when (cpuAddress(15 downto 10) = "000010" and iopwr18NasVidHigh = '0' and iopwr18NasVidRam = '1')
                           or (cpuAddress(15 downto 10) = "111110" and iopwr18NasVidHigh = '1' and iopwr18NasVidRam = '1') else '1';

    -- Special (alternate) boot ROM is 1Kbyte at 0 after reset but normally at 0x1000
    n_sbootRomCS <= '0' when (cpuAddress(15 downto 10) = "000000" and iopwr18SBootRom = '1' and reset_jump = '1')
                          or (cpuAddress(15 downto 10) = "000100" and iopwr18SBootRom = '1'                     ) else '1';

    -- MAP80 VFC video RAM
    n_vfcVidRamCS <= '0' when cpuAddress(15 downto 12) = iopwrECVfcPage and cpuAddress(11) = '1' and iopwrECRamEnable = '1' else '1';
    -- MAP80 VFC ROM
    iopwrECRomEnable_gated <= iopwrECRomEnable xor iopwr18MAP80AutoBoot;
    n_vfcRomCS    <= '0' when cpuAddress(15 downto 12) = iopwrECVfcPage and cpuAddress(11) = '0' and iopwrECRomEnable_gated = '1' else '1';

    -- Nascom UART at I/O ports 0x01 and 0x02
    n_UartCS <= '0' when ((cpuAddress(7 downto 0) = "00000001") or (cpuAddress(7 downto 0) = "00000010")) else '1';

    -- SDcard at I/O ports 0x10-0x14 but decode 0x10-0x17
    n_sdCardCS     <= '0' when cpuAddress(7 downto 3) = "00010" else '1';

-- ____________________________________________________________________________________
-- BUS ISOLATION GOES HERE

    cpuDataIn <=
                        nasLocalIODataOut       when n_IORQ        = '0' else
                        sbootRomDataOut         when n_sbootRomCS  = '0' else -- needs to be above nasRomDataOut so that reset jump
                                                                              -- works
                        nasRomDataOut           when n_nasRomCS    = '0' else
                        vfcRomDataOut           when n_vfcRomCS    = '0' else
                        nasWSRamDataOut         when n_nasWSRamCS  = '0' else
                        VDURamDataOut           when n_nasVidRamCS = '0' or n_vfcVidRamCS = '0' else
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
    end if;
    end process;


-- reset control and jump-on-reset

-- n_reset_clean asserts asynchronously and negates synchronously; this ensures
-- that all blocks come out of reset cleanly and on the same clock.
    n_reset_clean <= n_reset and n_reset_s2;

    rst_gen: process (clk, n_reset)
    begin
      if (n_reset='0') then
        n_reset_s1 <= '0';
        n_reset_s2 <= '0';
        n_reset_s1 <= '0';
        post_reset_rd_cnt <= "00";
        reset_jump <= '1';
      elsif rising_edge(clk) then
        n_reset_s1 <= n_reset;
        n_reset_s2 <= n_reset_s1;

        -- count reads after reset..
        if n_reset_s2 = '1' and n_rd = '0' and n_WAIT = '1' and post_reset_rd_cnt /= "11" then
          post_reset_rd_cnt <= post_reset_rd_cnt + "01";
        end if;

        -- ..after the 3rd read, set reset_jump high to un-map the special
        -- boot ROM (NASCOM 2 does this by counting 2 M1 cycles but counting
        -- reads has cleaner timing).
        if post_reset_rd_cnt = "11" and reset_jump = '1' then
          reset_jump <= '0';
        end if;
      end if;
    end process;

end;
