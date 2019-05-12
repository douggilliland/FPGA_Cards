
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity key_led is
port (
key_in : in std_logic_vector (3 downto 0);   --KEY INPUT   k2 k3 k4  k5
led_out : out std_logic_vector (5 downto 0)  --LED OUTPUT
);
end entity;

architecture key_led_arch of key_led is

begin

process(key_in)
begin
led_out <= (others => '1');   --???????????

case key_in is
when "1110" => led_out <= "111110"; -- key1???KEY1??????LED?
when "1101" => led_out <= "111100"; -- key2???KEY2??????LED?
when "1011" => led_out <= "111000"; -- key3???KEY3??????LED?
when "0111" => led_out <= "110000"; -- key4???KEY4??????LED?
when others => NULL;
end case;
end process;

end architecture;
