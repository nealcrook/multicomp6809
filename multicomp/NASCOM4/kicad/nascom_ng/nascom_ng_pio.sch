EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 6
Title "NASCOM 4 - a NASCOM in an FPGA"
Date ""
Rev "PRE-A"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L myLib:Z80PIO U12
U 1 1 5FC9E4CC
P 4400 2500
F 0 "U12" H 3850 3900 50  0000 L CNN
F 1 "Z80PIO" H 4650 3900 50  0000 L CNN
F 2 "Package_DIP:DIP-40_W15.24mm" H 4400 2900 50  0001 C CNN
F 3 "" H 4400 2900 50  0001 C CNN
	1    4400 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 2000 5450 2000
Wire Wire Line
	5100 1900 5450 1900
Wire Wire Line
	7150 2450 7550 2450
Wire Wire Line
	5100 1800 5450 1800
Wire Wire Line
	7150 2350 7550 2350
Wire Wire Line
	5100 1700 5450 1700
Wire Wire Line
	7150 2250 7550 2250
Wire Wire Line
	5100 1600 5450 1600
Wire Wire Line
	7150 2150 7550 2150
Wire Wire Line
	5100 1500 5450 1500
Wire Wire Line
	7150 2050 7550 2050
Wire Wire Line
	5100 1400 5450 1400
Wire Wire Line
	7150 1950 7550 1950
Wire Wire Line
	5100 1300 5450 1300
Wire Wire Line
	7150 1850 7550 1850
Wire Wire Line
	7150 1350 7550 1350
Wire Wire Line
	7150 1250 7550 1250
Wire Wire Line
	7150 1550 7550 1550
Wire Wire Line
	5450 2200 5100 2200
Wire Wire Line
	7150 1650 7550 1650
NoConn ~ 8050 1850
NoConn ~ 8050 2450
Wire Wire Line
	8350 1750 8050 1750
Wire Wire Line
	8350 1250 8050 1250
Wire Wire Line
	8350 1350 8050 1350
Wire Wire Line
	8350 1450 8050 1450
Wire Wire Line
	8350 1550 8050 1550
Wire Wire Line
	8350 1650 8050 1650
Wire Wire Line
	8050 2150 8150 2150
Wire Wire Line
	8050 2250 8150 2250
Wire Wire Line
	8150 2250 8150 2150
$Comp
L power:GND #PWR0113
U 1 1 5FC9E531
P 4400 4000
F 0 "#PWR0113" H 4400 3750 50  0001 C CNN
F 1 "GND" H 4400 3850 50  0000 C CNN
F 2 "" H 4400 4000 50  0001 C CNN
F 3 "" H 4400 4000 50  0001 C CNN
	1    4400 4000
	1    0    0    -1  
$EndComp
Text Label 7150 1250 2    60   ~ 0
PIO_B5
Text Label 7150 1350 2    60   ~ 0
PIO_B6
Text Label 7150 1450 2    60   ~ 0
PIO_B7
Text Label 7150 1550 2    60   ~ 0
PIO_ARDY
Text Label 7150 1850 2    60   ~ 0
PIO_A0
Text Label 7150 1950 2    60   ~ 0
PIO_A1
Text Label 7150 2050 2    60   ~ 0
PIO_A2
Text Label 7150 2150 2    60   ~ 0
PIO_A3
Text Label 7150 2250 2    60   ~ 0
PIO_A4
Text Label 7150 2350 2    60   ~ 0
PIO_A5
Text Label 7150 2450 2    60   ~ 0
PIO_A6
Text Label 5450 1300 0    50   ~ 0
PIO_A0
Text Label 5450 1400 0    50   ~ 0
PIO_A1
Text Label 5450 1500 0    50   ~ 0
PIO_A2
Text Label 5450 1600 0    50   ~ 0
PIO_A3
Text Label 5450 1700 0    50   ~ 0
PIO_A4
Text Label 5450 1800 0    50   ~ 0
PIO_A5
Text Label 5450 1900 0    50   ~ 0
PIO_A6
Text Label 5450 2000 0    50   ~ 0
PIO_A7
Text Label 5450 2200 0    50   ~ 0
PIO_ARDY
Wire Wire Line
	5100 3200 5450 3200
