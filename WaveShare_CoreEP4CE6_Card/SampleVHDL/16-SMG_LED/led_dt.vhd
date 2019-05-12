
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
entity led_dt is 
port( clk      :in std_logic;                       --????50M
      led_bit  :out std_logic;                      --????????         
      dout     :out std_logic_vector(7 downto 0));  --????7???
end led_dt ; 
architecture bhv of led_dt is 
signal counter:std_logic_vector(27 downto 0); 
signal counter_en:std_logic; 
signal seg:std_logic_vector(3 downto 0); 
begin 
led_bit<= '0' ;     --??????????????

process(clk) 
begin 
if clk'event and clk='1'   then 
    if counter>=x"37D783F"  then --??counter????????
       counter_en<='1';          --????????????
       counter<=x"0000000"; 
       else counter<=counter+'1'; 
       counter_en<='0'; 
      end if; 
end if; 
end process; 
      
process(clk) 
begin 
if clk'event and clk='1' then 
   if counter_en='1'   then  
      if seg>=B"1010" then  
         seg<=B"0000"; 
       else 
      seg<=seg+'1'; 
      end if; 
   end if; 
end if; 
end process; 
process(clk) 
begin 
if clk'event and clk='1'  then  
    case seg is    --??????
      when "0000" =>dout<="11000000"; --0 
      when "0001" =>dout<="11111001"; --1 
      when "0010" =>dout<="10100100"; --2 
      when "0011" =>dout<="10110000"; --3 
      when "0100" =>dout<="10011001"; --4 
      when "0101" =>dout<="10010010"; --5 
      when "0110" =>dout<="10000010"; --6 
      when "0111" =>dout<="11111000"; --7 
      when "1000" =>dout<="10000000"; --8 
      when "1001" =>dout<="10010000"; --9 
      when others=>null; 
    end case; 
end if; 
end process; 
end bhv; 