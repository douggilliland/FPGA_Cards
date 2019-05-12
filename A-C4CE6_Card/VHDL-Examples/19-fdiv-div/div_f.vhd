
library ieee;
use ieee.std_logic_1164.all;
entity div_f is
port(clk        :in std_logic;    --??????
     miao_out   :out std_logic;   --??1hz????,LED?????????
     f_miao_out :out std_logic);  --??2hz????,LED?????????
     end div_f;
architecture miao of div_f is
begin 
p1:process(clk)
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
miao_out<=ff;
end process p1;
p2:process(clk)
variable cnn:integer range 0 to 12499999;  --?????12499999
variable dd:std_logic;
begin
if clk'event and clk='1' then
if cnn<12499999 then
cnn:=cnn+1;
else
cnn:=0;
dd:=not dd;  --??
end if;
end if;
f_miao_out <=dd;
end process p2;
end  miao;