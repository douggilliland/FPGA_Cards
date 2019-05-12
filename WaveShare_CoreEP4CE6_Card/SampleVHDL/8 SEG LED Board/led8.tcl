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
# File: LED8.tcl
# Generated on: Wed Jan 13 21:12:54 2010

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "LED8"]} {
		puts "Project LED8 is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists LED8]} {
		project_open -revision LED8 LED8
	} else {
		project_new -revision LED8 LED8
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone III"
	set_global_assignment -name DEVICE EP3C25Q240C8
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 5.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "16:11:52  MARCH 27, 2009"
	set_global_assignment -name LAST_QUARTUS_VERSION "9.0 SP2"
	set_global_assignment -name VHDL_FILE LED8.vhd
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz"
	set_global_assignment -name FMAX_REQUIREMENT "50 MHz" -section_id GCLKP1
	set_global_assignment -name ANALYZE_LATCHES_AS_SYNCHRONOUS_ELEMENTS OFF
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name NOMINAL_CORE_SUPPLY_VOLTAGE 1.2V
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_global_assignment -name CYCLONEIII_CONFIGURATION_DEVICE EPCS4
	set_global_assignment -name FORCE_CONFIGURATION_VCCIO ON
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED"
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"
	set_global_assignment -name TIMEQUEST_MULTICORNER_ANALYSIS ON
	set_global_assignment -name TIMEQUEST_DO_CCPP_REMOVAL ON
	set_global_assignment -name MISC_FILE "C:/Documents and Settings/Administrator/×ÀÃæ/EP3C16_VHDL/LED8/LED8.dpf"
	set_global_assignment -name MISC_FILE "F:/ICDev/EP3C25/EP3C25_Program/EP3C25_VHDL/LED8/LED8.dpf"
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 240
	set_location_assignment PIN_151 -to GCLKP1
	set_location_assignment PIN_145 -to RESET
	set_instance_assignment -name CLOCK_SETTINGS GCLKP1 -to GCLKP1
	set_location_assignment PIN_78 -to DigitSelect[0]
	set_location_assignment PIN_80 -to DigitSelect[1]
	set_location_assignment PIN_81 -to DigitSelect[2]
	set_location_assignment PIN_69 -to LEDOut[0]
	set_location_assignment PIN_65 -to LEDOut[1]
	set_location_assignment PIN_73 -to LEDOut[2]
	set_location_assignment PIN_71 -to LEDOut[3]
	set_location_assignment PIN_70 -to LEDOut[4]
	set_location_assignment PIN_68 -to LEDOut[5]
	set_location_assignment PIN_76 -to LEDOut[6]
	set_location_assignment PIN_72 -to LEDOut[7]
	set_location_assignment PIN_119 -to light[0]
	set_location_assignment PIN_118 -to light[1]
	set_location_assignment PIN_117 -to light[2]
	set_location_assignment PIN_114 -to light[3]
	set_location_assignment PIN_113 -to light[4]
	set_location_assignment PIN_112 -to light[5]
	set_location_assignment PIN_111 -to light[6]
	set_location_assignment PIN_110 -to light[7]

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
