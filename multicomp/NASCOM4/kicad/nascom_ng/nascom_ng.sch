EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title "NASCOM 4 - a NASCOM in an FPGA"
Date "14-Feb-2021"
Rev "A"
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
Text Notes 2850 2950 0    50   ~ 0
Footprint matches the physical\ntop view of the main board. The\nFPGA board is mounted upside\ndown and so this is a view through\nthe rear of the FPGA board.
Wire Wire Line
	4000 5200 4000 5050
Text GLabel 4000 5050 1    50   Input ~ 0
PIN41_SDCS
Wire Wire Line
	3900 5200 3900 5050
Text GLabel 3900 5050 1    50   Input ~ 0
PIN43_SDCLK
Wire Wire Line
	3800 5200 3800 5050
Text GLabel 3800 5050 1    50   Input ~ 0
PIN45_KDAT
Wire Wire Line
	3700 5200 3700 5050
Text GLabel 3700 5050 1    50   Input ~ 0
PIN48_SEC_VSYNC
Wire Wire Line
	3600 5200 3600 5050
Text GLabel 3600 5050 1    50   Input ~ 0
PIN52_SEC_VIDEO
Wire Wire Line
	3500 5200 3500 5050
Text GLabel 3500 5050 1    50   Input ~ 0
PIN55_PRI_HSYNC
Wire Wire Line
	3400 5200 3400 5050
Wire Wire Line
	2900 5200 2900 5050
Text GLabel 2900 5050 1    50   Input ~ 0
~PIN72_IO_RESET
Wire Wire Line
	3000 5200 3000 5050
Wire Wire Line
	3100 5200 3100 5050
Text GLabel 3100 5050 1    50   Input ~ 0
PIN67_CLK1
Wire Wire Line
	3200 5200 3200 5050
Text GLabel 3200 5050 1    50   Input ~ 0
~PIN64_FDC_CS
Wire Wire Line
	3300 5200 3300 5050
Text GLabel 3300 5050 1    50   Input ~ 0
~PIN60_WR
Wire Wire Line
	2900 5700 2900 5850
Wire Wire Line
	3000 5700 3000 5850
Text GLabel 3000 5850 3    50   Input ~ 0
PIN69_CLK4
Wire Wire Line
	3100 5700 3100 5850
Wire Wire Line
	3200 5700 3200 5850
Text GLabel 3200 5850 3    50   Input ~ 0
~PIN63_IORQ
Wire Wire Line
	3300 5700 3300 5850
Text GLabel 3300 5850 3    50   Input ~ 0
~PIN59_RD
Wire Wire Line
	3400 5700 3400 5850
Text GLabel 3400 5850 3    50   Input ~ 0
~PIN57_M1
Wire Wire Line
	3500 5700 3500 5850
Text GLabel 3500 5850 3    50   Input ~ 0
PIN53_PRI_VIDEO
Wire Wire Line
	3600 5700 3600 5850
Text GLabel 3600 5850 3    50   Input ~ 0
PIN51_PRI_VSYNC
Wire Wire Line
	3700 5700 3700 5850
Text GLabel 3700 5850 3    50   Input ~ 0
PIN47_SEC_HSYNC
$Comp
L myLib:Conn_02x14_Even_Odd J6
U 1 1 5FEA6F67
P 3300 1600
F 0 "J6" V 3350 2300 50  0000 C CNN
F 1 "Conn_02x14_Even_Odd" V 3350 2900 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 3300 1600 50  0001 C CNN
F 3 "~" H 3300 1600 50  0001 C CNN
	1    3300 1600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 1800 2800 1950
Wire Wire Line
	2900 1800 2900 1950
Text GLabel 2900 1950 3    50   Input ~ 0
PIN115_D1
Wire Wire Line
	3000 1800 3000 1950
Text GLabel 3000 1950 3    50   Input ~ 0
PIN119_D0
Wire Wire Line
	3100 1800 3100 1950
Text GLabel 3100 1950 3    50   Input ~ 0
PIN121_A0
Wire Wire Line
	3200 1800 3200 1950
Text GLabel 3200 1950 3    50   Input ~ 0
PIN125_A1
Wire Wire Line
	3300 1800 3300 1950
Text GLabel 3300 1950 3    50   Input ~ 0
PIN129_A2
Wire Wire Line
	3400 1800 3400 1950
Text GLabel 3400 1950 3    50   Input ~ 0
PIN133_A3
Wire Wire Line
	3500 1800 3500 1950
