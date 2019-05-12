
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity DECL7S  is
PORT ( key_data  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); --??????? K1 K2 K3 K4 
       LED7      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --??????8????
       LED7S : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  ) ; --??????8???
end DECL7S ;
 
 ARCHITECTURE behav OF DECL7S IS 
 signal led_temp: std_logic_vector(3 downto 0);
 BEGIN 
  PROCESS( key_data ) 
  BEGIN 
     LED7 <="00000000" ;   --?????8???????????
     led_temp<= key_data ;
  CASE  led_temp  IS 
   WHEN "1110" =>  LED7S <= "11111001";    --  1--??key5?????1
   WHEN "1101" =>  LED7S <= "10100100";    --  2--??key4?????2
   WHEN "1011" =>  LED7S <= "10110000";    --  3--??key3?????3
   WHEN "0111" =>  LED7S <= "10011001";    --  4--??key2?????4
   WHEN OTHERS =>  LED7S <= "10001110";    --  ?????????FFFFFFFF
   END CASE ; 
  END PROCESS ; 
 END behav; 