Wire Wire Line
	5100 3100 5450 3100
Wire Wire Line
	5100 3000 5450 3000
Wire Wire Line
	5100 2900 5450 2900
Wire Wire Line
	5100 2800 5450 2800
Wire Wire Line
	5100 2700 5450 2700
Wire Wire Line
	5100 2600 5450 2600
Wire Wire Line
	5100 2500 5450 2500
Wire Wire Line
	5450 3400 5100 3400
Wire Wire Line
	5450 3500 5100 3500
Text Label 5450 2500 0    50   ~ 0
PIO_B0
Text Label 5450 2600 0    50   ~ 0
PIO_B1
Text Label 5450 2700 0    50   ~ 0
PIO_B2
Text Label 5450 2800 0    50   ~ 0
PIO_B3
Text Label 5450 2900 0    50   ~ 0
PIO_B4
Text Label 5450 3000 0    50   ~ 0
PIO_B5
Text Label 5450 3100 0    50   ~ 0
PIO_B6
Text Label 5450 3200 0    50   ~ 0
PIO_B7
Text Label 5450 3400 0    50   ~ 0
PIO_BRDY
Text Label 5450 3500 0    50   ~ 0
~PIO_BSTB
$Comp
L power:GND #PWR0114
U 1 1 5FCF4C71
P 8250 2600
F 0 "#PWR0114" H 8250 2350 50  0001 C CNN
F 1 "GND" H 8250 2450 50  0000 C CNN
F 2 "" H 8250 2600 50  0001 C CNN
F 3 "" H 8250 2600 50  0001 C CNN
	1    8250 2600
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0115
U 1 1 5FCF502A
P 8150 1050
F 0 "#PWR0115" H 8150 900 50  0001 C CNN
F 1 "+5V" H 8150 1190 50  0000 C CNN
F 2 "" H 8150 1050 50  0001 C CNN
F 3 "" H 8150 1050 50  0001 C CNN
	1    8150 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 2350 8350 2350
Wire Wire Line
	8150 2150 8150 1050
Connection ~ 8150 2150
Wire Wire Line
	8050 2050 8250 2050
Wire Wire Line
	8250 2050 8250 2600
Wire Wire Line
	8050 1950 8250 1950
Wire Wire Line
	8250 1950 8250 2050
Connection ~ 8250 2050
Text Label 8350 1250 0    50   ~ 0
PIO_B4
Text Label 8350 1350 0    50   ~ 0
PIO_B3
Text Label 8350 1450 0    50   ~ 0
PIO_B2
Text Label 8350 1550 0    50   ~ 0
PIO_B1
Text Label 8350 1650 0    50   ~ 0
PIO_B0
Text Label 8350 1750 0    50   ~ 0
PIO_BRDY
Text Label 8350 2350 0    50   ~ 0
PIO_A7
Wire Wire Line
	3700 1300 3000 1300
Text GLabel 3000 1300 0    50   Input ~ 0
D0_5V
Wire Wire Line
	3700 1400 3000 1400
Text GLabel 3000 1400 0    50   Input ~ 0
D1_5V
Wire Wire Line
	3700 1500 3000 1500
Text GLabel 3000 1500 0    50   Input ~ 0
D2_5V
Wire Wire Line
	3700 1600 3000 1600
Text GLabel 3000 1600 0    50   Input ~ 0
D3_5V
Wire Wire Line
	3700 1700 3000 1700
Text GLabel 3000 1700 0    50   Input ~ 0
D4_5V
Wire Wire Line
	3700 1800 3000 1800
Text GLabel 3000 1800 0    50   Input ~ 0
D5_5V
Wire Wire Line
	3700 1900 3000 1900
Text GLabel 3000 1900 0    50   Input ~ 0
D6_5V
Wire Wire Line
	3700 2000 3000 2000
Text GLabel 3000 2000 0    50   Input ~ 0
D7_5V
Wire Wire Line
	3700 2200 3000 2200
Text GLabel 3000 2200 0    50   Input ~ 0
A0_5V
Wire Wire Line
	3700 2300 3000 2300
Text GLabel 3000 2300 0    50   Input ~ 0
A1_5V
Wire Wire Line
	3700 3000 3000 3000
