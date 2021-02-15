EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 6
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
L Memory_RAM:AS6C4008-55PCN U9
U 1 1 60208A1B
P 2050 2100
F 0 "U9" H 2200 3300 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 2500 3200 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 2050 2200 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 2050 2200 50  0001 C CNN
	1    2050 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 1200 2800 1200
Text GLabel 2800 1200 2    50   Input ~ 0
PIN119_D0
Wire Wire Line
	2550 1300 2800 1300
Text GLabel 2800 1300 2    50   Input ~ 0
PIN115_D1
Wire Wire Line
	2550 1400 2800 1400
Text GLabel 2800 1400 2    50   Input ~ 0
PIN113_D2
Wire Wire Line
	2550 1500 2800 1500
Text GLabel 2800 1500 2    50   Input ~ 0
PIN112_D3
Wire Wire Line
	2550 1600 2800 1600
Text GLabel 2800 1600 2    50   Input ~ 0
PIN114_D4
Wire Wire Line
	2550 1700 2800 1700
Text GLabel 2800 1700 2    50   Input ~ 0
PIN118_D5
Wire Wire Line
	2550 1800 2800 1800
Text GLabel 2800 1800 2    50   Input ~ 0
PIN120_D6
Wire Wire Line
	2550 1900 2800 1900
Text GLabel 2800 1900 2    50   Input ~ 0
PIN122_D7
Wire Wire Line
	2550 2200 2800 2200
Text GLabel 2800 2200 2    50   Input ~ 0
PIN126_CS1
Wire Wire Line
	2550 2300 2800 2300
Text GLabel 2800 2300 2    50   Input ~ 0
PIN134_RD
Wire Wire Line
	2550 2400 2800 2400
Text GLabel 2800 2400 2    50   Input ~ 0
PIN4_WR
Wire Wire Line
	1550 1800 1300 1800
Text GLabel 1300 1800 0    50   Input ~ 0
PIN141_A6
Wire Wire Line
	1550 1700 1300 1700
Text GLabel 1300 1700 0    50   Input ~ 0
PIN137_A5
Wire Wire Line
	1550 1600 1300 1600
Text GLabel 1300 1600 0    50   Input ~ 0
PIN135_A4
Wire Wire Line
	1550 1500 1300 1500
Text GLabel 1300 1500 0    50   Input ~ 0
PIN133_A3
Wire Wire Line
	1550 1400 1300 1400
Text GLabel 1300 1400 0    50   Input ~ 0
PIN129_A2
Wire Wire Line
	1550 1300 1300 1300
Text GLabel 1300 1300 0    50   Input ~ 0
PIN125_A1
Wire Wire Line
	1550 1200 1300 1200
Text GLabel 1300 1200 0    50   Input ~ 0
PIN121_A0
Wire Wire Line
	1550 2500 1300 2500
Text GLabel 1300 2500 0    50   Input ~ 0
PIN24_A13
Wire Wire Line
	1550 2400 1300 2400
Text GLabel 1300 2400 0    50   Input ~ 0
PIN28_A12
Wire Wire Line
	1550 2300 1300 2300
Text GLabel 1300 2300 0    50   Input ~ 0
PIN136_A11
Wire Wire Line
	1550 2200 1300 2200
Text GLabel 1300 2200 0    50   Input ~ 0
PIN132_A10
Wire Wire Line
	1550 2100 1300 2100
Text GLabel 1300 2100 0    50   Input ~ 0
PIN139_A9
Wire Wire Line
	1550 2000 1300 2000
Text GLabel 1300 2000 0    50   Input ~ 0
PIN142_A8
Wire Wire Line
	1550 1900 1300 1900
Text GLabel 1300 1900 0    50   Input ~ 0
PIN143_A7
Wire Wire Line
	1550 3000 1300 3000
Text GLabel 1300 3000 0    50   Input ~ 0
PIN32_A18
Wire Wire Line
	1550 2900 1300 2900
Text GLabel 1300 2900 0    50   Input ~ 0
PIN31_A17
Wire Wire Line
	1550 2800 1300 2800
Text GLabel 1300 2800 0    50   Input ~ 0
PIN25_A16
Wire Wire Line
	1550 2700 1300 2700
Text GLabel 1300 2700 0    50   Input ~ 0
PIN8_A15
Wire Wire Line
	1550 2600 1300 2600
