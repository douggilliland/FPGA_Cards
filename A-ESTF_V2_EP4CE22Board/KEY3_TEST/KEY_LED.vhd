--������21EDA����
--�������ͺ�:A-C8V4
--www.21eda.com
--ѧϰ����һ��LED�򵥵�ʵ�顣
--���ǵĿ�����LED�ƶ�Ӧ��I/OΪ0ʱ��LED������
--��ʵ�顣���°���һ������key1ʱ������LED�ơ�
--���������Ʋ��������¾�����
--��Ƶ�̳��ʺ�����21EDA���ӵ�����ѧϰ��

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KEY_LED is
port (
key_in  : in std_logic ;   --����һ��KEY INPUT
led_out : out std_logic    --����һ��LED OUTPUT
);
end KEY_LED;

architecture key_led_arch of KEY_LED is
begin
led_out <= key_in  ; --���û�а�����LED�ڶ�Ӧ��״̬ʱ�ߵ�ƽ��
                     --���°�����LED�ڶ�Ӧ��״̬ʱ�͵�ƽ���ƾͻ���
end architecture;
