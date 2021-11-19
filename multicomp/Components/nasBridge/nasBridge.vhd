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
-- Next: draw out a picture of how the RETI will work, including
-- the async start, the stall and the way in which the data busses
-- need to be controlled and where the values will get MUXed out
-- and forced in (to the CPU)


-- Problems to solve:
-- * Make sure that write data for CPU I/O write gets to the
--   pins (may only be coded for memory operations)
-- * Work out how to get read data back for reads and for
--   intack: need the FPGA buffer in the correct direction
--   and may need to register the data internally in order
--   to keep the timing clean, then drive it back to the CPU
--   using another leg in the existing read data MUX
-- * Work out how to turn the bus around so that the bridge
--   can drive data out and through the external I/O bus data
--   buffer in order to make the RETI bytes visible to the
--   PIO and CTC.
--
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

        iopwr1AStalls : std_logic_vector(7 downto 0); -- control memory wait states

        -- Z80 signals
        addr    : in  std_logic_vector(7 downto 0); -- 8-bit I/O address
        n_M1    : in  std_logic;
        n_IORQ  : in  std_logic;
        n_MREQ  : in  std_logic;
        n_RD    : in  std_logic;
        n_WR    : in  std_logic;
        n_WAIT  : out std_logic;
        cpuRdData: in  std_logic_vector(7 downto 0);    -- for spotting op-codes

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
        porte4_wr   : out std_logic;  -- idle high, goes low-then-high on write.
        port00_rd_n : out std_logic;  -- idle high, goes low-then-high on read.

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
        reset, idle,
        iot1, iot2,
        m1t1, m1t2, m1t3,
        iat1, iat3, iat5,
        rett1, rett2, rett3
        );

    type iastates is (
        idle, start, active, done
        );

    type rstates is (
        idle, prefix, reti, active
        );

    -- TODO the reti might have originated from internal or external memory and, at least for the 1st byte we need to drive
    -- it out while the CPU is stalled. Need a control signal and control interface to allow this and need to work out
    -- how to detect it and stall the processor at the right time.

    signal  state   : states;
    signal  iastate : iastates;
    signal  rstate  : rstates;

    signal clkCount: integer range 0 to 24 := 0;
    signal clk4Sync: std_logic;
    signal i_clk1: std_logic;
    signal clkExtend: std_logic;
    -- 4MHz clocks come in pairs: T1 H/L T2 H/L
    -- these are decodes of the counter that can be used to do a synchronous
    -- transition at any of these boundaries
    signal clk4t1h: std_logic;
    signal clk4t1l: std_logic;
    signal clk4t2h: std_logic;
    signal clk4t2l: std_logic;

    signal stateCount: integer range 0 to 7 := 0;

    signal bridgeDone : std_logic;

    -- Decode interrupt acknowledge cycle
    signal IntAckCycle : std_logic;
    -- Decode all of the ports that the bridge must respond to
    signal bridgeIOCycle: std_logic;
    -- Asynchronous decode of chip selects
    signal e_pio_cs_n: std_logic;
    signal e_ctc_cs_n: std_logic;
    signal e_fdc_cs_n: std_logic;
    signal e_porte4_wr : std_logic;
    signal e_port00_rd_n: std_logic;

    signal RetiCycle : std_logic;

    signal mstall_a      : std_logic;
    signal stall_bridge_a: std_logic;
    signal stall_e       : std_logic;
    signal stall_cnt     : integer range 0 to 255;
    signal i_n_WAIT      : std_logic;

