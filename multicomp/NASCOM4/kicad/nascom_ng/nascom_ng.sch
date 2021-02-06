EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title "NASCOM 4 - a NASCOM in an FPGA"
Date ""
Rev "PRE-A"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 9000 4650 2050 150 
U 5FC86EA5
F0 "nascom_ng_ram" 50
F1 "nascom_ng_ram.sch" 50
$EndSheet
$Sheet
S 9000 5050 2050 150 
U 5FC8753B
F0 "nascom_ng_pio" 50
F1 "nascom_ng_pio.sch" 50
$EndSheet
$Sheet
S 9000 5450 2050 150 
U 5FC87A4E
F0 "nascom_ng_fdc" 50
F1 "nascom_ng_fdc.sch" 50
$EndSheet
Text Notes 2950 3450 0    50   ~ 0
Footprint matches the physical\ntop view of the main board. The\nFPGA board is mounted upside\ndown and so this is a view through\nthe rear of the FPGA board.
$Comp
L myLib:Conn_02x14_Even_Odd J1
U 1 1 5FE8AA27
P 1750 3300
F 0 "J1" H 1800 2375 50  0000 C CNN
F 1 "Conn_02x14_Even_Odd" H 1800 2466 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 1750 3300 50  0001 C CNN
F 3 "~" H 1750 3300 50  0001 C CNN
	1    1750 3300
	-1   0    0    1   
$EndComp
Wire Wire Line
	1950 3900 2100 3900
Text GLabel 2100 3900 2    50   Input ~ 0
PIN41_SDCS
Wire Wire Line
	1950 3800 2100 3800
Text GLabel 2100 3800 2    50   Input ~ 0
PIN43_SDCLK
Wire Wire Line
	1950 3700 2100 3700
Text GLabel 2100 3700 2    50   Input ~ 0
PIN45_KDAT
Wire Wire Line
	1950 3600 2100 3600
Text GLabel 2100 3600 2    50   Input ~ 0
PIN48_SEC_VSYNC
Wire Wire Line
	1950 3500 2100 3500
Text GLabel 2100 3500 2    50   Input ~ 0
PIN52_SEC_VIDEO
Wire Wire Line
	1950 3400 2100 3400
Text GLabel 2100 3400 2    50   Input ~ 0
PIN55_PRI_HSYNC
Wire Wire Line
	1950 3300 2100 3300
Text GLabel 2100 3300 2    50   Input ~ 0
PIN58_GPIO5
Wire Wire Line
	1950 2800 2100 2800
Text GLabel 2100 2800 2    50   Input ~ 0
PIN72_GPIO0
Wire Wire Line
	1950 2900 2100 2900
Wire Wire Line
	1950 3000 2100 3000
Text GLabel 2100 3000 2    50   Input ~ 0
PIN67_GPIO1
Wire Wire Line
	1950 3100 2100 3100
Text GLabel 2100 3100 2    50   Input ~ 0
~PIN64_KBDRST
Wire Wire Line
	1950 3200 2100 3200
Text GLabel 2100 3200 2    50   Input ~ 0
PIN60_GPIO7
Wire Wire Line
	1450 2800 1300 2800
Text GLabel 1300 2800 0    50   Input ~ 0
PIN71_GPIO3
Wire Wire Line
	1450 2900 1300 2900
Text GLabel 1300 2900 0    50   Input ~ 0
PIN69_GPIO2
Wire Wire Line
	1450 3000 1300 3000
Text GLabel 1300 3000 0    50   Input ~ 0
PIN65_CTS
Wire Wire Line
	1450 3100 1300 3100
Text GLabel 1300 3100 0    50   Input ~ 0
~PIN63_KBDCLK
Wire Wire Line
	1450 3200 1300 3200
Text GLabel 1300 3200 0    50   Input ~ 0
PIN59_PORT0RD
Wire Wire Line
	1450 3300 1300 3300
Text GLabel 1300 3300 0    50   Input ~ 0
PIN57_GPIO4
Wire Wire Line
	1450 3400 1300 3400
Text GLabel 1300 3400 0    50   Input ~ 0
PIN53_PRI_VIDEO
Wire Wire Line
	1450 3500 1300 3500
Text GLabel 1300 3500 0    50   Input ~ 0
PIN51_PRI_VSYNC
Wire Wire Line
	1450 3600 1300 3600
Text GLabel 1300 3600 0    50   Input ~ 0
PIN47_SEC_HSYNC
$Comp
L myLib:Conn_02x14_Even_Odd J3
U 1 1 5FEA6F67
P 5550 3200
F 0 "J3" H 5600 4050 50  0000 C CNN
F 1 "Conn_02x14_Even_Odd" H 5600 3950 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 5550 3200 50  0001 C CNN
F 3 "~" H 5550 3200 50  0001 C CNN
	1    5550 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 2700 5200 2700
Wire Wire Line
	5350 2800 5200 2800
Text GLabel 5200 2800 0    50   Input ~ 0
PIN115_D1
Wire Wire Line
	5350 2900 5200 2900
Text GLabel 5200 2900 0    50   Input ~ 0
PIN119_D0
Wire Wire Line
	5350 3000 5200 3000
Text GLabel 5200 3000 0    50   Input ~ 0
PIN121_A0
Wire Wire Line
	5350 3100 5200 3100
Text GLabel 5200 3100 0    50   Input ~ 0
PIN125_A1
Wire Wire Line
	5350 3200 5200 3200
Text GLabel 5200 3200 0    50   Input ~ 0
PIN129_A2
Wire Wire Line
	5350 3300 5200 3300
Text GLabel 5200 3300 0    50   Input ~ 0
PIN133_A3
Wire Wire Line
	5350 3400 5200 3400
