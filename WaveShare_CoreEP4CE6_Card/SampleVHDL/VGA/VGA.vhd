---------------------------------------------------------------------------------------------------
--*
--* File                : VGA.vhd
--* Hardware Environment:
--* Build Environment   : Quartus II Version 9.1
--* Version             : 
--* By                  : Su Wei Feng
--*
--*                                  (c) Copyright 2005-2011, WaveShare
--*                                       http://www.waveshare.net
--*                                          All Rights Reserved
--*
---------------------------------------------------------------------------------------------------

-- VHDL library Declarations 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Entity Declarations 
ENTITY VGA IS
	PORT 
	(
		RESET	: IN STD_LOGIC;
		--GCLKP1	: IN STD_LOGIC; 
		GCLKP2	: IN STD_LOGIC; 
		
		-------------------------------------
		-- VGA 
		R : OUT STD_LOGIC;--_VECTOR(3 DOWNTO 0);
		G : OUT STD_LOGIC;--_VECTOR(3 DOWNTO 0);
		B : OUT STD_LOGIC;--_VECTOR(3 DOWNTO 0);
		
		VS : OUT STD_LOGIC; 
		HS : OUT STD_LOGIC
	);
END VGA;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Architecture of Entity Declarations 
ARCHITECTURE Behavioral OF VGA IS
--	SuperVGA timing from NEC monitor manual
--	Horizontal :
--	                ______________                 _____________
--	               |              |               |
--	_______________|  VIDEO       |_______________|  VIDEO (next line)
--	
--	___________   _____________________   ______________________
--	           |_|                     |_|
--	            B C <------D-----><-E->
--	            <----------A---------->
--	
--	
--	Vertical :
--	                ______________                 _____________
--	               |              |               |           
--	_______________|  VIDEO       |_______________|  VIDEO (next frame)
--	
--	___________   _____________________   ______________________
--	           |_|                     |_|
--	            P Q <------R-----><-S->
--	            <----------O---------->
--	
--	For VESA 800*600 @ 60Hz:
--	Fh (kHz) :37.88
--	A  (us)  :26.4
--	B  (us)  :3.2
--	C  (us)  :2.2
--	D  (us)  :20.0
--	E  (us)  :1.0
--	
--	Fv (Hz)  :60.32
--	O  (ms)  :16.579
--	P  (ms)  :0.106
--	Q  (ms)  :0.607
--	R  (ms)  :15.84
--	S  (ms)  :0.026
--	
--	
--	Horizonal timing information:
--	
--	Mode name          Pixel      sync      back  active  front whole line
--	                   clock      pulse     porch  time   porch  period
--	                   (MHz)   (us)  (pix)  (pix)  (pix)  (pix)  (pix)
--	 
--	VGA 800x600 60Hz   40       3.2   128     85    806    37    1056
--	
--	Vertical timing information:
--	Mode name          Lines   line    sync      back        active     front     whole frame
--	                   Total   width   pulse     porch        time      porch        period
--	                           (us)   (us)(lin) (us)(lin)  (us)  (lin)  (us)(lin)  (us)  (lin)
--	
--	VGA 800x600 60Hz    628    26.40  106   4   554   21   15945  604         -1*  16579  628
--	
	------------------------------------------------
--	CONSTANT H_PIXELS		: INTEGER := 806; 	--  806
--	CONSTANT H_FRONTPORCH	: INTEGER := 37; 	--  37
--	CONSTANT H_SYNCTIME		: INTEGER := 128; 	--  128
--	CONSTANT H_BACKPORCH	: INTEGER := 85; 	--  85
--	CONSTANT H_SYNCSTART	: INTEGER := H_PIXELS    + H_FRONTPORCH; 
--	CONSTANT H_SYNCEND		: INTEGER := H_SYNCSTART + H_SYNCTIME; 
--	CONSTANT H_PERIOD		: INTEGER := H_SYNCEND   + H_BACKPORCH; 
--	
--	CONSTANT V_LINES		: INTEGER := 604; 	--  604
--	CONSTANT V_FRONTPORCH	: INTEGER := -1; 	--  -1
--	CONSTANT V_SYNCTIME		: INTEGER := 4; 	--  4
--	CONSTANT V_BACKPORCH	: INTEGER := 21; 	--  21
--	CONSTANT V_SYNCSTART	: INTEGER := V_LINES     + V_FRONTPORCH; 
--	CONSTANT V_SYNCEND		: INTEGER := V_SYNCSTART + V_SYNCTIME; 
--	CONSTANT V_PERIOD		: INTEGER := V_SYNCEND   + V_BACKPORCH; 

	CONSTANT H_PIXELS		: INTEGER := 640; 	--  806
	CONSTANT H_FRONTPORCH	: INTEGER := 16; 	--  37
	CONSTANT H_SYNCTIME		: INTEGER := 96; 	--  128
	CONSTANT H_BACKPORCH	: INTEGER := 48; 	--  85
	CONSTANT H_SYNCSTART	: INTEGER := H_PIXELS    + H_FRONTPORCH; 
	CONSTANT H_SYNCEND		: INTEGER := H_SYNCSTART + H_SYNCTIME; 
	CONSTANT H_PERIOD		: INTEGER := H_SYNCEND   + H_BACKPORCH; 
	
	CONSTANT V_LINES		: INTEGER := 480; 	--  604
	CONSTANT V_FRONTPORCH	: INTEGER := 11; 	--  -1
	CONSTANT V_SYNCTIME		: INTEGER := 2; 	--  4
	CONSTANT V_BACKPORCH	: INTEGER := 32; 	--  21
	CONSTANT V_SYNCSTART	: INTEGER := V_LINES     + V_FRONTPORCH; 
	CONSTANT V_SYNCEND		: INTEGER := V_SYNCSTART + V_SYNCTIME; 
	CONSTANT V_PERIOD		: INTEGER := V_SYNCEND   + V_BACKPORCH; 
	
	------------------------------------------------
	------------------------------------------------
	SIGNAL HsyncB : STD_LOGIC; 
	SIGNAL VsyncB : STD_LOGIC; 
	SIGNAL Hcnt	: STD_LOGIC_VECTOR(9 DOWNTO 0); 
	SIGNAL Vcnt	: STD_LOGIC_VECTOR(9 DOWNTO 0); 
	
	SIGNAL Enable : STD_LOGIC; 
	SIGNAL TempR  : STD_LOGIC; 
	SIGNAL TempG  : STD_LOGIC; 
	SIGNAL TempB  : STD_LOGIC; 
	
	------------------------------------------------
	--Clock: 
	SIGNAL Period1uS, Period1mS: STD_LOGIC;
	
	------------------------------------------------
	SIGNAL Count : STD_LOGIC_VECTOR(2 DOWNTO 0); 
	SIGNAL CLK, CLKTemp : STD_LOGIC; 