Text GLabel 1300 2600 0    50   Input ~ 0
PIN30_A14
$Comp
L power:GND #PWR0123
U 1 1 6020CDD1
P 2050 3300
F 0 "#PWR0123" H 2050 3050 50  0001 C CNN
F 1 "GND" H 2055 3127 50  0000 C CNN
F 2 "" H 2050 3300 50  0001 C CNN
F 3 "" H 2050 3300 50  0001 C CNN
	1    2050 3300
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0124
U 1 1 6020D26C
P 2050 900
F 0 "#PWR0124" H 2050 750 50  0001 C CNN
F 1 "+3.3V" H 2065 1073 50  0000 C CNN
F 2 "" H 2050 900 50  0001 C CNN
F 3 "" H 2050 900 50  0001 C CNN
	1    2050 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 900  2050 1000
Wire Wire Line
	2050 3200 2050 3300
$Comp
L Memory_RAM:AS6C4008-55PCN U7
U 1 1 602149FB
P 4800 2100
F 0 "U7" H 4950 3300 50  0000 C CNN
F 1 "AS6C4008-55PCN" H 5250 3200 50  0000 C CNN
F 2 "Package_DIP:DIP-32_W15.24mm" H 4800 2200 50  0001 C CNN
F 3 "https://www.alliancememory.com/wp-content/uploads/pdf/AS6C4008.pdf" H 4800 2200 50  0001 C CNN
	1    4800 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5300 1200 5550 1200
Text GLabel 5550 1200 2    50   Input ~ 0
PIN119_D0
Wire Wire Line
	5300 1300 5550 1300
Text GLabel 5550 1300 2    50   Input ~ 0
PIN115_D1
Wire Wire Line
	5300 1400 5550 1400
Text GLabel 5550 1400 2    50   Input ~ 0
PIN113_D2
Wire Wire Line
	5300 1500 5550 1500
Text GLabel 5550 1500 2    50   Input ~ 0
PIN112_D3
Wire Wire Line
	5300 1600 5550 1600
Text GLabel 5550 1600 2    50   Input ~ 0
PIN114_D4
Wire Wire Line
	5300 1700 5550 1700
Text GLabel 5550 1700 2    50   Input ~ 0
PIN118_D5
Wire Wire Line
	5300 1800 5550 1800
Text GLabel 5550 1800 2    50   Input ~ 0
PIN120_D6
Wire Wire Line
	5300 1900 5550 1900
Text GLabel 5550 1900 2    50   Input ~ 0
PIN122_D7
Wire Wire Line
	5300 2200 5550 2200
Text GLabel 5550 2200 2    50   Input ~ 0
PIN79_CS2
Wire Wire Line
	5300 2300 5550 2300
Text GLabel 5550 2300 2    50   Input ~ 0
PIN134_RD
Wire Wire Line
	5300 2400 5550 2400
Text GLabel 5550 2400 2    50   Input ~ 0
PIN4_WR
Wire Wire Line
	4300 1800 4050 1800
Text GLabel 4050 1800 0    50   Input ~ 0
PIN141_A6
Wire Wire Line
	4300 1700 4050 1700
Text GLabel 4050 1700 0    50   Input ~ 0
PIN137_A5
Wire Wire Line
	4300 1600 4050 1600
Text GLabel 4050 1600 0    50   Input ~ 0
PIN135_A4
Wire Wire Line
	4300 1500 4050 1500
Text GLabel 4050 1500 0    50   Input ~ 0
PIN133_A3
Wire Wire Line
	4300 1400 4050 1400
Text GLabel 4050 1400 0    50   Input ~ 0
PIN129_A2
Wire Wire Line
	4300 1300 4050 1300
Text GLabel 4050 1300 0    50   Input ~ 0
PIN125_A1
Wire Wire Line
	4300 1200 4050 1200
Text GLabel 4050 1200 0    50   Input ~ 0
PIN121_A0
Wire Wire Line
	4300 2500 4050 2500
Text GLabel 4050 2500 0    50   Input ~ 0
PIN24_A13
Wire Wire Line
	4300 2400 4050 2400
Text GLabel 4050 2400 0    50   Input ~ 0
PIN28_A12
Wire Wire Line
	4300 2300 4050 2300
Text GLabel 4050 2300 0    50   Input ~ 0
PIN136_A11
Wire Wire Line
	4300 2200 4050 2200
Text GLabel 4050 2200 0    50   Input ~ 0
PIN132_A10
Wire Wire Line
	4300 2100 4050 2100
Text GLabel 4050 2100 0    50   Input ~ 0
PIN139_A9
Wire Wire Line
	4300 2000 4050 2000