Text GLabel 5200 3400 0    50   Input ~ 0
PIN135_A4
Wire Wire Line
	5350 3500 5200 3500
Text GLabel 5200 3500 0    50   Input ~ 0
PIN137_A5
Wire Wire Line
	5350 3600 5200 3600
Text GLabel 5200 3600 0    50   Input ~ 0
PIN141_A6
Wire Wire Line
	5350 3700 5200 3700
Text GLabel 5200 3700 0    50   Input ~ 0
PIN143_A7
Wire Wire Line
	5850 2700 6000 2700
Text GLabel 6000 2700 2    50   Input ~ 0
PIN112_D3
Wire Wire Line
	5850 2800 6000 2800
Text GLabel 6000 2800 2    50   Input ~ 0
PIN114_D4
Wire Wire Line
	5850 2900 6000 2900
Text GLabel 6000 2900 2    50   Input ~ 0
PIN118_D5
Wire Wire Line
	5850 3000 6000 3000
Text GLabel 6000 3000 2    50   Input ~ 0
PIN120_D6
Wire Wire Line
	5850 3100 6000 3100
Text GLabel 6000 3100 2    50   Input ~ 0
PIN122_D7
Wire Wire Line
	5850 3200 6000 3200
Text GLabel 6000 3200 2    50   Input ~ 0
PIN126_CS1
Wire Wire Line
	5850 3300 6000 3300
Text GLabel 6000 3300 2    50   Input ~ 0
PIN132_A10
Wire Wire Line
	5850 3400 6000 3400
Text GLabel 6000 3400 2    50   Input ~ 0
PIN134_RD
Wire Wire Line
	5850 3500 6000 3500
Text GLabel 6000 3500 2    50   Input ~ 0
PIN136_A11
Wire Wire Line
	5850 3600 6000 3600
Text GLabel 6000 3600 2    50   Input ~ 0
PIN139_A9
Wire Wire Line
	5850 3700 6000 3700
Text GLabel 6000 3700 2    50   Input ~ 0
PIN142_A8
Wire Wire Line
	5850 3800 6000 3800
Text GLabel 6000 3800 2    50   Input ~ 0
PIN144_RST
$Comp
L myLib:Conn_02x14_Even_Odd J2
U 1 1 5FEAB151
P 3550 1850
F 0 "J2" V 3646 1062 50  0000 R CNN
F 1 "Conn_02x14_Even_Odd" V 3555 1062 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 3550 1850 50  0001 C CNN
F 3 "~" H 3550 1850 50  0001 C CNN
	1    3550 1850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4250 2050 4250 2200
Wire Wire Line
	4150 2050 4150 2100
Wire Wire Line
	4050 2050 4050 2200
Text GLabel 4050 2200 3    50   Input ~ 0
PIN103_TX
Wire Wire Line
	3950 2050 3950 2200
Text GLabel 3950 2200 3    50   Input ~ 0
PIN100_TX
Wire Wire Line
	3850 2050 3850 2200
Text GLabel 3850 2200 3    50   Input ~ 0
PIN97_RCLK
Wire Wire Line
	3750 2050 3750 2200
Text GLabel 3750 2200 3    50   Input ~ 0
PIN94_SDA
Wire Wire Line
	3650 2050 3650 2200
Text GLabel 3650 2200 3    50   Input ~ 0
PIN92_RIO
Wire Wire Line
	3550 2050 3550 2200
Text GLabel 3550 2200 3    50   Input ~ 0
PIN90_NCIN
Wire Wire Line
	3450 2050 3450 2200
Text GLabel 3450 2200 3    50   Input ~ 0
PIN88_NCIN
Wire Wire Line
	3350 2050 3350 2200
Text GLabel 3350 2200 3    50   Input ~ 0
PIN86_SCL
Wire Wire Line
	3250 2050 3250 2200
Wire Wire Line
	3150 2050 3150 2200
Wire Wire Line
	3050 2050 3050 2200
Text GLabel 3050 2200 3    50   Input ~ 0
PIN74_TVSYNCH
Wire Wire Line
	2950 2050 2950 2100
Wire Wire Line
	4250 1550 4250 1500
Wire Wire Line
	4150 1550 4150 1400
Text GLabel 4150 1400 1    50   Input ~ 0
PIN104_RTS
Wire Wire Line
	4050 1550 4050 1400
Wire Wire Line
	3950 1550 3950 1400
Text GLabel 3950 1400 1    50   Input ~ 0
PIN99_RX
Wire Wire Line
	3850 1550 3850 1400
Text GLabel 3850 1400 1    50   Input ~ 0
PIN96_RTS
Wire Wire Line
	3750 1550 3750 1400
Text GLabel 3750 1400 1    50   Input ~ 0
PIN93_RCERST
Wire Wire Line
	3650 1550 3650 1400
Text GLabel 3650 1400 1    50   Input ~ 0
PIN91_NCIN
Wire Wire Line
	3550 1550 3550 1400
Text GLabel 3550 1400 1    50   Input ~ 0
PIN89_NCIN
Wire Wire Line
	3450 1550 3450 1400
Text GLabel 3450 1400 1    50   Input ~ 0
PIN87_CTS
Wire Wire Line
	3350 1550 3350 1400
Wire Wire Line
	3250 1550 3250 1400
Text GLabel 3250 1400 1    50   Input ~ 0
PIN79_CS2
Wire Wire Line
	3150 1550 3150 1400
Text GLabel 3150 1400 1    50   Input ~ 0
PIN75_TVVID
Wire Wire Line
	3050 1550 3050 1400
Wire Wire Line
	2950 1550 2950 1500
