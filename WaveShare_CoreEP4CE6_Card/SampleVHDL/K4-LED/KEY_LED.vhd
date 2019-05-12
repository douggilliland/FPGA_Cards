

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KEY_LED is
port (
key_in  : in std_logic ;   --定义一个K4 INPUT
led_out : out std_logic    --定义一个LED OUTPUT
);
end KEY_LED;

architecture key_led_arch of KEY_LED is
begin
led_out <= key_in  ; --如果没有按键，LED口对应的状态时高电平。
                     --按下按键后，LED口对应的状态时低电平，灯就会亮
end architecture;
