LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY JOYSTICK IS
PORT(
		CLK: IN STD_LOGIC;
		RESET: IN STD_LOGIC;
		DATA: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		LED: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
     );
	  

END JOYSTICK;

ARCHITECTURE LED OF JOYSTICK IS
BEGIN

process( DATA )
	begin
		if(DATA= "11111110") then
				LED  <= "0001";
		elsif(DATA= "11111101") then
				LED  <= "0010";
		elsif(DATA= "11111011") then
				LED  <= "0011";	
		elsif(DATA= "11110111") then
				LED  <= "0100";	
		elsif(DATA= "11101111") then
				LED  <= "0101";	
		elsif(DATA= "11011111") then
				LED  <= "0111";				
		elsif(DATA= "10111111") then
				LED  <= "1000";				
		elsif(DATA= "01111111") then
				LED  <= "1001";				
				
		else		LED  <= "0000";
		end if;
	end  process;		
	
END LED;

