-- External I/O bridge for NASCOM 4 FPGA design.
--
-- Creates an off-chip interface that behaves like a 4MHz Z80 bus
-- supporting I/O read and write cycles to a specific set of port
-- addresses. All interrupts in the system (except NMI) originate
-- from devices on this interface and handling them is the most
-- complex part of the design, as explained in detail below.
--
-- Since the bridge has to drive WAIT back to the CPU in order
-- to stall I/O cycles, the WAIT generation for memory reads
-- has been moved here to keep all the WAIT logic in one process.
--
-- next:
-- do idle state of tracking state machine and decide how to
-- hand-off for control of I/O bus cycles in an efficient way
-- - also need to re-solve the problem of doing reset cycles
-- for the I/O bus while stalling, if necessary, an I/O cycle
-- from the processor.


--
-- Considerations:
--
-- - CLK4 and CLK1 must free-run all the time
-- - Do a long reset cycle, multiple clocks, and assert
--   M1 at this time to reset the PIO (assume the CTC does
--   not mind).
-- - PIO (and maybe CTC) synchronises its INT assertion
--   to /M1 and so needs regular M1 cycles. At that time,
--   need to have /RD driven also so it's not seen as a
--   reset, and need to ensure that the data bus is not
--   driven with a RETI op-code pair. Also, need to stop
--   data bus from floating during potentially long periods
--   of inactivity. Solve this problem by output-enabling
--   the keyboard buffer by default: it can drive a non-Z
--   value on the bus. If no keyboard is connected its
--   inputs should float high driving $FF on the bus and
--   if a keyboard is connected the MSB is tied high so
--   driving a non-$4D value. Worst-case it will drive
--   a $ED for multiple cycles but that will not cause
--   a problem for interrupts.
-- - IO write and IO read cycles from Z80 addressing an
--   external device (address details below) cause the
--   bridge to stall the Z80 and propagate the cycle.
--   Because the clocks are free-running the first step
--   is to align to the external (slow) clock.
-- - Interrupt Acknowledge cycles from Z80 cause the
--   bridge to stall the Z80 and propagate the cycle.
-- - Spy on Z80 code execution, propagate a RETI
--   instruction so that the PIO/CTC devices can control
--   their interrupt daisy-chain correctly (see reference
--   below). This is the most fiddly part because RETI
--   is a 2-byte instruction ED 4D and different things
--   happen on each byte, BUT don't simply want to stall
--   and propagate every ED prefix. If I mock up the
--   ED 4D too early, nested interrupts will be handled
--   wrongly. If I mock up the ED 4D too late, it can
--   create a lock-up situation where an eligible
--   interrupt source is blocked by an upstream IEI
--   from a device that has actually been serviced.
--
-- The bridge (only) responds to these I/O port addresses:
-- 0x00        READs only (NASCOM keyboard)
--             -> generates read strobe
--             (writes are internal; handled elsewhere)
-- 0x04 - 0x07 PIO
--             -> generates chip select
-- 0x08 - 0x0B CTC
--             -> generates chip select
-- 0xE0 - 0xE3 FDC
--             -> generates chip select
-- 0xE4        WRITEs only (FDC drive select)
--             -> generates write strobe
--             (reads are internal; handled elsewhere?)
--             [NAC HACK 2021Feb27] look at my notes on vsnascom
--             and see if anything more complex is needed for NASCOM VFC
--             support
--
--
-- Reference on Z80 interrupts and daisy-chain
-- http://www.z80.info/zip/z80-interrupts_rewritten.pdf

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity nasBridge is
    port (
        n_reset	: in  std_logic;
        clk    	: in  std_logic;

        iopwr1aStalls : std_logic_vector(7 downto 0); -- control memory wait states

        -- Z80 signals
        addr    : in  std_logic_vector(7 downto 0); -- 8-bit I/O address
        n_M1    : in  std_logic;
        n_IORQ  : in  std_logic;
        n_MREQ  : in  std_logic;
        n_RD    : in  std_logic;
        n_WR    : in  std_logic;
        n_WAIT  : out std_logic;
        cpuWrData: in  std_logic_vector(7 downto 0);    -- for I/O writes
        cpuRdData: in  std_logic_vector(7 downto 0);    -- for spotting op-codes
        BridgeRdData: out std_logic_vector(7 downto 0); -- data from I/O rd & IntAck

        -- Primary I/O of FPGA [NAC HACK 2021Feb27] change to camelcase? BrClk4
        clk4 : out std_logic;
        clk1 : out std_logic;

        -- (Address lines 1:0 from memory interface are buffered
        -- to the I/O bus)

        -- Address decode
        pio_cs_n : out std_logic;
        ctc_cs_n : out std_logic;
        fdc_cs_n : out std_logic;

        -- Address and strobe decode
        porte4_wr_n : out std_logic;
        port00_rd_n : out std_logic;

        -- Bridge control signals like Z80
        BrReset_n : out std_logic;
        BrM1_n : out std_logic;
        BrIORQ_n : out std_logic;
        BrRD_n : out std_logic;
        BrWR_n : out std_logic;

        -- Data lines from the memory interface are buffered to
        -- the I/O bus. This is control for the external
        -- 74LVT245 level-shifter/buffer
        BrBufOE_n : out std_logic; -- OE_N pin
        BrBufWr : out std_logic    -- DIR  pin
        );
