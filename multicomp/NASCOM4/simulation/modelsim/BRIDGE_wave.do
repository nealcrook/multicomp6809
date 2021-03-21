onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nascom4/vduffd0
add wave -noupdate /nascom4/n_reset
add wave -noupdate /nascom4/clk
add wave -noupdate /nascom4/n_MREQ
add wave -noupdate /nascom4/n_IORQ
add wave -noupdate /nascom4/n_WAIT
add wave -noupdate /nascom4/n_M1
add wave -noupdate /nascom4/n_RD
add wave -noupdate /nascom4/n_WR
add wave -noupdate -radix hexadecimal /nascom4/sRamData
add wave -noupdate -radix hexadecimal /nascom4/sRamAddress
add wave -noupdate /nascom4/n_sRamWE
add wave -noupdate /nascom4/n_sRamCS
add wave -noupdate /nascom4/n_sRamCS2
add wave -noupdate /nascom4/n_sRamOE
add wave -noupdate -radix hexadecimal /nascom4/cpuAddress
add wave -noupdate -radix hexadecimal /nascom4/cpuDataOut
add wave -noupdate -radix hexadecimal /nascom4/cpuDataIn
add wave -noupdate -radix hexadecimal /nascom4/UartDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasRomDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasWSRamDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasLocalIODataOut
add wave -noupdate -radix hexadecimal /nascom4/VDURamDataOut
add wave -noupdate -radix hexadecimal /nascom4/vfcRomDataOut
add wave -noupdate -radix hexadecimal /nascom4/sbootRomDataOut
add wave -noupdate /nascom4/n_nasWSRamCS
add wave -noupdate /nascom4/n_nasVidRamCS
add wave -noupdate /nascom4/n_nasRomCS
add wave -noupdate /nascom4/n_vfcVidRamCS
add wave -noupdate /nascom4/n_vfcRomCS
add wave -noupdate /nascom4/n_sbootRomCS
add wave -noupdate /nascom4/cpuClock
add wave -noupdate /nascom4/n_HALT
add wave -noupdate /nascom4/wren_nasWSRam
add wave -noupdate -radix hexadecimal /nascom4/portE4wr
add wave -noupdate -radix hexadecimal /nascom4/portE8wr
add wave -noupdate /nascom4/n_WR_uart
add wave -noupdate /nascom4/n_RD_uart
add wave -noupdate /nascom4/n_NMI
add wave -noupdate /nascom4/n_memWr
add wave -noupdate /nascom4/n_reset
add wave -noupdate /nascom4/n_reset_s1
add wave -noupdate /nascom4/n_reset_s2
add wave -noupdate /nascom4/n_reset_clean
add wave -noupdate /nascom4/reset_jump
add wave -noupdate /nascom4/post_reset_rd_cnt
add wave -noupdate /nascom4/SBootRomState
add wave -noupdate /nascom4/ioprd18
add wave -noupdate /nascom4/br1/n_reset
add wave -noupdate /nascom4/br1/clk
add wave -noupdate /nascom4/br1/n_M1
add wave -noupdate /nascom4/cpu1/RFSH_n
add wave -noupdate /nascom4/cpu1/INT_n
add wave -noupdate /nascom4/br1/n_IORQ
add wave -noupdate /nascom4/br1/n_MREQ
add wave -noupdate /nascom4/br1/n_RD
add wave -noupdate /nascom4/br1/n_WR
add wave -noupdate /nascom4/br1/n_WAIT
add wave -noupdate /nascom4/br1/stall_bridge_a
add wave -noupdate /nascom4/br1/mstall_a
add wave -noupdate /nascom4/br1/stall_e
add wave -noupdate /nascom4/br1/stall_cnt
add wave -noupdate /nascom4/br1/bridgeDone
add wave -noupdate -radix hexadecimal /nascom4/br1/cpuWrData
add wave -noupdate -radix hexadecimal /nascom4/br1/cpuRdData
add wave -noupdate -radix hexadecimal /nascom4/br1/BridgeRdData
add wave -noupdate /nascom4/br1/IntAckCycle
add wave -noupdate /nascom4/br1/iastate
add wave -noupdate /nascom4/br1/RetiCycle
add wave -noupdate /nascom4/br1/rstate
add wave -noupdate -radix hexadecimal /nascom4/br1/addr
add wave -noupdate /nascom4/br1/clkCount
add wave -noupdate /nascom4/br1/clk4t1h
add wave -noupdate /nascom4/br1/clk4t1l
add wave -noupdate /nascom4/br1/clk4t2h
add wave -noupdate /nascom4/br1/clk4t2l
add wave -noupdate /nascom4/br1/clk4
add wave -noupdate /nascom4/br1/clk1
add wave -noupdate /nascom4/br1/pio_cs_n
add wave -noupdate /nascom4/br1/ctc_cs_n
add wave -noupdate /nascom4/br1/fdc_cs_n
add wave -noupdate /nascom4/br1/port00_rd_n
add wave -noupdate /nascom4/br1/porte4_wr
add wave -noupdate /nascom4/br1/BrReset_n
add wave -noupdate /nascom4/br1/BrM1_n
add wave -noupdate /nascom4/br1/BrIORQ_n
add wave -noupdate /nascom4/br1/BrRD_n
add wave -noupdate /nascom4/br1/BrWR_n
add wave -noupdate /nascom4/br1/BrBufOE_n
add wave -noupdate /nascom4/br1/BrBufWr
add wave -noupdate /nascom4/br1/state
add wave -noupdate /nascom4/br1/stateCount
add wave -noupdate /nascom4/br1/bridgeIOCycle
add wave -noupdate /nascom4/br1/e_pio_cs_n
add wave -noupdate /nascom4/br1/e_ctc_cs_n
add wave -noupdate /nascom4/br1/e_fdc_cs_n
add wave -noupdate /nascom4/br1/e_port00_rd_n
add wave -noupdate /nascom4/br1/e_porte4_wr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {26240000 ps} 1} {{Cursor 3} {26039812 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 271
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {28598515 ps} {30600079 ps}
