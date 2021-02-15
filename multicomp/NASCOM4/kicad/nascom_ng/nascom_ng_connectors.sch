EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 6
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
L Connector:DB15_Female_HighDensity J17
U 1 1 5FD8C4EA
P 2950 1750
F 0 "J17" H 2950 2617 50  0000 C CNN
F 1 "DB15_Female_HighDensity" H 2950 2526 50  0000 C CNN
F 2 "Connector_Dsub:DSUB-15-HD_Female_Horizontal_P2.29x1.98mm_EdgePinOffset3.03mm_Housed_MountingHolesOffset4.94mm" H 2000 2150 50  0001 C CNN
F 3 " ~" H 2000 2150 50  0001 C CNN
	1    2950 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R25
U 1 1 5FD8D7B7
P 1850 1350
F 0 "R25" V 1750 1350 50  0000 C CNN
F 1 "R" V 1850 1350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 1780 1350 50  0001 C CNN
F 3 "~" H 1850 1350 50  0001 C CNN
	1    1850 1350
	0    1    1    0   
$EndComp
$Comp
L Device:R R24
U 1 1 5FD8DEB7
P 1850 1550
F 0 "R24" V 1750 1550 50  0000 C CNN
F 1 "R" V 1850 1550 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 1780 1550 50  0001 C CNN
F 3 "~" H 1850 1550 50  0001 C CNN
	1    1850 1550
	0    1    1    0   
$EndComp
$Comp
L Device:R R23
U 1 1 5FD8E0C3
P 1850 1750
F 0 "R23" V 1750 1750 50  0000 C CNN
F 1 "R" V 1850 1750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 1780 1750 50  0001 C CNN
F 3 "~" H 1850 1750 50  0001 C CNN
	1    1850 1750
	0    1    1    0   
$EndComp
Text Label 2050 1350 0    50   ~ 0
PRI_RED
Text Label 2050 1550 0    50   ~ 0
PRE_GREEN
Text Label 2050 1750 0    50   ~ 0
PRI_BLUE
Wire Wire Line
	2000 1350 2650 1350
Wire Wire Line
	2000 1550 2650 1550
Wire Wire Line
	2000 1750 2650 1750
Wire Wire Line
	1700 1750 1550 1750
Wire Wire Line
	1550 1750 1550 1550
Wire Wire Line
	1550 1350 1700 1350
Wire Wire Line
	1700 1550 1550 1550
Connection ~ 1550 1550
Wire Wire Line
	1550 1550 1550 1350
Wire Wire Line
	1550 1350 1300 1350
Connection ~ 1550 1350
Wire Wire Line
	3250 1750 3450 1750
Wire Wire Line
	3450 1750 3450 2550
Wire Wire Line
	3450 2550 1350 2550
Wire Wire Line
	3250 1950 3350 1950
Wire Wire Line
	3350 1950 3350 2450
Wire Wire Line
	3350 2450 1350 2450
Wire Wire Line
	2650 1850 2450 1850
Wire Wire Line
	2450 1850 2450 1250
Wire Wire Line
	2650 1250 2550 1250
Wire Wire Line
	2550 1250 2550 1450
Wire Wire Line
	2650 1450 2550 1450
Connection ~ 2550 1450
Wire Wire Line
	2550 1450 2550 1650
Wire Wire Line
	2650 1650 2550 1650
Connection ~ 2550 1650
Wire Wire Line
	2550 1650 2550 2050
Wire Wire Line
	2650 2150 2550 2150
Connection ~ 2550 2150
Wire Wire Line
	2550 2150 2550 2750
Wire Wire Line
	2650 2050 2550 2050
Connection ~ 2550 2050
Wire Wire Line
	2550 2050 2550 2150
NoConn ~ 3250 1350
NoConn ~ 3250 1550
NoConn ~ 3250 2150
NoConn ~ 2650 1950
$Comp
L power:GND #PWR0109
U 1 1 5FD92E1F
P 2550 2750
F 0 "#PWR0109" H 2550 2500 50  0001 C CNN
F 1 "GND" H 2555 2577 50  0000 C CNN
F 2 "" H 2550 2750 50  0001 C CNN
F 3 "" H 2550 2750 50  0001 C CNN
	1    2550 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0110