end nasBridge;

architecture rtl of nasBridge is

    type states is (
        reset,                           -- coded
        idle,                            -- coded
        t1m1,  t2m1,  t3m1,  t4m1,       -- coded
        t1io,  t2io,  twio,  t3io,
        t1intack, t2intack, tw1intack, tw2intack, t3intack, t4intack,
        t1m1reti,  t2m1reti,  t3m1reti,  t4m1reti   -- used twice; once for each byte
        );

    -- TODO the reti might have originated from internal or external memory and, at least for the 1st byte we need to drive
    -- it out while the CPU is stalled. Need a control signal and control interface to allow this and need to work out
    -- how to detect it and stall the processor at the right time.

    signal  state : states;

    signal  clkCount: integer range 0 to 24 := 0;
    signal  clk4Sync: std_logic;
    signal  i_clk1: std_logic;
    signal  clkExtend: std_logic;
    signal  startCycle: std_logic;

    signal  stateCount: integer range 0 to 7 := 0;

    signal  bridgeDone : std_logic;

    -- Decode all of the ports that the bridge must respond to
    signal  bridgeIOCycle: std_logic;
    -- Asynchronous decode of chip selects
    signal e_pio_cs_n: std_logic;
    signal e_ctc_cs_n: std_logic;
    signal e_fdc_cs_n: std_logic;
    signal e_porte4_wr_n: std_logic;
    signal e_port00_rd_n: std_logic;

    signal RetiPrefix : std_logic;
    signal Reti       : std_logic;

    signal mstall_a      : std_logic;
    signal stall_bridge_a: std_logic;
    signal stall_e       : std_logic;
    signal stall_cnt     : integer range 0 to 255;
    signal i_n_WAIT      : std_logic;

