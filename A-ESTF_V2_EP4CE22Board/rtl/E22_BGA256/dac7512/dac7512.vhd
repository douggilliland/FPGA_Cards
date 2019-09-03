--���о΢����
--�绰 15815519071 QQ 906606596
--Email 906606596@qq.com
--dac7512DA�������ݲ��γ�
--ʵ��������ͨ��LED11�۲�
--dac7512DA output, sawtooth wave formation
--The experimental results can be observed by LED11
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dac7512 is
	port
	(
		clkin,resetin:in std_logic;--ʱ�ӣ���λ�ź����� CLK 50M
		sync_out:out std_logic;--dac7512֡ͬ���źţ�����Ч Dac7512 frame sync signal, low effective
		sclk_out:out std_logic;--dac7512ʱ���ź�   Dac7512 clock signal
		da_data_out:out std_logic--dac7512����λ���  Dac7512 data bit output
	);
end dac7512;

architecture behave of dac7512 is
	component gen_div is--��ƵԪ����������
	generic(div_param:integer:=2);--Ĭ����4��Ƶ
	port
	(
		clk:in std_logic;
		bclk:out std_logic;
		resetb:in std_logic
	);
	end component;	
----
signal sclk_out_tmp:std_logic;
signal sync_out_tmp:std_logic;
signal data_out:std_logic_vector(15 downto 0);--��Ҫת��ģ���źŵ�������,�޸ĸ�ֵ��DB11��DB0�ɸı������ģ����
--- need to convert analog signal to digital quantity, modify the value of DB11 ~ DB0 can change the output analog
----
begin
----
sclk_out<=sclk_out_tmp;--da7512��ʱ�ӣ�1MHz
sync_out<=sync_out_tmp;--da7512Ƭѡ
----
gen_1M: --��Ƶ����1MHz����
		gen_div generic map(20)--40��Ƶ��,����1MHz����  40 frequency divider, 1MHz pulse generation
		port map--��ƵԪ������
		(
			clk=>clkin,
			resetb=>not resetin,
			bclk=>sclk_out_tmp
		);
---
	process(sclk_out_tmp,resetin)
	variable cnt:integer range 0 to 32:=0;
	begin
		if resetin='0' then
			sync_out_tmp<='1';
			da_data_out<='0';
			cnt:=0;
			data_out<=X"0000";--��������ģʽ���޸ĸ�ֵ��DB11��DB0�ɸı������ģ����
			--Normal operating mode, modify the value of DB11 ~ DB0 can change the output analog
		elsif rising_edge(sclk_out_tmp) then
			cnt:=cnt+1;
			if cnt=1 then
				sync_out_tmp<='1';--֡ͬ����Ч
			elsif cnt>=2 and cnt<18 then
				sync_out_tmp<='0';----֡ͬ����Ч
				da_data_out<=data_out(17-cnt);--��λ�����MSB
			elsif cnt=18 then
				sync_out_tmp<='1';
				cnt:=0;--ѭ��ת������
				data_out<=data_out+'1';--������ֵ��DB11��DB0���ı������ģ����(DB15-DB12�̶�Ϊ0--��������ģʽ),��ݲ�
				--Increase the value of the DB11 ~ DB0 to change the analog output (DB15-DB12 fixed to 0-- normal mode), sawtooth wave
				if data_out=X"0FFE" then
					data_out<=X"0000";
				end if;
			end if;
		end if;
	end process;
end behave;