Text GLabel 3500 1950 3    50   Input ~ 0
PIN135_A4
Wire Wire Line
	3600 1800 3600 1950
Text GLabel 3600 1950 3    50   Input ~ 0
PIN137_A5
Wire Wire Line
	3700 1800 3700 1950
Text GLabel 3700 1950 3    50   Input ~ 0
PIN141_A6
Wire Wire Line
	3800 1800 3800 1950
Text GLabel 3800 1950 3    50   Input ~ 0
PIN143_A7
Wire Wire Line
	2800 1300 2800 1150
Text GLabel 2800 1150 1    50   Input ~ 0
PIN112_D3
Wire Wire Line
	2900 1300 2900 1150
Text GLabel 2900 1150 1    50   Input ~ 0
PIN114_D4
Wire Wire Line
	3000 1300 3000 1150
Text GLabel 3000 1150 1    50   Input ~ 0
PIN118_D5
Wire Wire Line
	3100 1300 3100 1150
Text GLabel 3100 1150 1    50   Input ~ 0
PIN120_D6
Wire Wire Line
	3200 1300 3200 1150
Text GLabel 3200 1150 1    50   Input ~ 0
PIN122_D7
Wire Wire Line
	3300 1300 3300 1150
Text GLabel 3300 1150 1    50   Input ~ 0
PIN126_CS1
Wire Wire Line
	3400 1300 3400 1150
Text GLabel 3400 1150 1    50   Input ~ 0
PIN132_A10
Wire Wire Line
	3500 1300 3500 1150
Text GLabel 3500 1150 1    50   Input ~ 0
PIN134_RD
Wire Wire Line
	3600 1300 3600 1150
Text GLabel 3600 1150 1    50   Input ~ 0
PIN136_A11
Wire Wire Line
	3700 1300 3700 1150
Text GLabel 3700 1150 1    50   Input ~ 0
PIN139_A9
Wire Wire Line
	3800 1300 3800 1150
Text GLabel 3800 1150 1    50   Input ~ 0
PIN142_A8
Wire Wire Line
	3900 1300 3900 1150
Text GLabel 3900 1150 1    50   Input ~ 0
PIN144_RST
$Comp
L myLib:Conn_02x14_Even_Odd J8
U 1 1 5FEAB151
P 1950 3600
F 0 "J8" H 2046 2812 50  0000 R CNN
F 1 "Conn_02x14_Even_Odd" H 2600 2700 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 1950 3600 50  0001 C CNN
F 3 "~" H 1950 3600 50  0001 C CNN
	1    1950 3600
	-1   0    0    1   
$EndComp
Wire Wire Line
	2150 2900 2300 2900
Wire Wire Line
	2150 3000 2200 3000
Wire Wire Line
	2150 3100 2300 3100
Text GLabel 2300 3100 2    50   Input ~ 0
PIN103_TX
Wire Wire Line
	2150 3200 2300 3200
Text GLabel 2300 3200 2    50   Input ~ 0
~PIN100_KBDCLK
Wire Wire Line
	2150 3300 2300 3300
Text GLabel 2300 3300 2    50   Input ~ 0
~PIN97_INT
Wire Wire Line
	2150 3400 2300 3400
Wire Wire Line
	2150 3500 2300 3500
Text GLabel 2300 3500 2    50   Input ~ 0
PIN92_TVSYNCH
Wire Wire Line
	2150 3600 2300 3600
Wire Wire Line
	2150 3700 2300 3700
Text GLabel 2300 3700 2    50   Input ~ 0
PIN88_IN_INTRQ
Wire Wire Line
	2150 3800 2300 3800
Text GLabel 2300 3800 2    50   Input ~ 0
PIN86_TX
Wire Wire Line
	2150 3900 2300 3900
Wire Wire Line
	2150 4000 2300 4000
Wire Wire Line
	2150 4100 2300 4100
Wire Wire Line
	2150 4200 2200 4200
Wire Wire Line
	1650 2900 1600 2900
Wire Wire Line
	1650 3000 1500 3000
Wire Wire Line
	1650 3100 1500 3100
Wire Wire Line
	1650 3200 1500 3200
Text GLabel 1500 3200 0    50   Input ~ 0
~PIN99_KBDRST
Wire Wire Line
	1650 3300 1500 3300
Wire Wire Line
	1650 3400 1500 3400
Text GLabel 1500 3400 0    50   Input ~ 0
PIN93_RXBAUDCLK
Wire Wire Line
	1650 3500 1500 3500