$Comp
L myLib:Conn_02x14_Even_Odd J4
U 1 1 5FEB71A3
P 3650 4800
F 0 "J4" V 3654 5480 50  0000 L CNN
F 1 "Conn_02x14_Even_Odd" V 3745 5480 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 3650 4800 50  0001 C CNN
F 3 "~" H 3650 4800 50  0001 C CNN
	1    3650 4800
	0    1    1    0   
$EndComp
Wire Wire Line
	2950 4600 2950 4450
Wire Wire Line
	3050 4600 3050 4550
Wire Wire Line
	3150 4600 3150 4450
Text GLabel 3150 4450 1    50   Input ~ 0
PIN31_A17
Wire Wire Line
	3250 4600 3250 4450
Text GLabel 3250 4450 1    50   Input ~ 0
PIN28_A12
Wire Wire Line
	3450 4600 3450 4450
Wire Wire Line
	3550 4600 3550 4450
Text GLabel 3550 4450 1    50   Input ~ 0
PIN24_A13
Wire Wire Line
	3650 4600 3650 4450
Text GLabel 3650 4450 1    50   Input ~ 0
PIN21_IN_NMI
Wire Wire Line
	3750 4600 3750 4450
Wire Wire Line
	3850 4600 3850 4550
Wire Wire Line
	3950 4600 3950 4550
Wire Wire Line
	4050 4600 4050 4450
Text GLabel 4050 4450 1    50   Input ~ 0
PIN8_A15
Wire Wire Line
	4150 4600 4150 4450
Text GLabel 4150 4450 1    50   Input ~ 0
PIN4_WR
Wire Wire Line
	4250 4600 4250 4550
Wire Wire Line
	3050 5100 3050 5150
Wire Wire Line
	3150 5100 3150 5250
Text GLabel 3150 5250 3    50   Input ~ 0
PIN32_A18
Wire Wire Line
	3250 5100 3250 5250
Text GLabel 3250 5250 3    50   Input ~ 0
PIN30_A14
Wire Wire Line
	3450 5100 3450 5250
Wire Wire Line
	3550 5100 3550 5250
Text GLabel 3550 5250 3    50   Input ~ 0
PIN25_A16
Wire Wire Line
	3650 5100 3650 5250
Text GLabel 3650 5250 3    50   Input ~ 0
PIN22_NCIN
Wire Wire Line
	3750 5100 3750 5250
Text GLabel 3750 5250 3    50   Input ~ 0
PIN18_IN_WARMRST
Wire Wire Line
	3850 5100 3850 5150
Wire Wire Line
	3950 5100 3950 5250
Text GLabel 3950 5250 3    50   Input ~ 0
PIN9_HALT
Wire Wire Line
	4050 5100 4050 5250
Text GLabel 4050 5250 3    50   Input ~ 0
PIN7_TAPE_DRIVE
Wire Wire Line
	4150 5100 4150 5250
Text GLabel 4150 5250 3    50   Input ~ 0
PIN3_SDACTIVE
Wire Wire Line
	4250 5100 4250 5150
$Comp
L power:+3.3V #PWR0101
U 1 1 5FED8E2B
P 2250 2600
F 0 "#PWR0101" H 2250 2450 50  0001 C CNN
F 1 "+3.3V" H 2265 2773 50  0000 C CNN
F 2 "" H 2250 2600 50  0001 C CNN
F 3 "" H 2250 2600 50  0001 C CNN
	1    2250 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5FED9629
P 2450 2550
F 0 "#PWR0102" H 2450 2300 50  0001 C CNN
F 1 "GND" H 2455 2377 50  0000 C CNN
F 2 "" H 2450 2550 50  0001 C CNN
F 3 "" H 2450 2550 50  0001 C CNN
	1    2450 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 2600 2000 2600
Wire Wire Line
	2450 2550 2300 2550
Wire Wire Line
	2300 2550 2300 2700
Wire Wire Line
	1950 2700 2050 2700
Wire Wire Line
	1450 2600 1450 2300
Wire Wire Line
	1450 2300 2000 2300
Wire Wire Line
	2000 2300 2000 2600
Connection ~ 2000 2600
Wire Wire Line
	2000 2600 2250 2600
Wire Wire Line
	1450 2700 1400 2700
Wire Wire Line
	1400 2700 1400 2250
Wire Wire Line
	1400 2250 2050 2250
Wire Wire Line
	2050 2250 2050 2700
Connection ~ 2050 2700
Wire Wire Line
	2050 2700 2300 2700
Wire Wire Line
	1450 3700 1300 3700
Text GLabel 1300 3700 0    50   Input ~ 0
PIN44_KCLK
Wire Wire Line
	1450 3800 1300 3800
Text GLabel 1300 3800 0    50   Input ~ 0
PIN42_SDDI
Wire Wire Line
	1450 3900 1300 3900
Text GLabel 1300 3900 0    50   Input ~ 0
PIN40_SDDO
Text GLabel 5200 2700 0    50   Input ~ 0
PIN113_D2
Wire Wire Line
	5850 2600 5900 2600
Wire Wire Line
	5350 2600 5300 2600
Wire Wire Line
	5850 3900 5900 3900
Wire Wire Line
	5900 3900 5900 4050
Wire Wire Line
	5350 3800 5300 3800
Wire Wire Line
	5300 3800 5300 4050
Wire Wire Line
	5300 4050 5900 4050
Wire Wire Line
	4600 3900 4600 3850
$Comp
L power:+3.3V #PWR0103
U 1 1 600B6B45
P 4600 3850
F 0 "#PWR0103" H 4600 3700 50  0001 C CNN
F 1 "+3.3V" H 4615 4023 50  0000 C CNN
F 2 "" H 4600 3850 50  0001 C CNN
F 3 "" H 4600 3850 50  0001 C CNN
	1    4600 3850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2950 1500 4250 1500
Wire Wire Line
	2950 2100 2800 2100
