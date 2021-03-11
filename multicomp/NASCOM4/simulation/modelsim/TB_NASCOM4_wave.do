onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_nascom4/n_reset
add wave -noupdate /tb_nascom4/clk
add wave -noupdate /tb_nascom4/uut/br1/state
add wave -noupdate /tb_nascom4/uut/br1/clkCount
add wave -noupdate /tb_nascom4/uut/br1/clk4t1h
add wave -noupdate /tb_nascom4/uut/br1/clk4t1l
add wave -noupdate /tb_nascom4/uut/br1/clk4t2h
add wave -noupdate /tb_nascom4/uut/br1/clk4t2l
add wave -noupdate /tb_nascom4/uut/br1/stateCount
add wave -noupdate -radix hexadecimal /tb_nascom4/sRamData
add wave -noupdate -radix hexadecimal /tb_nascom4/sRamData_dly
add wave -noupdate -radix hexadecimal /tb_nascom4/sRamAddress
add wave -noupdate /tb_nascom4/n_sRamWE
add wave -noupdate /tb_nascom4/n_sRamCS
add wave -noupdate /tb_nascom4/n_sRamCS2
add wave -noupdate /tb_nascom4/n_sRamOE
add wave -noupdate /tb_nascom4/clk4
add wave -noupdate /tb_nascom4/clk1
add wave -noupdate /tb_nascom4/BrReset_n
add wave -noupdate /tb_nascom4/BrM1_n
add wave -noupdate /tb_nascom4/BrIORQ_n
add wave -noupdate /tb_nascom4/BrRD_n
add wave -noupdate /tb_nascom4/BrWR_n
add wave -noupdate /tb_nascom4/BrBufOE_n
add wave -noupdate /tb_nascom4/BrBufWr
add wave -noupdate -radix hexadecimal /tb_nascom4/BrData
add wave -noupdate /tb_nascom4/BrAddr
add wave -noupdate /tb_nascom4/pio_cs_n
add wave -noupdate /tb_nascom4/ctc_cs_n
add wave -noupdate /tb_nascom4/fdc_cs_n
add wave -noupdate /tb_nascom4/porte4_wr
add wave -noupdate /tb_nascom4/port00_rd_n
add wave -noupdate -radix hexadecimal -childformat {{/tb_nascom4/ramL(0) -radix hexadecimal} {/tb_nascom4/ramL(1) -radix hexadecimal} {/tb_nascom4/ramL(2) -radix hexadecimal} {/tb_nascom4/ramL(3) -radix hexadecimal} {/tb_nascom4/ramL(4) -radix hexadecimal} {/tb_nascom4/ramL(5) -radix hexadecimal} {/tb_nascom4/ramL(6) -radix hexadecimal} {/tb_nascom4/ramL(7) -radix hexadecimal}} -subitemconfig {/tb_nascom4/ramL(0) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(1) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(2) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(3) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(4) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(5) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(6) {-height 13 -radix hexadecimal} /tb_nascom4/ramL(7) {-height 13 -radix hexadecimal}} /tb_nascom4/ramL
add wave -noupdate -radix hexadecimal -childformat {{/tb_nascom4/ramH(0) -radix hexadecimal} {/tb_nascom4/ramH(1) -radix hexadecimal} {/tb_nascom4/ramH(2) -radix hexadecimal} {/tb_nascom4/ramH(3) -radix hexadecimal} {/tb_nascom4/ramH(4) -radix hexadecimal} {/tb_nascom4/ramH(5) -radix hexadecimal} {/tb_nascom4/ramH(6) -radix hexadecimal} {/tb_nascom4/ramH(7) -radix hexadecimal}} -subitemconfig {/tb_nascom4/ramH(0) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(1) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(2) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(3) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(4) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(5) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(6) {-height 13 -radix hexadecimal} /tb_nascom4/ramH(7) {-height 13 -radix hexadecimal}} /tb_nascom4/ramH
add wave -noupdate -radix hexadecimal -childformat {{/tb_nascom4/fdc(0) -radix hexadecimal} {/tb_nascom4/fdc(1) -radix hexadecimal} {/tb_nascom4/fdc(2) -radix hexadecimal} {/tb_nascom4/fdc(3) -radix hexadecimal}} -subitemconfig {/tb_nascom4/fdc(0) {-height 13 -radix hexadecimal} /tb_nascom4/fdc(1) {-height 13 -radix hexadecimal} /tb_nascom4/fdc(2) {-height 13 -radix hexadecimal} /tb_nascom4/fdc(3) {-height 13 -radix hexadecimal}} /tb_nascom4/fdc
add wave -noupdate -radix hexadecimal /tb_nascom4/kbdbuf
add wave -noupdate -radix hexadecimal /tb_nascom4/drvreg
add wave -noupdate /tb_nascom4/n_LED7
add wave -noupdate /tb_nascom4/n_LED9
add wave -noupdate /tb_nascom4/u_pio/reset
add wave -noupdate /tb_nascom4/u_pio/reg_wr
add wave -noupdate /tb_nascom4/u_pio/reg_rd
add wave -noupdate /tb_nascom4/uut/cpu1/WAIT_n
add wave -noupdate /tb_nascom4/uut/cpu1/INT_n
add wave -noupdate /tb_nascom4/uut/cpu1/NMI_n
add wave -noupdate /tb_nascom4/uut/cpu1/M1_n
add wave -noupdate /tb_nascom4/uut/cpu1/MREQ_n
add wave -noupdate /tb_nascom4/uut/cpu1/IORQ_n
add wave -noupdate /tb_nascom4/uut/cpu1/RD_n
add wave -noupdate /tb_nascom4/uut/cpu1/WR_n
add wave -noupdate /tb_nascom4/uut/cpu1/RFSH_n
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/cpu1/A
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/cpu1/DI
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/cpu1/DO
add wave -noupdate -radix hexadecimal /tb_nascom4/u_pio/a_vector
add wave -noupdate -radix hexadecimal /tb_nascom4/u_pio/a_mode
add wave -noupdate /tb_nascom4/u_pio/a_int
add wave -noupdate /tb_nascom4/u_pio/a_icount
add wave -noupdate /tb_nascom4/u_pio/a_istate
add wave -noupdate -radix hexadecimal /tb_nascom4/u_pio/a_out
add wave -noupdate /tb_nascom4/u_pio/int_n
add wave -noupdate /tb_nascom4/u_pio/iack
add wave -noupdate /tb_nascom4/u_pio/reg_wr
add wave -noupdate /tb_nascom4/u_pio/reg_rd
add wave -noupdate /tb_nascom4/u_pio/ba
add wave -noupdate /tb_nascom4/u_pio/cd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18462348 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 228
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
WaveRestoreZoom {0 ps} {105105 ns}