Wire Wire Line
	1650 3600 1500 3600
Text GLabel 1500 3600 0    50   Input ~ 0
PIN89_IN_NC
Wire Wire Line
	1650 3700 1500 3700
Text GLabel 1500 3700 0    50   Input ~ 0
PIN87_PORT0RD
Wire Wire Line
	1650 3800 1500 3800
Wire Wire Line
	1650 3900 1500 3900
Text GLabel 1500 3900 0    50   Input ~ 0
PIN79_CS2
Wire Wire Line
	1650 4000 1500 4000
Wire Wire Line
	1650 4100 1500 4100
Wire Wire Line
	1650 4200 1600 4200
$Comp
L myLib:Conn_02x14_Even_Odd J7
U 1 1 5FEB71A3
P 4900 3500
F 0 "J7" H 4904 4180 50  0000 L CNN
F 1 "Conn_02x14_Even_Odd" H 4500 4300 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 4900 3500 50  0001 C CNN
F 3 "~" H 4900 3500 50  0001 C CNN
	1    4900 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 4200 4550 4200
Wire Wire Line
	4700 4100 4650 4100
Wire Wire Line
	4700 4000 4550 4000
Text GLabel 4550 4000 0    50   Input ~ 0
PIN31_A17
Wire Wire Line
	4700 3900 4550 3900
Text GLabel 4550 3900 0    50   Input ~ 0
PIN28_A12
Wire Wire Line
	4700 3700 4550 3700
Wire Wire Line
	4700 3600 4550 3600
Text GLabel 4550 3600 0    50   Input ~ 0
PIN24_A13
Wire Wire Line
	4700 3500 4550 3500
Text GLabel 4550 3500 0    50   Input ~ 0
PIN21_IN_NMI
Wire Wire Line
	4700 3400 4550 3400
Wire Wire Line
	4700 3300 4650 3300
Wire Wire Line
	4700 3200 4650 3200
Wire Wire Line
	4700 3100 4550 3100
Text GLabel 4550 3100 0    50   Input ~ 0
PIN8_A15
Wire Wire Line
	4700 3000 4550 3000
Text GLabel 4550 3000 0    50   Input ~ 0
PIN4_WR
Wire Wire Line
	4700 2900 4650 2900
Wire Wire Line
	5200 4100 5250 4100
Wire Wire Line
	5200 4000 5350 4000
Text GLabel 5350 4000 2    50   Input ~ 0
PIN32_A18
Wire Wire Line
	5200 3900 5350 3900
Text GLabel 5350 3900 2    50   Input ~ 0
PIN30_A14
Wire Wire Line
	5200 3700 5350 3700
Wire Wire Line
	5200 3600 5350 3600
Text GLabel 5350 3600 2    50   Input ~ 0
PIN25_A16
Wire Wire Line
	5200 3500 5350 3500
Wire Wire Line
	5200 3400 5350 3400
Text GLabel 5350 3400 2    50   Input ~ 0
PIN18_IN_WARMRST
Wire Wire Line
	5200 3300 5250 3300
Wire Wire Line
	5200 3200 5350 3200
Text GLabel 5350 3200 2    50   Input ~ 0
PIN9_HALT
Wire Wire Line
	5200 3100 5350 3100
Text GLabel 5350 3100 2    50   Input ~ 0
PIN7_TAPE_DRIVE
Wire Wire Line
	5200 3000 5350 3000
Text GLabel 5350 3000 2    50   Input ~ 0
PIN3_SDACTIVE
Wire Wire Line
	5200 2900 5250 2900
$Comp
L power:GND #PWR0102
U 1 1 5FED9629
P 2500 5750
F 0 "#PWR0102" H 2500 5500 50  0001 C CNN
F 1 "GND" H 2505 5577 50  0000 C CNN
F 2 "" H 2500 5750 50  0001 C CNN
F 3 "" H 2500 5750 50  0001 C CNN
	1    2500 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 5200 2800 5100
Wire Wire Line
	2800 5700 2800 5750
Wire Wire Line
	2800 5750 2500 5750
Wire Wire Line
	2500 5750 2500 5100
Wire Wire Line
	2500 5100 2800 5100
Wire Wire Line
	3800 5700 3800 5850
Text GLabel 3800 5850 3    50   Input ~ 0
PIN44_KCLK
Wire Wire Line
	3900 5700 3900 5850
Text GLabel 3900 5850 3    50   Input ~ 0
PIN42_SDDI
Wire Wire Line
	4000 5700 4000 5850
