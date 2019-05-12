# Copyright (C) 1991-2009 Altera Corporation
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
# File: VGA.tcl
# Generated on: Wed Jan 13 21:20:15 2010

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "VGA"]} {
		puts "Project VGA is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists VGA]} {
		project_open -revision VGA VGA
	} else {
		project_new -revision VGA VGA
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone III"
	set_global_assignment -name DEVICE EP3C25Q240C8
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 5.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "14:55:29  MARCH 29, 2009"
	set_global_assignment -name LAST_QUARTUS_VERSION "9.0 SP2"
	set_global_assignment -name VHDL_FILE VGA.vhd
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz"
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz" -section_id GCLKP1
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz" -section_id GCLKP2
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name CYCLONEIII_CONFIGURATION_DEVICE EPCS16
	set_global_assignment -name FORCE_CONFIGURATION_VCCIO ON
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"
	set_global_assignment -name MISC_FILE "C:/Documents and Settings/Administrator/×ÀÃæ/EP3C16_VHDL/VGA/VGA.dpf"
	set_global_assignment -name ENABLE_ADVANCED_IO_TIMING ON
	set_global_assignment -name ENABLE_SIGNALTAP ON
	set_global_assignment -name USE_SIGNALTAP_FILE stp1.stp
	set_global_assignment -name VERILOG_FILE VGA.v
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 8
	set_global_assignment -name MISC_FILE "F:/ICDev/EP3C25/EP3C25_Program/EP3C25_VHDL/VGA/VGA.dpf"
	set_location_assignment PIN_145 -to RESET
	set_location_assignment PIN_151 -to GCLKP1
	set_location_assignment PIN_152 -to GCLKP2
	set_location_assignment PIN_109 -to HS
	set_location_assignment PIN_108 -to VS
	set_location_assignment PIN_107 -to B[0]
	set_location_assignment PIN_106 -to B[1]
	set_location_assignment PIN_103 -to B[2]
	set_location_assignment PIN_100 -to B[3]
	set_location_assignment PIN_99 -to G[0]
	set_location_assignment PIN_98 -to G[1]
	set_location_assignment PIN_95 -to G[2]
	set_location_assignment PIN_94 -to G[3]
	set_location_assignment PIN_93 -to R[0]
	set_location_assignment PIN_88 -to R[1]
	set_location_assignment PIN_87 -to R[2]
	set_location_assignment PIN_84 -to R[3]
	set_instance_assignment -name CLOCK_SETTINGS GCLKP1 -to GCLKP1
	set_instance_assignment -name CLOCK_SETTINGS GCLKP2 -to GCLKP2

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
