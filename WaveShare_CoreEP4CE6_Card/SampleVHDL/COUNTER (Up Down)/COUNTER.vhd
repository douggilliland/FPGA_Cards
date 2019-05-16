-- COUNTER 
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_std.all;

entity COUNTER is
  port (CLK, RESET : in STD_LOGIC;
        UpDown: in STD_LOGIC := '0';
        Q:   out STD_LOGIC_VECTOR(3 downto 0));
end entity COUNTER;

architecture RTL of COUNTER is
  signal Cnt: Unsigned(3 downto 0);
begin
  process (CLK, RESET)
  begin
    if RESET = '1' then
      Cnt <= x"0";
    elsif Rising_edge(CLK) then
      if UpDown = '1' then
        Cnt <= Cnt + 1;
      else
        Cnt <= Cnt - 1;
      end if; 
    end if;
  end process;
  
  Q <= STD_LOGIC_VECTOR(Cnt);

end architecture RTL;