Text GLabel 4050 2000 0    50   Input ~ 0
PIN142_A8
Wire Wire Line
	4300 1900 4050 1900
Text GLabel 4050 1900 0    50   Input ~ 0
PIN143_A7
Wire Wire Line
	4300 3000 4050 3000
Text GLabel 4050 3000 0    50   Input ~ 0
PIN32_A18
Wire Wire Line
	4300 2900 4050 2900
Text GLabel 4050 2900 0    50   Input ~ 0
PIN31_A17
Wire Wire Line
	4300 2800 4050 2800
Text GLabel 4050 2800 0    50   Input ~ 0
PIN25_A16
Wire Wire Line
	4300 2700 4050 2700
Text GLabel 4050 2700 0    50   Input ~ 0
PIN8_A15
Wire Wire Line
	4300 2600 4050 2600
Text GLabel 4050 2600 0    50   Input ~ 0
PIN30_A14
$Comp
L power:GND #PWR0125
U 1 1 60214A3D
P 4800 3300
F 0 "#PWR0125" H 4800 3050 50  0001 C CNN
F 1 "GND" H 4805 3127 50  0000 C CNN
F 2 "" H 4800 3300 50  0001 C CNN
F 3 "" H 4800 3300 50  0001 C CNN
	1    4800 3300
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0126
U 1 1 60214A43
P 4800 900
F 0 "#PWR0126" H 4800 750 50  0001 C CNN
F 1 "+3.3V" H 4815 1073 50  0000 C CNN
F 2 "" H 4800 900 50  0001 C CNN
F 3 "" H 4800 900 50  0001 C CNN
	1    4800 900 
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 900  4800 1000
Wire Wire Line
	4800 3200 4800 3300
Text Notes 1100 3650 0    50   ~ 0
512Kbytes RAM (equivalent to 2 x MAP256K RAM boards)
Text Notes 4250 3700 0    50   ~ 0
Optional second RAM (if fitted, total RAM is\nequivalent to 4 x MAP256K RAM boards)
$Comp
L 74xx:74LS245 U2
U 1 1 602F5D56
P 2050 5100
F 0 "U2" H 2150 5850 50  0000 C CNN
F 1 "74LVC245" H 2300 5750 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 2050 5100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 2050 5100 50  0001 C CNN
	1    2050 5100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HCT244 U16
U 1 1 602F6AF7
P 4800 5100
F 0 "U16" H 4950 5850 50  0000 C CNN
F 1 "74LVC244" H 5100 5750 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 4800 5100 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT244.pdf" H 4800 5100 50  0001 C CNN
	1    4800 5100
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR01
U 1 1 602FBBD6
P 2050 4200
F 0 "#PWR01" H 2050 4050 50  0001 C CNN
F 1 "+3.3V" H 2065 4373 50  0000 C CNN
F 2 "" H 2050 4200 50  0001 C CNN
F 3 "" H 2050 4200 50  0001 C CNN
	1    2050 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 4200 2050 4300
$Comp
L power:+3.3V #PWR03
U 1 1 603015D0
P 4800 4200
F 0 "#PWR03" H 4800 4050 50  0001 C CNN
F 1 "+3.3V" H 4815 4373 50  0000 C CNN
F 2 "" H 4800 4200 50  0001 C CNN
F 3 "" H 4800 4200 50  0001 C CNN
	1    4800 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 4200 4800 4300
$Comp
L power:GND #PWR02
U 1 1 60312DC6
P 2050 6000
F 0 "#PWR02" H 2050 5750 50  0001 C CNN
F 1 "GND" H 2055 5827 50  0000 C CNN
F 2 "" H 2050 6000 50  0001 C CNN
F 3 "" H 2050 6000 50  0001 C CNN
	1    2050 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 5900 2050 6000
$Comp
L power:GND #PWR04
U 1 1 603169FD
P 4800 6000
F 0 "#PWR04" H 4800 5750 50  0001 C CNN
F 1 "GND" H 4805 5827 50  0000 C CNN
F 2 "" H 4800 6000 50  0001 C CNN
F 3 "" H 4800 6000 50  0001 C CNN
	1    4800 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 5900 4800 5950
Wire Wire Line
	1550 5100 1300 5100
Text GLabel 1300 5100 0    50   Input ~ 0
PIN119_D0
Wire Wire Line
	1550 4900 1300 4900
Text GLabel 1300 4900 0    50   Input ~ 0
PIN115_D1
Wire Wire Line
	1550 4700 1300 4700
