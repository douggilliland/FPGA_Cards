LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY BO IS
PORT(
	DQ:inOUT STD_LOGIC;   --DS18B20�ĵ���������
	--DQ2:IN STD_LOGIC;
	inclk:in std_logic;
--	k1,k2,k3,k4,k5:in std_logic;--
	sel:out std_logic_vector(3 downto 0);--�����λѡ
	seg:out std_logic_vector(7 downto 0);--����ܶ�ѡ
	templlreture:out std_logic_vector(10 downto 0);   --��ǰ�¶�
	baojing:out std_logic  --�����ź�
	);
END;
ARCHITECTURE bhv OF BO IS
constant ml1:std_logic_vector(15 downto 0):="0011001100100010";   --����1����ǰһ�ֽں��Զ�DS18B20��ROM ��һ�ֽڿ�ʼת���¶�
constant ml2:std_logic_vector(15 downto 0):="0011001101111101";   --����2��ǰһ�ֽں��Զ�DS18B20��ROM ��һ�ֽڿ�ʼ���ݴ���
signal templ1,templ2:std_logic_vector(7 downto 0);    --��DS18b20���������ֽ��¶�

signal d,c,b,a:std_logic_vector(7 downto 0);--ʮ��������ĸ�λ��С�����һλ���ڶ�λ��Ӧ������ܵĶ���ֵ
signal var1,var2,var3,var4:integer;--�ֱ��Ӧ������������ת��Ϊʮ��������ĸ�λ��С�����һλ���ڶ�λ
signal current_templ:std_logic_vector(10 downto 0);   --��ǰ�¶�
signal cur:std_logic_vector(7 downto 0);   --��ǰ�¶�
signal ng:std_logic;    --������־λ
signal clk:std_logic;
signal count_48:std_logic_vector(4 downto 0);
begin
process(inclk)
begin
if rising_edge(inclk) then
	count_48<=count_48+1;
	if count_48="11000" then
		clk<=not clk;
		count_48<="00000";
	end if;
end if;
end process;

process(clk)
variable saomiao:std_logic_vector(1 downto 0);   --ɨ�����
variable count1:std_logic_vector(10 downto 0);   --������1������DS18B20��ʼ��ʱ��ʱ���Բ���ʱ��
variable count2:std_logic_vector(9 downto 0);   --������2��������DS18B20д����ʱ��ʱ���Բ���ʱ��
variable count3:std_logic_vector(7 downto 0);   --������3��������DS18B20������ʱ��ʱ���Բ���ʱ��
variable fenping_saomiao:std_logic_vector(23 downto 0);   



variable i:integer range -1 to 15:=15;   --������ؼ���ֵ
variable init:integer range 0 to 1:=0;   --��ɳ�ʼ����־
variable j:integer range 0 to 8:=0;   --���¶�ʱ�����ؼ���ֵ
variable k:integer range 0 to 1:=0;    --����ָʾ��ȡ�ĸ��¶�ֵ
variable state:integer range 0 to 2:=0;   --״̬��־��0ʱд����1,1ʱд����2,2ʱ��ȡ�¶�

variable templ:std_logic_vector(7 downto 0);
begin
if rising_edge(clk) then
	fenping_saomiao:=fenping_saomiao+1;
	if fenping_saomiao="11" then
		if saomiao="11"  then
				saomiao:="00";
		else  
				saomiao:=saomiao+1;   --ɨ��
		end if;	
		case saomiao is   --������ܽ���λɨ��
			when "00"=>sel<="0000";seg<=a;   --ע������ܵ�λѡ�ź��ǵ͵�ƽ��Ч
			when "01"=>sel<="0000";seg<=b;
			when "10"=>sel<="0000";seg<=c;
			when "11"=>sel<="0000";seg<=d;
			when others=>sel<="0000";
		end case;
	end if;
	if state=0 then
		if init=1 then   --����ʼ����ɣ���ʼд����
			count2:=count2+1;
			if count2="0000000001" then   --����������
				DQ<='0';
			elsif count2="0000001100" then   --��15us��������дһ������ֵ
				DQ<=ml1(i);
			elsif count2="0001011010" then   --��дʱ���15us~60us�ڣ�DS18B20�����߲���������ȡ90us
				DQ<='1';
			elsif count2="1010110100" then   --�ڴ���1us֮���������ͣ�������һдʱ��
				--DQ<='0';
				count2:="0000000000";   --����������
				i:=i-1;   --д��1��������
				if i=-1 then    --д������������ֵ���㣬��ʼ����־���㣬�Բ����´γ�ʼ����״̬תΪ1������д����2
					i:=15;init:=0;state:=1;
				end if;
			end if;
		else   --init=0ʱ���г�ʼ��
			count1:=count1+1;
			if count1="000000000001" then
			    DQ<='1';
			elsif count1="000000000011" then   --����
				DQ<='0';
			elsif count1="01010111100" then   --��ʼ��ʱҪ�󣬵͵�ƽ���ٱ���480us������ȡ500us
				DQ<='1';
			elsif count1="01011011010" then   --Ҫ��15us~60us�����ߣ�����ȡ30us��530�������ͷ����ߣ�����DS18B20������������
				DQ<='Z';
			elsif count1="01111001010" then   --��������Ϊ60us~240us��830��������
				DQ<='1';
			elsif count1="10000000000" then   --����ʱ��Ҫ��960us������ȡ1024us
				init:=1;count1:="00000000000";   --�������ͣ�Ҳ���Բ����ͣ�����ʼ����־��1�����´β����г�ʼ��������������
			end if;
		end if;
	elsif state=1 then   --state=1��д����2
		if init=1 then
			count2:=count2+1;
			if count2="0000000001" then
				DQ<='0';
			elsif count2="0000001100" then
				DQ<=ml2(i);
			elsif count2="0001011010" then
				DQ<='1';
			elsif count2="0001011100" then
				count2:="0000000000";
				i:=i-1;
				if i=-1 then
					i:=15;init:=0;state:=2;
				end if;
			end if;
		else
			count1:=count1+1;
			if count1="000000000001" then
			    DQ<='1';
			elsif count1="000000000011" then   --����
				DQ<='0';
			elsif count1="01010111100" then   --��ʼ��ʱҪ�󣬵͵�ƽ���ٱ���480us������ȡ500us
				DQ<='1';
			elsif count1="01011011010" then   --Ҫ��15us~60us�����ߣ�����ȡ30us��530�������ͷ����ߣ�����DS18B20������������
				DQ<='Z';
			elsif count1="01111001010" then   --��������Ϊ60us~240us��830��������
				DQ<='1';
			elsif count1="10000000000" then   --����ʱ��Ҫ��960us������ȡ1024us
				init:=1;count1:="00000000000";   --�������ͣ�Ҳ���Բ����ͣ�����ʼ����־��1�����´β����г�ʼ��������������
			end if;
		end if;
	else    --state=2����ȡ�¶�
		if k=0 then   --k=0����ȡ��һ�ֽ��¶ȣ����ֽڣ�
			count3:=count3+1;
			if count3="00000001" then
				DQ<='0';
			elsif count3="00000100" then   --�͵�ƽ����1us�����ͷ�����
				DQ<='Z';
			elsif count3="00001101" then   --Ҫ����15us�ڶ�ȡ�¶�
				templ(j):=DQ;
			elsif count3="01010000" then   --��ʱ������60us������ȡ80us
				DQ<='1';
			elsif count3="01010010" then   --����������
				count3:="00000000";
				j:=j+1;   --��ȡ��һ����
				if j=8 then   --��ȡ��
					j:=0;   --��0
					k:=1;   --����2�ֽ�
					templ1<=templ;
				end if;
			end if;
		else   --k=1 ����2�ֽ�
			count3:=count3+1;
			if count3="00000001" then
				DQ<='0';
			elsif count3="00000100" then
				DQ<='Z';
			elsif count3="00001101" then
				templ(j):=DQ;
			elsif count3="01010000" then
				DQ<='1';
			elsif count3="01010010" then
				count3:="00000000";
				j:=j+1;
				if j=8 then
					j:=0;
					k:=0;
					state:=0;   --״̬��־���㣬�����´δ�ѭ��
					if (templ and "11111000")="11111000" then   --����¶��Ǹ�������Ҫת����
						templ:=(not templ);
						templ1<=(not templ1)+1;
						if templ1="0000000" then 
							templ:=templ+1;
						end if;
						ng<='1';   --���¶ȱ�־
					else
						ng<='0';
					end if;
					current_templ<=templ(2 downto 0) & templ1;   --�¶�ֵ��templ_value2�ĵ�5λ��templ_value1
				end if;
			end if;
		end if;
	end if;