begin

    clk4 <= clk4Sync or clkExtend;
    clk1 <= i_clk1;
    n_WAIT <= i_n_WAIT;

    -- These decodes condition state machine transitions that need to align with 4MHz clock edges
    clk4t1h       <= '1' when clkCount = 24 else '0';
    clk4t1l       <= '1' when clkCount =  5 else '0';
    clk4t2h       <= '1' when clkCount = 12 else '0'; -- happens 1/2 cycle later than 4MHz clock edge
    clk4t2l       <= '1' when clkCount = 18 else '0'; -- happens 1/2 cycle later than 4MHz clock edge


    -- Internal async decodes of chip selects/strobes for I/O bus
    e_pio_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "000001"   else '1'; -- 04..07
    e_ctc_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "000010"   else '1'; -- 08..0B
    e_fdc_cs_n    <= '0' when (n_RD = '0' or n_WR = '0') and addr(7 downto 2) = "111000"   else '1'; -- E0..E3
    e_port00_rd_n <= '0' when (n_RD = '0'              ) and addr(7 downto 0) = "00000000" else '1'; -- 00
    e_porte4_wr   <= '1' when (              n_wr = '0') and addr(7 downto 0) = "11100100" else '0'; -- E4

    -- Addresses (I/O ports) that the bridge responds to
    bridgeIOCycle <= '1' when n_IORQ = '0' and (e_pio_cs_n = '0' or e_ctc_cs_n = '0' or
                                                e_fdc_cs_n = '0' or e_porte4_wr = '1' or e_port00_rd_n = '0') else '0';

    -- Detect interrupt acknowledge cycle
    -- Unlike other T80 cycles (memory or I/O read or write, refresh) all of which have MREQ or IORQ asserted for 1~
    -- unless stalled, intack has M1 asserted for 4~ with IORQ asserted for the last 3~.
    -- So, detect the final cycle, in order to be able to stall it there and kick off the bridge cycle.
    IntAckDetect: process (clk, n_reset)
    begin
        if n_reset = '0' then
            iastate <= idle;
            IntAckCycle <= '0';
        elsif rising_edge(clk) then
            case iastate is
                when idle =>
                    if n_M1 = '0' and n_IORQ = '0' and i_n_WAIT = '1' then
                        iastate <= start;
                    end if;

                when start =>
                    IntAckCycle <= '1';
                    iastate <= active;

                when active =>
                    if bridgeDone = '1' then
                        IntAckCycle <= '0';
                        iastate <= done;
                    end if;

                when done =>
                    -- delay to prevent it re-starting on end of cycle
                    iastate <= idle;

            end case;
        end if;
    end process;


    -- Detect RETI; op-code pair $ED $4D
    -- The cycle is replayed on the I/O bus. Original plan was to do this after
    -- the CPU had read the second byte, by stalling the CPU during the RFRSH that
    -- is part of the second M1 cycle. Sadly, the T80 core doesn't allow stalling
    -- of RFRSH so I need to do all this before allowing the 2nd fetch to complete
    -- at the CPU. That means I need to honour any stalls imposed for the memory
    -- access then stall again while these cycles are replayed on the I/O bus.
    -- TODO remember to test this with 0 memory stall
    RetiDetect: process (clk, n_reset)
    begin
        if n_reset = '0' then
            rstate <= idle;
            RetiCycle <= '0';
        elsif rising_edge(clk) then
            case rstate is
                when idle =>
                    if n_M1 = '0' and n_MREQ = '0' and n_RD = '0' and i_n_WAIT = '1' and cpuRdData = x"ED" then
                        rstate <= prefix;
                    end if;

                when prefix =>
                    if n_M1 = '0' and n_MREQ = '0' and n_RD = '0' and i_n_WAIT = '1' then
                        if cpuRdData = x"4D" then
                            rstate <= reti;
                        else
                            rstate <= idle;
                        end if;
                    end if;

                when reti =>
                    RetiCycle <= '1';
                    rstate <= active;

                when active =>
                    if bridgeDone = '1' then
                        RetiCycle <= '0';
                        rstate <= idle;
                    end if;

            end case;
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

    i_n_WAIT <= '0' when (mstall_a = '1' and stall_e = '0') or
                (stall_bridge_a = '1'    and bridgeDone = '0') or
                (IntAckCycle = '1'       and bridgeDone = '0') else '1'; -- or
