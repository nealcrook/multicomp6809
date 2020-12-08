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
-- On the FPGA:
-- * 2KROM "NAS-SYS3" at location 0.
--   - Can be re-written (TBD how) to contain other monitors
-- * 1K video RAM at location 0x800
-- * 1K ws RAM at location 0xc00
--
-- * I/O port 0     - keyboard and single-step control
-- * I/O port 1,2   - 6402 compatible UART
-- * I/O port 3     - NEW controls paging of ROM/RAM/VDU
--
-- * I/O port E4    - VFC FDC drive select etc.
-- * I/O port E6    - VFC "parallel" keyboard (maybe; from PS/2 keyboard)
-- * I/O port E8    - VFC Alarm (beeper?) output - TBD to external buzzer?
-- * I/O port EC    - VFC mapping register (write-only)
-- * I/O port EE    - VFC write to select VFC video on output
-- * I/O port EF    - VFC write to select NASCOM video on output

-- * I/O port FE    - MAP80 256KRAM paging/memory mapping (write-only)


-- TBD port for memory-mapping control
-- * NASCOM video RAM in low memory or (for NASCOM CP/M) high memory
--   -- write-only? Reads come from RAM?
-- * Possible write-protect of RAM? Or would this be too fiddly with paged MAP80 RAM "underneath"?
-- emulate NASCOM keyboard via PS/2?
-- SDcard support? Could be instead of Flash ROM..

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
--
-- "Special boot ROM" (SBR) needs to appear at 0 after reset, but it will be
-- much simpler to code it (especially as it is only 1Kbytes) if it can make
-- use of NAS-SYS I/O routines. This can be achieved by remapping it to a
-- different address and decoding the NAS-SYS ROM at zero; the SPR can then
-- call the monitor initialisation routine.
-- How to manage it?
-- Decode and assemble it at $1000. After reset, it it's enabled, decode
-- it for the 1st op-code fetch. In that case, the Port 3 bits mean this:

-- B3          0: enable NAS-SYS 1: enable NAS-SYS at 0
-- B2          0: disable SBR    1: enable SBR at $1000
-- When SBR is enabled at reset, control passes to it rather
-- than to NAS-SYS
-- -> this is achieved by decoding the SBR for the first M1 cycle
-- after reset. The SBR must start with a jump to $1003.
-- -> need to put sbootRom higher than nasRom in "bus isolation" code.
--
-- Function of SBR
-- Very crude FAT32 support - read-only.
-- Read jumpers
-- if bootmode2: read profile 2 from SDcard: usually ROM-based NASCOM
-- if bootmode3: read profile 3 from SDcard: usually menu
--
-- menu displays text on screen and invites selection of a profile
-- from a separate file.
-- format of profile file?
-- ROMIMAGES file like for NASCAS
-- profile is very simple script, and must be small enough that it
-- can be loaded into the workspace RAM. Tokens:
-- W write to address: W1234=5678 means write 0x5678 to address 1234
-- P write to port: P34=03 means write 0x03 to port 0x34
-- G go: G1000 means jump to 1000
-- I image: I125600 means set image offset (offset from start of NASROM.BIN)
-- L load: L1000=400 means load image to address 0x1000 for 0x400 bytes.
-- CR/LF characters are ignored/skipped.
-- Any detected error casues a HALT. The script is executed until the first
-- error, upto a maximum of 256 characters (1 sector). The file can be
-- bigger, eg to contain comments.
--
-- Example: load BASIC, ZEAP and NAS-PEN, map out ROM, write-protect memory,
-- restart NAS-SYS.
-- I000000,LE000=2000,I004000,LD000=1000,I005000,LB800=800,P03=45,P99=FF,G0
--
-- (the P commands there are NOT correct!)
--
-- could restrict the images to 4K boundaries to reduce the calculations
-- required.

-- [NAC HACK 2020Dec06] TODO need a warm-start bit set by this load process
-- so that a subsequent reset does not repeat it. Eg: an i/o port that is
-- initialised but not reset.




