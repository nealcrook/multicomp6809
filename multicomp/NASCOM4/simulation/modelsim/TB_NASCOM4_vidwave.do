onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/clk
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/video
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/hSync
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/vSync
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/pixelCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/n_CS
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/n_memWr
add wave -noupdate -radix hexadecimal -childformat {{/tb_nascom4/uut/io1/nas_render/charAddr(11) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(10) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(9) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(8) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(7) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(6) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(5) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(4) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(3) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(2) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(1) -radix hexadecimal} {/tb_nascom4/uut/io1/nas_render/charAddr(0) -radix hexadecimal}} -subitemconfig {/tb_nascom4/uut/io1/nas_render/charAddr(11) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(10) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(9) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(8) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(7) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(6) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(5) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(4) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(3) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(2) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(1) {-height 13 -radix hexadecimal} /tb_nascom4/uut/io1/nas_render/charAddr(0) {-height 13 -radix hexadecimal}} /tb_nascom4/uut/io1/nas_render/charAddr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/charData
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/charDataR
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/vActive
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/hActive
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/pixelClockCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/horizCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/vertLineCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/charVert
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/charScanLine
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/charHoriz
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/cursorVert
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/cursorHoriz
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/dispAddr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/dispCharData
add wave -noupdate /tb_nascom4/uut/io1/nas_render/charAccess
add wave -noupdate /tb_nascom4/uut/io1/nas_render/charClash
add wave -noupdate /tb_nascom4/uut/io1/nas_render/charClashR
add wave -noupdate /tb_nascom4/uut/io1/nas_render/charClashRR
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/cursorOn
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/cursBlinkCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/dispAddr_xx
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/wren
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/addr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/dataIn
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/nas_render/dataOut
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/clk
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/addr
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/n_CS
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/video
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/hSync
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/vSync
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/pixelClockCount
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/n_memWr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/dataIn
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/dataOut
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/charAddr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/charData
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/charDataR
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/vActive
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/hActive
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/pixelCount
add wave -noupdate -radix decimal /tb_nascom4/uut/io1/vfc_render/horizCount
add wave -noupdate -radix decimal /tb_nascom4/uut/io1/vfc_render/vertLineCount
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charVert
add wave -noupdate -radix decimal /tb_nascom4/uut/io1/vfc_render/charScanLine
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charHoriz
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/cursorVert
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/cursorHoriz
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/dispAddr
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/dispCharData
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charAccess
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charClash
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charClashR
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/charClashRR
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/cursorOn
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/cursBlinkCount
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/vfc_render/dispAddr_xx
add wave -noupdate /tb_nascom4/uut/io1/vfc_render/wren
add wave -noupdate /tb_nascom4/uut/io1/fontRom/clock
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/fontRom/address
add wave -noupdate -radix hexadecimal /tb_nascom4/uut/io1/fontRom/q
add wave -noupdate /tb_nascom4/uut/io1/n_charGenCS
add wave -noupdate /tb_nascom4/uut/io1/charGenHigh
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15791759463 ps} 0} {{Cursor 2} {38091106259 ps} 0}
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
WaveRestoreZoom {15782865502 ps} {15800723422 ps}
