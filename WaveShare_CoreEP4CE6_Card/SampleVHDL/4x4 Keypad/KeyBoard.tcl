# Copyright (C) 1991-2008 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: KeyBoard.tcl
# Generated on: Sun Apr 04 22:44:11 2010

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "KeyBoard"]} {
		puts "Project KeyBoard is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists KeyBoard]} {
		project_open -revision KeyBoard KeyBoard
	} else {
		project_new -revision KeyBoard KeyBoard
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone III"
	set_global_assignment -name DEVICE EP3C25Q240C8
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 5.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "17:13:06  MARCH 28, 2009"
	set_global_assignment -name LAST_QUARTUS_VERSION 8.0
	set_global_assignment -name VHDL_FILE Frequency.vhd
	set_global_assignment -name VERILOG_FILE key44.v
	set_global_assignment -name VHDL_FILE LED8.vhd
	set_global_assignment -name BDF_FILE KeyBoard.bdf
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz"
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz" -section_id GCLKP1
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_global_assignment -name CYCLONEIII_CONFIGURATION_DEVICE EPCS4
	set_global_assignment -name FORCE_CONFIGURATION_VCCIO ON
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"
	set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
	set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
	set_global_assignment -name MISC_FILE "C:/Documents and Settings/Administrator/×ÀÃæ/EP3C16_VHDL/KeyBoard/KeyBoard.dpf"
	set_global_assignment -name MISC_FILE "F:/ICDev/EP3C25/EP3C25_Program/EP3C25_VHDL/KeyBoard/KeyBoard.dpf"
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 240
	set_instance_assignment -name CLOCK_SETTINGS GCLKP1 -to GCLKP1

	# RESET
	set_location_assignment PIN_145 -to RESET
	
	# SYS CLK
	set_location_assignment PIN_151 -to GCLKP1
	
	# KEY
	set_location_assignment PIN_161 -to COL\[3\]
	set_location_assignment PIN_160 -to COL\[2\]
	set_location_assignment PIN_159 -to COL\[1\]
	set_location_assignment PIN_148 -to COL\[0\]
	
	set_location_assignment PIN_162 -to ROW\[3\]
	set_location_assignment PIN_164 -to ROW\[2\]
	set_location_assignment PIN_166 -to ROW\[1\]
	set_location_assignment PIN_167 -to ROW\[0\]	
	
	# 7 SEG LED
	set_location_assignment PIN_81 -to DIGIT\[2\]
	set_location_assignment PIN_80 -to DIGIT\[1\]
	set_location_assignment PIN_78 -to DIGIT\[0\]
	
	set_location_assignment PIN_72 -to LED\[7\]	
	set_location_assignment PIN_76 -to LED\[6\]	
	set_location_assignment PIN_68 -to LED\[5\]	
	set_location_assignment PIN_70 -to LED\[4\]
	set_location_assignment PIN_71 -to LED\[3\]	
	set_location_assignment PIN_73 -to LED\[2\]	
	set_location_assignment PIN_65 -to LED\[1\]	
	set_location_assignment PIN_69 -to LED\[0\]
	
	# LED
	set_location_assignment PIN_110 -to Light\[7\]	
	set_location_assignment PIN_111 -to Light\[6\]	
	set_location_assignment PIN_112 -to Light\[5\]	
	set_location_assignment PIN_113 -to Light\[4\]
	set_location_assignment PIN_114 -to Light\[3\]	
	set_location_assignment PIN_117 -to Light\[2\]	
	set_location_assignment PIN_118 -to Light\[1\]	
	set_location_assignment PIN_119 -to Light\[0\]


	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