U 1 1 5FD9320F
P 2450 1250
F 0 "#PWR0110" H 2450 1100 50  0001 C CNN
F 1 "+3.3V" H 2465 1423 50  0000 C CNN
F 2 "" H 2450 1250 50  0001 C CNN
F 3 "" H 2450 1250 50  0001 C CNN
	1    2450 1250
	1    0    0    -1  
$EndComp
$Comp
L Connector:DB15_Female_HighDensity J18
U 1 1 5FD94BC5
P 6150 1750
F 0 "J18" H 6150 2617 50  0000 C CNN
F 1 "DB15_Female_HighDensity" H 6150 2526 50  0000 C CNN
F 2 "Connector_Dsub:DSUB-15-HD_Female_Horizontal_P2.29x1.98mm_EdgePinOffset3.03mm_Housed_MountingHolesOffset4.94mm" H 5200 2150 50  0001 C CNN
F 3 " ~" H 5200 2150 50  0001 C CNN
	1    6150 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R28
U 1 1 5FD94BCF
P 5050 1350
F 0 "R28" V 4950 1350 50  0000 C CNN
F 1 "R" V 5050 1350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 4980 1350 50  0001 C CNN
F 3 "~" H 5050 1350 50  0001 C CNN
	1    5050 1350
	0    1    1    0   
$EndComp
$Comp
L Device:R R27
U 1 1 5FD94BD9
P 5050 1550
F 0 "R27" V 4950 1550 50  0000 C CNN
F 1 "R" V 5050 1550 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 4980 1550 50  0001 C CNN
F 3 "~" H 5050 1550 50  0001 C CNN
	1    5050 1550
	0    1    1    0   
$EndComp
$Comp
L Device:R R26
U 1 1 5FD94BE3
P 5050 1750
F 0 "R26" V 4950 1750 50  0000 C CNN
F 1 "R" V 5050 1750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 4980 1750 50  0001 C CNN
F 3 "~" H 5050 1750 50  0001 C CNN
	1    5050 1750
	0    1    1    0   
$EndComp
Text Label 5250 1350 0    50   ~ 0
SEC_RED
Text Label 5250 1550 0    50   ~ 0
SEC_GREEN
Text Label 5250 1750 0    50   ~ 0
SEC_BLUE
Wire Wire Line
	5200 1350 5850 1350
Wire Wire Line
	5200 1550 5850 1550
Wire Wire Line
	5200 1750 5850 1750
Wire Wire Line
	4900 1750 4750 1750
Wire Wire Line
	4750 1750 4750 1550
Wire Wire Line
	4750 1350 4900 1350
Wire Wire Line
	4900 1550 4750 1550
Connection ~ 4750 1550
Wire Wire Line
	4750 1550 4750 1350
Wire Wire Line
	4750 1350 4500 1350
Connection ~ 4750 1350
Wire Wire Line
	6450 1750 6650 1750
Wire Wire Line
	6650 1750 6650 2550
Wire Wire Line
	6650 2550 4550 2550
Wire Wire Line
	6450 1950 6550 1950
Wire Wire Line
	6550 1950 6550 2450
Wire Wire Line
	6550 2450 4550 2450
Wire Wire Line
	5850 1850 5650 1850
Wire Wire Line
	5650 1850 5650 1250
Wire Wire Line
	5850 1250 5750 1250
Wire Wire Line
	5750 1250 5750 1450
Wire Wire Line
	5850 1450 5750 1450
Connection ~ 5750 1450
Wire Wire Line
	5750 1450 5750 1650
Wire Wire Line
	5850 1650 5750 1650
Connection ~ 5750 1650
Wire Wire Line
	5750 1650 5750 2050
Wire Wire Line
	5850 2150 5750 2150
Connection ~ 5750 2150
Wire Wire Line
	5750 2150 5750 2750
Wire Wire Line
	5850 2050 5750 2050
Connection ~ 5750 2050
Wire Wire Line
	5750 2050 5750 2150