Text GLabel 1300 4700 0    50   Input ~ 0
PIN113_D2
Wire Wire Line
	1550 4600 1300 4600
Text GLabel 1300 4600 0    50   Input ~ 0
PIN112_D3
Wire Wire Line
	1550 4800 1300 4800
Text GLabel 1300 4800 0    50   Input ~ 0
PIN114_D4
Wire Wire Line
	1550 5000 1300 5000
Text GLabel 1300 5000 0    50   Input ~ 0
PIN118_D5
Wire Wire Line
	1550 5200 1300 5200
Text GLabel 1300 5200 0    50   Input ~ 0
PIN120_D6
Wire Wire Line
	1550 5300 1300 5300
Text GLabel 1300 5300 0    50   Input ~ 0
PIN122_D7
Wire Wire Line
	2550 5100 2800 5100
Text GLabel 2800 5100 2    50   Input ~ 0
D0_5V
Wire Wire Line
	2550 4900 2800 4900
Text GLabel 2800 4900 2    50   Input ~ 0
D1_5V
Wire Wire Line
	2550 4700 2800 4700
Text GLabel 2800 4700 2    50   Input ~ 0
D2_5V
Wire Wire Line
	2550 4600 2800 4600
Text GLabel 2800 4600 2    50   Input ~ 0
D3_5V
Wire Wire Line
	2550 4800 2800 4800
Text GLabel 2800 4800 2    50   Input ~ 0
D4_5V
Wire Wire Line
	2550 5000 2800 5000
Text GLabel 2800 5000 2    50   Input ~ 0
D5_5V
Wire Wire Line
	2550 5200 2800 5200
Text GLabel 2800 5200 2    50   Input ~ 0
D6_5V
Wire Wire Line
	2550 5300 2800 5300
Text GLabel 2800 5300 2    50   Input ~ 0
D7_5V
Wire Wire Line
	4800 5950 4150 5950
Wire Wire Line
	4150 5950 4150 5600
Wire Wire Line
	4150 5500 4300 5500
Connection ~ 4800 5950
Wire Wire Line
	4800 5950 4800 6000
Wire Wire Line
	4300 5600 4150 5600
Connection ~ 4150 5600
Wire Wire Line
	4150 5600 4150 5500
Wire Wire Line
	7850 4600 8100 4600
Text GLabel 8100 4600 2    50   Input ~ 0
A0_5V
Wire Wire Line
	7850 5200 8100 5200
Text GLabel 8100 5200 2    50   Input ~ 0
A1_5V
Wire Wire Line
	5300 4800 5550 4800
Wire Wire Line
	5300 4900 5550 4900
Wire Wire Line
	5300 5200 5550 5200
Wire Wire Line
	4300 5300 4200 5300
Wire Wire Line
	4300 5200 4200 5200
Wire Wire Line
	4300 5000 4200 5000
Wire Wire Line
	4300 4900 4200 4900
Wire Wire Line
	4300 4800 4200 4800
Wire Wire Line
	6850 5200 6750 5200
Text GLabel 6750 5200 0    50   Input ~ 0
PIN125_A1
Wire Wire Line
	6850 4600 6750 4600
Text GLabel 6750 4600 0    50   Input ~ 0
PIN121_A0
Wire Wire Line
	1550 5500 1300 5500
Text GLabel 1300 5500 0    50   Input ~ 0
PIN96_IOBUFWR
Text GLabel 1300 5650 0    50   Input ~ 0
~PIN104_IOBUFOE
Wire Wire Line
	1550 5600 1450 5600
Wire Wire Line
	1450 5600 1450 5650
Wire Wire Line
	1450 5650 1300 5650
$Comp
L 74xx:74HCT244 U5
U 1 1 60A0A01A
P 7350 5100
F 0 "U5" H 7500 5850 50  0000 C CNN
F 1 "74LVC244" H 7650 5750 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 7350 5100 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT244.pdf" H 7350 5100 50  0001 C CNN
	1    7350 5100
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR016
U 1 1 60A0A020
P 7350 4200
F 0 "#PWR016" H 7350 4050 50  0001 C CNN
F 1 "+3.3V" H 7365 4373 50  0000 C CNN
F 2 "" H 7350 4200 50  0001 C CNN
F 3 "" H 7350 4200 50  0001 C CNN
	1    7350 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 4200 7350 4300
