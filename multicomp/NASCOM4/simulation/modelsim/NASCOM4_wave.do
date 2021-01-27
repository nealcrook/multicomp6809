onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nascom4/vduffd0
add wave -noupdate /nascom4/stall_a
add wave -noupdate /nascom4/stall_s
add wave -noupdate /nascom4/stall_cnt
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
add wave -noupdate /nascom4/n_UartCS
add wave -noupdate /nascom4/n_WR_uart
add wave -noupdate /nascom4/n_RD_uart
add wave -noupdate -radix hexadecimal /nascom4/uartcnt
add wave -noupdate /nascom4/n_NMI
add wave -noupdate /nascom4/nmi_state
add wave -noupdate /nascom4/n_memWr
add wave -noupdate /nascom4/video_map80vfc
add wave -noupdate /nascom4/iopwrECVfcPage
add wave -noupdate /nascom4/iopwrECRomEnable
add wave -noupdate /nascom4/iopwrECRamEnable
add wave -noupdate -radix hexadecimal /nascom4/io1/charAddr
add wave -noupdate /nascom4/io1/hSync
add wave -noupdate /nascom4/io1/vSync
add wave -noupdate -radix hexadecimal /nascom4/io1/addr
add wave -noupdate /nascom4/n_reset
add wave -noupdate /nascom4/n_reset_s1
add wave -noupdate /nascom4/n_reset_s2
add wave -noupdate /nascom4/n_reset_clean
add wave -noupdate /nascom4/reset_jump
add wave -noupdate /nascom4/post_reset_rd_cnt
add wave -noupdate -expand /nascom4/SBootRomState
add wave -noupdate /nascom4/iopwr18SBootRom
add wave -noupdate /nascom4/iopwr18MAP80AutoBoot
add wave -noupdate /nascom4/iopwr18NasSysRom
add wave -noupdate /nascom4/iopwr18NasVidHigh
add wave -noupdate /nascom4/iopwr18NasVidRam
add wave -noupdate /nascom4/ioprd18
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {RET {31667427 ps} 1} {{Cursor 2} {3877920000 ps} 0}
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
WaveRestoreZoom {0 ps} {4305 ns}