Wire Wire Line
	2800 2100 2800 1500
Wire Wire Line
	2800 1500 2950 1500
Connection ~ 2950 1500
Wire Wire Line
	2950 2100 4150 2100
Connection ~ 2950 2100
$Comp
L power:+3.3V #PWR0104
U 1 1 600DF161
P 4400 2200
F 0 "#PWR0104" H 4400 2050 50  0001 C CNN
F 1 "+3.3V" H 4415 2373 50  0000 C CNN
F 2 "" H 4400 2200 50  0001 C CNN
F 3 "" H 4400 2200 50  0001 C CNN
	1    4400 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 2200 4400 2200
Wire Wire Line
	5300 2600 5300 3800
Connection ~ 5300 3800
Wire Wire Line
	5900 3900 5900 2600
Connection ~ 5900 3900
$Comp
L power:GND #PWR0105
U 1 1 600FCF89
P 5900 4050
F 0 "#PWR0105" H 5900 3800 50  0001 C CNN
F 1 "GND" H 5905 3877 50  0000 C CNN
F 2 "" H 5900 4050 50  0001 C CNN
F 3 "" H 5900 4050 50  0001 C CNN
	1    5900 4050
	1    0    0    -1  
$EndComp
Connection ~ 5900 4050
$Comp
L power:GND #PWR0106
U 1 1 6010386E
P 2800 2100
F 0 "#PWR0106" H 2800 1850 50  0001 C CNN
F 1 "GND" H 2805 1927 50  0000 C CNN
F 2 "" H 2800 2100 50  0001 C CNN
F 3 "" H 2800 2100 50  0001 C CNN
	1    2800 2100
	1    0    0    -1  
$EndComp
Connection ~ 2800 2100
Wire Wire Line
	4250 4550 3950 4550
Wire Wire Line
	3050 4550 2800 4550
Wire Wire Line
	2800 4550 2800 5150
Wire Wire Line
	2800 5150 3050 5150
Connection ~ 3050 4550
Wire Wire Line
	3050 5150 3850 5150
Connection ~ 3050 5150
$Comp
L power:GND #PWR0107
U 1 1 6011C46C
P 2800 5150
F 0 "#PWR0107" H 2800 4900 50  0001 C CNN
F 1 "GND" H 2805 4977 50  0000 C CNN
F 2 "" H 2800 5150 50  0001 C CNN
F 3 "" H 2800 5150 50  0001 C CNN
	1    2800 5150
	1    0    0    -1  
$EndComp
Connection ~ 2800 5150
Connection ~ 3950 4550
Wire Wire Line
	3950 4550 3850 4550
Connection ~ 3850 4550
Wire Wire Line
	3850 4550 3050 4550
$Comp
L power:+3.3V #PWR0108
U 1 1 6012D58F
P 2950 4100
F 0 "#PWR0108" H 2950 3950 50  0001 C CNN
F 1 "+3.3V" H 2965 4273 50  0000 C CNN
F 2 "" H 2950 4100 50  0001 C CNN
F 3 "" H 2950 4100 50  0001 C CNN
	1    2950 4100
	1    0    0    -1  
$EndComp
Connection ~ 3850 5150
Wire Wire Line
	3850 5150 4250 5150
NoConn ~ 3350 4600
NoConn ~ 3350 5100
Wire Wire Line
	2950 5450 2650 5450
Wire Wire Line
	2650 5450 2650 4450
Wire Wire Line
	2650 4450 2950 4450
Wire Wire Line
	2950 5100 2950 5450
Connection ~ 2950 4450
Wire Wire Line
	2950 4450 2950 4100
Wire Notes Line
	6600 1000 6600 6350
Wire Notes Line
	6600 6350 650  6350
Wire Notes Line
	650  6350 650  1000
Wire Notes Line
	650  1000 6600 1000
Wire Notes Line
	4450 5450 6100 5450
Wire Notes Line
	6100 5450 6100 5850
Wire Notes Line
	6100 5800 4450 5800
Wire Notes Line
	4450 5850 4450 5450
Wire Notes Line
	4450 5950 6100 5950
Wire Notes Line
	6100 5950 6100 6300
Wire Notes Line
	6100 6300 4450 6300
Wire Notes Line
	4450 6300 4450 6000
Wire Notes Line
	750  5700 1550 5700
Wire Notes Line
	1550 5700 1550 6200
Wire Notes Line
	1550 6200 750  6200
Wire Notes Line
	750  6200 750  5700
Text Notes 5050 6200 0    50   ~ 0
AS Socket
Text Notes 5100 5700 0    50   ~ 0
JTAG socket\n
Text Notes 1000 6100 0    50   ~ 0
Barrel\nPower\nConnector
$Comp
L Device:LED D1
U 1 1 601B7AD7
P 9200 1000
F 0 "D1" H 9193 1217 50  0000 C CNN
F 1 "LED" H 9193 1126 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1000 50  0001 C CNN
F 3 "~" H 9200 1000 50  0001 C CNN
	1    9200 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 601B83BC
P 9200 1350
F 0 "D2" H 9193 1567 50  0000 C CNN
F 1 "LED" H 9193 1476 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1350 50  0001 C CNN
F 3 "~" H 9200 1350 50  0001 C CNN
	1    9200 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D3
U 1 1 601B8BB6
P 9200 1650
F 0 "D3" H 9193 1867 50  0000 C CNN
F 1 "LED" H 9193 1776 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1650 50  0001 C CNN
F 3 "~" H 9200 1650 50  0001 C CNN
	1    9200 1650
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 601B953B
P 8650 1000
F 0 "R9" V 8550 1000 50  0000 C CNN
F 1 "220R" V 8650 1000 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1000 50  0001 C CNN
F 3 "~" H 8650 1000 50  0001 C CNN
	1    8650 1000
	0    1    1    0   