$Comp
L power:GND #PWR017
U 1 1 60A0A027
P 7350 6000
F 0 "#PWR017" H 7350 5750 50  0001 C CNN
F 1 "GND" H 7355 5827 50  0000 C CNN
F 2 "" H 7350 6000 50  0001 C CNN
F 3 "" H 7350 6000 50  0001 C CNN
	1    7350 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 5900 7350 5950
Wire Wire Line
	7350 5950 6700 5950
Wire Wire Line
	6700 5950 6700 5600
Wire Wire Line
	6700 5500 6850 5500
Connection ~ 7350 5950
Wire Wire Line
	7350 5950 7350 6000
Wire Wire Line
	6850 5600 6700 5600
Connection ~ 6700 5600
Wire Wire Line
	6700 5600 6700 5500
Wire Wire Line
	8300 4250 8450 4250
Text GLabel 8450 4250 2    50   Input ~ 0
CLK4_5V
Wire Wire Line
	5750 4250 5900 4250
Text GLabel 5900 4250 2    50   Input ~ 0
CLK1_5V
Wire Wire Line
	4300 4700 4200 4700
Text GLabel 4200 4700 0    50   Input ~ 0
PIN67_CLK1
Wire Wire Line
	6850 5300 6750 5300
Text GLabel 6750 5300 0    50   Input ~ 0
PIN69_CLK4
$Comp
L 74xx:74HCT244 U6
U 1 1 60A1EF8A
P 9900 5100
F 0 "U6" H 10050 5850 50  0000 C CNN
F 1 "74LVC244" H 10200 5750 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 9900 5100 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT244.pdf" H 9900 5100 50  0001 C CNN
	1    9900 5100
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR018
U 1 1 60A1EF90
P 9900 4200
F 0 "#PWR018" H 9900 4050 50  0001 C CNN
F 1 "+3.3V" H 9915 4373 50  0000 C CNN
F 2 "" H 9900 4200 50  0001 C CNN
F 3 "" H 9900 4200 50  0001 C CNN
	1    9900 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 4200 9900 4300
$Comp
L power:GND #PWR019
U 1 1 60A1EF97
P 9900 6000
F 0 "#PWR019" H 9900 5750 50  0001 C CNN
F 1 "GND" H 9905 5827 50  0000 C CNN
F 2 "" H 9900 6000 50  0001 C CNN
F 3 "" H 9900 6000 50  0001 C CNN
	1    9900 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 5900 9900 5950
Wire Wire Line
	9900 5950 9250 5950
Wire Wire Line
	9250 5950 9250 5600
Wire Wire Line
	9250 5500 9400 5500
Connection ~ 9900 5950
Wire Wire Line
	9900 5950 9900 6000
Wire Wire Line
	9400 5600 9250 5600
Connection ~ 9250 5600
Wire Wire Line
	9250 5600 9250 5500
Wire Wire Line
	7850 4800 8100 4800
Text GLabel 8100 4800 2    50   Input ~ 0
~PIN97_INT
Wire Wire Line
	10400 4700 10650 4700
Wire Wire Line
	9400 4700 9300 4700
Wire Wire Line
	6850 4800 6750 4800
Text GLabel 6750 4800 0    50   Input ~ 0
~INT_5V
Wire Wire Line
	4300 5100 4200 5100
Text GLabel 5550 4800 2    50   Input ~ 0
~RD_5V
Text GLabel 5550 4900 2    50   Input ~ 0
~WR_5V
Text GLabel 5550 5000 2    50   Input ~ 0
~IORQ_5V
Text GLabel 5550 5200 2    50   Input ~ 0
~M1_5V
Wire Wire Line
	5300 5300 5550 5300
Wire Wire Line
	5300 5100 5550 5100
Text GLabel 5550 5300 2    50   Input ~ 0
~PIO_CS_5V
Text GLabel 5550 5100 2    50   Input ~ 0
~FDC_CS_5V
Text GLabel 4200 4800 0    50   Input ~ 0
~PIN59_RD
Text GLabel 4200 4900 0    50   Input ~ 0
~PIN60_WR
Text GLabel 4200 5000 0    50   Input ~ 0
~PIN63_IORQ
Text GLabel 4200 5200 0    50   Input ~ 0
~PIN57_M1
Text GLabel 4200 5300 0    50   Input ~ 0
~PIN58_PIO_CS
Text GLabel 4200 5100 0    50   Input ~ 0
~PIN64_FDC_CS
Wire Wire Line
	10400 4600 10650 4600
