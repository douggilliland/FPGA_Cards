// Copyright (C) 1991-2009 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II"
// VERSION		"Version 9.1 Build 222 10/21/2009 SJ Full Version"
// CREATED		"Tue Mar 01 17:21:41 2011"

module keyboard(
	RESET,
	GCLKP1,
	ROW,
	COL,
	DIGIT,
	LED,
	Light
);


input	RESET;
input	GCLKP1;
input	[3:0] ROW;
output	[0:3] COL;
output	[2:0] DIGIT;
output	[7:0] LED;
output	[7:0] Light;

wire	ClockScan;
wire	KeyScan;
wire	[3:0] SYNTHESIZED_WIRE_0;





Frequency	b2v_inst(
	.RESET(RESET),
	.GCLKP1(GCLKP1),
	.ClockScan(ClockScan),
	.KeyScan(KeyScan));


key44	b2v_inst1(
	.sys_clk(KeyScan),
	.rst(RESET),
	.row(ROW),
	
	.code(SYNTHESIZED_WIRE_0),
	.col(COL));


LED8	b2v_inst6(
	.RESET(RESET),
	.ClockScan(ClockScan),
	.LED0(SYNTHESIZED_WIRE_0),
	.DigitSelect(DIGIT),
	.LEDOut(LED),
	.light(Light));


endmodule