--                (RetiCycle = '1'         and bridgeDone = '0') else '1';


    stall_e        <= '1' when stall_cnt = iopwr1AStalls else '0';

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
    -- clkCount is decoded elsewhere to provide decodes (clk4t1h etc.) that
    -- enable state machine transitions that align to clk4 edges.
    ClkGen: process (n_reset, clk)
    begin
        if n_reset = '0' then
            clk4Sync <= '0';
            i_clk1 <= '0';
            clkCount <= 0;
        elsif rising_edge(clk) then
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
            porte4_wr   <= '1';
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
                    -- I/O bus reset sequence: hold BrReset_n and BrM1_n asserted for a few (8) 4MHz
                    -- clock cycles. The CPU is already running and executing code at this point
                    -- so a cycle (eg, an I/O read) may already be pending by the time we exit
                    -- to the idle state. In addition, the op-code tracking (process RetiPrefixDetect
                    -- etc.) is already running so we won't miss anything.

                    pio_cs_n <= '1';
                    ctc_cs_n <= '1';
                    fdc_cs_n <= '1';

                    porte4_wr   <= '1';
                    port00_rd_n <= '1';

                    BrIORQ_n <= '1';
                    BrRD_n <= '1';
                    BrWR_n <= '1';

                    BrBufOE_n <= '1';
                    BrBufWr <= '1';

                    bridgeDone <= '0';

                    -- Track how long we've been in reset
                    if clk4t1h = '1' then
                        stateCount <= stateCount + 1;
                    end if;

                    -- TODO: general question over whether this coding style (just coding when
                    -- signal transitions occur) will synthesise successfully..
                    if clk4t1h = '1' and stateCount = 3 then
                        -- provide reset recovery time (seems polite)
                        BrM1_n <= '1';
                        BrReset_n <= '1';
                    end if;

                    -- Transition during the low part of T4. All the signals are already in
                    -- their idle state
                    if clk4t2l = '1' and stateCount = 4 then
                        state <= idle;
                    end if;

                when idle =>
                    -- Come here during the low-time of a T4 cycle, so always
                    -- spend a few cycles here before clk4t1h goes high to start
                    -- the next sequence.
                    -- During those cycles, want the existing outputs to be maintained,
                    -- so that the previous cycle is completed successfully.

                    BrReset_n <= '1';  -- always negated here
                    bridgeDone <= '0'; -- might be asserted on the way in
                    porte4_wr <= '1';  -- might be asserted on the way in
                    BrIORQ_n <= '1';   -- might be asserted on the way in
                    BrRD_n <= '1';     -- might be asserted on the way in
                    BrWR_n <= '1';     -- might be asserted on the way in

                    -- synchronise start point of next cycle to clk4 rising T1
                    if clk4t1h = '1' then

                        -- requests from Z80 are mutually exclusive but need priority
                        -- tree to allow a default activity: the dummy M1 cycle.

                        if bridgeIOCycle = '1' then
                            -- I/O read or write cycle. CPU is already stalled.
                            pio_cs_n <= e_pio_cs_n;
                            ctc_cs_n <= e_ctc_cs_n;
                            fdc_cs_n <= e_fdc_cs_n;

                            porte4_wr   <= '1';
                            port00_rd_n <= '1';

                            BrM1_n <= '1';
                            BrIORQ_n <= '1';
                            BrRD_n <= '1';
                            BrWR_n <= '1';

                            BrBufOE_n <= '1';
                            BrBufWr <= not n_WR; -- get it in the right direction

                            state <= iot1;
                            stateCount <= 0;
                        elsif IntAckCycle = '1' then
                            -- Interrupt acknowledge cycle. CPU is already stalled.
                            pio_cs_n <= '1';
                            ctc_cs_n <= '1';
                            fdc_cs_n <= '1';

                            porte4_wr   <= '1';
                            port00_rd_n <= '1';

                            BrM1_n <= '0';
                            BrIORQ_n <= '1';
                            BrRD_n <= '1';
                            BrWR_n <= '1';

                            BrBufOE_n <= '1';
                            BrBufWr <= '0'; -- get it in the right direction for reading the vector

                            state <= iat1;
                            stateCount <= 0;
                        elsif RetiCycle = '1' then
                            -- Fake RETI cycle. CPU is already stalled.
                            pio_cs_n <= '1';
                            ctc_cs_n <= '1';
                            fdc_cs_n <= '1';

                            porte4_wr   <= '1';
                            port00_rd_n <= '1';

                            BrM1_n <= '0';
                            BrIORQ_n <= '1';
                            BrRD_n <= '0';
                            BrWR_n <= '1';

                            BrBufOE_n <= '1';
                            BrBufWr <= '1';

                            state <= rett1;
                            stateCount <= 0;
                        else
                            -- If nothing to do for the CPU, do an dummy cycle on the I/O
                            -- bus. This has 2 purposes: keep the data bus driven with a
                            -- valid logic level (achieved by enabling the keyboard read
                            -- buffer using port00_rd_n) and create M1 activity to allow
                            -- the PIO to synchronise its assertion of INT_n. Because
                            -- this looks like an M1 cycle, the PIO and CTC will be
                            -- looking for a RETI op-code sequence so need to guarantee
                            -- that the keyboard buffer won't drive that. It should be
                            -- guaranteed by design because but[7] is tied high on the
                            -- keyboard and should float to 1 if no keyboard is connected.

                            -- TODO maybe idle for 2 clocks after the end of a previous sequence
                            -- before launching one of these?? Is there any benefit??
                            pio_cs_n <= '1';
                            ctc_cs_n <= '1';
                            fdc_cs_n <= '1';

                            porte4_wr   <= '1';
                            port00_rd_n <= '1';

                            BrM1_n <= '0';
                            BrIORQ_n <= '1';
                            BrRD_n <= '0';
                            BrWR_n <= '1';

                            BrBufOE_n <= '1';
                            BrBufWr <= '1';

                            state <= m1t1;
                            stateCount <= 0;
                        end if;
                    end if;


                ---------------------------------------------------------------
                -- CPU Interrupt Acknowledge cycle
                when iat1 =>
                    -- Spend 3 1/2 clocks here so need to track stateCount
                    if clk4t1h = '1' then
                        stateCount <= stateCount + 1;
                    end if;

                    if clk4t1l = '1' and stateCount = 1 then
                        BrIORQ_n <= '0';
                        BrBufOE_n <= '0';

                        state <= iat3;
                    end if;

                when iat3 =>
                    if clk4t1h = '1' then