$EndComp
$Comp
L Device:R R10
U 1 1 601C43BA
P 8650 1350
F 0 "R10" V 8550 1350 50  0000 C CNN
F 1 "220R" V 8650 1350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1350 50  0001 C CNN
F 3 "~" H 8650 1350 50  0001 C CNN
	1    8650 1350
	0    1    1    0   
$EndComp
$Comp
L Device:R R11
U 1 1 601C485F
P 8650 1650
F 0 "R11" V 8550 1650 50  0000 C CNN
F 1 "220R" V 8650 1650 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1650 50  0001 C CNN
F 3 "~" H 8650 1650 50  0001 C CNN
	1    8650 1650
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 1000 9050 1000
Wire Wire Line
	8800 1350 9050 1350
Wire Wire Line
	8800 1650 9050 1650
Wire Wire Line
	9350 1650 9750 1650
Wire Wire Line
	9750 1650 9750 1350
$Comp
L power:+3.3V #PWR0121
U 1 1 601DC5D7
P 9750 800
F 0 "#PWR0121" H 9750 650 50  0001 C CNN
F 1 "+3.3V" H 9765 973 50  0000 C CNN
F 2 "" H 9750 800 50  0001 C CNN
F 3 "" H 9750 800 50  0001 C CNN
	1    9750 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 1000 9750 1000
Connection ~ 9750 1000
Wire Wire Line
	9750 1000 9750 850 
Wire Wire Line
	9350 1350 9750 1350
Connection ~ 9750 1350
Wire Wire Line
	9750 1350 9750 1000
Text GLabel 8200 1000 0    50   Input ~ 0
PIN3_SDACTIVE
Wire Wire Line
	8200 1000 8500 1000
Text GLabel 8200 1350 0    50   Input ~ 0
PIN7_TAPE_DRIVE
Wire Wire Line
	8200 1350 8500 1350
Text GLabel 8200 1650 0    50   Input ~ 0
PIN9_HALT
Wire Wire Line
	8200 1650 8500 1650
Text Notes 800  4650 0    50   ~ 0
There are 7 input-only pins; none are used\non MULTICOMP. Named PINxx_IN_XXX here.\nPins 18 21 22 88 89 90 91\n
$Sheet
S 9000 5850 2050 150 
U 5FC85C78
F0 "nascom_ng_connectors" 50
F1 "nascom_ng_connectors.sch" 50
$EndSheet
Text Notes 10050 2750 0    50   ~ 0
"COLD RESET" This duplicates\nthe push-button on the\nFPGA board pin 144.
Text GLabel 4050 1400 1    50   Input ~ 0
PIN101_RX
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 60368851
P 9400 800
F 0 "#FLG0101" H 9400 875 50  0001 C CNN
F 1 "PWR_FLAG" H 9400 973 50  0000 C CNN
F 2 "" H 9400 800 50  0001 C CNN
F 3 "~" H 9400 800 50  0001 C CNN
	1    9400 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	9400 800  9400 850 
Wire Wire Line
	9400 850  9750 850 
Connection ~ 9750 850 
Wire Wire Line
	9750 850  9750 800 
$Comp
L power:PWR_FLAG #FLG0103
U 1 1 603811AC
P 10200 800
F 0 "#FLG0103" H 10200 875 50  0001 C CNN
F 1 "PWR_FLAG" H 10200 973 50  0000 C CNN
F 2 "" H 10200 800 50  0001 C CNN
F 3 "~" H 10200 800 50  0001 C CNN
	1    10200 800 
	1    0    0    -1  
$EndComp
Wire Wire Line
	10200 800  10200 900 
Wire Wire Line
	10200 900  10550 900 
Wire Wire Line
	10550 900  10550 800 
$Comp
L power:+5V #PWR0127
U 1 1 6038908C
P 10550 800
F 0 "#PWR0127" H 10550 650 50  0001 C CNN
F 1 "+5V" H 10565 973 50  0000 C CNN
F 2 "" H 10550 800 50  0001 C CNN
F 3 "" H 10550 800 50  0001 C CNN
	1    10550 800 
	1    0    0    -1  
$EndComp
Text GLabel 7700 4700 2    50   Input ~ 0
~PIN22_IN_READY
Wire Wire Line
	7500 4700 7700 4700
Text GLabel 7500 4700 0    50   Input ~ 0
PIN22_NCIN
Text GLabel 7700 4800 2    50   Input ~ 0
PIN90_IN_DRQ
Wire Wire Line
	7500 4800 7700 4800
Text GLabel 7500 4800 0    50   Input ~ 0
PIN90_NCIN
Text GLabel 7700 4900 2    50   Input ~ 0
PIN91_IN_INTRQ
Wire Wire Line
	7500 4900 7700 4900
Text GLabel 7500 4900 0    50   Input ~ 0
PIN91_NCIN
Text GLabel 7700 5000 2    50   Input ~ 0
~PIN57_INT
Wire Wire Line
	7500 5000 7700 5000
Text GLabel 7500 5000 0    50   Input ~ 0
PIN57_GPIO4
Text GLabel 7700 5500 2    50   Input ~ 0
~PIN42_RD
Wire Wire Line
	7500 5100 7700 5100
Text GLabel 7500 5100 0    50   Input ~ 0
PIN69_GPIO2
Text GLabel 7700 5600 2    50   Input ~ 0
~PIN40_WR
Wire Wire Line
	7500 5200 7700 5200
Text GLabel 7500 5200 0    50   Input ~ 0
PIN72_GPIO0
Text GLabel 7700 5300 2    50   Input ~ 0
~PIN47_M1
Wire Wire Line
	7500 5300 7700 5300