NoConn ~ 6450 1350
NoConn ~ 6450 1550
NoConn ~ 6450 2150
NoConn ~ 5850 1950
$Comp
L power:GND #PWR0111
U 1 1 5FD94C18
P 5750 2750
F 0 "#PWR0111" H 5750 2500 50  0001 C CNN
F 1 "GND" H 5755 2577 50  0000 C CNN
F 2 "" H 5750 2750 50  0001 C CNN
F 3 "" H 5750 2750 50  0001 C CNN
	1    5750 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0112
U 1 1 5FD94C22
P 5650 1250
F 0 "#PWR0112" H 5650 1100 50  0001 C CNN
F 1 "+3.3V" H 5665 1423 50  0000 C CNN
F 2 "" H 5650 1250 50  0001 C CNN
F 3 "" H 5650 1250 50  0001 C CNN
	1    5650 1250
	1    0    0    -1  
$EndComp
Text GLabel 1350 2550 0    50   Input ~ 0
PIN55_PRI_HSYNC
Text GLabel 1350 2450 0    50   Input ~ 0
PIN51_PRI_VSYNC
Wire Wire Line
	8650 1500 8050 1500
Text GLabel 8050 1500 0    50   Input ~ 0
PIN41_SDCS
Wire Wire Line
	8650 1800 8050 1800
Text GLabel 8050 1800 0    50   Input ~ 0
PIN42_SDDI
Wire Wire Line
	8650 1700 8050 1700
Text GLabel 8050 1700 0    50   Input ~ 0
PIN43_SDCLK
Wire Wire Line
	8650 1600 8050 1600
Text GLabel 8050 1600 0    50   Input ~ 0
PIN40_SDDO
$Comp
L power:GND #PWR07
U 1 1 60780598
P 8500 2050
F 0 "#PWR07" H 8500 1800 50  0001 C CNN
F 1 "GND" H 8505 1877 50  0000 C CNN
F 2 "" H 8500 2050 50  0001 C CNN
F 3 "" H 8500 2050 50  0001 C CNN
	1    8500 2050
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR06
U 1 1 607813D2
P 8500 1250
F 0 "#PWR06" H 8500 1100 50  0001 C CNN
F 1 "+3.3V" H 8515 1423 50  0000 C CNN
F 2 "" H 8500 1250 50  0001 C CNN
F 3 "" H 8500 1250 50  0001 C CNN
	1    8500 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	8650 1400 8500 1400
Wire Wire Line
	8500 1400 8500 1250
Wire Wire Line
	8650 1900 8500 1900
$Comp
L Device:R R17
U 1 1 60792D3D
P 8350 3450
F 0 "R17" H 8420 3496 50  0000 L CNN
F 1 "10k" H 8420 3405 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8280 3450 50  0001 C CNN
F 3 "~" H 8350 3450 50  0001 C CNN
	1    8350 3450
	1    0    0    -1  
$EndComp
$Comp
L Device:D_Zener D5
U 1 1 6079345F
P 8350 3950
F 0 "D5" V 8304 4030 50  0000 L CNN
F 1 "3V6" V 8395 4030 50  0000 L CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 8350 3950 50  0001 C CNN
F 3 "~" H 8350 3950 50  0001 C CNN
	1    8350 3950
	0    1    1    0   
$EndComp
$Comp
L Device:R R18
U 1 1 607938E7
P 8650 3450
F 0 "R18" H 8720 3496 50  0000 L CNN
F 1 "10k" H 8720 3405 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 3450 50  0001 C CNN
F 3 "~" H 8650 3450 50  0001 C CNN
	1    8650 3450
	1    0    0    -1  
$EndComp
$Comp
L Device:D_Zener D6
U 1 1 60793B99
P 8650 3950
F 0 "D6" V 8604 4030 50  0000 L CNN
F 1 "3V6" V 8695 4030 50  0000 L CNN
F 2 "Diode_THT:D_DO-35_SOD27_P7.62mm_Horizontal" H 8650 3950 50  0001 C CNN
F 3 "~" H 8650 3950 50  0001 C CNN
	1    8650 3950
	0    1    1    0   
