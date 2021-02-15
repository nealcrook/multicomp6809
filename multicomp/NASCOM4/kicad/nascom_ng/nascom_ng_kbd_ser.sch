EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 5 7
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector_Generic:Conn_02x08_Odd_Even PL1 
U 1 1 60827083
P 2700 1800
F 0 "PL1" H 2750 2317 50 0000 C CNN 
F 1 "Conn_02x08_Odd_Even" H 2750 2226 50  0000 C CNN
F 2 "" H 2700 1800 50  0001 C CNN
F 3 "~" H 2700 1800 50  0001 C CNN
	1    2700 1800
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_02x08_Odd_Even J5 
U 1 1 6082737D
P 2700 3200
F 0 "J5" H 2750 3717 50 0000 C CNN 
F 1 "Conn_02x08_Odd_Even" H 2750 3626 50  0000 C CNN
F 2 "" H 2700 3200 50  0001 C CNN
F 3 "~" H 2700 3200 50  0001 C CNN
	1    2700 3200
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HCT244 U? 
U 1 1 60849F95
P 7150 1850
AR Path="/5FC86EA5/60849F95" Ref="U?"  Part="1" 
AR Path="/5FC877BB/60849F95" Ref="U10"  Part="1" 
F 0 "U8" H 7300 2600 50 0000 C CNN 
F 1 "74HCT244" H 7450 2500 50  0000 C CNN
F 2 "" H 7150 1850 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT244.pdf" H 7150 1850 50  0001 C CNN
	1    7150 1850
	1    0    0    -1  
$EndComp
Text Notes 4850 1000 0    50   ~ 0
s/b 74lvc245.. CHECK VOLTAGE\nLIMITS AT FANOUT
Wire Wire Line
	7150 950  7150 1050
$Comp
L power:GND #PWR? 
U 1 1 60849FA3
P 7150 2750
AR Path="/5FC86EA5/60849FA3" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60849FA3" Ref="#PWR013"  Part="1" 
F 0 "#PWR013" H 7150 2500 50 0001 C CNN 
F 1 "GND" H 7155 2577 50  0000 C CNN
F 2 "" H 7150 2750 50  0001 C CNN
F 3 "" H 7150 2750 50  0001 C CNN
	1    7150 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	6500 2250 6650 2250
Wire Wire Line
	6650 2350 6500 2350
Wire Wire Line
	6500 2350 6500 2250
Wire Wire Line
	7650 1350 7900 1350
Text GLabel 7900 1350 2    50   Input ~ 0
D0_5V
Wire Wire Line
	2500 1500 2100 1500
Text Label 2100 1500 2    50   ~ 0
~KBDS0
Wire Wire Line
	2500 1600 2100 1600
Text Label 2100 1600 2    50   ~ 0
~KBDS1
Wire Wire Line
	2500 1700 2100 1700
Text Label 2100 1700 2    50   ~ 0
~KBDS2
Wire Wire Line
	2500 1800 2100 1800
Text Label 2100 1800 2    50   ~ 0
~KBDS3
Wire Wire Line
	2500 1900 2100 1900
Text Label 2100 1900 2    50   ~ 0
~KBDS4
Wire Wire Line
	2500 2000 2100 2000
Text Label 2100 2000 2    50   ~ 0
~KBDS5
Wire Wire Line
	2500 2100 2100 2100
Text Label 2100 2100 2    50   ~ 0
~KBDS6
Wire Wire Line
	2500 2200 2100 2200
Text Label 2100 2200 2    50   ~ 0
~KBDS7
Wire Wire Line
	6650 1350 6250 1350
Text Label 6250 1350 2    50   ~ 0
~KBDS0
Wire Wire Line
	6650 1450 6250 1450
Text Label 6250 1450 2    50   ~ 0
~KBDS1
Wire Wire Line
	6650 1550 6250 1550
Text Label 6250 1550 2    50   ~ 0
~KBDS2
Wire Wire Line
	6650 1650 6250 1650
Text Label 6250 1650 2    50   ~ 0
~KBDS3
Wire Wire Line
	6650 1750 6250 1750
Text Label 6250 1750 2    50   ~ 0
~KBDS4
Wire Wire Line
	6650 1850 6250 1850
Text Label 6250 1850 2    50   ~ 0
~KBDS5
Wire Wire Line
	6650 1950 6250 1950
Text Label 6250 1950 2    50   ~ 0
~KBDS6
Wire Wire Line
	6650 2050 6250 2050
Text Label 6250 2050 2    50   ~ 0
~KBDS7
Wire Wire Line
	7650 1450 7900 1450
Text GLabel 7900 1450 2    50   Input ~ 0
D1_5V
Wire Wire Line
	7650 1550 7900 1550
Text GLabel 7900 1550 2    50   Input ~ 0
D2_5V
Wire Wire Line
	7650 1650 7900 1650
Text GLabel 7900 1650 2    50   Input ~ 0
D3_5V
Wire Wire Line
	7650 1750 7900 1750
Text GLabel 7900 1750 2    50   Input ~ 0
D4_5V
Wire Wire Line
	7650 1850 7900 1850