--                        BrM1_n <= '1';
--                        BrIORQ_n <= '1';

--                        BrBufOE_n <= '1';   -- end the cycle. CPU grabs vector from read data
                        bridgeDone <= '1';
                        state <= idle;
                    end if;

-- at the end of the intack I need to kick DONE so that the CPU can
-- grab the vector. Not sure if I then need to make the bridge be busy
-- eg hold off dummy M1 and any CPU cycle to the bridge -- for a peripheral
-- recovery time? Need to investigate further once it's working enough
-- to enter and return from the ISR.

--                        state <= iat5;
--                    end if;
--
--                when iat5 =>
--                    if clk4t1l = '1' then
--                        BrBufOE_n <= '1';
--
--                        bridgeDone <= '1';
--                        state <= idle;
--                    end if;


                ---------------------------------------------------------------
                -- CPU I/O read or write cycle
                when iot1 =>
                    BrIORQ_n <= '0';
                    BrRD_n <= n_RD;
                    BrWR_n <= n_WR;
                    port00_rd_n <= e_port00_rd_n; -- drive read data from keyboard
                    BrBufOE_n <= '0';
                    if clk4t2h = '1' then
                        state <= iot2;
                    end if;

                when iot2 =>
                    -- Spend 3 clocks here so need to track stateCount
                    if clk4t1h = '1' then
                        stateCount <= stateCount + 1;
                    end if;

                    if clk4t2l = '1' and stateCount = 1 then
                        -- TODO does this allow data capture correctly or do I need to move it right to the
                        -- end of the final cycle low time??
                        porte4_wr <= not e_porte4_wr; -- rising edge at end of write
                        bridgeDone <= '1';
                        state <= idle;
                    end if;
                    -- TODO need to release OE in a way that avoids chance of bus clash


                ---------------------------------------------------------------
                -- CPU mocked-up RETI cycle: 2 M1 cycles, driving the bytes $ED $4D
                -- TODO the data bus control and the scheme for driving data back
                -- out. After the 2nd cycle want to drive the 4D back into the CPU
                -- as well, otherwise would have to go and get it from memory AGAIN.
                when rett1 =>
                    if clk4t2h = '1' then
                        state <= rett2;
                    end if;


                when rett2 =>
                    if clk4t1h = '1' then
                        -- going to T3 (don't need stateCount to tell us)
                        BrM1_n <= '1';
                        BrRD_n <= '1';
                        state <= rett3;
                        stateCount <= stateCount + 1;
                    end if;


                when rett3 =>
                    if stateCount = 1 and clk4t1h = '1' then
                        -- done the first M1 cycle, go round again to do the second
                        BrM1_n <= '0';
                        BrRD_n <= '0';

                        state <= rett1;
                    end if;

                    if stateCount = 2 and clk4t2l = '1' then
                        -- done!
                        bridgeDone <= '1';
                        state <= idle;
                    end if;


                ---------------------------------------------------------------
                -- Dummy M1 cycle
                when m1t1 =>
                    if clk4t2h = '1' then
                        port00_rd_n <= '0'; -- drive the I/O data bus
                        state <= m1t2;
                    end if;


                when m1t2 =>
                    if clk4t1h = '1' then
                        -- going to T3 (don't need stateCount to tell us)
                        port00_rd_n <= '1';
                        BrM1_n <= '1';
                        BrRD_n <= '1';
                        state <= m1t3;
                    end if;


                when m1t3 =>
                    if clk4t2l = '1' then
                        -- going to idle (don't need stateCount to tell us)
                        -- no bridgeDone pulse for the dummy M1 cycle because the
                        -- CPU did not request it
                        state <= idle;
                    end if;


                when others =>
                    state <= idle;
            end case;
        end if;
    end process;


end rtl;