$EndComp
$Comp
L power:+3.3V #PWR09
U 1 1 6079795E
P 8350 3100
F 0 "#PWR09" H 8350 2950 50  0001 C CNN
F 1 "+3.3V" H 8365 3273 50  0000 C CNN
F 2 "" H 8350 3100 50  0001 C CNN
F 3 "" H 8350 3100 50  0001 C CNN
	1    8350 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 60797F7C
P 8350 4250
F 0 "#PWR010" H 8350 4000 50  0001 C CNN
F 1 "GND" H 8355 4077 50  0000 C CNN
F 2 "" H 8350 4250 50  0001 C CNN
F 3 "" H 8350 4250 50  0001 C CNN
	1    8350 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	8350 4100 8350 4200
Wire Wire Line
	8350 4200 8650 4200
Wire Wire Line
	8650 4200 8650 4100
Connection ~ 8350 4200
Wire Wire Line
	8350 4200 8350 4250
Wire Wire Line
	9000 3700 8900 3700
Wire Wire Line
	8900 3700 8900 4200
Wire Wire Line
	8900 4200 8650 4200
Connection ~ 8650 4200
Wire Wire Line
	8350 3600 8350 3650
Wire Wire Line
	8650 3600 8650 3750
Wire Wire Line
	8350 3650 7800 3650
Connection ~ 8350 3650
Wire Wire Line
	8650 3750 7800 3750
Connection ~ 8650 3750
Wire Wire Line
	8650 3750 8650 3800
Wire Wire Line
	8650 3800 9000 3800
Connection ~ 8650 3800
Text GLabel 7800 3650 0    50   Input ~ 0
PIN44_KCLK
Text GLabel 7800 3750 0    50   Input ~ 0
PIN45_KDAT
Wire Wire Line
	8350 3100 8350 3150
Wire Wire Line
	8650 3300 8650 3150
Wire Wire Line
	8650 3150 8350 3150
Connection ~ 8350 3150
Wire Wire Line
	8350 3150 8350 3300
$Comp
L Connector:Conn_01x03_Male J12
U 1 1 607AD886
P 9650 2950
F 0 "J12" V 9712 3094 50  0000 L CNN
F 1 "Conn_01x03_Male" V 9900 3000 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 9650 2950 50  0001 C CNN
F 3 "~" H 9650 2950 50  0001 C CNN
	1    9650 2950
	0    1    1    0   
$EndComp
Wire Wire Line
	9550 3150 8650 3150
Connection ~ 8650 3150
Wire Wire Line
	9650 3150 9650 3700
Wire Wire Line
	9650 3700 9600 3700
Wire Wire Line
	9750 3150 10100 3150
Wire Wire Line
	10100 3150 10100 3100
$Comp
L power:+5V #PWR011
U 1 1 607BB163
P 10100 3100
F 0 "#PWR011" H 10100 2950 50  0001 C CNN
F 1 "+5V" H 10115 3273 50  0000 C CNN
F 2 "" H 10100 3100 50  0001 C CNN
F 3 "" H 10100 3100 50  0001 C CNN
	1    10100 3100
	1    0    0    -1  
$EndComp
Text Notes 9000 4300 0    50   ~ 0
PS/2 Keyboard. For 5V operation link\npins 1-2 and fit Zener diodes. For 3V3\noperation link pins 2-3 (Zener diodes\nare optional in this case)
Text GLabel 4550 2450 0    50   Input ~ 0
PIN48_SEC_VSYNC
Text GLabel 4550 2550 0    50   Input ~ 0
PIN47_SEC_HSYNC
Text GLabel 1300 1350 0    50   Input ~ 0
PIN53_PRI_VIDEO
Text GLabel 4500 1350 0    50   Input ~ 0
PIN52_SEC_VIDEO
NoConn ~ 9600 3600
NoConn ~ 9600 3800
$Comp
L Connector_Generic:Conn_02x08_Odd_Even PL?
U 1 1 60D96959
P 1550 3850
AR Path="/5FC877BB/60D96959" Ref="PL?"  Part="1" 
AR Path="/5FC85C78/60D96959" Ref="PL3"  Part="1" 
F 0 "PL3" H 1600 4367 50  0000 C CNN
F 1 "Conn_02x08_Odd_Even" H 1600 4276 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 1550 3850 50  0001 C CNN
F 3 "~" H 1550 3850 50  0001 C CNN
	1    1550 3850
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x08_Odd_Even J?
U 1 1 60D9695F
P 5000 3850
AR Path="/5FC877BB/60D9695F" Ref="J?"  Part="1" 
AR Path="/5FC85C78/60D9695F" Ref="PL2"  Part="1" 
F 0 "PL2" H 5050 4367 50  0000 C CNN
F 1 "Conn_02x08_Odd_Even" H 5050 4276 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 5000 3850 50  0001 C CNN
F 3 "~" H 5000 3850 50  0001 C CNN
	1    5000 3850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HCT244 U?