Text GLabel 9300 4600 0    50   Input ~ 0
PIN103_TX
Text GLabel 10650 4600 2    50   Input ~ 0
TX_5V
Text GLabel 9300 4700 0    50   Input ~ 0
RX_5V
Text GLabel 10650 4700 2    50   Input ~ 0
PIN101_RX
Wire Wire Line
	6850 4900 6750 4900
Wire Wire Line
	7850 4900 8100 4900
Text GLabel 6750 4900 0    50   Input ~ 0
~PIN71_CTC_CS
Text GLabel 8100 4900 2    50   Input ~ 0
~CTC_CS_5V
Wire Wire Line
	9400 5200 9350 5200
Text GLabel 9350 5200 0    50   Input ~ 0
PIN7_TAPE_DRIVE
Wire Wire Line
	10400 5200 10650 5200
Text GLabel 10650 5200 2    50   Input ~ 0
TAPE_DRIVE_5V
Wire Wire Line
	9400 4800 9300 4800
Text GLabel 9300 4800 0    50   Input ~ 0
TXBAUDCLK_5V
Wire Wire Line
	9400 4900 9300 4900
Text GLabel 9300 4900 0    50   Input ~ 0
RXBAUDCLK_5V
Wire Wire Line
	10400 4800 10650 4800
Text GLabel 10650 4800 2    50   Input ~ 0
PIN94_TXBAUDCLK
Wire Wire Line
	10400 4900 10650 4900
Text GLabel 10650 4900 2    50   Input ~ 0
PIN93_RXBAUDCLK
Wire Wire Line
	7850 5100 8100 5100
Text GLabel 8100 5100 2    50   Input ~ 0
PORTE4_WR_5V
Wire Wire Line
	6850 5100 6750 5100
Text GLabel 6750 5100 0    50   Input ~ 0
PIN70_PORTE4_WR
Wire Wire Line
	6850 4700 6750 4700
Text GLabel 6750 4700 0    50   Input ~ 0
~PIN72_IO_RESET
Text GLabel 8100 4700 2    50   Input ~ 0
~IO_RESET_5V
Wire Wire Line
	10400 5000 10650 5000
Text GLabel 10650 5000 2    50   Input ~ 0
~PIN22_IN_READY
Wire Wire Line
	9400 5000 9300 5000
Text GLabel 9300 5000 0    50   Input ~ 0
~READY_5V
$Comp
L Device:C C?
U 1 1 6013003B
P 6800 1350
AR Path="/62588EF4/6013003B" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/6013003B" Ref="C7"  Part="1" 
F 0 "C7" H 6915 1396 50  0000 L CNN
F 1 "0.1u" H 6915 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 6838 1200 50  0001 C CNN
F 3 "~" H 6800 1350 50  0001 C CNN
	1    6800 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60130041
P 7200 1350
AR Path="/62588EF4/60130041" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/60130041" Ref="C11"  Part="1" 
F 0 "C11" H 7315 1396 50  0000 L CNN
F 1 "0.1u" H 7315 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 7238 1200 50  0001 C CNN
F 3 "~" H 7200 1350 50  0001 C CNN
	1    7200 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60130047
P 7600 1350
AR Path="/62588EF4/60130047" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/60130047" Ref="C4"  Part="1" 
F 0 "C4" H 7715 1396 50  0000 L CNN
F 1 "0.1u" H 7715 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 7638 1200 50  0001 C CNN
F 3 "~" H 7600 1350 50  0001 C CNN
	1    7600 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 6013004D
P 8000 1350
AR Path="/62588EF4/6013004D" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/6013004D" Ref="C22"  Part="1" 
F 0 "C22" H 8115 1396 50  0000 L CNN
F 1 "0.1u" H 8115 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 8038 1200 50  0001 C CNN
F 3 "~" H 8000 1350 50  0001 C CNN
	1    8000 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60130053
P 8400 1350
AR Path="/62588EF4/60130053" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/60130053" Ref="C17"  Part="1" 
F 0 "C17" H 8515 1396 50  0000 L CNN
F 1 "0.1u" H 8515 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 8438 1200 50  0001 C CNN
F 3 "~" H 8400 1350 50  0001 C CNN
	1    8400 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60130059
P 8800 1350
AR Path="/62588EF4/60130059" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/60130059" Ref="C30"  Part="1" 
F 0 "C30" H 8915 1396 50  0000 L CNN
F 1 "0.1u" H 8915 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 8838 1200 50  0001 C CNN
F 3 "~" H 8800 1350 50  0001 C CNN
	1    8800 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 6013005F
