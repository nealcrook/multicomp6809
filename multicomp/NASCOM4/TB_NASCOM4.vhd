-- Top-level testbench for NASCOM4 FPGA design

-- Next:
-- More PIO modelling... to assert an interrupt eg on particular data write
-- Change test ROM to do PIO setup and program interrupt vector and enable interrupts- and change location in ROM of vector so that
-- the correct value has to be supplied for the code to work
-- Maybe in NASCOM decode "bridge_source" to select sRamData during bridge reads and interrupt acknowledge

-- ?? write PIO model that
-- * decodes ports and I/o like a real device
-- * implements the daisy-chain
-- * responds to intack by supplying a vector
-- * tracks reti
-- * can generate an interrupt
-- then put 2 of them in place - connect one to the CTC chip select.
--
-- Future: can create an SDcard model for debugging that interface..
-- dummy NASCOM keyboard for injecting a command string from a file
-- dummy terminal for injecting a command string from a file and reporting the response
-- something for reporting the state of the nascom screen?
-- dummy PS/2 device..



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity TB_NASCOM4 is
    port(
        clk     : in std_logic;
        n_SwRst : in std_logic;
        n_SwWarmRst : in std_logic;
        n_SwNMI : in std_logic;
        SerRxBdClk : in std_logic;
        SerTxBdClk : in std_logic
        );
end TB_NASCOM4;

architecture rtl of TB_NASCOM4 is

    signal sRamData    : std_logic_vector(7 downto 0);
    signal sRamData_dly : std_logic_vector(7 downto 0);
    signal sRamAddress : std_logic_vector(18 downto 0);
    signal n_sRamWE    : std_logic;
    signal n_sRamCS1   : std_logic;
    signal n_sRamCS2   : std_logic;
    signal n_sRamOE    : std_logic;

    signal n_LED7Drive    : std_logic;
    signal n_LED9Halt     : std_logic;
    signal n_LED3SdActive : std_logic;

    -- Devices on memory bus
    type t_mem8 is array (0 to 7) of std_logic_vector(7 downto 0);
    signal ramL : t_mem8;
    signal ramH : t_mem8;

    -- Devices on I/O bus
    type t_mem4 is array (0 to 3) of std_logic_vector(7 downto 0);
    signal fdc : t_mem4;
    signal kbdbuf : std_logic_vector(7 downto 0) := x"FA";
    signal drvreg : std_logic_vector(7 downto 0);

    -- NASCOM serial port
    signal txd : std_logic;

    -- I/O bus connections from FPGA
    signal clk4 :       std_logic;
    signal clk1 :       std_logic;

    signal n_INT :      std_logic;

    signal pio_cs_n :   std_logic;
    signal ctc_cs_n :   std_logic;
    signal fdc_cs_n :   std_logic;

    signal porte4_wr :  std_logic;
    signal port00_rd_n: std_logic;

    signal BrReset_n :  std_logic;
    signal BrM1_n :     std_logic;
    signal BrIORQ_n :   std_logic;
    signal BrRD_n :     std_logic;
    signal BrWR_n :     std_logic;

    signal BrBufOE_n :  std_logic;
    signal BrBufWr :    std_logic;

    -- I/O bus data bus - isolated from SRAM bus by bidirectional buffer
    signal BrData :     std_logic_vector(7 downto 0);
    -- I/O bus address - buffered version of SRAM bus
    signal BrAddr :     std_logic_vector(1 downto 0);

    signal fdc_wr :     std_logic;

    signal raml_wr :    std_logic;
    signal ramh_wr :    std_logic;

    -- PIO daisy-chain and interrupts
    signal pio_ieo :    std_logic;
    signal pio_int_n :  std_logic;
    signal ctc_int_n :  std_logic;

    -- PIO io signals
    signal pio_a :      std_logic_vector(7 downto 0);
    signal pio_ardy:    std_logic;
    signal pio_astb_n:  std_logic;

    signal pio_b :      std_logic_vector(7 downto 0);
    signal pio_brdy:    std_logic;
    signal pio_bstb_n:  std_logic;

    signal ctc_a :      std_logic_vector(7 downto 0);
    signal ctc_ardy:    std_logic;
    signal ctc_astb_n:  std_logic;

    signal ctc_b :      std_logic_vector(7 downto 0);
    signal ctc_brdy:    std_logic;
    signal ctc_bstb_n:  std_logic;


