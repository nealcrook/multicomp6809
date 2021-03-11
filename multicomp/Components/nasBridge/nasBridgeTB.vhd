-- Test-bench for external i/o bridge for NASCOM
--
-- This module connects to nasBridge as though it was the
-- external I/O sub-system, allowing I/O read/write and
-- interrupt functionality to be tested.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity nasBridgeTB is
    port (
        clk1    : in std_logic;
        clk4    : in std_logic;
        addr    : in  std_logic_vector(1 downto 0); -- 8-bit I/O address
        data	: inout std_logic_vector(7 downto 0);

        -- Bridge control signals like Z80
        BrReset_n : in std_logic;
        BrM1_n : in std_logic;
        BrIORQ_n : in std_logic;
        BrRD_n : in std_logic;
        BrWR_n : in std_logic;

        -- Address decode
        pio_cs_n : in std_logic;
        ctc_cs_n : in std_logic;
        fdc_cs_n : in std_logic;

        -- Address and strobe decode
        porte4_wr_n : in std_logic;
        port00_rd_n : in std_logic;

        -- Data lines from the memory interface are buffered to
        -- the I/O bus. This is control for the external
        -- 74LVT245 level-shifter/buffer
        BrBufOE_n : in std_logic; -- OE_N pin
        BrBufWr : in std_logic;   -- DIR  pin

        -- [NAC HACK 2021Feb27] These are delivered from a READ of port E4.. move them out
        -- of here because they don't need the bridge: they can be done at full speed.
        FdcIntr: out std_logic;
        FdcDrq: out std_logic;
        FdcRdy: out std_logic -- [NAC HACK 2021Feb27] might be inverted
    );
end nasBridgeTB;

architecture rtl of nasBridgeTB is

    -- signal  startCycle: std_logic;
    -- signal  stateCount: integer range 0 to 7 := 0;

    signal BrData: std_logic_vector (7 downto 0);
    signal KbdData: std_logic_vector (7 downto 0) := x"AA";


begin

    -- 8-bit buffer is the interface between the Z80 data bus and the
    -- expansion bus
    BusBuf: process (BrData, data, BrBufOE_n, BrBufWr)
    begin
        if BrBugOE_n = '1' then
            data <= (others => 'z');
            BrData <= (others => 'z');
        else
            if BrBufWr = '1' then
                BrData <= data;
            else
                data <= BrData;
            end if;
        end if;
    end process;

    -- Keyboard buffer drives onto the bus when enabled
    KbdBuf: process (KbdData, BrData, port00_rd_n)
    begin
        if port00_rd_n = '0' then
            BrData <= KbdData;
        else
            BrData <= (others => 'z');
        end if;
    end process;

    -- ?? How to resolve a bus with multiple drivers?

    -- Next: node that responds to CS and allows reads and writes
    -- duplicated 2 or 3 times
    -- and a node that responds to intack cycle
    -- for bonus points, a node that tracks the op-code to detect reti
    -- finally a way to assert an interrupt and to maintain the daisy-chain
    -- and to track state in the way that the Z80 app-note describes

end rtl;