Text GLabel 4000 5850 3    50   Input ~ 0
PIN40_SDDO
Text GLabel 2800 1950 3    50   Input ~ 0
PIN113_D2
Wire Wire Line
	2700 1300 2700 1250
Wire Wire Line
	2700 1800 2700 1850
Wire Wire Line
	4000 1300 4000 1250
Wire Wire Line
	4000 1250 4150 1250
Wire Wire Line
	3900 1800 3900 1850
Wire Wire Line
	3900 1850 4150 1850
Wire Wire Line
	4150 1850 4150 1250
Wire Wire Line
	4350 1800 4350 1750
$Comp
L power:+3.3V #PWR0103
U 1 1 600B6B45
P 4350 1750
F 0 "#PWR0103" H 4350 1600 50  0001 C CNN
F 1 "+3.3V" H 4365 1923 50  0000 C CNN
F 2 "" H 4350 1750 50  0001 C CNN
F 3 "" H 4350 1750 50  0001 C CNN
	1    4350 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1600 4200 1600 2900
Wire Wire Line
	2200 4200 2200 4350
Wire Wire Line
	2200 4350 1600 4350
Wire Wire Line
	1600 4350 1600 4200
Connection ~ 1600 4200
Wire Wire Line
	2200 4200 2200 3000
Connection ~ 2200 4200
$Comp
L power:+3.3V #PWR0104
U 1 1 600DF161
P 2300 2900
F 0 "#PWR0104" H 2300 2750 50  0001 C CNN
F 1 "+3.3V" H 2315 3073 50  0000 C CNN
F 2 "" H 2300 2900 50  0001 C CNN
F 3 "" H 2300 2900 50  0001 C CNN
	1    2300 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 1850 3900 1850
Connection ~ 3900 1850
Wire Wire Line
	4000 1250 2700 1250
Connection ~ 4000 1250
$Comp
L power:GND #PWR0105
U 1 1 600FCF89
P 4150 1850
F 0 "#PWR0105" H 4150 1600 50  0001 C CNN
F 1 "GND" H 4155 1677 50  0000 C CNN
F 2 "" H 4150 1850 50  0001 C CNN
F 3 "" H 4150 1850 50  0001 C CNN
	1    4150 1850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 6010386E
P 2200 4350
F 0 "#PWR0106" H 2200 4100 50  0001 C CNN
F 1 "GND" H 2205 4177 50  0000 C CNN
F 2 "" H 2200 4350 50  0001 C CNN
F 3 "" H 2200 4350 50  0001 C CNN
	1    2200 4350
	1    0    0    -1  
$EndComp
Connection ~ 2200 4350
Wire Wire Line
	4650 2900 4650 3200
Wire Wire Line
	4650 4100 4650 4350
Wire Wire Line
	4650 4350 5250 4350
Wire Wire Line
	5250 4350 5250 4100
Connection ~ 4650 4100
Wire Wire Line
	5250 4100 5250 3300
Connection ~ 5250 4100
$Comp
L power:GND #PWR0107
U 1 1 6011C46C
P 5250 4600
F 0 "#PWR0107" H 5250 4350 50  0001 C CNN
F 1 "GND" H 5255 4427 50  0000 C CNN
F 2 "" H 5250 4600 50  0001 C CNN
F 3 "" H 5250 4600 50  0001 C CNN
	1    5250 4600
	1    0    0    -1  
$EndComp
Connection ~ 5250 4350
Connection ~ 4650 3200
Wire Wire Line
	4650 3200 4650 3300
Connection ~ 4650 3300
Wire Wire Line
	4650 3300 4650 4100
$Comp
L power:+3.3V #PWR0108
U 1 1 6012D58F
P 5700 4500
F 0 "#PWR0108" H 5700 4350 50  0001 C CNN
F 1 "+3.3V" H 5715 4673 50  0000 C CNN
F 2 "" H 5700 4500 50  0001 C CNN
F 3 "" H 5700 4500 50  0001 C CNN
	1    5700 4500
	1    0    0    -1  
$EndComp
Connection ~ 5250 3300
Wire Wire Line
	5250 3300 5250 2900
NoConn ~ 4700 3800
NoConn ~ 5200 3800
Wire Wire Line
	5550 4200 5550 4500
Wire Wire Line
	5550 4500 4550 4500
Wire Wire Line
	4550 4500 4550 4200
Wire Wire Line
	5200 4200 5550 4200