Text GLabel 3000 3000 0    50   Input ~ 0
~IORQ_5V
Wire Wire Line
	3700 3100 3000 3100
Text GLabel 3000 3100 0    50   Input ~ 0
~RD_5V
Wire Wire Line
	3700 3300 3000 3300
Text GLabel 3000 3300 0    50   Input ~ 0
CLK4_5V
Wire Wire Line
	3700 3500 3250 3500
Text GLabel 3000 6900 0    50   Input ~ 0
~INT_5V
Wire Wire Line
	3700 2800 3000 2800
Text GLabel 3000 2800 0    50   Input ~ 0
~PIO_CS_5V
Wire Wire Line
	3700 2900 3000 2900
Text GLabel 3000 2900 0    50   Input ~ 0
~M1_5V
$Comp
L Device:R R22
U 1 1 5FD27F88
P 3550 1050
F 0 "R22" H 3620 1096 50  0000 L CNN
F 1 "10k" H 3620 1005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 3480 1050 50  0001 C CNN
F 3 "~" H 3550 1050 50  0001 C CNN
	1    3550 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 1200 3550 3600
Wire Wire Line
	3550 3600 3700 3600
Text Notes 1050 3900 0    50   ~ 0
PIO is first device on interrupt\ndaisy-chain
$Comp
L Device:R R21
U 1 1 5FD2D67B
P 3250 1050
F 0 "R21" H 3320 1096 50  0000 L CNN
F 1 "2k2" H 3320 1005 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 3180 1050 50  0001 C CNN
F 3 "~" H 3250 1050 50  0001 C CNN
	1    3250 1050
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0116
U 1 1 5FD2DE82
P 4400 750
F 0 "#PWR0116" H 4400 600 50  0001 C CNN
F 1 "+5V" H 4400 890 50  0000 C CNN
F 2 "" H 4400 750 50  0001 C CNN
F 3 "" H 4400 750 50  0001 C CNN
	1    4400 750 
	1    0    0    -1  
$EndComp
Wire Wire Line
	4400 1000 4400 800 
Wire Wire Line
	3250 900  3250 800 
Wire Wire Line
	3250 800  3550 800 
Wire Wire Line
	3550 900  3550 800 
Connection ~ 3550 800 
Wire Wire Line
	3550 800  4400 800 
Connection ~ 4400 800 
Wire Wire Line
	4400 800  4400 750 
Wire Wire Line
	3250 1200 3250 3500
Connection ~ 3250 3500
Wire Wire Line
	7150 1450 7550 1450
Wire Wire Line
	5100 2300 5450 2300
Text Label 5450 2300 0    50   ~ 0
~PIO_ASTB
Wire Wire Line
	7550 1750 7150 1750
Text Label 7150 1750 2    50   ~ 0
~PIO_ASTB
Text Label 7150 1650 2    50   ~ 0
~PIO_BSTB
$Comp
L Connector_Generic:Conn_02x13_Odd_Even PL4
U 1 1 60828C59
P 7750 1850
F 0 "PL4" H 7800 2667 50  0000 C CNN
F 1 "Conn_02x13_Odd_Even" H 7800 2576 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x13_P2.54mm_Vertical" H 7750 1850 50  0001 C CNN
F 3 "~" H 7750 1850 50  0001 C CNN
	1    7750 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 4900 7400 4900
Wire Wire Line
	8350 5500 8050 5500
Text Label 8350 5100 0    50   ~ 0
CLK_TRG1
Text Label 8350 5500 0    50   ~ 0
CLK_TRG3
Wire Wire Line
	8050 4900 8350 4900
Wire Wire Line
	8050 5300 8350 5300
Text Notes 7000 6250 0    50   ~ 0
Pin numbering does NOT match NASCOM I/O\nboard; it is arranged so that jumpers can be\nused to trigger each timer either from (1)\nCLK or (2) from the timeout of another\ncounter or (3) by attaching a cable.
Text Notes 7700 4600 0    50   ~ 0
"CTC"
$Comp
L power:+5V #PWR?
U 1 1 60EDFB20
P 8150 4500
AR Path="/5FC877BB/60EDFB20" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60EDFB20" Ref="#PWR?"  Part="1" 
AR Path="/5FC8753B/60EDFB20" Ref="#PWR025"  Part="1" 
F 0 "#PWR025" H 8150 4350 50  0001 C CNN
F 1 "+5V" H 8165 4673 50  0000 C CNN
F 2 "" H 8150 4500 50  0001 C CNN
F 3 "" H 8150 4500 50  0001 C CNN
	1    8150 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 5400 7150 5400
