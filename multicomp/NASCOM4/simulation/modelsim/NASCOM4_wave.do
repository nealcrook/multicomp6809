onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /nascom4/n_reset
add wave -noupdate /nascom4/clk
add wave -noupdate /nascom4/n_MREQ
add wave -noupdate /nascom4/n_IORQ
add wave -noupdate /nascom4/n_M1
add wave -noupdate /nascom4/n_RD
add wave -noupdate /nascom4/n_WR
add wave -noupdate -radix hexadecimal /nascom4/sRamData
add wave -noupdate -radix hexadecimal /nascom4/sRamAddress
add wave -noupdate /nascom4/vduffd0
add wave -noupdate -radix hexadecimal /nascom4/cpuAddress
add wave -noupdate -radix hexadecimal /nascom4/cpuDataOut
add wave -noupdate -radix hexadecimal /nascom4/cpuDataIn
add wave -noupdate -radix hexadecimal /nascom4/nasRomDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasWSRamDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasVidRamDataOut
add wave -noupdate -radix hexadecimal /nascom4/nasLocalIODataOut
add wave -noupdate /nascom4/n_nasWSRamCS
add wave -noupdate /nascom4/n_nasVidRamCS
add wave -noupdate /nascom4/n_nasRomCS
add wave -noupdate /nascom4/cpuClock
add wave -noupdate /nascom4/n_HALT
add wave -noupdate /nascom4/wren_nasWSRam
add wave -noupdate /nascom4/wren_nasVidRam
add wave -noupdate -radix hexadecimal /nascom4/port00wr
add wave -noupdate -radix hexadecimal /nascom4/portE4wr
add wave -noupdate -radix hexadecimal /nascom4/portE8wr
add wave -noupdate -radix hexadecimal /nascom4/portECwr
add wave -noupdate /nascom4/video_map80vfc
add wave -noupdate -radix hexadecimal /nascom4/portFEwr
add wave -noupdate -radix hexadecimal /nascom4/uartcnt
add wave -noupdate -radix hexadecimal /nascom4/port01rd
add wave -noupdate -radix hexadecimal /nascom4/port02rd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 230
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
WaveRestoreZoom {0 ps} {80745 ns}