Wire Notes Line
	800  550  6450 550 
Wire Notes Line
	6450 550  6450 6500
Wire Notes Line
	6450 6500 800  6500
Wire Notes Line
	800  6500 800  550 
Wire Notes Line
	5550 2700 5550 1050
Wire Notes Line
	5550 1050 5950 1050
Wire Notes Line
	5900 1050 5900 2700
Wire Notes Line
	5950 2700 5550 2700
Wire Notes Line
	6050 2700 6050 1050
Wire Notes Line
	6050 1050 6400 1050
Wire Notes Line
	6400 1050 6400 2700
Wire Notes Line
	6400 2700 6100 2700
Wire Notes Line
	5800 6400 5800 5600
Wire Notes Line
	5800 5600 6300 5600
Wire Notes Line
	6300 5600 6300 6400
Wire Notes Line
	6300 6400 5800 6400
Text Notes 6300 2100 1    50   ~ 0
AS Socket
Text Notes 5800 2050 1    50   ~ 0
JTAG socket\n
Text Notes 5850 6150 0    50   ~ 0
Barrel\nPower\nConnector\n(5V)
$Comp
L Device:LED D1
U 1 1 601B7AD7
P 9200 2050
F 0 "D1" H 9193 2267 50  0000 C CNN
F 1 "LED" H 9193 2176 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 2050 50  0001 C CNN
F 3 "~" H 9200 2050 50  0001 C CNN
	1    9200 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D3
U 1 1 601B83BC
P 9200 1350
F 0 "D3" H 9193 1567 50  0000 C CNN
F 1 "LED" H 9193 1476 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1350 50  0001 C CNN
F 3 "~" H 9200 1350 50  0001 C CNN
	1    9200 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 601B8BB6
P 9200 1700
F 0 "D2" H 9193 1917 50  0000 C CNN
F 1 "LED" H 9193 1826 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1700 50  0001 C CNN
F 3 "~" H 9200 1700 50  0001 C CNN
	1    9200 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 601B953B
P 8650 2050
F 0 "R2" V 8550 2050 50  0000 C CNN
F 1 "220R" V 8650 2050 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 2050 50  0001 C CNN
F 3 "~" H 8650 2050 50  0001 C CNN
	1    8650 2050
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 601C43BA
P 8650 1350
F 0 "R4" V 8550 1350 50  0000 C CNN
F 1 "220R" V 8650 1350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1350 50  0001 C CNN
F 3 "~" H 8650 1350 50  0001 C CNN
	1    8650 1350
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 601C485F
P 8650 1700
F 0 "R3" V 8550 1700 50  0000 C CNN
F 1 "220R" V 8650 1700 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1700 50  0001 C CNN
F 3 "~" H 8650 1700 50  0001 C CNN
	1    8650 1700
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 2050 9050 2050
Wire Wire Line
	8800 1350 9050 1350
Wire Wire Line
	8800 1700 9050 1700
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
Wire Wire Line
	9750 1350 9750 1000
Text GLabel 8200 1350 0    50   Input ~ 0
PIN3_SDACTIVE
Wire Wire Line
	8200 2050 8500 2050
Text GLabel 8200 2050 0    50   Input ~ 0
PIN7_TAPE_DRIVE
Wire Wire Line
	8200 1350 8500 1350
Text GLabel 8200 1700 0    50   Input ~ 0
PIN9_HALT
Wire Wire Line
	8200 1700 8500 1700
Text Notes 900  6300 0    50   ~ 0
There are 7 input-only pins; none are used\non MULTICOMP. Named PINxx_IN_XXX here.\nPins 18 21 22 88 89 90 91\n
$Sheet
S 9000 5850 2050 150 
U 5FC85C78
F0 "nascom_ng_connectors" 50
F1 "nascom_ng_connectors.sch" 50
$EndSheet
Text Notes 10050 2750 0    50   ~ 0
"COLD RESET" This duplicates\nthe push-button on the\nFPGA board pin 144.
Text GLabel 1500 3100 0    50   Input ~ 0
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
Text GLabel 5350 3500 2    50   Input ~ 0
~PIN22_IN_READY
Text GLabel 2300 3600 2    50   Input ~ 0
PIN90_IN_NC
Text GLabel 1500 3500 0    50   Input ~ 0
PIN91_IN_DRQ
Text GLabel 3100 5850 3    50   Input ~ 0
PIN65_TVVID
Text GLabel 3400 5050 1    50   Input ~ 0
~PIN58_PIO_CS
Text GLabel 2900 5850 3    50   Input ~ 0
~PIN71_CTC_CS
Text GLabel 3000 5050 1    50   Input ~ 0
PIN70_PORTE4_WR
Text GLabel 2300 3400 2    50   Input ~ 0
PIN94_TXBAUDCLK
Wire Wire Line
	7450 5750 7650 5750
