-- Copyright (C) 1991-2009 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 222 10/21/2009 SJ Full Version"
-- CREATED		"Tue Mar 01 17:33:03 2011"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY keyboard IS 
	PORT
	(
		RESET :  IN  STD_LOGIC;
		GCLKP1 :  IN  STD_LOGIC;
		ROW :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		COL :  OUT  STD_LOGIC_VECTOR(0 TO 3);
		DIGIT :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		LED :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		Light :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END keyboard;

ARCHITECTURE bdf_type OF keyboard IS 

COMPONENT frequency
	PORT(RESET : IN STD_LOGIC;
		 GCLKP1 : IN STD_LOGIC;
		 ClockScan : OUT STD_LOGIC;
		 KeyScan : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT key44
GENERIC (
			);
	PORT(sys_clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 row : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 valid : OUT STD_LOGIC;
		 code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 col : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT led8
	PORT(RESET : IN STD_LOGIC;
		 ClockScan : IN STD_LOGIC;
		 LED1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED6 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 LED8 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 DigitSelect : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 LEDOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		 light : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	ClockScan :  STD_LOGIC;
SIGNAL	KeyScan :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : frequency
PORT MAP(RESET => RESET,
		 GCLKP1 => GCLKP1,
		 ClockScan => ClockScan,
		 KeyScan => KeyScan);


b2v_inst1 : key44
GENERIC MAP(
			)
PORT MAP(sys_clk => KeyScan,
		 rst => RESET,
		 row => ROW,
		 code => SYNTHESIZED_WIRE_8,
		 col => COL);


b2v_inst7 : led8
PORT MAP(RESET => RESET,
		 ClockScan => ClockScan,
		 LED1 => SYNTHESIZED_WIRE_8,
		 LED2 => SYNTHESIZED_WIRE_8,
		 LED3 => SYNTHESIZED_WIRE_8,
		 LED4 => SYNTHESIZED_WIRE_8,
		 LED5 => SYNTHESIZED_WIRE_8,
		 LED6 => SYNTHESIZED_WIRE_8,
		 LED7 => SYNTHESIZED_WIRE_8,
		 LED8 => SYNTHESIZED_WIRE_8,
		 DigitSelect => DIGIT,
		 LEDOut => LED,
		 light => Light);


END bdf_type;