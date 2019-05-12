

LIBRARY IEEE;                                                  
USE IEEE.STD_LOGIC_1164.ALL;                     
USE IEEE.std_logic_unsigned.ALL;                   
ENTITY LEDA is                                        
     PORT(
          clk:in STD_LOGIC;  --System Clk           --????   input  17 pin                    
          led1:out STD_LOGIC_VECTOR(11 DOWNTO 0));   --LED output???8?
                                                
END LEDA ;                                              
ARCHITECTURE light OF LEDA IS            
SIGNAL clk1,CLK2:std_logic;                                       
BEGIN                                                                  
P1:PROCESS (clk)    --????????                                          
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
   if count1<=16 then                                          --?COUNT1<=9???????
      if count1=15 then                                        --?COUNT1=8??COUNT1??
         count1:=0;                                                 --
      end if;                                                            --
      CASE count1 IS                                             --CASE?????LED1??
      WHEN 0=>led1<="111111111110";                        --?????????
      WHEN 1=>led1<="111111111100";                        -- 
      WHEN 2=>led1<="111111111000";                        --
      WHEN 3=>led1<="111111110000";                        --
      WHEN 4=>led1<="111111100000";                        --
      WHEN 5=>led1<="111111000000";                        --
      WHEN 6=>led1<="111110000000";                        --
      WHEN 7=>led1<="111100000000"; 
      WHEN 8=>led1<="111000000000";                        --?????????
      WHEN 9=>led1<="110000000000";                        -- 
      WHEN 10=>led1<="100000000000";                        --
      WHEN 11=>led1<="000000000000";                        --
                       --                       --
      WHEN OTHERS=>led1<="111111111111";              
      END CASE;                                                     
      count1:=count1+1;                                   
    end if;                                                                     
end if;                                                                        
end process;                              
END light;