begin

    clk4 <= clk4Sync or clkExtend;
    clk1 <= i_clk1;
    n_WAIT <= i_n_WAIT;

    -- Internal async decodes of chip selects/strobes for I/O bus
    e_pio_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "000001"   else '1'; -- 04..07
    e_ctc_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "000010"   else '1'; -- 08..0B
    e_fdc_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "111000"   else '1'; -- E0..E3
    e_port00_rd_n <= '0' when (n_RD = '0'              ) and addr(7 downto 0) = "00000000" else '1'; -- 00
    e_porte4_wr_n <= '0' when (              n_wr = '0') and addr(7 downto 0) = "11100100" else '1'; -- E4

    -- Addresses (I/O ports) that the bridge responds to
    bridgeIOCycle <= '1' when n_IORQ = '0' and (e_pio_cs_n = '0' or e_ctc_cs_n = '0' or
                                                e_fdc_cs_n = '0' or e_porte4_wr_n = '0' or e_port00_rd_n = '0') else '0';

    -- Detect RETI; op-code pair $ED $4D
    -- The prefix byte $EF is detected synchronously, on the clock edge that ends the op-code fetch
    -- The second byte $4D is detected asynchronously, during the op-code fetch, to give the main FSM
    -- the opportunity to delay that cycle.
    -- Therefore, Reti must be conditioned properly (eg, with n_WAIT) elsewhere
    Reti <= '1' when n_M1 = '0' and n_MREQ = '0' and n_RD = '0' and cpuRdData = x"4D" and RetiPrefix = '1'
            else '0';

    RetiPrefixDetect: process (clk, n_reset)
    begin
        if n_reset = '0' then
            RetiPrefix <= '0';
        elsif rising_edge(clk) then
            if n_M1 = '0' and n_MREQ = '0' and n_RD = '0' and i_n_WAIT = '1' then
                if cpuRdData = x"ED" then
                    RetiPrefix <= '1';
                else
                    RetiPrefix <= '0';
                end if;
            end if;
        end if;
    end process;

    -- wait-state generation
    -- mstall_a is asynchronous decode of the need for a stall in a memory access. It is a
    -- function of n_MREQ, n_RD and n_WR (need RD/WR because n_MREQ also asserts (without
    -- RD/WR) during refresh cycles.
    -- stall_e asserts after the programmed required number of stalls have occurred; it forces
    -- n_WAIT to negate, ending the stall.

    -- need to include RD/WR otherwise we'll also stall RFSH cycles, which would be a shame.
    mstall_a       <= '1' when n_MREQ = '0'        and (n_RD = '0' or n_WR = '0') else '0';
    stall_bridge_a <= '1' when bridgeIOCycle = '1' and (n_RD = '0' or n_WR = '0') else '0';

    i_n_WAIT <= '0' when (mstall_a = '1' and stall_e = '0') or (stall_bridge_a = '1' and bridgeDone = '0') else '1';

    stall_e        <= '1' when stall_cnt = iopwr1aStalls else '0';

    WaitGen: process (clk, n_reset)
    begin
        if n_reset = '0' then
            stall_cnt <= 0;
        elsif rising_edge(clk) then
            if mstall_a = '1' then
                stall_cnt <= stall_cnt + 1;
            else
                stall_cnt <= 0;
            end if;
        end if;
    end process;




    Extend: process (n_reset, clk)
    begin
        if n_reset = '0' then
            clkExtend <= '0';
        elsif falling_edge(clk) then
            if clkCount = 12 or clkCount = 17 then
                clkExtend <= '1';
            else
                clkExtend <= '0';
            end if;
        end if;
    end process;

    -- Each loop through this generates 2 cycles at 4MHz and 0.5 cycles at 1MHz.
    -- The 4MHz clock is high for 6 cycles @50MHz and low for 6.5 cycles @50MHz.
    -- By doing a pair of cycles each loop takes a total of 25 cycles @50MHz.
    -- All of the bus operations take an even number of clocks so this works out
    -- nicely. The clkExtend pulses extend the front and back high-times of the
    -- second cycle of the pair. Using both edges of clock is never pretty but
    -- this should be safe and glitch-free.
    -- Sad to say, the very first clk4 high time after reset is 1 cycle @50MHz
    -- too short, but I don't see an efficient way to fix this other than having
    -- the clock idle high at reset. It's ugly but will not cause a problem.
    -- startCycle is used to kick off the state machine co-incident to the start
    -- of a pair of 4MHz cycles.
    ClkGen: process (n_reset, clk)
    begin
        if n_reset = '0' then
            clk4Sync <= '0';
            i_clk1 <= '0';
            clkCount <= 0;
            startCycle <= '0';
        elsif rising_edge(clk) then
            if clkCount = 23 then
                startCycle <= '1';
            else
                startCycle <= '0';
            end if;

            if clkCount = 24 then
                clkCount <= 0;
                i_clk1 <= not i_clk1;
            else
                clkCount <= clkCount + 1;
            end if;

            if clkCount = 0 or clkCount = 1 or clkCount = 2 or clkCount = 3 or clkCount = 4
                or clkCount = 12 or clkCount = 13 or clkCount = 14 or clkCount = 15 or clkCount = 16 or clkCount = 24 then
                clk4Sync <= '1';
            else
                clk4Sync <= '0';
            end if;
        end if;
    end process;

    -- FSM that performs all the bus cycles on the I/O bus:
    -- Reset sequence
    -- I/O read
    -- I/O write
    -- M1 idle
    -- Interrupt Acknowledge
    -- Fake RETI
    CycleGen: process (n_reset, clk)
    begin
        if n_reset = '0' then
            -- Address decode
            pio_cs_n <= '1';
            ctc_cs_n <= '1';
            fdc_cs_n <= '1';

            -- Address and strobe decode
            porte4_wr_n <= '1';
            port00_rd_n <= '1';

            -- Bridge control signals like Z80
            BrReset_n <= '0';
            BrM1_n <= '0';    -- this resets the PIO
            BrIORQ_n <= '1';
            BrRD_n <= '1';
            BrWR_n <= '1';

            -- Data lines from the memory interface are buffered to
            -- the I/O bus. This is control for the external
            -- 74LVT245 level-shifter/buffer
            BrBufOE_n <= '1';
            BrBufWr <= '1';

            bridgeDone <= '0';

            state <= reset;
            stateCount <= 0;

        elsif rising_edge(clk) then

            case state is

                when reset =>
                    -- The CPU is already running and executing code at this point so it would be
                    -- embarassing if it did an I/O cycle whilst we're still resetting the slow
                    -- external bus. We either need to hold off CPU execution or start monitoring
                    -- the CPU bus now but remembering that we're not 'ready' yet - which will involve
                    -- doing the reset sequence from within the idle cycle rather than it having its
                    -- own state sequence.

                    -- Next, need to do the i/o bus decode for the different things that we need
                    -- to spot and have the idle state here detect them, stall and take over control
                    -- of the bus. That will include a separate little state machine to detect the RETI
                    -- sequence and stall the CPU on the 2nd byte of it.

                    -- Best to move the wait-state generator into this module and make it responsible
                    -- for all bus tracking and wait-state generation.

                    -- Add a blob of logic at the top-level that connects to the expansion bus to model
                    -- the data bus buffer, the keyboard buffer and a vector-supplying peripheral that
                    -- will generate an interrupt and drive a vector in response to an interrupt ack cycle,
                    -- then create a small ROM that cyscles through the different I/O addresses, enables
                    -- interrupts and includes a vector table and ISR. Finally, snap a set of waves
                    -- showing the behavior of the whole thing and write a short document to describe
                    -- how it all works. Too much detail for the handbook, but a useful stand-alone
                    -- supplementary document. May even include 2 interruptors and modelling of the
                    -- daiy chain? Maybe put that whole sub-system into a module that can be dropped
                    -- down as a test-bench, connected to this bridge.

                    pio_cs_n <= '1';
                    ctc_cs_n <= '1';
                    fdc_cs_n <= '1';

                    porte4_wr_n <= '1';
                    port00_rd_n <= '1';

                    BrReset_n <= '0';
                    BrM1_n <= '0';    -- this resets the PIO
                    BrIORQ_n <= '1';
                    BrRD_n <= '1';
                    BrWR_n <= '1';

                    BrBufOE_n <= '1';
                    BrBufWr <= '1';

                    bridgeDone <= '0';

                    if startCycle = '1' then
                        if stateCount = 7 then
                            state <= idle;
                        else
                            stateCount <= stateCount + 1;
                        end if;
                    end if;

                when idle =>





                    if startCycle = '1' then
                        -- Dummy M1 cycles to keep PIO happy
                        pio_cs_n <= '1';
                        ctc_cs_n <= '1';
                        fdc_cs_n <= '1';

                        porte4_wr_n <= '1';
                        port00_rd_n <= '1';

                        BrReset_n <= '1';
                        BrM1_n <= '0';
                        BrIORQ_n <= '1';
                        BrRD_n <= '0';
                        BrWR_n <= '1';

                        BrBufOE_n <= '1';
                        BrBufWr <= '1';

                        bridgeDone <= '0';

                        state <= t1m1;
                        stateCount <= 0;
                    else
                        pio_cs_n <= '1';
                        ctc_cs_n <= '1';
                        fdc_cs_n <= '1';

                        porte4_wr_n <= '1';
                        port00_rd_n <= '1';

                        BrReset_n <= '1';
                        BrM1_n <= '1';
                        BrIORQ_n <= '1';
                        BrRD_n <= '1';
                        BrWR_n <= '1';

                        BrBufOE_n <= '1';
                        BrBufWr <= '1';

                        bridgeDone <= '0';

                        state <= idle;
                        stateCount <= 0;
                    end if;

                --  Dummy M1 cycle
                when t1m1 =>
                    if (clkCount = 11) then
                        state <= t2m1;
                        port00_rd_n <= '0';
                    end if;

                when t2m1 =>
                    if (startCycle = '1') then
                        state <= t3m1;
                        BrM1_n <= '1';
                        BrRD_n <= '1';
                    end if;

                when t3m1 =>
                    if (clkCount = 6) then
                        port00_rd_n <= '1';
                    end if;
                    if (clkCount = 11) then
                        state <= t4m1;
                    end if;

                when t4m1 =>
                    if (startCycle = '1') then
                        state <= idle;
                        bridgeDone <= '1';
                    end if;

                -- I/O read or write cycle
                -- [NAC HACK 2021Mar04] come here with chip selects decoded??
                when t1io =>
                    if (clkCount = 11) then
                        state <= t2io;
                        -- read or write determines buffer direction
                        BrIORQ_n <= '0';
                        BrRD_n <= '0'; -- incoming signal from CPU decides read or write
                        BrWR_n <= '0';
                    end if;

                when t2io =>
                    if (startCycle = '1') then
                        state <= twio;
                    end if;

                when twio =>
                    if (clkCount = 6) then
                        BrIORQ_n <= '1';
                        BrRD_n <= '1'; -- and data bus control and strobe control if appropriate
                        BrWR_n <= '1';
                    end if;
                    if (clkCount = 11) then
                        state <= t3io;
                    end if;

                when t3io =>
                    if (startCycle = '1') then
                        state <= idle;
                    end if;


                when t1intack =>
                    -- Interrupt acknowledge cycle
                    if (clkCount = 11) then
                        state <= t2intack;
                    end if;

                when t2intack =>
                    if (startCycle = '1') then
                        state <= tw1intack;
                    end if;

                when tw1intack =>
                    if (clkCount = 11) then
                        state <= tw2intack;
                    end if;

                when tw2intack =>
                    if (startCycle = '1') then
                        state <= t3intack;
                    end if;

                when t3intack =>
                    if (clkCount = 11) then
                        state <= t4intack;
                    end if;

                when t4intack =>
                    if (startCycle = '1') then
                        state <= idle;
                    end if;

                when others =>
                    state <= idle;
            end case;
        end if;
    end process;


end rtl;
