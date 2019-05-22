## Generated SDC file "VGASDRAM1.sdc"

## Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 15.1.0 Build 185 10/21/2015 SJ Lite Edition"

## DATE    "Tue May 10 19:32:30 2016"

##
## DEVICE  "EP4CE6E22C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.833 -waveform { 0.000 10.416 } [get_ports {clk}]
create_clock -name {sclk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {sclk}]
create_clock -name {vclk} -period 41.667 -waveform { 0.000 20.833 } 


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {ipll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {ipll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 25 -divide_by 12 -master_clock {clk} [get_pins {ipll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {vpll:ivpll|altpll:altpll_component|vpll_altpll:auto_generated|wire_pll1_clk[0]} -source [get_pins {ivpll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 25 -divide_by 48 -master_clock {clk} [get_pins {ivpll|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[0]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[1]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[2]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[3]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[4]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[5]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[6]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[7]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[8]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[9]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[10]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[11]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[12]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[13]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[14]}]
set_input_delay -add_delay  -clock [get_clocks {ipll|altpll_component|auto_generated|pll1|clk[0]}]  1.000 [get_ports {sdata[15]}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

