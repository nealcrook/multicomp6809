# Hand-created to build into top-level testbench

transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/DisplayRam1K.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/DisplayRam2K.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/nasCharGenRom4K.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/nasCharGenRam4K.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80_ALU.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80_MCode.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80_Pack.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80_Reg.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/SDCARD/sd_controller.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/UART/bufferedUART6402.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasKBDPS2/nasKBDPS2.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasBridge/nasBridge.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/RAMS/InternalRam1K.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/ROMS/Z80/Z80_NASSYS3_ROM.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/ROMS/Z80/Z80_MAP80VFC_ROM.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/ROMS/Z80/Z80_SBOOT_ROM.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/nasVDU_render.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80s.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/Z80/T80.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/Components/nasVDU/nasVDU.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/NASCOM4/NASCOM4.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/NASCOM4/Z80_PIO.vhd}
vcom -93 -work work {/home/crook/retro/multicomp6809/multicomp/NASCOM4/TB_NASCOM4.vhd}

vsim work.tb_nascom4
