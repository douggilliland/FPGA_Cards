---------------------------------------------------------------------------------------------------
--*************************************************************************************************
--  CreateDate  :  2009-03-24 
--  ModifData   :  2009-03-24 
--  Description :  Frequency For KeyBoard 
--  Author      :  Explorer01 
--  Version     :  V1.0  
--*************************************************************************************************
---------------------------------------------------------------------------------------------------

-- VHDL library Declarations 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.std_logic_unsigned.ALL;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Entity Declarations 
ENTITY Frequency IS
	PORT 
	(
		RESET: 		IN STD_LOGIC; 
		GCLKP1: 	IN STD_LOGIC; 		-- 50 MHz 
		
		ClockScan:	OUT STD_LOGIC;
		KeyScan:	OUT STD_LOGIC
	);
END Frequency;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The Architecture of Entity Declarations 
ARCHITECTURE Frequency_arch OF Frequency IS
	--Clock: 
	SIGNAL Period1uS: STD_LOGIC;
BEGIN
	
	-------------------------------------------------
	-- GCLK: 1MHz(1uS), 1KHz(1mS), 1Hz(1S) 
	CLK: PROCESS( RESET, GCLKP1, Period1uS )
		VARIABLE Count  : STD_LOGIC_VECTOR(5 DOWNTO 0);
		VARIABLE Count1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
	BEGIN 
		------------------------------------
		--Period: 1uS (Period1uS <= GCLKP1; )
		IF( GCLKP1'EVENT AND GCLKP1='1' ) THEN 
			IF( Count>"110000" ) THEN 	Count := "000000";
			ELSE                  		Count := Count + 1;
			END IF;
			
			Period1uS <= Count(5);		-- 1MHz 
		END IF;
		
		KeyScan <= Period1uS; 
		
		------------------------------------
		--Period: 1mS 
		IF( Period1uS'EVENT AND Period1uS='1' ) THEN 
			IF( Count1>"1111100110" ) THEN 	Count1 := "0000000000";
			ELSE                  			Count1 := Count1 + 1;
			END IF;
		END IF;
		
		ClockScan <= Count1(8); 
		
	END PROCESS;
	
END Frequency_arch;