end if;
end process;
--process()
--end process;
process(current_templ)
begin
if CONV_INTEGER(current_templ)/16>25 then   --����¶ȴ���25�ȣ�����
	baojing<='1';
else
	baojing<='0';
end if;
templlreture<=current_templ; 

--if k1='1' then
	if ng='1' then
	d<="01000000";   --����
	var3<=CONV_INTEGER(current_templ)/160 rem 10;   --ʮλ
	var2<=CONV_INTEGER(current_templ)/16 rem 10;   --��λ
	var1<=CONV_INTEGER(current_templ)*10/16 rem 10;   --С�����һλ
	else
	var4<=CONV_INTEGER(current_templ)/1600;   --��λ
	var3<=CONV_INTEGER(current_templ)/160 rem 10;   --ʮλ
	var2<=CONV_INTEGER(current_templ)/16 rem 10;   --��λ
	var1<=CONV_INTEGER(current_templ)*10/16 rem 10;   --С�����һλ
    end if;
--  else
--
--      if  k3='0' then
--          if var2=9 then
--             var2<=0;
--          else
--             var2<=var2+1;
--          end if; 
--     end if;         
--  end if;
--     
     
case var4 is--��λ
	when 0 => d <= not "11000000";--000
	when 1 => d <= not"11111001";--100
	when 2 => d <= not "10100100";--200
	when 3 => d <=not "10110000";--300
	when 4 => d <= not"10011001";--400
	when 5 => d <= not"10010010";--500
	when 6 => d <=not "10000010";--600
	when 7 => d <= not "11111000";--700
	when 8 => d <=not"10000000";--800
	when 9 => d <= not"10010000";--900
	when others => d <= not"11111111";
end case;

case var3 is--ʮλ
	when 0 => c <=not"11000000";
	when 1 => c <=not  "11111001";
	when 2 => c <= not "10100100" ;		--2
	when 3 => c <=not"10110000";		--3
	when 4 => c <=not"10011001";		--4
	when 5 => c <= not"10010010" ;		--5
	when 6 => c <= not"10000010" ;		--6
	when 7 => c <=not"11111000" ;		--7
	when 8 => c <= not"10000000" ;		--8
	when 9 => c <=not"10010000" ;		--9
	when others => c <=not "11111111";
end case;

case var2 is--��λ
	when 0 => b <=not"01000000" ;
	when 1 => b <= not"01111001" ;
	when 2 => b <=not"00100100" ;		--2
	when 3 => b <=not "00110000";		--3
	when 4 => b <=not"00011001" ;		--4
	when 5 => b <= not"00010010" ;		--5
	when 6 => b <=not "00000010";		--6
	when 7 => b <= not"01111000";		--7
	when 8 => b <=not "00000000" ;		--8
	when 9 => b <= not"00010000" ;		--9
	when others => b <=not  "01111111";
end case;

case var1 is--��С������һλ����
	when 0 => a <= not"11000000" ;
	when 1 => a <=not "11111001" ;
	when 2 => a <=not "10100100" ;		--2
	when 3 => a <= not"10110000" ;		--3
	when 4 => a <=not "10011001";		--4
	when 5 => a <= not "10010010";		--5
	when 6 => a <=not "10000010";		--6
	when 7 => a <= not"11111000" ;		--7
	when 8 => a <= not"10000000" ;		--8
	when 9 => a <=not "10010000";		--9
	when others => a <=not "11111111";
end case;
end process;
END ARCHITECTURE bhv;