Text GLabel 7450 5750 0    50   Input ~ 0
PIN75_RCLK
Wire Wire Line
	7450 5350 7650 5350
Text GLabel 1500 3300 0    50   Input ~ 0
PIN96_IOBUFWR
Wire Wire Line
	7450 5550 7650 5550
Text GLabel 7450 5550 0    50   Input ~ 0
PIN86_TX
Wire Wire Line
	7450 5650 7650 5650
Text GLabel 7450 5650 0    50   Input ~ 0
PIN74_RX
Text GLabel 1500 3000 0    50   Input ~ 0
~PIN104_IOBUFOE
Wire Wire Line
	7450 5850 7650 5850
Text Notes 950  6850 0    50   ~ 0
TODO: gating of side select from FDC to imitate NASCOM FDC\n
Text Notes 4500 3450 2    50   ~ 0
PIN17_CLK50
NoConn ~ 4550 3400
Text Notes 5800 3750 2    50   ~ 0
PIN27_PWR
NoConn ~ 5350 3700
Text Notes 4500 3750 2    50   ~ 0
PIN26_PWR
NoConn ~ 4550 3700
Text Notes 1450 3850 2    50   ~ 0
PIN81_PWR
NoConn ~ 1500 3800
Text Notes 1450 4150 2    50   ~ 0
PIN73_RC_RESET
NoConn ~ 1500 4100
Text Notes 2350 4050 0    50   ~ 0
PIN76_JTAG
Text Notes 2350 3950 0    50   ~ 0
PIN80_PWR
NoConn ~ 2300 4000
NoConn ~ 2300 3900
$Sheet
S 9000 6250 2050 150 
U 62588EF4
F0 "nascom_ng_fdc2" 50
F1 "nascom_ng_fdc2.sch" 50
$EndSheet
$Comp
L Device:LED D4
U 1 1 6000B7F6
P 9200 1000
F 0 "D4" H 9193 1217 50  0000 C CNN
F 1 "LED" H 9193 1126 50  0000 C CNN
F 2 "LED_THT:LED_D5.0mm" H 9200 1000 50  0001 C CNN
F 3 "~" H 9200 1000 50  0001 C CNN
	1    9200 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 6000B7FC
P 8650 1000
F 0 "R1" V 8550 1000 50  0000 C CNN
F 1 "220R" V 8650 1000 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8580 1000 50  0001 C CNN
F 3 "~" H 8650 1000 50  0001 C CNN
	1    8650 1000
	0    1    1    0   
$EndComp
Wire Wire Line
	8800 1000 9050 1000
Wire Wire Line
	8200 1000 8500 1000
$Comp
L power:GND #PWR041
U 1 1 6002A46E
P 8200 1000
F 0 "#PWR041" H 8200 750 50  0001 C CNN
F 1 "GND" H 8205 827 50  0000 C CNN
F 2 "" H 8200 1000 50  0001 C CNN
F 3 "" H 8200 1000 50  0001 C CNN
	1    8200 1000
	-1   0    0    -1  
$EndComp
Text Notes 7150 750  0    50   ~ 0
These duplicate the 4 LEDs on the FPGA board,\nwhich are also on pins 3, 7, 9 and 3V3 power.
Text Notes 850  4750 0    50   ~ 0
PIN73 is connected to an RC\nnetwork on the FPGA board\nand could be used for\npower-on reset
Text Notes 900  950  0    50   ~ 0
EP2C5T144C8N mini board\nmounts face-down. It overhangs\nthe edge of the main board in order to give\naccess to the programming headers.
Wire Notes Line
	5350 6600 5350 450 
Wire Notes Line
	5650 900  5900 900 
Wire Notes Line
	5900 900  5900 800 
Wire Notes Line
	5900 800  5650 800 
Wire Notes Line
	5650 800  5650 900 
Text Notes 5900 900  2    50   ~ 0
RESET
Wire Notes Line
	5400 900  5400 750 
Wire Notes Line
	5400 750  5500 750 
Wire Notes Line
	5500 750  5500 900 
Wire Notes Line
	5500 900  5400 900 