Text GLabel 7500 5300 0    50   Input ~ 0
PIN65_CTS
Text GLabel 7700 5400 2    50   Input ~ 0
~PIN86_IORQ
Wire Wire Line
	7500 5400 7700 5400
Text GLabel 7500 5400 0    50   Input ~ 0
PIN86_SCL
Text GLabel 7700 5100 2    50   Input ~ 0
PIN53_CLK4
Wire Wire Line
	7500 5500 7700 5500
Text GLabel 7500 5500 0    50   Input ~ 0
PIN93_RCERST
Text GLabel 7700 5200 2    50   Input ~ 0
PIN51_CLK1
Wire Wire Line
	7500 5600 7700 5600
Text GLabel 7500 5600 0    50   Input ~ 0
PIN92_RIO
Text GLabel 7700 6100 2    50   Input ~ 0
~PIN48_PIO_CS
Wire Wire Line
	7500 5700 7700 5700
Text GLabel 7500 5700 0    50   Input ~ 0
PIN60_GPIO7
Text GLabel 7700 6200 2    50   Input ~ 0
~PIN87_FDC_CS
Wire Wire Line
	7500 5800 7700 5800
Text GLabel 7500 5800 0    50   Input ~ 0
PIN58_GPIO5
Text GLabel 7700 5900 2    50   Input ~ 0
~PIN55_CTC_CS
Wire Wire Line
	7500 5900 7700 5900
Text GLabel 7500 5900 0    50   Input ~ 0
PIN71_GPIO3
Text GLabel 7700 6000 2    50   Input ~ 0
PIN52_RXBAUDCLK
Wire Wire Line
	7500 6000 7700 6000
Text GLabel 7500 6000 0    50   Input ~ 0
PIN67_GPIO1
Text GLabel 7700 5700 2    50   Input ~ 0
PIN60_TXBAUDCLK
Wire Wire Line
	7500 6100 7700 6100
Text GLabel 7500 6100 0    50   Input ~ 0
PIN70_VDUFFD0
Text GLabel 7700 5800 2    50   Input ~ 0
PIN58_PORTE4_WR
Wire Wire Line
	7500 6200 7700 6200
Text GLabel 7500 6200 0    50   Input ~ 0
PIN87_CTS
Text GLabel 7700 6300 2    50   Input ~ 0
~PIN43_IO_RESET
Wire Wire Line
	7500 6300 7700 6300
Text GLabel 7500 6300 0    50   Input ~ 0
PIN94_SDA
Wire Wire Line
	4650 7200 4850 7200
Text GLabel 4650 7200 0    50   Input ~ 0
PIN97_RCLK
Wire Wire Line
	4650 7300 4850 7300
Text GLabel 4650 7300 0    50   Input ~ 0
PIN75_TVVID
Text GLabel 7700 6400 2    50   Input ~ 0
PIN96_IOBUFWR
Wire Wire Line
	7500 6400 7700 6400
Text GLabel 7500 6400 0    50   Input ~ 0
PIN96_RTS
Wire Wire Line
	4650 7000 4850 7000
Text GLabel 4650 7000 0    50   Input ~ 0
PIN100_TX
Wire Wire Line
	4650 7100 4850 7100
Text GLabel 4650 7100 0    50   Input ~ 0
PIN99_RX
Text GLabel 7700 6500 2    50   Input ~ 0
~PIN104_IOBUFOE
Wire Wire Line
	7500 6500 7700 6500
Text GLabel 7500 6500 0    50   Input ~ 0
PIN104_RTS
Wire Wire Line
	4650 6900 4850 6900
Text GLabel 4650 6900 0    50   Input ~ 0
PIN74_TVSYNCH
Text Notes 1700 6750 0    50   ~ 0
TODO: ADD SERIES RESISTOR (0ohm) FOR CLK4 AND CLK1\nTODO: level shift for KBD CLK and KBD RST and FDC RDY,\nFDC DRQ,  FDC INT.\nTODO: gating of side select from FDC to imitate NASCOM FDC
Text Notes 3800 4400 1    50   ~ 0
PIN17_CLK50
NoConn ~ 3750 4450
Text Notes 3500 5700 1    50   ~ 0
PIN27_PWR
NoConn ~ 3450 5250
Text Notes 3500 4400 1    50   ~ 0
PIN26_PWR
NoConn ~ 3450 4450
Text Notes 3400 1350 1    50   ~ 0
PIN81_PWR
NoConn ~ 3350 1400
Text Notes 3100 1350 1    50   ~ 0
PIN73_RC_RESET
NoConn ~ 3050 1400
Text Notes 3200 2700 1    50   ~ 0
PIN76_JTAG
Text Notes 3300 2700 1    50   ~ 0
PIN80_PWR
NoConn ~ 3150 2200
NoConn ~ 3250 2200
$Sheet
S 9000 6250 2050 150 
U 62588EF4
F0 "nascom_ng_fdc2" 50
F1 "nascom_ng_fdc2.sch" 50
$EndSheet
$Comp
L Device:LED D7
U 1 1 6000B7F6
P 9200 1950
F 0 "D7" H 9193 2167 50  0000 C CNN
F 1 "LED" H 9193 2076 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1950 50  0001 C CNN
F 3 "~" H 9200 1950 50  0001 C CNN
	1    9200 1950
	1    0    0    -1  
$EndComp
$Comp
L Device:R R25
U 1 1 6000B7FC
P 8650 1950
F 0 "R25" V 8550 1950 50  0000 C CNN
F 1 "220R" V 8650 1950 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1950 50  0001 C CNN
F 3 "~" H 8650 1950 50  0001 C CNN
	1    8650 1950
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 1950 9050 1950
Wire Wire Line
	9350 1950 9750 1950
Wire Wire Line
	9750 1950 9750 1650