-- TODO change ROMs to be a single model with an initialisation file
-- and put them in a generic folder.
-- TODO change char gen to an initialised RAM and add control port for
-- writes.

-- Next:
-- remove latches
-- wire SDcard controller correctly for I/O access
-- programmable wait state generator
-- external RAM access
-- MAP80 256K RAM paging (ported in from __ed file).




-- External port addressing:
-- * I/O port 4,5,6,7 - External PIO
-- * I/O port E0-E3   - 2797 FDC


-- TODO
--
-- Review compilation warnings and fix
-- Split out port0 write signals like port3 stuff, implement DRIVE

-- draw up a list of new I/O and what pins it will be assigned to
-- .. annoying if I were to run out!!


-- Current         New
-- gpio0(2)        in, NMI button
-- gpio0(1)        in, bootmode1
-- gpio0(0)        in, bootmode0
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
-- Create dummy Special Boot ROM code (use T2??)
-- .. or a piece of code that reads the mode and
-- selects NASCOM or MAP80 then vectors through RAM
-- to set it up and go to it.
------
-- Work out how to do video switching (2 sets of timing)
-- Add debug signals to show reads of video/chargen RAM
------
-- Implement write-protect register
-- Add write port to char gen.. how to decode? Whole of VFC space?
-- Code synchroniser and pulse generator for NMI push button
-- Work out what's needed for FDC miscellaneous control
-- Look at clocking, implement external RAM interface, allow
-- slow-down for I/O cycles. Allow operation at a lower clock speed.
-- Work out external pin mapping.
-- Consider Arduino interface; 1 or 2 external SDcards..
-- Implement UART
-- Implement PS/2 keyboard interface?


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
    generic( constant RTLSIM_UART : boolean := FALSE
    );
    port(
	-- these are connected on the base FPGA board
        n_reset       : in std_logic;
        clk           : in std_logic;

        -- LEDs on base FPGA board and duplicated on James Moxham's PCB.
        -- Set LOW to illuminate. 3rd LED is "driveLED" output.
        n_LED7        : out std_logic := '1';
        n_LED9        : out std_logic := '1';  -- HALT

        -- External pull-up so this defaults to 1. When pulled to gnd
        -- this swaps the address decodes so that the Serial A port is
        -- decoded at $FFD0 and the VDU at $FFD2.
        vduffd0         : in std_logic;  -- [NAC HACK 2020Dec04] unused

        sRamData        : inout std_logic_vector(7 downto 0);
        sRamAddress     : out std_logic_vector(18 downto 0); -- 18:0 -> 512KByte
        n_sRamWE        : out std_logic;
        n_sRamCS        : out std_logic;                     -- lower blocks
        n_sRamCS2       : out std_logic;                     -- upper blocks
        n_sRamOE        : out std_logic;

        rxd1            : in std_logic;
        txd1            : out std_logic;
        rts1            : out std_logic; -- [NAC HACK 2020Dec04] unused

        rxd2		: in std_logic; -- [NAC HACK 2020Dec04] unused
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
        gpio0       : in std_logic_vector(2 downto 0); --[NAC HACK 2020Nov25] (1..0) now used for bootmode
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
    signal state                  : std_logic_vector(2 downto 0);
    signal cpuAddress             : std_logic_vector(15 downto 0);
    signal cpuDataOut             : std_logic_vector(7 downto 0);
    signal cpuDataIn              : std_logic_vector(7 downto 0);
    signal sRamAddress_i          : std_logic_vector(18 downto 0);
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

    -- synchronise reset and generate control for jump-on-reset
    signal n_reset_s1             : std_logic;
    signal n_reset_s2             : std_logic;
    signal n_reset_clean          : std_logic;
    signal post_reset_rd_cnt      : std_logic_vector(1 downto 0);
    signal reset_jump             : std_logic;

    signal cpuClock               : std_logic := '1';
    signal n_MREQ                 : std_logic := '1';
    signal n_IORQ                 : std_logic := '1';
    signal n_HALT                 : std_logic;
    signal n_M1                   : std_logic;

    signal n_memWr                : std_logic;

    ------------------------------------------------------------------
    -- Port 0: NASCOM keyboard
    -- ff means no key detected
    signal port00rd               : std_logic_vector(7 downto 0) := x"ff";
    signal port00wr               : std_logic_vector(7 downto 0);

    ------------------------------------------------------------------
    -- Port 1/2: UART
    --
    -- Only used when RTLSIM_UART is TRUE
    signal port01rd               : std_logic_vector(7 downto 0) := x"00"; -- UART data
    signal port02rd               : std_logic_vector(7 downto 0) := x"80"; -- UART status -> always has data
    signal uartcnt                : std_logic_vector(7 downto 0) := x"00";


    ------------------------------------------------------------------
    -- Port 3: new for FPGA implementation
    --              Write                                   Read
    -- B7          ignored                                 bootmode1
    -- B6          ignored                                 bootmode0
    -- B5          unused                                       0
    -- B4          MAP80 VFC autoboot                           0
    -- B3          0: disable NAS-SYS  1: enable NAS-SYS        0
    -- B2          0: disable boot ROM 1: enable boot ROM       0
    -- B1          0: VRAM@800, 1:VRAM@?? (for CP/M)            0
    -- B0          1: enable NASCOM VRAM                        0
    --
    -- autoboot bit is subtle..
    -- autoboot=0 : iopwrECRomEnable is reset to 0. Writing a 1
    --              to the register bit sets it to 1.
    -- autoboot=1 : iopwrECRomEnable is reset to 1. Writing a 1
    --              to the register bit sets it to 0.
    -- the bootmode bits determine the reset state of autoboot, and
    -- therefore the initial state of iopwrECRomEnable. The reason
    -- for having it as a writeable bit is that it allows the special
    -- boot ROM to start at reset and then pass control to the MAP80
    -- VFC ROM and autoboot.
    --
    -- The boot ROM is 1Kbytes decoded at address 0x1000.
    -- When it is enabled at reset, it is selected for the first
    -- three read cycles (which had better be a "JP 1003"). Decoding
    -- it away from location 0 allows the boot ROM to call STMON to
    -- to initialise NAS-SYS and then to make use of the the NAS-SYS
    -- I/O and other routines. The usual function of the boot
    -- ROM is to load ROM images into RAM, and then write-protect
    -- the RAM, to give the appearance of a ROM-laden NASCOM.

    signal iopwr03NasVidEnable    : std_logic;
    signal iopwr03NasVidHigh      : std_logic;
    signal iopwr03SBootRom        : std_logic;
    signal iopwr03NasSysRom       : std_logic;
    signal iopwr03MAP80AutoBoot   : std_logic;

    ------------------------------------------------------------------
    -- Port 4/5/6/7: PIO (external)

    ------------------------------------------------------------------
    -- MAP80 VFC disk control
    signal portE4wr               : std_logic_vector(7 downto 0);
    signal portE4rd               : std_logic_vector(7 downto 0) := x"00";

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

    -- combine from misc ports (and UART?)
    signal nasLocalIODataOut      : std_logic_vector(7 downto 0);

    -- enable readback
    signal nasLocalIOCS           : std_logic;

    -- NMI to CPU and NMI state machine
    signal n_NMI                  : std_logic;
    signal nmi_state              : std_logic_vector(2 downto 0);


    -- [NAC HACK 2020Nov22] Bootmode pins should be primary inputs
    -- The 2 bootmode bits are set by front-panel switch and are decoded to generate
    -- the initial state of the "low level" control bits writeable from this register.
    -- They also provide the initial state of the MAP80 VFC LINK4 "autoboot" jumper
    -- and the MAP80 video select
    --
    -- bootmode1  bootmode0
    --     0          0       Raw NASCOM (NAS-SYS only)
    --     0          1       MAP VFC    (CP/M)
    --     1          0       Special boot ROM, mode 0 - usually NASCOM + ZEAP + BASIC
    --     1          1       Special boot ROM, mode 1 - usually NASCOM CP/M
    --
    -- The special boot ROM allows stuff to be loaded into RAM and then protected to
    -- make it look like ROM. Typically, it terminates by jumping through a tiny
    -- code stub in RAM whose function is to write to the port to disable the
    -- ROM and then to jump to some destination address (eg, NAS-SYS).
    -- Once the special boot ROM is executing, it need not "honour" the bootmode;
    -- it can do anything.
    -- Any number of "profiles" can be provided via the boot ROM. For example:
    -- start NASCOM + ZEAP + BASIC
    -- start NASCOM + BASIC + POLYDOS
    -- start NASCOM + BASIC + NAS-DOS
    -- start NASCOM CP/M
    -- start T4 + BASIC
    --                     Port 3 b4:b0           MAP80 VFC video select
    -- bootmode=0           01001                   NASCOM video
    -- bootmode=1           10000                   MAP80 video
    -- bootmode=2           01101                   NASCOM video
    -- bootmode=3           01101                   NASCOM video
    signal bootmode               : std_logic_vector(1 downto 0) := "10";

begin

    n_LED9 <= n_HALT;
    -- [NAC HACK 2020Nov25] change sim script to set the pins accordingly
--    bootmode(1) <= gpio0(1);
--    bootmode(0) <= gpio0(0);


-- ____________________________________________________________________________________
-- CPU CHOICE GOES HERE

    cpuClock <= clk; -- [NAC HACK 2020Nov15] fix.. this is 50MHz?

    cpu1 : entity work.T80s
      generic map(mode => 1, t2write => 1, iowait => 0)
      port map(
            clk_n   => cpuClock, -- or just clk??
            reset_n => n_reset_clean,
            wait_n  => '1',
            int_n   => '1', -- TODO from external I/O sub-system
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

-- Assign to pins. Set the address width to match external RAM/pin assignments
    sRamAddress(18 downto 0) <= sRamAddress_i(18 downto 0);
    n_sRamCS  <= n_sRamCSLo_i;
    n_sRamCS2 <= n_sRamCSHi_i;

-- External RAM - high-order address lines come from the mem_mapper
-- [NAC HACK 2020Nov23] need to prevent video and VFC RAM writes from going to paged RAM
-- and make sure that workspace writes DO go to paged RAM..
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

-- ____________________________________________________________________________________
-- INPUT/OUTPUT DEVICES GO HERE

    -- Miscellaneous I/O port write
    proc_iowr: process(clk, n_reset_clean, bootmode)
    begin
      if (n_reset_clean='0') then
        port00wr <= x"00";

        -- Decode bootmode to get initial state of port3 stuff and video select
        if (bootmode = 1) then
          -- MAP80 VFC CP/M boot
          iopwr03NasVidEnable  <= '0';
          iopwr03NasSysRom     <= '0';
          iopwr03SBootRom      <= '0';
          iopwr03MAP80AutoBoot <= '1';
          video_map80vfc       <= '1';
        else
          iopwr03NasVidEnable  <= '1';
          iopwr03NasSysRom     <= '1';
          if bootmode = 2 or bootmode = 3 then
            iopwr03SBootRom    <= '1';
          else
            iopwr03SBootRom    <= '0';
          end if;
          iopwr03MAP80AutoBoot <= '0';
          video_map80vfc       <= '0';
        end if;

        -- This will be high for NASCOM CP/M but that requires other stuff
        -- to be loaded by the SBootRom so that ROM can also do the port
        -- write to remap this.
        iopwr03NasVidHigh    <= '0';

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
          port00wr <= cpuDataOut;
        end if;

        if cpuAddress(7 downto 0) = x"03" and n_IORQ = '0' and n_WR = '0' then
          iopwr03MAP80AutoBoot <= cpuDataOut(4);
          iopwr03NasSysRom     <= cpuDataOut(3);
          iopwr03SBootRom      <= cpuDataOut(2);
          iopwr03NasVidHigh    <= cpuDataOut(1);
          iopwr03NasVidEnable  <= cpuDataOut(0);
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

        if cpuAddress(7 downto 0) = x"ee" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '1';
        end if;

        if cpuAddress(7 downto 0) = x"ef" and n_IORQ = '0' and n_WR = '0' then
          video_map80vfc <= '0';
        end if;

        if cpuAddress(7 downto 0) = x"fe" and n_IORQ = '0' and n_WR = '0' then
          iopwrFE32kPages   <= cpuDataOut(7);
          iopwrFEUpper32k   <= cpuDataOut(6);
          iopwrFEPageSel    <= cpuDataOut(5 downto 0);
        end if;
      end if;
    end process;

    -- [NAC HACK 2020Nov16] here, I drive data for any IO request -- will need changing for external IO read
    -- [NAC HACK 2020Nov16] and for interrupt ack cycle
    -- I/O port read..
    -- 00 read from input pins
    -- E4 read from stuff.. disk control
    -- E6 parallel keyboard synthesised from PS/2 kbd
    -- Miscellaneous I/O port write
    proc_iord: process(cpuAddress, port00rd, UartDataOut, porte4rd, porte6rd)
    begin
      if cpuAddress(7 downto 0) = x"00" then
        nasLocalIODataOut  <= port00rd;
      elsif cpuAddress(7 downto 0) = x"01" or cpuAddress(7 downto 0) = x"02" then
        nasLocalIODataOut  <= UartDataOut;
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
    UartDataOut <= port01rd when cpuAddress(1) = '0' else port02rd;

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

--    port01rd <= x"53" when uartcnt = 0 else -- SC80<newline><newline>
--                x"43" when uartcnt = 1 else
--                x"38" when uartcnt = 2 else
--                x"30" when uartcnt = 3 else
--                x"0d" when uartcnt = 4 else
--                x"0d" when uartcnt = 5 else
--                x"0d" when uartcnt = 6 else
--                x"00"; -- null -> ignored by NAS-SYS

    -- starting non-zero means that, when I send uartcnt, I don't get non-printing characters like clear-screen
    -- messing up the sign-on screen.
    port01rd <= x"4d" when uartcnt = x"0a" else -- MBCA<newline>B6/BF9<newline>B5.<newline>
                x"42" when uartcnt = x"0b" else -- to put characters top left/right on line 16
                x"43" when uartcnt = x"0c" else
                x"41" when uartcnt = x"0d" else
                x"0d" when uartcnt = x"0e" else
                x"42" when uartcnt = x"0f" else
                x"36" when uartcnt = x"10" else
                x"2f" when uartcnt = x"11" else
                x"42" when uartcnt = x"12" else
                x"46" when uartcnt = x"13" else
                x"39" when uartcnt = x"14" else
                x"0d" when uartcnt = x"15" else
                x"42" when uartcnt = x"16" else
                x"35" when uartcnt = x"17" else
                x"2e" when uartcnt = x"18" else
                x"0d" when uartcnt = x"19" else
                x"54" when uartcnt = x"1a" else -- T0 28<newline>
                x"30" when uartcnt = x"1b" else
                x"20" when uartcnt = x"1c" else
                x"32" when uartcnt = x"1d" else
                x"38" when uartcnt = x"1e" else
                x"0d" when uartcnt = x"1f" else
                uartcnt when uartcnt /= x"ff" else -- (most of the) char set
                x"00"; -- null -> ignored by NAS-SYS
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
            n_reset => n_reset_clean,
            dataIn => cpuDataOut,
            dataOut => sdCardDataOut,
            regAddr => cpuAddress(2 downto 0),
            driveLED => driveLED,
            clk => clk
    );



    -- pin control. There's probably an easier way of doing this??
    -- .. refer to multicomp6809 design

-- ____________________________________________________________________________________
-- MEMORY READ/WRITE LOGIC GOES HERE

-- ____________________________________________________________________________________
-- CHIP SELECTS GO HERE

    -- Nascom code ROM is 2Kbytes at 0x0000
    n_nasRomCS    <= '0' when cpuAddress(15 downto 11) = "00000"  and iopwr03NasSysRom='1' else '1';
    -- Nascom workspace RAM is 1Kbytes at 0x0C00
    n_nasWSRamCS  <= '0' when cpuAddress(15 downto 10) = "000011" else '1';
    -- Nascom video RAM is 1Kbytes at 0x0800 usually, can be at 0xF800 for NASCOM CP/M
    n_nasVidRamCS <= '0' when (cpuAddress(15 downto 10) = "000010" and iopwr03NasVidHigh = '0' and iopwr03NasVidEnable = '1')
                           or (cpuAddress(15 downto 10) = "111110" and iopwr03NasVidHigh = '1' and iopwr03NasVidEnable = '1') else '1';

    -- Special (alternate) boot ROM is 1Kbyte at 0 after reset but normally at 0x1000
    n_sbootRomCS <= '0' when (cpuAddress(15 downto 10) = "000000" and iopwr03SBootRom = '1' and reset_jump = '1')
                          or (cpuAddress(15 downto 10) = "000100" and iopwr03SBootRom = '1'                     ) else '1';

    -- MAP80 VFC video RAM
    n_vfcVidRamCS <= '0' when cpuAddress(15 downto 12) = iopwrECVfcPage and cpuAddress(11) = '1' and iopwrECRamEnable = '1' else '1';
    -- MAP80 VFC ROM
    iopwrECRomEnable_gated <= iopwrECRomEnable xor iopwr03MAP80AutoBoot;
    n_vfcRomCS    <= '0' when cpuAddress(15 downto 12) = iopwrECVfcPage and cpuAddress(11) = '0' and iopwrECRomEnable_gated = '1' else '1';

    -- Nascom UART at I/O port 1 and 2
    n_UartCS <= '0' when ((cpuAddress(7 downto 0) = "00000001") or (cpuAddress(7 downto 0) = "00000010")) else '1';

    -- [NAC HACK 2020Dec04] needs moving to I/O space if I'm keeping it..
    n_sdCardCS     <= '0' when cpuAddress(15 downto 3) = "1111111111011"   else '1'; -- 8 bytes FFD8-FFDF
    -- experimented with allowing RAM to be written to "underneath" ROM but
    -- there is no advantage vs repaging the region, and it causes problems because
    -- it's necessary to avoid writing to the I/O space.

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
        if state = 0               then
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
        if state = 3 or (state = 0              ) then
            hold <= '0'; -- run the clock
        else
            hold <= '1'; -- pause the clock
        end if;

        -- decode memory and RW control from state etc.
        if (state = 1 or state = 2 or state = 3) then
--          if n_cpuWr = '0' then
--                n_WR <= '0';
--                n_sRamWE <= (n_sRamCSHi_i and n_sRamCSLo_i) or ramWrInhib ; -- synchronous and glitch-free
--          else
--                n_RD <= '0';
--                n_sRamOE <= n_sRamCSHi_i and n_sRamCSLo_i; -- synchronous and glitch-free
--          end if;
        else
--            n_WR <= '1';
--            n_RD <= '1';
            n_sRamWE <= '1';
            n_sRamOE <= '1';
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
        if (n_reset_s2 = '1' and n_rd = '0' and post_reset_rd_cnt /= "11") then
          post_reset_rd_cnt <= post_reset_rd_cnt + "01";
        end if;

        -- ..after the 3rd read, set reset_jump high to un-map the special
        -- boot ROM (NASCOM 2 does this by counting 2 M1 cycles but counting
        -- reads has cleaner timing).
        if (post_reset_rd_cnt = "11" and reset_jump = '1') then
          reset_jump <= '0';
        end if;
      end if;
    end process;


end;
