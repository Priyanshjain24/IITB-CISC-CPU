transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/Mux3_8_1.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/alu_3.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/FSMultraProMax.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/DUT.vhdl}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/six_extender.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/shifter.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/register_file.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/reg16.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/reg1.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/nine_extender.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/mux_two_to_one.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/mux_four_to_one.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/mux_eight_to_one.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/Mux16_4to1.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/Mux16_2to1.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/memory.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/datapath.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/clock.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/penc.vhd}
vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/Mux3_2_1.vhd}

vcom -93 -work work {C:/Users/HP/Downloads/iitb-cpu-pro/Testbench.vhdl}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  Testbench

add wave *
view structure
view signals
run -all