Wire Wire Line
	8200 1950 8500 1950
$Comp
L power:GND #PWR041
U 1 1 6002A46E
P 8200 1950
F 0 "#PWR041" H 8200 1700 50  0001 C CNN
F 1 "GND" H 8205 1777 50  0000 C CNN
F 2 "" H 8200 1950 50  0001 C CNN
F 3 "" H 8200 1950 50  0001 C CNN
	1    8200 1950
	-1   0    0    -1  
$EndComp
Text Notes 7150 750  0    50   ~ 0
These duplicate the 4 LEDs on the FPGA board,\nwhich are also on pins 3, 7, 9 and 3V3 power.
Text Notes 1650 1500 0    50   ~ 0
PIN73 is connected to an RC\nnetwork on the FPGA board\nand could be used for\npower-on reset
Text Notes 4800 1300 0    50   ~ 0
FPGA board mounts face-down. It overhangs\nthe edge of the main board in order to give\naccess to the programming headers.
Wire Notes Line
	550  5250 6700 5250
Wire Notes Line
	6250 5550 6250 5800
Wire Notes Line
	6250 5800 6350 5800
Wire Notes Line
	6350 5800 6350 5550
Wire Notes Line
	6350 5550 6250 5550
Text Notes 6350 5800 1    50   ~ 0
RESET
Wire Notes Line
	6250 5300 6400 5300
Wire Notes Line
	6400 5300 6400 5400
Wire Notes Line
	6400 5400 6250 5400
Wire Notes Line
	6250 5400 6250 5300
Text Notes 6250 5400 0    50   ~ 0
LED
Wire Notes Line
	6250 4900 6400 4900
Wire Notes Line
	6400 4900 6400 5000
Wire Notes Line
	6400 5000 6250 5000
Wire Notes Line
	6250 5000 6250 4900
Text Notes 6250 5000 0    50   ~ 0
LED
Wire Notes Line
	6250 5100 6400 5100
Wire Notes Line
	6400 5100 6400 5200
Wire Notes Line
	6400 5200 6250 5200
Wire Notes Line
	6250 5200 6250 5100
Text Notes 6250 5200 0    50   ~ 0
LED
Wire Notes Line
	2100 6200 2250 6200
Wire Notes Line
	2250 6200 2250 6300
Wire Notes Line
	2250 6300 2100 6300
Wire Notes Line
	2100 6300 2100 6200
Text Notes 2100 6300 0    50   ~ 0
LED
Text Notes 1150 5250 0    50   ~ 0
overhang
$Comp
L Mechanical:MountingHole H1
U 1 1 5FFC648B
P 9450 3650
F 0 "H1" H 9550 3696 50  0000 L CNN
F 1 "MountingHole" H 9550 3605 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 9450 3650 50  0001 C CNN
F 3 "~" H 9450 3650 50  0001 C CNN
	1    9450 3650
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5FFCCBD7
P 9450 4350
F 0 "H2" H 9550 4396 50  0000 L CNN
F 1 "MountingHole" H 9550 4305 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 9450 4350 50  0001 C CNN
F 3 "~" H 9450 4350 50  0001 C CNN
	1    9450 4350
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 5FFCD074
P 10300 3650
F 0 "H3" H 10400 3696 50  0000 L CNN
F 1 "MountingHole" H 10400 3605 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 10300 3650 50  0001 C CNN
F 3 "~" H 10300 3650 50  0001 C CNN
	1    10300 3650
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 5FFCD593
P 10300 4350
F 0 "H4" H 10400 4396 50  0000 L CNN
F 1 "MountingHole" H 10400 4305 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 10300 4350 50  0001 C CNN
F 3 "~" H 10300 4350 50  0001 C CNN
	1    10300 4350
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 60371398
P 7550 2550
F 0 "#FLG0102" H 7550 2625 50  0001 C CNN
F 1 "PWR_FLAG" H 7550 2723 50  0000 C CNN
F 2 "" H 7550 2550 50  0001 C CNN
F 3 "~" H 7550 2550 50  0001 C CNN
	1    7550 2550
	1    0    0    -1  
$EndComp
Text GLabel 9150 2550 2    50   Input ~ 0
PIN144_RST
Wire Wire Line
	9150 2550 8850 2550
Wire Wire Line
	8450 2550 7550 2550
Connection ~ 7550 2550
Connection ~ 7550 3350
Wire Wire Line
	8450 3350 7550 3350
Wire Wire Line
	7550 2950 7550 3350
Connection ~ 7550 2950
Wire Wire Line
	8450 2950 7550 2950
$Comp
L power:GND #PWR0122
U 1 1 60252982
P 7550 3600
F 0 "#PWR0122" H 7550 3350 50  0001 C CNN
F 1 "GND" H 7555 3427 50  0000 C CNN
F 2 "" H 7550 3600 50  0001 C CNN
F 3 "" H 7550 3600 50  0001 C CNN
	1    7550 3600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7550 2550 7550 2950
Wire Wire Line
	9150 3350 8850 3350
Text GLabel 9150 3350 2    50   Input ~ 0
PIN21_IN_NMI
Wire Wire Line
	9150 2950 8850 2950
Text GLabel 9150 2950 2    50   Input ~ 0
PIN18_IN_WARMRST
Text Notes 10050 3400 0    50   ~ 0
\n\n\n\n\n"NMI"
Text Notes 10050 3000 0    50   ~ 0
"WARM RESET"
Wire Wire Line
	5350 3900 4600 3900