begin

    -- Unit Under Test
    uut: entity work.NASCOM4
        port map(
            clk         => clk,
            n_SwRst     => n_SwRst,

            n_SwWarmRst => n_SwWarmRst,
            n_SwNMI     => n_SwNMI,

            n_LED7Drive    => n_LED7Drive,
            n_LED9Halt     => n_LED9Halt,
            n_LED3SdActive => n_LED3SdActive,

            sRamData    => sRamData,
            sRamAddress => sRamAddress,
            n_sRamWE    => n_sRamWE,
            n_sRamCS1   => n_sRamCS1,
            n_sRamCS2   => n_sRamCS2,
            n_sRamOE    => n_sRamOE,

            n_INT       => n_INT,     -- logic below combines the drivers
            sdMISO      => '0',

            -- I/O bus
            clk4        => clk4,
            clk1        => clk1,

            pio_cs_n    => pio_cs_n,
            ctc_cs_n    => ctc_cs_n,
            fdc_cs_n    => fdc_cs_n,

            porte4_wr   => porte4_wr,
            port00_rd_n => port00_rd_n,

            BrReset_n   => BrReset_n,
            BrM1_n      => BrM1_n,
            BrIORQ_n    => BrIORQ_n,
            BrRD_n      => BrRD_n,
            BrWR_n      => BrWR_n,

            BrBufOE_n   => BrBufOE_n,
            BrBufWr     => BrBufWr,

            -- NASCOM serial port.. currently doesn't do anything here
            SerRxToNas  => txd, -- loopback'1',
            SerTxFrNas  => txd,
            SerRxBdClk  => SerRxBdClk,
            SerTxBdClk  => SerTxBdClk,

            -- Inputs from FDC, not modelled here but need to be tied off
            FdcRdy_n    => '0',
            FdcIntr     => '0',
            FdcDrq      => '0',

            -- Unused inputs
            SpareIn89   => '0',
            SpareIn90   => '0'
            );

    -- PIO
    u_pio: entity work.Z80_PIO
        port map(
            d           => BrData,
            ba          => BrAddr(0),
            cd          => BrAddr(1),
            ce_n        => pio_cs_n,
            m1_n        => BrM1_n,
            iorq_n      => BrIORQ_n,
            rd_n        => BrRD_n,
            clk         => clk4,

            int_n       => pio_int_n,
            iei         => '1',       -- top of the chain
            ieo         => pio_ieo,

            a           => pio_a,
            ardy        => pio_ardy,
            astb_n      => pio_astb_n,

            b           => pio_b,
            brdy        => pio_brdy,
            bstb_n      => pio_bstb_n
            );

    -- Second PIO - in the real system this is a CTC
    u_ctc: entity work.Z80_PIO
        port map(
            d           => BrData,
            ba          => BrAddr(0),
            cd          => BrAddr(1),
            ce_n        => ctc_cs_n,
            m1_n        => BrM1_n,
            iorq_n      => BrIORQ_n,
            rd_n        => BrRD_n,
            clk         => clk4,

            int_n       => ctc_int_n,
            iei         => pio_ieo,   -- upstream
                                      -- ieo output is unconnected

            a           => ctc_a,
            ardy        => ctc_ardy,
            astb_n      => ctc_astb_n,

            b           => ctc_b,
            brdy        => ctc_brdy,
            bstb_n      => ctc_bstb_n
            );

    -- Delayed version of data bus to model bus hold time. All of the
    -- write strobes are combinational rather than clocked: without
    -- this the data would have negative hold time relative to the strobes
    -- and would be missed
    sRamData_dly <= sRamData after 1 ns;


    -- Mimic an open-collector interrupt line; the two interrupt sources
    -- go between Z and 0.
    n_INT <= '0' when pio_int_n = '0' or ctc_int_n = '0' else '1';

    -- Report HALT LED
    LedHalt : process (n_LED9Halt)
    begin
        if rising_edge(n_LED9Halt) then
            report "The HALT LED has turned off";
        end if;

        if falling_edge(n_LED9Halt) then
            report "The HALT LED has turned on";
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- I/O address bus
    BrAddr <= sRamAddress(1 downto 0);


    --------------------------------------------------------------------------------
    -- Resolve I/O data bus, and handle I/O Reads
    -- TODO should have iorq in the gating also??
    -- TODO need to decode/handle intack
    -- TODO - need to check for multiple drivers instead of this simple priority tree
    BrData <= sRamData_dly when BrBufWr = '1' and BrBufOE_n = '0' else
              fdc(to_integer(unsigned(BrAddr))) when fdc_cs_n = '0' and BrRD_n = '0'   else
              kbdbuf      when port00_rd_n = '0' else
             (others=>'Z');

    sRamData <= BrData when BrBufWr = '0' and BrBufOE_n = '0' else (others=> 'Z');

    --------------------------------------------------------------------------------
    -- Handle memory writes
    raml_wr <= '1' when n_sRamWE = '0' and n_sRamCS1 = '0' else '0';
    ramh_wr <= '1' when n_sRamWE = '0' and n_sRamCS2 = '0' else '0';

    -- Capture write data at the *end* of the write cycle
    WrRaml : process (raml_wr)
    begin
        if falling_edge(raml_wr) then
            raml(to_integer(unsigned(sRamAddress(2 downto 0)))) <= sRamData_dly;
        end if;
    end process;

    WrRamh : process (ramh_wr)
    begin
        if falling_edge(ramh_wr) then
            ramh(to_integer(unsigned(sRamAddress(2 downto 0)))) <= sRamData_dly;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- Handle memory reads

    sRamData <= raml(to_integer(unsigned(sRamAddress(2 downto 0)))) when n_sRamCS1 = '0' and n_sRamOE = '0' else (others=> 'Z');
    sRamData <= ramh(to_integer(unsigned(sRamAddress(2 downto 0)))) when n_sRamCS2 = '0' and n_sRamOE = '0' else (others=> 'Z');

    --------------------------------------------------------------------------------
    -- Writes to drvreg, which is posedge clocked and also has a reset
    ff_e4 : process (BrReset_n, porte4_wr)
    begin
        if BrReset_n = '0' then
            drvreg <= x"00";
        elsif rising_edge(porte4_wr) then
            drvreg <= BrData;
        end if;
    end process;


    --------------------------------------------------------------------------------
    -- Handle I/O Writes to FDC
    fdc_wr <= '1' when fdc_cs_n = '0' and BrIORQ_n = '0' and BrWr_n = '0' else '0';

    -- Capture data at the end of the write strobe
    WrFdc : process (fdc_wr)
    begin
        if falling_edge(fdc_wr) then
            fdc(to_integer(unsigned(BrAddr))) <= BrData;
        end if;
    end process;

end;