Text GLabel 7900 1850 2    50   Input ~ 0
D5_5V
Wire Wire Line
	7650 1950 7900 1950
Text GLabel 7900 1950 2    50   Input ~ 0
D6_5V
Wire Wire Line
	7650 2050 7900 2050
Text GLabel 7900 2050 2    50   Input ~ 0
D7_5V
Wire Wire Line
	7150 2650 7150 2750
Wire Wire Line
	6500 2250 6250 2250
Connection ~ 6500 2250
Text GLabel 6250 2250 0    50   Input ~ 0
PINx_PORT0RD
$Comp
L power:GND #PWR? 
U 1 1 6085897C
P 3100 2250
AR Path="/5FC86EA5/6085897C" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/6085897C" Ref="#PWR014"  Part="1" 
F 0 "#PWR014" H 3100 2000 50 0001 C CNN 
F 1 "GND" H 3105 2077 50  0000 C CNN
F 2 "" H 3100 2250 50  0001 C CNN
F 3 "" H 3100 2250 50  0001 C CNN
	1    3100 2250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 2200 3100 2250
Wire Wire Line
	3000 2200 3100 2200
Wire Wire Line
	3000 1500 3100 1500
Wire Wire Line
	3100 1500 3100 1300
$Comp
L power:+5V #PWR015 
U 1 1 6085C3EE
P 7150 950
F 0 "#PWR015" H 7150 800 50 0001 C CNN 
F 1 "+5V" H 7165 1123 50  0000 C CNN
F 2 "" H 7150 950 50  0001 C CNN
F 3 "" H 7150 950 50  0001 C CNN
	1    7150 950 
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR012 
U 1 1 6085CECB
P 3100 1300
F 0 "#PWR012" H 3100 1150 50 0001 C CNN 
F 1 "+5V" H 3115 1473 50  0000 C CNN
F 2 "" H 3100 1300 50  0001 C CNN
F 3 "" H 3100 1300 50  0001 C CNN
	1    3100 1300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 1600 3300 1600
Text GLabel 3300 1600 2    50   Input ~ 0
PIN21_IN_NMI
Wire Wire Line
	3000 1900 3300 1900
Wire Wire Line
	3000 2000 3300 2000
Wire Wire Line
	3000 2100 3300 2100
Text GLabel 3300 1900 2    50   Input ~ 0
PIN144_RST
NoConn ~ 3000 1700
NoConn ~ 3000 1800
Text Notes 3100 1850 0    50   ~ 0
On the NASCOM, pins 6, 8 are connected to\nPORT0 output bits but are NC on the keyboard.
Text GLabel 3300 2000 2    50   Input ~ 0
~PINx_KBDCLK
Text GLabel 3300 2100 2    50   Input ~ 0
~PINx_KBDRST
Text Notes 1200 1800 0    50   ~ 0
"KBD"
Text Notes 1200 3050 0    50   ~ 0
"SERIAL"
Text Notes 1800 4100 0    50   ~ 0
This is only "sympathetic with" not "compatible with" the\nNASCOM serial connector. There are no 12V RS232 levels,\nonly 5V levels, and no audio/cassette interface.
Wire Wire Line
	2500 2900 2100 2900
Text Label 2100 2900 2    50   ~ 0
~KBDS7
NoConn ~ 3000 3200
$Comp
L power:GND #PWR? 
U 1 1 60879268
P 2400 3650
AR Path="/5FC86EA5/60879268" Ref="#PWR?"  Part="1" 
AR Path="/5FC877BB/60879268" Ref="#PWR0137"  Part="1" 
F 0 "#PWR0137" H 2400 3400 50 0001 C CNN 
F 1 "GND" H 2405 3477 50  0000 C CNN
F 2 "" H 2400 3650 50  0001 C CNN
F 3 "" H 2400 3650 50  0001 C CNN
	1    2400 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 3400 2400 3400
Wire Wire Line
	2400 3400 2400 3600
Wire Wire Line
	2500 3600 2400 3600
Connection ~ 2400 3600
Wire Wire Line
	2400 3600 2400 3650
Wire Wire Line
	3000 2900 3100 2900
Wire Wire Line
	3100 2900 3100 2700
$Comp
L power:+5V #PWR0138 
U 1 1 608805C2
P 3100 2700
F 0 "#PWR0138" H 3100 2550 50 0001 C CNN 
F 1 "+5V" H 3115 2873 50  0000 C CNN
F 2 "" H 3100 2700 50  0001 C CNN
F 3 "" H 3100 2700 50  0001 C CNN
	1    3100 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 3400 3300 3400
Text GLabel 3300 3400 2    50   Input ~ 0
TX_5V
Text Notes 3900 3150 0    50   ~ 0
TX OUT, RX IN - both at 5V\nTODO: polarity..
Wire Wire Line
	2500 3000 2400 3000
Wire Wire Line
	2500 3300 2400 3300
Wire Wire Line
	2400 3300 2400 3000
Connection ~ 2400 3000
Wire Wire Line
	2400 3000 2100 3000
Text GLabel 2100 3000 0    50   Input ~ 0
RX_5V
NoConn ~ 3000 3300
NoConn ~ 2500 3200
NoConn ~ 3000 3100
$EndSCHEMATC