P 9200 1350
AR Path="/62588EF4/6013005F" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/6013005F" Ref="C6"  Part="1" 
F 0 "C6" H 9315 1396 50  0000 L CNN
F 1 "0.1u" H 9315 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 9238 1200 50  0001 C CNN
F 3 "~" H 9200 1350 50  0001 C CNN
	1    9200 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60130065
P 9600 1350
AR Path="/62588EF4/60130065" Ref="C?"  Part="1" 
AR Path="/5FC86EA5/60130065" Ref="C19"  Part="1" 
F 0 "C19" H 9715 1396 50  0000 L CNN
F 1 "0.1u" H 9715 1305 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W2.0mm_P2.50mm" H 9638 1200 50  0001 C CNN
F 3 "~" H 9600 1350 50  0001 C CNN
	1    9600 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6013006B
P 6800 1650
AR Path="/5FC87A4E/6013006B" Ref="#PWR?"  Part="1" 
AR Path="/62588EF4/6013006B" Ref="#PWR?"  Part="1" 
AR Path="/5FC86EA5/6013006B" Ref="#PWR036"  Part="1" 
F 0 "#PWR036" H 6800 1400 50  0001 C CNN
F 1 "GND" H 6805 1477 50  0000 C CNN
F 2 "" H 6800 1650 50  0001 C CNN
F 3 "" H 6800 1650 50  0001 C CNN
	1    6800 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6800 1200 6800 1150
Wire Wire Line
	6800 1500 6800 1550
Wire Wire Line
	6800 1550 7200 1550
Wire Wire Line
	9600 1550 9600 1500
Connection ~ 6800 1550
Wire Wire Line
	6800 1550 6800 1650
Wire Wire Line
	9600 1200 9600 1150
Wire Wire Line
	9600 1150 9200 1150
Connection ~ 6800 1150
Wire Wire Line
	6800 1150 6800 1050
Wire Wire Line
	7200 1150 7200 1200
Connection ~ 7200 1150
Wire Wire Line
	7200 1150 6800 1150
Wire Wire Line
	7600 1200 7600 1150
Connection ~ 7600 1150
Wire Wire Line
	7600 1150 7200 1150
Wire Wire Line
	8000 1200 8000 1150
Connection ~ 8000 1150
Wire Wire Line
	8000 1150 7600 1150
Wire Wire Line
	8400 1200 8400 1150
Connection ~ 8400 1150
Wire Wire Line
	8400 1150 8000 1150
Wire Wire Line
	8800 1200 8800 1150
Connection ~ 8800 1150
Wire Wire Line
	8800 1150 8400 1150
Wire Wire Line
	9200 1200 9200 1150
Connection ~ 9200 1150
Wire Wire Line
	9200 1150 8800 1150
Wire Wire Line
	9200 1500 9200 1550
Connection ~ 9200 1550
Wire Wire Line
	9200 1550 9600 1550
Wire Wire Line
	8800 1500 8800 1550
Connection ~ 8800 1550
Wire Wire Line
	8800 1550 9200 1550
Wire Wire Line
	8400 1500 8400 1550
Connection ~ 8400 1550
Wire Wire Line
	8400 1550 8800 1550
Wire Wire Line
	8000 1500 8000 1550
Connection ~ 8000 1550
Wire Wire Line
	8000 1550 8400 1550
Wire Wire Line
	7600 1500 7600 1550
Connection ~ 7600 1550
Wire Wire Line
	7600 1550 8000 1550
Wire Wire Line
	7200 1500 7200 1550
Connection ~ 7200 1550
Wire Wire Line
	7200 1550 7600 1550
$Comp
L power:+3.3V #PWR035
U 1 1 60139D5E
P 6800 1050
F 0 "#PWR035" H 6800 900 50  0001 C CNN
F 1 "+3.3V" H 6815 1223 50  0000 C CNN
F 2 "" H 6800 1050 50  0001 C CNN
F 3 "" H 6800 1050 50  0001 C CNN
	1    6800 1050
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C32
U 1 1 6013C2F5
P 10000 1350
F 0 "C32" H 10088 1396 50  0000 L CNN
F 1 "10u" H 10088 1305 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 10000 1350 50  0001 C CNN
F 3 "~" H 10000 1350 50  0001 C CNN
	1    10000 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 1150 10000 1150
Wire Wire Line
	10000 1150 10000 1250
Connection ~ 9600 1150
Wire Wire Line
	9600 1550 10000 1550
Wire Wire Line
	10000 1550 10000 1450