U 1 1 60D96965
P 2100 6600
AR Path="/5FC86EA5/60D96965" Ref="U?"  Part="1" 
AR Path="/5FC877BB/60D96965" Ref="U?"  Part="1" 
AR Path="/5FC85C78/60D96965" Ref="U8"  Part="1" 
F 0 "U8" H 2250 7350 50  0000 C CNN
F 1 "74HCT244" H 2400 7250 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 2100 6600 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT244.pdf" H 2100 6600 50  0001 C CNN
	1    2100 6600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2100 5700 2100 5800
$Comp
L power:GND #PWR?
U 1 1 60D9696D
P 2100 7500
AR Path="/5FC86EA5/60D9696D" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60D9696D" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D9696D" Ref="#PWR015"  Part="1" 
F 0 "#PWR015" H 2100 7250 50  0001 C CNN
F 1 "GND" H 2105 7327 50  0000 C CNN
F 2 "" H 2100 7500 50  0001 C CNN
F 3 "" H 2100 7500 50  0001 C CNN
	1    2100 7500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 7000 1600 7000
Wire Wire Line
	1600 7100 1450 7100
Wire Wire Line
	1450 7100 1450 7000
Wire Wire Line
	2600 6800 2850 6800
Text GLabel 2850 6800 2    50   Input ~ 0
D0_5V
Wire Wire Line
	1350 3550 950  3550
Text Label 950  3550 2    50   ~ 0
~KBDS0
Wire Wire Line
	1350 3650 950  3650
Text Label 950  3650 2    50   ~ 0
~KBDS1
Wire Wire Line
	1350 3750 950  3750
Text Label 950  3750 2    50   ~ 0
~KBDS2
Wire Wire Line
	1350 3850 950  3850
Text Label 950  3850 2    50   ~ 0
~KBDS3
Wire Wire Line
	1350 3950 950  3950
Text Label 950  3950 2    50   ~ 0
~KBDS4
Wire Wire Line
	1350 4050 950  4050
Text Label 950  4050 2    50   ~ 0
~KBDS5
Wire Wire Line
	1350 4150 950  4150
Text Label 950  4150 2    50   ~ 0
~KBDS6
Wire Wire Line
	1350 4250 950  4250
Text Label 950  4250 2    50   ~ 0
~KBDS7
Wire Wire Line
	1600 6800 1200 6800
Text Label 1200 6800 2    50   ~ 0
~KBDS0
Wire Wire Line
	1600 6400 1200 6400
Text Label 1200 6400 2    50   ~ 0
~KBDS1
Wire Wire Line
	1600 6300 1200 6300
Text Label 1200 6300 2    50   ~ 0
~KBDS2
Wire Wire Line
	1600 6700 1200 6700
Text Label 1200 6700 2    50   ~ 0
~KBDS3
Wire Wire Line
	1600 6600 1200 6600
Text Label 1200 6600 2    50   ~ 0
~KBDS4
Wire Wire Line
	1600 6200 1200 6200
Text Label 1200 6200 2    50   ~ 0
~KBDS5
Wire Wire Line
	1600 6500 1200 6500
Text Label 1200 6500 2    50   ~ 0
~KBDS6
Wire Wire Line
	1600 6100 1200 6100
