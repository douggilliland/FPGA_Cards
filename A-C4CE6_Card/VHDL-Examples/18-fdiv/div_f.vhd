
library ieee;
use ieee.std_logic_1164.all;

entity div_f is
port(clk      :in std_logic;  --??????
     miao_out :out std_logic);  --??1hz????  led display
     end div_f ;
     
architecture miao of div_f is
begin 
 process(clk)
variable cnt:integer range 0 to 24999999;  --?????24999999
variable ff:std_logic;
begin
    if clk'event and clk='1' then
    if cnt<24999999 then
      cnt:=cnt+1;
    else
    cnt:=0;
    ff:=not ff;  --??

    end if;
   end if;
    miao_out<= not ff ;  --??
end process ;
end miao ;