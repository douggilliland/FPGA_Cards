

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KEY_LED is
port (
key_in  : in std_logic ;   --����һ��K4 INPUT
led_out : out std_logic    --����һ��LED OUTPUT
);
end KEY_LED;

architecture key_led_arch of KEY_LED is
begin
led_out <= key_in  ; --���û�а�����LED�ڶ�Ӧ��״̬ʱ�ߵ�ƽ��
                     --���°�����LED�ڶ�Ӧ��״̬ʱ�͵�ƽ���ƾͻ���
end architecture;