Text Label 1200 6100 2    50   ~ 0
~KBDS7
Wire Wire Line
	2600 6400 2850 6400
Text GLabel 2850 6400 2    50   Input ~ 0
D1_5V
Wire Wire Line
	2600 6300 2850 6300
Text GLabel 2850 6300 2    50   Input ~ 0
D2_5V
Wire Wire Line
	2600 6700 2850 6700
Text GLabel 2850 6700 2    50   Input ~ 0
D3_5V
Wire Wire Line
	2600 6600 2850 6600
Text GLabel 2850 6600 2    50   Input ~ 0
D4_5V
Wire Wire Line
	2600 6200 2850 6200
Text GLabel 2850 6200 2    50   Input ~ 0
D5_5V
Wire Wire Line
	2600 6100 2850 6100
Text GLabel 2850 6100 2    50   Input ~ 0
D7_5V
Wire Wire Line
	2100 7400 2100 7500
Wire Wire Line
	1450 7000 1200 7000
Connection ~ 1450 7000
Text GLabel 1200 7000 0    50   Input ~ 0
PIN87_PORT0RD
$Comp
L power:GND #PWR?
U 1 1 60D969AA
P 1950 4300
AR Path="/5FC86EA5/60D969AA" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60D969AA" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D969AA" Ref="#PWR013"  Part="1" 
F 0 "#PWR013" H 1950 4050 50  0001 C CNN
F 1 "GND" H 1955 4127 50  0000 C CNN
F 2 "" H 1950 4300 50  0001 C CNN
F 3 "" H 1950 4300 50  0001 C CNN
	1    1950 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 4250 1950 4300
Wire Wire Line
	1850 4250 1950 4250
Wire Wire Line
	1850 3550 1950 3550
Wire Wire Line
	1950 3550 1950 3350
$Comp
L power:+5V #PWR?
U 1 1 60D969B4
P 2100 5700
AR Path="/5FC877BB/60D969B4" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D969B4" Ref="#PWR014"  Part="1" 
F 0 "#PWR014" H 2100 5550 50  0001 C CNN
F 1 "+5V" H 2115 5873 50  0000 C CNN
F 2 "" H 2100 5700 50  0001 C CNN
F 3 "" H 2100 5700 50  0001 C CNN
	1    2100 5700
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60D969BA
P 1950 3350
AR Path="/5FC877BB/60D969BA" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D969BA" Ref="#PWR012"  Part="1" 
F 0 "#PWR012" H 1950 3200 50  0001 C CNN
F 1 "+5V" H 1965 3523 50  0000 C CNN
F 2 "" H 1950 3350 50  0001 C CNN
F 3 "" H 1950 3350 50  0001 C CNN
	1    1950 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 3650 2150 3650
Text GLabel 2150 3650 2    50   Input ~ 0
PIN21_IN_NMI
Wire Wire Line
	1850 3950 2150 3950
Wire Wire Line
	1850 4050 2150 4050
Wire Wire Line
	1850 4150 2150 4150
Text GLabel 2150 3950 2    50   Input ~ 0
PIN144_RST
NoConn ~ 1850 3750
NoConn ~ 1850 3850
Text Notes 1950 3900 0    50   ~ 0
On the NASCOM, pins 6, 8 are connected to\nPORT0 output bits but are NC on the keyboard.
Text GLabel 2150 4050 2    50   Input ~ 0
~KBDCLK_5V
Text GLabel 2150 4150 2    50   Input ~ 0
~KBDRST_5V
Text Notes 1500 3250 0    50   ~ 0
"KBD"
Text Notes 4900 3250 0    50   ~ 0
"SERIAL"
Text Notes 4100 4750 0    50   ~ 0
This is only "sympathetic with" not "compatible with" the\nNASCOM serial connector. There are no 12V RS232 levels,\nonly 5V levels, and no audio/cassette interface.
NoConn ~ 5300 3850
$Comp
L power:GND #PWR?
U 1 1 60D969D1
P 4700 4300
AR Path="/5FC86EA5/60D969D1" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60D969D1" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D969D1" Ref="#PWR020"  Part="1" 
F 0 "#PWR020" H 4700 4050 50  0001 C CNN
F 1 "GND" H 4705 4127 50  0000 C CNN
F 2 "" H 4700 4300 50  0001 C CNN
F 3 "" H 4700 4300 50  0001 C CNN
	1    4700 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 4050 4700 4050
