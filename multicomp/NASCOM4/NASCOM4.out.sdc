## Generated SDC file "NASCOM4.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Sat Apr 18 21:00:06 2015"

##
## DEVICE  "EP2C5T144C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {n_SwRst}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {n_SwWarmRst}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {n_SwNMI}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {ps2Clk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {ps2Data}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SerRxToNas}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SerRxBdClk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SerTxBdClk}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sdMISO}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {FdcRdy_n}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {FdcIntr}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {FdcDrq}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {sramData[7]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  10.000 [get_ports {n_LED7Drive}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  10.000 [get_ports {n_LED9Halt}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  10.000 [get_ports {n_LED3SdActive}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramData[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sramAddress[18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {n_sRamWE}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {n_sRamCS1}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {n_sRamCS2}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {n_sRamOE}]
# constraining clk4 results in the overall fmax being reduced from 52.96 to about 35MHz - probably
# due to the 'extend' that's generated on -ve clock and ORed with the posedge signal -- so I need to learn how
# to do this properly..
#set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {clk4}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {clk1}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {pio_cs_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {ctc_cs_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {fdc_cs_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {porte4_wr}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {port00_rd_n}]

set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrReset_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrM1_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrIORQ_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrRD_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrWR_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrBufOE_n}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {BrBufWr}]

set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {ps2Clk}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {ps2Data}]


set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {NasKbdClk}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {NasKbdRst}]

set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SerTxFrNas}]

set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sdCS}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sdMOSI}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {sdSCLK}]

set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {PriVSync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {PriHSync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {PriVideo}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SecVSync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SecHSync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  5.000 [get_ports {SecVideo}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

