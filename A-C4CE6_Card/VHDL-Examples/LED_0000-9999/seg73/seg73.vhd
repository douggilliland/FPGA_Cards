-- 7 digital tube experiment 2: incremental manner in the 4 digital tube counting up from 0000-0001->0002...... ..9999... .0000... .0001... .
-- Design: a 4 bit decimal counter using FPGA, and digital tube display the current count value

-- http://www.aliexpress.com/store/620372
-- Email: sz21eda@126.com

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY seg73 IS
   PORT (
      clk                     : IN std_logic;   
      rst                     : IN std_logic;   
      dataout                 : OUT std_logic_vector(7 DOWNTO 0);
      en                      : OUT std_logic_vector(3 DOWNTO 0));
END seg73;

ARCHITECTURE arch OF seg73 IS
signal div_cnt : std_logic_vector(24 downto 0 );
signal data4 :    std_logic_vector(3 downto 0);
signal dataout_xhdl1 : std_logic_vector(7 downto 0);
signal en_xhdl : std_logic_vector(3 downto 0);
signal cntfirst :std_logic_vector(3 downto 0);
signal cntsecond : std_logic_vector(3 downto 0);
signal cntthird  : std_logic_vector(3 downto 0);
signal cntlast   : std_logic_vector(3 downto 0);
signal first_over: std_logic;
signal second_over: std_logic;
signal third_over : std_Logic; 
signal last_over  : std_logic;
begin
  
  dataout<=dataout_xhdl1;
  en<=en_xhdl;

 process(clk,rst)
 begin
   if(rst='0')then 
   div_cnt<="0000000000000000000000000";
   elsif(clk'event and clk='1')then
   div_cnt<=div_cnt+1;
   end if;
 end process;

process(div_cnt(24),rst,last_over)                 ---first 10 counter
begin
 if(rst='0')then
   cntfirst<="0000";
   first_over<='0';
 elsif(div_cnt(24)'event and div_cnt(24)='1')then
   if(cntfirst="1001" or last_over='1')then
      cntfirst<="0000";
      first_over<='1';
   else
      first_over<='0';
      cntfirst<=cntfirst+1;
   end if;
  end if;
end process;


process(first_over,rst)               --second 10  counter
begin
 if(rst='0')then
   cntsecond<="0000";
   second_over<='0';
 elsif(first_over'event and first_over='1')then
   if(cntsecond="1001")then
      cntsecond<="0000";
      second_over<='1';
   else
      second_over<='0';
      cntsecond<=cntsecond+1;
   end if;
  end if;
end process;


process(second_over,rst)               --second 10  counter
begin
 if(rst='0')then
   cntthird<="0000";
   third_over<='0';
 elsif(second_over'event and second_over='1')then
   if( cntthird="1001")then
       cntthird<="0000";
      third_over<='1';
   else
      third_over<='0';
       cntthird<= cntthird+1;
   end if;
  end if;
end process;

process(third_over,rst)               --second 10  counter
begin
 if(rst='0')then
   cntlast<="0000";
   last_over<='0';
 elsif(third_over'event and third_over='1')then
   if( cntlast="1001")then
       cntlast<="0000";
      last_over<='1';
   else
      last_over<='0';
       cntlast<= cntlast+1;
   end if;
  end if;
end process;

---
 
 process(rst,clk,div_cnt(19 downto 18))
 begin
  if(rst='0')then
    en_xhdl<="1110";
  elsif(clk'event and clk='1')then
    case div_cnt(19 downto 18) is
     when"00"=> en_xhdl<="1110";
     when"01"=> en_xhdl<="1101";
     when"10"=> en_xhdl<="1011";
     when"11"=> en_xhdl<="0111"; 
    end case;
  end if;

 end process;

process(en_xhdl,cntfirst,cntsecond,cntthird,cntlast)
begin
 case en_xhdl is 
   when "1110"=> data4<=cntfirst;
   when "1101"=> data4<=cntsecond;
   when "1011"=> data4<=cntthird;
   when "0111"=> data4<=cntlast;   
   when others    => data4<="1010";
  end case;
end process;

process(data4)
begin
  case data4 is
   WHEN "0000" =>
                  dataout_xhdl1 <= "11000000";    
         WHEN "0001" =>
                  dataout_xhdl1 <= "11111001";    
         WHEN "0010" =>
                  dataout_xhdl1 <= "10100100";    
         WHEN "0011" =>
                  dataout_xhdl1 <= "10110000";    
         WHEN "0100" =>
                  dataout_xhdl1 <= "10011001";    
         WHEN "0101" =>
                  dataout_xhdl1 <= "10010010";    
         WHEN "0110" =>
                  dataout_xhdl1 <= "10000010";    
         WHEN "0111" =>
                  dataout_xhdl1 <= "11111000";    
         WHEN "1000" =>
                  dataout_xhdl1 <= "10000000";    
         WHEN "1001" =>
                  dataout_xhdl1 <= "10010000";    
         WHEN "1010" =>
                  dataout_xhdl1 <= "10000000";    
         WHEN "1011" =>
                  dataout_xhdl1 <= "10010000";    
         WHEN "1100" =>
                  dataout_xhdl1 <= "01100011";    
         WHEN "1101" =>
                  dataout_xhdl1 <= "10000101";    
         WHEN "1110" =>
                  dataout_xhdl1 <= "01100001";    
         WHEN "1111" =>
                  dataout_xhdl1 <= "01110001";    
         WHEN OTHERS =>
               dataout_xhdl1 <= "00000011"; 
         
         
      END CASE;
   END PROCESS;
end arch;