Connection ~ 9600 1550
Wire Wire Line
	5300 5000 5550 5000
$Comp
L Device:R R5
U 1 1 601BB8EF
P 1450 4350
F 0 "R5" H 1520 4396 50  0000 L CNN
F 1 "10k" H 1520 4305 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 1380 4350 50  0001 C CNN
F 3 "~" H 1450 4350 50  0001 C CNN
	1    1450 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	1450 5600 1450 4500
Connection ~ 1450 5600
Wire Wire Line
	1450 4200 2050 4200
Connection ~ 2050 4200
Text Notes 750  4250 0    50   ~ 0
Pullup is data-sheet\nrecommendation to keep\nthe outputs tristated during\npower-up.
Text Notes 4250 6400 0    50   ~ 0
74LVC244 required for level translation in 5V -> 3V3 direction. Not\nrequired for 3V3 -> 5V direction but used as buffers for some signals .
Text Notes 7100 6950 0    98   ~ 20
RAM, data-bus buffer (and level translator)\nmisc. level-translators/buffers
Wire Wire Line
	4300 4600 4200 4600
Text GLabel 4200 4600 0    50   Input ~ 0
INTRQ_5V
Wire Wire Line
	6850 5000 6750 5000
Text GLabel 6750 5000 0    50   Input ~ 0
DRQ_5V
Wire Wire Line
	5300 4600 5550 4600
Text GLabel 5550 4600 2    50   Input ~ 0
PIN88_IN_INTRQ
Wire Wire Line
	7850 5000 8100 5000
Text GLabel 8100 5000 2    50   Input ~ 0
PIN91_IN_DRQ
Wire Wire Line
	10400 5300 10650 5300
Text GLabel 10650 5300 2    50   Input ~ 0
~PIN99_KBDRST
Wire Wire Line
	9400 5300 9300 5300
Text GLabel 9300 5300 0    50   Input ~ 0
~KBDRST_5V
Wire Wire Line
	9400 5100 9350 5100
Text GLabel 9350 5100 0    50   Input ~ 0
~KBDCLK_5V
Wire Wire Line
	10400 5100 10650 5100
Text GLabel 10650 5100 2    50   Input ~ 0
~PIN100_KBDCLK
Wire Wire Line
	9300 4600 9400 4600
$Comp
L Device:R R10
U 1 1 602F32C1
P 8150 4250
F 0 "R10" V 8250 4300 50  0000 L CNN
F 1 "33R" V 8250 4100 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 8080 4250 50  0001 C CNN
F 3 "~" H 8150 4250 50  0001 C CNN
	1    8150 4250
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R19
U 1 1 6033DFDB
P 5600 4250
F 0 "R19" V 5700 4300 50  0000 L CNN
F 1 "33R" V 5700 4100 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 5530 4250 50  0001 C CNN
F 3 "~" H 5600 4250 50  0001 C CNN
	1    5600 4250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5350 4700 5350 4250
Wire Wire Line
	5350 4250 5450 4250
Wire Wire Line
	7850 4700 8100 4700
Wire Wire Line
	5300 4700 5350 4700
Text Notes 9950 1750 0    50   ~ 0
Near\nSDcard
$Comp
L Device:CP_Small C3
U 1 1 60433BB3
P 10400 1350
F 0 "C3" H 10488 1396 50  0000 L CNN
F 1 "10u" H 10488 1305 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 10400 1350 50  0001 C CNN
F 3 "~" H 10400 1350 50  0001 C CNN
	1    10400 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	10400 1150 10400 1250
Wire Wire Line
	10400 1550 10400 1450
$Comp
L Device:CP_Small C2
U 1 1 60440715
P 10800 1350
F 0 "C2" H 10888 1396 50  0000 L CNN
F 1 "10u" H 10888 1305 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 10800 1350 50  0001 C CNN
F 3 "~" H 10800 1350 50  0001 C CNN
	1    10800 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	10800 1150 10800 1250
Wire Wire Line
	10800 1550 10800 1450
Wire Wire Line
	10400 1150 10000 1150
Connection ~ 10000 1150
Wire Wire Line
	10400 1550 10000 1550
Connection ~ 10000 1550
Wire Wire Line
	10800 1150 10400 1150
Connection ~ 10400 1150
Wire Wire Line
	10800 1550 10400 1550
Connection ~ 10400 1550
Wire Wire Line
	7900 4250 8000 4250
Wire Wire Line
	7850 5300 7900 5300
Wire Wire Line
	7900 4250 7900 5300
$EndSCHEMATC