Text Notes 5500 900  1    50   ~ 0
LED
Wire Notes Line
	5000 900  5000 750 
Wire Notes Line
	5000 750  5100 750 
Wire Notes Line
	5100 750  5100 900 
Wire Notes Line
	5100 900  5000 900 
Text Notes 5100 900  1    50   ~ 0
LED
Wire Notes Line
	5200 900  5200 750 
Wire Notes Line
	5200 750  5300 750 
Wire Notes Line
	5300 750  5300 900 
Wire Notes Line
	5300 900  5200 900 
Text Notes 5300 900  1    50   ~ 0
LED
Wire Notes Line
	6300 5050 6300 4900
Wire Notes Line
	6300 4900 6400 4900
Wire Notes Line
	6400 4900 6400 5050
Wire Notes Line
	6400 5050 6300 5050
Text Notes 6400 5050 1    50   ~ 0
LED
Text Notes 5350 6000 1    50   ~ 0
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
L Mechanical:MountingHole H3
U 1 1 5FFCCBD7
P 9450 4350
F 0 "H3" H 9550 4396 50  0000 L CNN
F 1 "MountingHole" H 9550 4305 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3" H 9450 4350 50  0001 C CNN
F 3 "~" H 9450 4350 50  0001 C CNN
	1    9450 4350
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5FFCD074
P 10300 3650
F 0 "H2" H 10400 3696 50  0000 L CNN
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
	4000 1800 4350 1800
$Comp
L Connector_Generic:Conn_02x08_Odd_Even PL?
U 1 1 601658F1
P 7850 5650
AR Path="/5FC877BB/601658F1" Ref="PL?"  Part="1" 
AR Path="/5FC85C78/601658F1" Ref="PL?"  Part="1" 
AR Path="/601658F1" Ref="J11"  Part="1" 
F 0 "J11" H 7850 6050 50  0000 C CNN
F 1 "Conn_02x08_Odd_Even" H 7900 6150 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 7850 5650 50  0001 C CNN
F 3 "~" H 7850 5650 50  0001 C CNN
	1    7850 5650
	1    0    0    -1  
$EndComp
Text Notes 7450 5000 0    50   ~ 0
SPARES/DEBUG/EXPANSION
Wire Wire Line
	8150 5550 8300 5550
Wire Wire Line
	8300 5550 8300 5650
Wire Wire Line
	8150 5950 8300 5950
Wire Wire Line
	8150 5850 8300 5850
Wire Wire Line
	8150 5750 8300 5750
Connection ~ 8300 5750
Wire Wire Line
	8300 5750 8300 5850
Wire Wire Line
	8150 5650 8300 5650
Connection ~ 8300 5650
Wire Wire Line
	8300 5650 8300 5750
$Comp
L Switch:SW_Push SW3
U 1 1 60158A7D
P 8650 2550
F 0 "SW3" H 8650 2835 50  0000 C CNN
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
L Switch:SW_Push SW1
U 1 1 6015E8F2
P 8650 3350
F 0 "SW1" H 8650 3635 50  0000 C CNN
F 1 "SW_Push" H 8650 3544 50  0000 C CNN
F 2 "mylib:MOMENTARY_TACTILE_RT_ANGLE" H 8650 3550 50  0001 C CNN
F 3 "~" H 8650 3550 50  0001 C CNN
	1    8650 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 3350 7550 3600
Text GLabel 7450 5450 0    50   Input ~ 0
PIN89_IN_NC
Text GLabel 7450 5950 0    50   Input ~ 0
PIN90_IN_NC
Wire Wire Line
	7450 5450 7650 5450
Wire Wire Line
	7450 5950 7650 5950
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
$Comp
L power:GND #PWR0132
U 1 1 604C5201
P 8600 5550
F 0 "#PWR0132" H 8600 5300 50  0001 C CNN
F 1 "GND" H 8605 5377 50  0000 C CNN
F 2 "" H 8600 5550 50  0001 C CNN
F 3 "" H 8600 5550 50  0001 C CNN
	1    8600 5550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8300 5550 8600 5550
Connection ~ 8300 5550
$Comp
L power:+5V #PWR?
U 1 1 604E98CC
P 8300 6050
AR Path="/5FC877BB/604E98CC" Ref="#PWR?"  Part="1" 
AR Path="/5FC85C78/604E98CC" Ref="#PWR?"  Part="1" 
AR Path="/604E98CC" Ref="#PWR0138"  Part="1" 
F 0 "#PWR0138" H 8300 5900 50  0001 C CNN
F 1 "+5V" V 8300 6250 50  0000 C CNN
F 2 "" H 8300 6050 50  0001 C CNN
F 3 "" H 8300 6050 50  0001 C CNN
	1    8300 6050
	0    1    1    0   