BEGIN
	--------------------------------------------------------------------------------------------------
	-- Globle Clock Assignment 
	GlobleClk:PROCESS( RESET, GCLKP2, Period1uS, Period1mS )
		VARIABLE Count  : STD_LOGIC_VECTOR(5 DOWNTO 0);	-- 1MHz 
		VARIABLE Count1 : STD_LOGIC_VECTOR(9 DOWNTO 0);	-- 1KHz 
		VARIABLE Count2 : STD_LOGIC_VECTOR(9 DOWNTO 0);	-- 1Hz 
	BEGIN 
		-----------------------------------------------
		IF( GCLKP2'EVENT AND GCLKP2='1' ) THEN CLK <= NOT CLK; 
		END IF; 
		
		-----------------------------------------------
		--GCLKP : 50MHz 
		--Period: 1uS (Period1uS <= GCLKP1; )
		IF( RESET = '0' ) THEN 
			Count := (OTHERS=>'0');	
		ELSIF( GCLKP2'EVENT AND GCLKP2='1' ) THEN 
			IF( Count>"110000" ) THEN 	Count := (OTHERS=>'0');	-- 1uS 
			ELSE                  		Count := Count + 1;
			END IF;
		END IF; 
		
		Period1uS <= Count(5); 
		-----------------------------------------------
		--Period: 1mS 
		IF( RESET = '0' ) THEN 
			Count1 := (OTHERS=>'0');	
		ELSIF( Period1uS'EVENT AND Period1uS='1' ) THEN 
			IF( Count1>"1111100110" ) THEN 	Count1 := (OTHERS=>'0');	-- 1uS 
			ELSE                  			Count1 := Count1 + 1;
			END IF;
		END IF; 
		
		Period1mS <= Count1(9); 
		-----------------------------------------------
		--Period: 1S 
		IF( RESET = '0' ) THEN 
			Count2 := (OTHERS=>'0');	
		ELSIF( Period1mS'EVENT AND Period1mS='1' ) THEN 
			IF( Count2>"1111100110" ) THEN 	Count2 := (OTHERS=>'0');	-- 1uS 
			ELSE                  			Count2 := Count2 + 1;
			END IF;
		END IF; 
		
		-- 2 Hz 
		CLKTemp <= Count2(8); 
		
	END PROCESS; 
	
	--------------------------------------------------------------------------------------------------
	-- VGA Clock process 
	--------------------------------------------------------------------------------------------------
	-- Horizontal counter 
	PROCESS( RESET, CLK )
	BEGIN 
		IF( RESET='0' ) THEN Hcnt <= (OTHERS=>'0');
		ELSIF( CLK'EVENT AND CLK='1' ) THEN  
			IF( Hcnt<H_PERIOD ) THEN Hcnt <= Hcnt + 1; 
			ELSE 					 Hcnt <= (OTHERS=>'0');
			END IF; 
		END IF; 
	END PROCESS; 
	
	------------------------------------------------

	-- Horizontal Sync 
	PROCESS( RESET, CLK )
	BEGIN
		IF( RESET='0' ) THEN HsyncB <= '1';
		ELSIF( CLK'EVENT AND CLK='1' ) THEN  
			IF( (Hcnt >= H_SYNCSTART) AND (Hcnt < H_SYNCEND) ) THEN 
				HsyncB <= '0';
			ELSE 
				HsyncB <= '1';
			END IF; 
		END IF; 
	END PROCESS; 

	------------------------------------------------
	------------------------------------------------
	-- Vertical counter 
	PROCESS( RESET, HsyncB )
	BEGIN
		IF( RESET='0' ) THEN Vcnt <= (OTHERS=>'0');
		ELSIF( HsyncB'EVENT AND HsyncB='1' ) THEN  
			IF( Vcnt<V_PERIOD ) THEN Vcnt <= Vcnt + 1; 
			ELSE 					 Vcnt <= (OTHERS=>'0');
			END IF; 
		END IF; 
	END PROCESS; 
		
	------------------------------------------------
	-- Vertical Sync 
	PROCESS( RESET, HsyncB )
	BEGIN
		IF( RESET='0' ) THEN VsyncB <= '1';
		ELSIF( HsyncB'EVENT AND HsyncB='1' ) THEN  
			IF( (Vcnt >= V_SYNCSTART) AND (Vcnt < V_SYNCEND) ) THEN 
				VsyncB <= '0';
			ELSE 
				VsyncB <= '1';
			END IF; 
		END IF; 
	END PROCESS; 
	
	HS <= HsyncB; 
	VS <= VsyncB; 
	
	------------------------------------------------
	------------------------------------------------
	-- 
	PROCESS( RESET, CLK, Hcnt, Vcnt )
	BEGIN
		IF( CLK'EVENT AND CLK='1' ) THEN 
			IF	 ( RESET='0' 						) THEN 	Enable <= '0';
			ELSIF( Hcnt>=H_PIXELS OR Vcnt>=V_LINES 	) THEN 	Enable <= '0';
			ELSE 											Enable <= '1';
			END IF; 
		END IF; 
	END PROCESS; 

	------------------------------------------------
	-- 
	PROCESS( RESET, Hcnt, Vcnt, Enable )
		CONSTANT a1: INTEGER := 50;
		CONSTANT a2: INTEGER := 600;
		CONSTANT b1: INTEGER := 100;
		CONSTANT b2: INTEGER := 200;
	BEGIN
		
		IF( Enable='1' ) THEN 
			IF( RESET='0' ) THEN R <= '0'; G <= '0'; B <= '0';
			ELSIF( (Hcnt >= a1) AND (Hcnt < a2) AND (Vcnt >= b1) AND (Vcnt < b2) ) THEN
				R <= '0'; 
				G <= '0'; 
				B <= '1';
			END IF;
		ELSE 
			R <= '0'; 
			G <= '1'; 
			B <= '0';
		END IF;
			
--		IF( Enable='1' ) THEN
--			IF	 ( RESET='0' ) THEN R <= '0'; G <= '0'; B <= '0';
--			ELSE R <= '0'; G <= '0'; B <= '1';
--			END IF;
--		ELSE R <= '0'; G <= '0'; B <= '0';
--		END IF;
	END PROCESS;
	
	------------------------------------------------
--	PROCESS( RESET, CLKTemp, Hcnt, Vcnt, Enable, TempR, TempG, TempB )--, Count )
----		VARIABLE Count : STD_LOGIC_VECTOR(2 DOWNTO 0); 
--	BEGIN
--		IF   ( RESET='0' 					 ) THEN Count <= "000";
--		ELSIF( CLKTemp'EVENT AND CLKTemp='1' ) THEN Count <= Count + 1; 
--		END IF; 
		
		------------------------------------------------		
--		CASE Hcnt(9 DOWNTO 7) IS 
--			WHEN "000" => TempR <= '0'; TempG <= '0'; TempB <= '0'; 
--			WHEN "001" => TempR <= '0'; TempG <= '0'; TempB <= '1'; 
--			WHEN "010" => TempR <= '0'; TempG <= '1'; TempB <= '0'; 
--			WHEN "011" => TempR <= '0'; TempG <= '1'; TempB <= '1'; 
--			WHEN "100" => TempR <= '1'; TempG <= '0'; TempB <= '0'; 
--			WHEN "101" => TempR <= '1'; TempG <= '0'; TempB <= '1'; 
--			WHEN "110" => TempR <= '1'; TempG <= '1'; TempB <= '0'; 
--			WHEN "111" => TempR <= '1'; TempG <= '1'; TempB <= '1'; 
--			WHEN OTHERS=> TempR <= '0'; TempG <= '0'; TempB <= '0'; 
--		END CASE; 
		
--		IF( Enable='1' ) THEN 
--			IF( TempR='1' ) THEN R <= '1'; 
--			ELSE 				 R <= '0'; 
--			END IF; 
--			IF( TempG='1' ) THEN G <= '1'; 
--			ELSE 				 G <= '0'; 
--			END IF; 
--			IF( TempB='1' ) THEN B <= '1'; 
--			ELSE 				 B <= '0'; 
--			END IF; 
--		ELSE 
--			R <= '1'; 
--			G <= '0'; 
--			B <= '0'; 
--		END IF; 
		
--	END PROCESS; 
	-------------------------------------------------
	-------------------------------------------------
	
END Behavioral;