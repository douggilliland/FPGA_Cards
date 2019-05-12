--

LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;                   
ENTITY LEDA is                                        
     PORT(
          clk:in STD_LOGIC;  --System Clk           --????                       
          led1:out STD_LOGIC_VECTOR(3 DOWNTO 0);
			  
			  LCD_N : out std_logic; --??????
			 LCD_P : out std_logic);   --LED output???8?                                          
		END LEDA ;       
		
ARCHITECTURE light OF LEDA IS            
SIGNAL clk1,CLK2:std_logic;                                       
BEGIN   
 LCD_N<='0';
LCD_P<='0';                                                                
P1:PROCESS (clk)                                              
VARIABLE count:INTEGER RANGE  0 TO 9999999;
BEGIN                                                                
    IF clk'EVENT AND clk='1' THEN                            --?????????????????
       IF count<=4999999 THEN                           
          clk1<='0';                                          --?count<=499999?divls=0??count?1
          count:=count+1;                          
        ELSIF count>=4999999 AND count<=9999999 THEN            --?ount>=499999 ?? count<=999998?
               clk1<='1';                                            --                             
               count:=count+1;                                --clk1=1??count?1
        ELSE count:=0;                                        --?count>=499999???count1
        END IF;                                                      
     END IF;                                          
END PROCESS ;    
  
P3:PROCESS(CLK1)   
begin
   IF clk1'event AND clk1='1'THEN  
 clk2<=not clk2;
 END IF; 
END PROCESS P3;     
---------------------------------------------------------
P2:PROCESS(clk2)                                              
variable count1:INTEGER RANGE 0 TO 16;                         --????????????
BEGIN                                                                --                                                 
IF clk2'event AND clk2='1'THEN                                 --?????????????????
   if count1<=4 then                                          --?COUNT1<=9???????
      if count1=4 then                                        --?COUNT1=8??COUNT1??
         count1:=0;                                                 --
      end if;                                                            --
      CASE count1 IS                                             --CASE?????LED1??
      WHEN 0=>led1<="1110";                        --?????????
      WHEN 1=>led1<="1101";                        -- 
      WHEN 2=>led1<="1011";                        --
      WHEN 3=>led1<="0111";                                         --
      WHEN OTHERS=>led1<="1111";              
      END CASE;                                                     
      count1:=count1+1;                                   
    end if;                                                                     
end if;                                                                        
end process;                              
END light;