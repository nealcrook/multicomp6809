-- Z80_PIO model for Top-level testbench for NASCOM4 FPGA design
--
-- This is intended for simulation test-bench purposes and not
-- intended to be synthesisable or to be a complete model.
-- Priority is for bus-related and interrupt-related behaviours
-- TODO need a way to make this generate an interrupt
-- and a way to make it assert/negate it with the right timing
-- so it can deliver the vector.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Z80_PIO is
    port(
        d       : inout std_logic_vector(7 downto 0);
        ba      : in std_logic;  -- connected to cpu A0
        cd      : in std_logic;  -- connected to cpu A1
        ce_n    : in std_logic;
        m1_n    : in std_logic;
        iorq_n  : in std_logic;
        rd_n    : in std_logic;
        clk     : in std_logic;

        int_n   : out std_logic;
        iei     : in  std_logic;
        ieo     : out std_logic;

        a       : inout std_logic_vector(7 downto 0);
        ardy    : out   std_logic;
        astb_n  : in    std_logic;

        b       : inout std_logic_vector(7 downto 0);
        brdy    : out   std_logic;
        bstb_n  : in    std_logic
        );
end Z80_PIO;

architecture rtl of Z80_PIO is

    signal reset :      std_logic;
    signal reset_x :   std_logic;
    signal reg_wr :     std_logic;
    signal reg_rd :     std_logic;
    signal iack :       std_logic;
    signal opfetch :    std_logic;

    -------
    -- C/D  B/A
    -- 0     0    4 port A Data
    -- 0     1    5 port B Data
    -- 1     0    6 port A Control
    -- 1     1    7 port B Control

    signal a_vector : std_logic_vector(7 downto 0);
    signal a_mode   : std_logic_vector(7 downto 0);
    signal a_m3dir  : std_logic_vector(7 downto 0);
    signal a_intctl : std_logic_vector(7 downto 0);
    signal a_mask   : std_logic_vector(7 downto 0);
    signal a_out    : std_logic_vector(7 downto 0); -- Data
    signal a_in     : std_logic_vector(7 downto 0); -- Data

    signal b_vector : std_logic_vector(7 downto 0);
    signal b_mode   : std_logic_vector(7 downto 0);
    --
    signal b_intctl : std_logic_vector(7 downto 0);
    signal b_mask   : std_logic_vector(7 downto 0);
    signal b_out    : std_logic_vector(7 downto 0); -- Data
    signal b_in     : std_logic_vector(7 downto 0); -- Data

    signal a_mask_follows : std_logic;
    signal a_m3dir_follows : std_logic;

    signal b_mask_follows : std_logic;

    type istates is (idle, count, interrupt, ack);

    signal a_icount : integer range 0 to 500;
    signal a_istate : istates;
    signal a_int : std_logic;

