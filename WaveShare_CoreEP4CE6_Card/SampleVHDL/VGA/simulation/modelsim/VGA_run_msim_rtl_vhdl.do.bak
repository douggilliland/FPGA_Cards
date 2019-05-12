transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/xiaoguang/FPGA data/FPGA receive/FPGA/VHDL/VGA/VGA.vhd}

vlog -vlog01compat -work work +incdir+D:/xiaoguang/FPGA\ data/FPGA\ receive/FPGA/VHDL/VGA/simulation/modelsim {D:/xiaoguang/FPGA data/FPGA receive/FPGA/VHDL/VGA/simulation/modelsim/VGA.vt}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneiii -L rtl_work -L work -voptargs="+acc" VGA_vlg_tst

add wave *
view structure
view signals
run -all