Text GLabel 7150 4900 0    50   Input ~ 0
CLK4_5V
$Comp
L power:GND #PWR?
U 1 1 60EF1373
P 7400 5600
AR Path="/5FC86EA5/60EF1373" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60EF1373" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60EF1373" Ref="#PWR?"  Part="1" 
AR Path="/5FC8753B/60EF1373" Ref="#PWR024"  Part="1" 
F 0 "#PWR024" H 7400 5350 50  0001 C CNN
F 1 "GND" H 7405 5427 50  0000 C CNN
F 2 "" H 7400 5600 50  0001 C CNN
F 3 "" H 7400 5600 50  0001 C CNN
	1    7400 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 5600 8150 4500
Text Label 8350 5400 0    50   ~ 0
ZC_TO2
Text Label 8350 5000 0    50   ~ 0
ZC_TO0
Wire Wire Line
	8050 5100 8350 5100
Text Label 8350 5200 0    50   ~ 0
ZC_TO1
Text Label 8350 4900 0    50   ~ 0
CLK_TRG0
Text Label 8350 5300 0    50   ~ 0
CLK_TRG2
$Comp
L myLib:Z80CTC U1
U 1 1 60F2EDA1
P 4400 6100
F 0 "U1" H 4700 7400 50  0000 C CNN
F 1 "Z80CTC" H 4800 7300 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 4400 6350 50  0001 C CNN
F 3 "" H 4400 6350 50  0001 C CNN
	1    4400 6100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR023
U 1 1 60F30C52
P 4400 7450
F 0 "#PWR023" H 4400 7200 50  0001 C CNN
F 1 "GND" H 4400 7300 50  0000 C CNN
F 2 "" H 4400 7450 50  0001 C CNN
F 3 "" H 4400 7450 50  0001 C CNN
	1    4400 7450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR022
U 1 1 60F3327E
P 4400 4800
F 0 "#PWR022" H 4400 4650 50  0001 C CNN
F 1 "+5V" H 4400 4940 50  0000 C CNN
F 2 "" H 4400 4800 50  0001 C CNN
F 3 "" H 4400 4800 50  0001 C CNN
	1    4400 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 5100 3000 5100
Text GLabel 3000 5100 0    50   Input ~ 0
D0_5V
Wire Wire Line
	3700 5200 3000 5200
Text GLabel 3000 5200 0    50   Input ~ 0
D1_5V
Wire Wire Line
	3700 5300 3000 5300
Text GLabel 3000 5300 0    50   Input ~ 0
D2_5V
Wire Wire Line
	3700 5400 3000 5400
Text GLabel 3000 5400 0    50   Input ~ 0
D3_5V
Wire Wire Line
	3700 5500 3000 5500
Text GLabel 3000 5500 0    50   Input ~ 0
D4_5V
Wire Wire Line
	3700 5600 3000 5600
Text GLabel 3000 5600 0    50   Input ~ 0
D5_5V
Wire Wire Line
	3700 5700 3000 5700
Text GLabel 3000 5700 0    50   Input ~ 0
D6_5V
Wire Wire Line
	3700 5800 3000 5800
Text GLabel 3000 5800 0    50   Input ~ 0
D7_5V
Wire Wire Line
	3700 6100 3000 6100
Text GLabel 3000 6100 0    50   Input ~ 0
A0_5V
Wire Wire Line
	3700 6200 3000 6200
Text GLabel 3000 6200 0    50   Input ~ 0
A1_5V
Wire Wire Line
	3700 3700 3550 3700
Wire Wire Line
	3550 3700 3550 6700
Wire Wire Line
	3550 6700 3700 6700
Wire Wire Line
	3250 6900 3250 3500
Wire Wire Line
	3000 6900 3250 6900