Wire Wire Line
	4700 4050 4700 4250
Wire Wire Line
	4800 4250 4700 4250
Connection ~ 4700 4250
Wire Wire Line
	4700 4250 4700 4300
Wire Wire Line
	5300 3550 5400 3550
Wire Wire Line
	5400 3550 5400 3350
$Comp
L power:+5V #PWR?
U 1 1 60D969DE
P 5400 3350
AR Path="/5FC877BB/60D969DE" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60D969DE" Ref="#PWR021"  Part="1" 
F 0 "#PWR021" H 5400 3200 50  0001 C CNN
F 1 "+5V" H 5415 3523 50  0000 C CNN
F 2 "" H 5400 3350 50  0001 C CNN
F 3 "" H 5400 3350 50  0001 C CNN
	1    5400 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 4050 5600 4050
Text GLabel 5600 4050 2    50   Input ~ 0
TX_5V
Text Notes 5750 3450 0    50   ~ 0
TX OUT, RX IN - both at 5V\nTODO: polarity..
Wire Wire Line
	4800 3650 4700 3650
Wire Wire Line
	4800 3950 4700 3950
Wire Wire Line
	4700 3950 4700 3650
Connection ~ 4700 3650
Wire Wire Line
	4700 3650 4400 3650
Text GLabel 4400 3650 0    50   Input ~ 0
RX_5V
NoConn ~ 5300 3950
NoConn ~ 4800 3850
NoConn ~ 5300 3750
Text GLabel 4400 3550 0    50   Input ~ 0
TAPE_DRIVE_5V
Wire Wire Line
	4800 3550 4400 3550
Wire Wire Line
	5300 3650 5600 3650
Text GLabel 5600 3650 2    50   Input ~ 0
TXBAUDCLK_5V
Wire Wire Line
	4800 3750 4400 3750
Text GLabel 4400 3750 0    50   Input ~ 0
RXBAUDCLK_5V
NoConn ~ 4800 4150
NoConn ~ 5300 4150
NoConn ~ 5300 4250
$Comp
L Connector_Generic:Conn_01x06 J19
U 1 1 602BDB1D
P 8850 1600
F 0 "J19" H 8930 1592 50  0000 L CNN
F 1 "Conn_01x06" H 8930 1501 50  0000 L CNN
F 2 "mylib:uSDcard_breakout_1x06_P2.54mm" H 8850 1600 50  0001 C CNN
F 3 "~" H 8850 1600 50  0001 C CNN
	1    8850 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 1900 8500 2050
Text Notes 8650 1300 0    50   ~ 0
uSDcard breakout board
Text GLabel 2850 6500 2    50   Input ~ 0
D6_5V
Wire Wire Line
	2600 6500 2850 6500
$Comp
L myLib:Mini-DIN_6pins_ver2 J13
U 1 1 604A5287
P 9300 3700
F 0 "J13" H 9300 4035 50  0000 C CNN
F 1 "Mini-DIN_6pins_ver2" H 9300 3944 50  0000 C CNN
F 2 "mylib:Connector_Mini-DIN_Female_6Pin_2rows" H 9300 3720 50  0001 C CNN
F 3 "" H 9300 3720 50  0000 C CNN
	1    9300 3700
	1    0    0    -1  
$EndComp
NoConn ~ 9300 3900
Wire Wire Line
	8350 3650 8350 3700
Wire Wire Line
	9000 3600 8800 3600
Wire Wire Line
	8800 3600 8800 3700
Wire Wire Line
	8800 3700 8350 3700
Connection ~ 8350 3700
Wire Wire Line
	8350 3700 8350 3800
Text Notes 7100 7000 0    98   ~ 20
Connectors: 2xVGA, 1xPS/2 keyboard, uSDcard,\nNASCOM Keyboard and Serial.
$EndSCHEMATC
