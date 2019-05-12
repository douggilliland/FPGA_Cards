
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity dff1 is
	port(    clk  :in std_logic;
                 d    :in std_logic;
	         q:out std_logic);
end dff1;
architecture rtl of dff1 is
begin 
	process(clk)
		begin
			if((clk'event) and (clk='1') )then
					q<=d;
			end if;
	end process;
end rtl;