Wire Wire Line
	3700 6900 3250 6900
Connection ~ 3250 6900
Wire Wire Line
	3700 6300 3000 6300
Text GLabel 3000 6300 0    50   Input ~ 0
~M1_5V
Wire Wire Line
	3700 6400 3000 6400
Text GLabel 3000 6400 0    50   Input ~ 0
~IORQ_5V
Wire Wire Line
	3700 6500 3000 6500
Text GLabel 3000 6500 0    50   Input ~ 0
~RD_5V
Wire Wire Line
	3700 7100 3000 7100
Text GLabel 3000 7100 0    50   Input ~ 0
CLK4_5V
Wire Wire Line
	3700 6000 3000 6000
Text GLabel 3000 6000 0    50   Input ~ 0
~CTC_CS_5V
Wire Wire Line
	5100 5100 5450 5100
Wire Wire Line
	5100 5200 5450 5200
Text Label 5450 5100 0    50   ~ 0
CLK_TRG0
Text Label 5450 5200 0    50   ~ 0
ZC_TO0
Wire Wire Line
	5100 5400 5450 5400
Wire Wire Line
	5100 5500 5450 5500
Text Label 5450 5400 0    50   ~ 0
CLK_TRG1
Text Label 5450 5500 0    50   ~ 0
ZC_TO1
Wire Wire Line
	5100 5700 5450 5700
Wire Wire Line
	5100 5800 5450 5800
Text Label 5450 5700 0    50   ~ 0
CLK_TRG2
Text Label 5450 5800 0    50   ~ 0
ZC_TO2
Wire Wire Line
	5100 6000 5450 6000
Text Label 5450 6000 0    50   ~ 0
CLK_TRG3
Text Notes 1000 6900 0    50   ~ 0
CTC is last device on interrupt\ndaisy-chain so its IEO is not\nconnected.
NoConn ~ 3700 6800
Wire Wire Line
	3700 7200 3000 7200
Text GLabel 3000 7200 0    50   Input ~ 0
~IO_RESET_5V
Wire Wire Line
	7550 5200 7150 5200
Wire Wire Line
	8050 5000 8350 5000
Wire Wire Line
	8050 5200 8350 5200
Wire Wire Line
	7400 5100 7550 5100
Connection ~ 7400 4900
Wire Wire Line
	7400 4900 7150 4900
Wire Wire Line
	7400 5300 7400 5100
Wire Wire Line
	7400 5300 7550 5300
Connection ~ 7400 5100
Wire Wire Line
	8050 5400 8350 5400
Wire Wire Line
	7550 5500 7400 5500
Wire Wire Line
	7400 5500 7400 5300
Connection ~ 7400 5300
Wire Wire Line
	7400 4900 7400 5100
Wire Wire Line
	7550 5000 7150 5000
Text Label 7150 5000 2    50   ~ 0
CLK_TRG2
Text Label 7150 5200 2    50   ~ 0
CLK_TRG3
Text Label 7150 5400 2    50   ~ 0
CLK_TRG0
Wire Wire Line
	8050 5600 8150 5600
Wire Wire Line
	7400 5600 7550 5600
Text Label 3550 3200 0    50   ~ 0
PUP_EIE
Text Label 3550 3950 0    50   ~ 0
PIO_EIO
Text Notes 7050 6800 0    98   ~ 20
Z80-PIO, Z80-CTC and their connectors
Text Notes 7650 950  0    50   ~ 0
"PORTS"
$Comp
L Connector_Generic:Conn_02x08_Odd_Even PL?
U 1 1 60EDA1EF
P 7750 5200
AR Path="/5FC877BB/60EDA1EF" Ref="PL?"  Part="1" 
AR Path="/5FC85C78/60EDA1EF" Ref="PL?"  Part="1" 
AR Path="/5FC8753B/60EDA1EF" Ref="J4"  Part="1" 
F 0 "J4" H 7800 5717 50  0000 C CNN
F 1 "Conn_02x08_Odd_Even" H 7800 5626 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 7750 5200 50  0001 C CNN
F 3 "~" H 7750 5200 50  0001 C CNN
	1    7750 5200
	1    0    0    -1  
$EndComp
$EndSCHEMATC