begin

    opfetch <= '1' when m1_n = '0' and rd_n = '0' else '0';
    -- iack but not necessarily for this device.
    iack  <= '1' when m1_n = '0' and iorq_n = '0' else '0';
    reg_rd <= '1' when ce_n = '0' and rd_n = '0' and iorq_n = '0' else '0';
    reg_wr <= '1' when ce_n = '0' and rd_n = '1' and iorq_n = '0' else '0'; -- how to avoid write glitches??

    int_n <= '0' when a_int = '1' else 'Z';

    -- TODO not yet implemented; this is to avoid compilation warnings
    ieo <= '1';
    a <= a_out;
    b <= b_out;

    --------------------------------------------------------------------------------
    -- Detect/Generate internal reset
    -- (handled elsewhere)

    GenReset : process (clk)
    begin
        if rising_edge(clk) then
            if m1_n = '0' and iorq_n = '1' and rd_n = '1' then
                reset_x <= '1';
            else
                reset_x <= '0';
            end if;
            if m1_n = '1' and reset_x = '1' then
                -- m1 was asserted without iorq or rd, and is now negated -> reset.
                reset <= '1';
            end if;
            if reset = '1' then
                reset <= '0';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Register write - and track most recent write
    -- Current status: good enough to allow an interrupt vector to be programmed but
    -- not properly handling the data port, and not driving the output pins

    DoRegWr : process (reset, reg_wr)
    begin
        if reset = '1' then
            -- ds states that vector registers are not reset
            a_mask <= x"00";
            b_mask <= x"00";
            a_intctl <= a_intctl and x"7F"; -- disable interrupt
            b_intctl <= b_intctl and x"7F"; -- disable interrupt
            a_out <= x"00";
            b_out <= x"00";
            ardy <= '0';
            brdy <= '0';

            a_mask_follows <= '0';
            a_m3dir_follows <= '0';
            b_mask_follows <= '0';
        elsif falling_edge(reg_wr) then
            if ba = '0' and cd = '0' then
                -- A Data
                a_out <= d;
            elsif ba = '0' and cd = '1' then
                -- A Control
                if a_mask_follows = '1' then
                    a_mask <= d;
                    a_mask_follows <= '0';
                elsif a_m3dir_follows = '1' then
                    a_m3dir <= d;
                    a_m3dir_follows <= '0';
                elsif d(0) = '0' then
                    a_vector <= d;
                elsif d(3 downto 0) = "1111" then
                    a_mode <= d;
                    if d(7 downto 6) = "11" then
                        a_m3dir_follows <= '1';
                    end if;
                elsif d(3 downto 0) = "0111" then
                    a_intctl <= d;
                    a_mask_follows <= '1';
                else
                    report "Error in write to Z80_PIO ctrl A port with data " & integer'image(to_integer(unsigned(d)));
                end if;
            elsif ba = '1' and cd = '0' then
                -- B Data
                b_out <= d;
            elsif ba = '1' and cd = '1' then
                -- B Control
                if b_mask_follows = '1' then
                    b_mask <= d;
                    b_mask_follows <= '0';
                elsif d(0) = '0' then
                    b_vector <= d;
                elsif d(3 downto 0) = "1111" then
                    b_mode <= d;
                    if d(7 downto 6) = "11" then
                        report "Error in write to Z80_PIO ctrl B port with data " & integer'image(to_integer(unsigned(d))) & "mode 3 is illegal";
                    end if;
                elsif d(3 downto 0) = "0111" then
                    b_intctl <= d;
                    b_mask_follows <= '1';
                else
                    report "Error in write to Z80_PIO ctrl B port with data " & integer'image(to_integer(unsigned(d)));
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Register read
    -- Data sheet does not explicitly state it but suggestion is that the control
    -- ports are write-only. This code returns 0 on read of control port, and reads
    -- back what was most recently written to the data port
    -- TODO the data port should behave differently depending upon the mode
    -- TODO this only allows A to interrupt.. presumably the real part has
    -- its own logical priority tree internally. That's more complexity than
    -- I need to handle.
    -- TODO should I 
    d <= a_out  when reg_rd = '1' and ba = '0' and cd = '0' else -- a data
         x"00"  when reg_rd = '1' and ba = '0' and cd = '1' else -- a ctrl
         b_out  when reg_rd = '1' and ba = '1' and cd = '0' else -- b data
         x"00"  when reg_rd = '1' and ba = '1' and cd = '1' else -- b ctrl
         a_vector when iack = '1' and a_int = '1' and iei = '1' else
         (others=> 'Z');

    --------------------------------------------------------------------------------
    -- Opcode tracking, to update interrupt state


    --------------------------------------------------------------------------------
    -- Interrupt generation and priority daisy chain


    -- Dummy interrupt generation
    -- NOT synthesisable!
    AInt: process (reset, clk, reg_wr, iack)
    begin
        if reset = '1' then
            a_istate <= idle;
            a_int <= '0';
        elsif falling_edge(reg_wr) then
            if ba = '0' and cd = '0' and d(0) = '1' then
                -- LSB of port at 1 starts counter to generate interrupt
                a_istate <= count;
                a_icount <= 0;
            end if;
        elsif rising_edge(clk) then
            if a_istate = count then
                if a_icount = 200 then
                    a_istate <= interrupt;
                    a_int <= '1';
                else
                    a_icount <= a_icount + 1;
                end if;
            end if;
        elsif falling_edge(iack) then
            -- TODO this is rather a simplfification. When does the reti recognition have an effect? Not yet implemented..
            if a_istate = interrupt then
                a_int <= '0';
                a_istate <= idle;
            end if;
        end if;
    end process;

end;