$Comp
L Connector_Generic:Conn_02x08_Odd_Even PL?
U 1 1 601658F1
P 5050 7200
AR Path="/5FC877BB/601658F1" Ref="PL?"  Part="1" 
AR Path="/5FC85C78/601658F1" Ref="PL?"  Part="1" 
AR Path="/601658F1" Ref="J14"  Part="1" 
F 0 "J14" H 5100 7717 50  0000 C CNN
F 1 "Conn_02x08_Odd_Even" H 5100 7626 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 5050 7200 50  0001 C CNN
F 3 "~" H 5050 7200 50  0001 C CNN
	1    5050 7200
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 60165907
P 4700 7600
AR Path="/5FC877BB/60165907" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/60165907" Ref="#PWR?"  Part="1" 
AR Path="/60165907" Ref="#PWR0132"  Part="1" 
F 0 "#PWR0132" H 4700 7450 50  0001 C CNN
F 1 "+5V" V 4700 7800 50  0000 C CNN
F 2 "" H 4700 7600 50  0001 C CNN
F 3 "" H 4700 7600 50  0001 C CNN
	1    4700 7600
	0    -1   -1   0   
$EndComp
Text Notes 4250 6650 0    50   ~ 0
SPARES/DEBUG/EXPANSION
$Comp
L power:GND #PWR0133
U 1 1 601C9647
P 5500 7600
F 0 "#PWR0133" H 5500 7350 50  0001 C CNN
F 1 "GND" H 5505 7427 50  0000 C CNN
F 2 "" H 5500 7600 50  0001 C CNN
F 3 "" H 5500 7600 50  0001 C CNN
	1    5500 7600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 6900 5500 6900
Wire Wire Line
	5500 6900 5500 7000
Wire Wire Line
	5350 7300 5500 7300
Connection ~ 5500 7300
Wire Wire Line
	5350 7200 5500 7200
Connection ~ 5500 7200
Wire Wire Line
	5500 7200 5500 7300
Wire Wire Line
	5350 7100 5500 7100
Connection ~ 5500 7100
Wire Wire Line
	5500 7100 5500 7200
Wire Wire Line
	5350 7000 5500 7000
Connection ~ 5500 7000
Wire Wire Line
	5500 7000 5500 7100
Wire Wire Line
	4700 7600 4850 7600
$Comp
L power:+3.3V #PWR0138
U 1 1 6024C2C3
P 4700 7400
F 0 "#PWR0138" H 4700 7250 50  0001 C CNN
F 1 "+3.3V" V 4700 7650 50  0000 C CNN
F 2 "" H 4700 7400 50  0001 C CNN
F 3 "" H 4700 7400 50  0001 C CNN
	1    4700 7400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4850 7500 4800 7500
Wire Wire Line
	4800 7500 4800 7400
Wire Wire Line
	4800 7400 4850 7400
Wire Wire Line
	4800 7400 4700 7400
Connection ~ 4800 7400
Wire Wire Line
	5500 7300 5500 7600
NoConn ~ 5350 7400
NoConn ~ 5350 7500
NoConn ~ 5350 7600
$Comp
L Switch:SW_Push SW1
U 1 1 60158A7D
P 8650 2550
F 0 "SW1" H 8650 2835 50  0000 C CNN
F 1 "SW_Push" H 8650 2744 50  0000 C CNN
F 2 "mylib:MOMENTARY_TACTILE_RT_ANGLE" H 8650 2750 50  0001 C CNN
F 3 "~" H 8650 2750 50  0001 C CNN
	1    8650 2550
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW2
U 1 1 6015E3B1
P 8650 2950
F 0 "SW2" H 8650 3235 50  0000 C CNN
F 1 "SW_Push" H 8650 3144 50  0000 C CNN
F 2 "mylib:MOMENTARY_TACTILE_RT_ANGLE" H 8650 3150 50  0001 C CNN
F 3 "~" H 8650 3150 50  0001 C CNN
	1    8650 2950
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW3
U 1 1 6015E8F2
P 8650 3350
F 0 "SW3" H 8650 3635 50  0000 C CNN
F 1 "SW_Push" H 8650 3544 50  0000 C CNN
F 2 "mylib:MOMENTARY_TACTILE_RT_ANGLE" H 8650 3550 50  0001 C CNN
F 3 "~" H 8650 3550 50  0001 C CNN
	1    8650 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 3350 7550 3600
Text GLabel 7450 4150 0    50   Input ~ 0
PIN89_NCIN
Text GLabel 7450 4250 0    50   Input ~ 0
PIN88_NCIN
Wire Wire Line
	7450 4150 7700 4150
Wire Wire Line
	7450 4250 7700 4250
NoConn ~ 7700 4150
NoConn ~ 7700 4250
Wire Notes Line
	9450 3650 10300 3650
Wire Notes Line
	10300 3650 10300 4350
Wire Notes Line
	10300 4350 9450 4350
Wire Notes Line
	9450 4350 9450 3650
Wire Notes Line
	9350 3550 10400 3550
Wire Notes Line
	10400 3550 10400 4450
Wire Notes Line
	10400 4450 9350 4450
Wire Notes Line
	9350 4450 9350 3550
Text Notes 7250 4050 0    50   ~ 0
Currently unused
Text Notes 7150 6950 0    98   ~ 20
FPGA daughter-card connection,\nLEDs and buttons, debug connector.
Text Notes 9500 4150 0    50   ~ 0
PCB:\n170mm x 145mm\nHole centres:\n160mmx135mm
Wire Notes Line
	10100 3800 10100 4150
Wire Notes Line
	10500 4150 10500 3800
Wire Notes Line
	10100 3800 10500 3800
Wire Notes Line
	10100 4150 10500 4150
Text Notes 10200 4050 0    50   ~ 0
FPGA\ncard
Text GLabel 2100 2900 2    50   Input ~ 0
PIN70_VDUFFD0
Text Notes 7150 4600 0    50   ~ 0
need to rename pins on RHS
$EndSCHEMATC