$EndComp
Wire Wire Line
	8150 6050 8300 6050
NoConn ~ 7650 6050
Text GLabel 2300 4100 2    50   Input ~ 0
PIN74_RX
Text GLabel 1500 4000 0    50   Input ~ 0
PIN75_RCLK
Text GLabel 7450 5350 0    50   Input ~ 0
PIN65_TVVID
Text GLabel 7450 5850 0    50   Input ~ 0
PIN92_TVSYNCH
Connection ~ 8300 5350
$Comp
L power:+3.3V #PWR0133
U 1 1 604E9156
P 8300 5350
F 0 "#PWR0133" H 8300 5200 50  0001 C CNN
F 1 "+3.3V" V 8300 5600 50  0000 C CNN
F 2 "" H 8300 5350 50  0001 C CNN
F 3 "" H 8300 5350 50  0001 C CNN
	1    8300 5350
	0    1    1    0   
$EndComp
Wire Wire Line
	8300 5450 8150 5450
Wire Wire Line
	8300 5350 8300 5450
Wire Wire Line
	8150 5350 8300 5350
Connection ~ 4150 1850
Connection ~ 2500 5750
$Comp
L myLib:Conn_02x14_Even_Odd J9
U 1 1 5FE8AA27
P 3400 5400
F 0 "J9" V 3450 4600 50  0000 C CNN
F 1 "Conn_02x14_Even_Odd" V 3450 3900 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x14_P2.54mm_Vertical" H 3400 5400 50  0001 C CNN
F 3 "~" H 3400 5400 50  0001 C CNN
	1    3400 5400
	0    1    1    0   
$EndComp
Wire Wire Line
	2700 5200 2700 5150
$Comp
L power:+3.3V #PWR0101
U 1 1 5FED8E2B
P 2400 5000
F 0 "#PWR0101" H 2400 4850 50  0001 C CNN
F 1 "+3.3V" H 2415 5173 50  0000 C CNN
F 2 "" H 2400 5000 50  0001 C CNN
F 3 "" H 2400 5000 50  0001 C CNN
	1    2400 5000
	1    0    0    -1  
$EndComp
Connection ~ 2400 5150
Wire Wire Line
	2700 5150 2400 5150
Wire Wire Line
	2400 5000 2400 5150
Wire Wire Line
	2400 5150 2400 5700
Wire Wire Line
	2700 5700 2400 5700
Wire Wire Line
	5550 4500 5700 4500
Connection ~ 5550 4500
Wire Wire Line
	5250 4350 5250 4600
Wire Wire Line
	8300 5950 8300 5850
Connection ~ 8300 5850
Wire Wire Line
	9350 1700 9750 1700
Wire Wire Line
	9350 2050 9750 2050
Wire Wire Line
	9750 1350 9750 1700
Connection ~ 9750 1350
Wire Wire Line
	9750 1700 9750 2050
Connection ~ 9750 1700
$Comp
L myLib:NASCOM-logo X1
U 1 1 602D8669
P 8450 4100
F 0 "X1" H 8150 4200 50  0000 C CNN
F 1 "NASCOM-logo" H 8750 4200 50  0000 C CNN
F 2 "mylib:nascom_logo_tiny" H 8450 4100 50  0001 C CNN
F 3 "" H 8450 4100 50  0001 C CNN
	1    8450 4100
	1    0    0    -1  
$EndComp
$Comp
L myLib:KiCad-sm-logo X2
U 1 1 602EF72E
P 8450 4300
F 0 "X2" H 8150 4400 50  0000 C CNN
F 1 "KiCad-sm-logo" H 8800 4400 50  0000 C CNN
F 2 "mylib:KiCad-Logo_5mm_SolderMask" H 8450 4300 50  0001 C CNN
F 3 "" H 8450 4300 50  0001 C CNN
	1    8450 4300
	1    0    0    -1  
$EndComp
Text Notes 850  7650 0    50   ~ 0
PCB setup:\nSet grid to 1.0mm for edge cuts and holes\nSet grid to 25mils for routing; tracks are\n0.25mm with 0.2mm spacing.\nChange IC pads to oval,\n1.6mm x 1.439mm to get 2 tracks through.
$EndSCHEMATC
