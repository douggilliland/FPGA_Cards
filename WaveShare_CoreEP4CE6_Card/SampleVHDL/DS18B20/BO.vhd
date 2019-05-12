LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY BO IS
PORT(
	DQ:inOUT STD_LOGIC;   --DS18B20的单数据总线
	--DQ2:IN STD_LOGIC;
	inclk:in std_logic;
--	k1,k2,k3,k4,k5:in std_logic;--
	sel:out std_logic_vector(3 downto 0);--数码管位选
	seg:out std_logic_vector(7 downto 0);--数码管段选
	templlreture:out std_logic_vector(10 downto 0);   --当前温度
	baojing:out std_logic  --报警信号
	);
END;
ARCHITECTURE bhv OF BO IS
constant ml1:std_logic_vector(15 downto 0):="0011001100100010";   --命令1，即前一字节忽略读DS18B20的ROM 后一字节开始转换温度
constant ml2:std_logic_vector(15 downto 0):="0011001101111101";   --命令2，前一字节忽略读DS18B20的ROM 后一字节开始读暂存器
signal templ1,templ2:std_logic_vector(7 downto 0);    --从DS18b20读出的两字节温度

signal d,c,b,a:std_logic_vector(7 downto 0);--十进制数后的个位、小数点第一位、第二位对应的数码管的段数值
signal var1,var2,var3,var4:integer;--分别对应将二进制数据转化为十进制数后的个位、小数点第一位、第二位
signal current_templ:std_logic_vector(10 downto 0);   --当前温度
signal cur:std_logic_vector(7 downto 0);   --当前温度
signal ng:std_logic;    --负数标志位
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
variable saomiao:std_logic_vector(1 downto 0);   --扫描变量
variable count1:std_logic_vector(10 downto 0);   --计数器1，用于DS18B20初始化时计时，以产生时序
variable count2:std_logic_vector(9 downto 0);   --计数器2，用于向DS18B20写命令时计时，以产生时序
variable count3:std_logic_vector(7 downto 0);   --计数器3，用于向DS18B20读数据时计时，以产生时序
variable fenping_saomiao:std_logic_vector(23 downto 0);   



variable i:integer range -1 to 15:=15;   --命令比特计数值
variable init:integer range 0 to 1:=0;   --完成初始化标志
variable j:integer range 0 to 8:=0;   --读温度时，比特计数值
variable k:integer range 0 to 1:=0;    --用于指示读取哪个温度值
variable state:integer range 0 to 2:=0;   --状态标志，0时写命令1,1时写命令2,2时读取温度

variable templ:std_logic_vector(7 downto 0);
begin
if rising_edge(clk) then
	fenping_saomiao:=fenping_saomiao+1;
	if fenping_saomiao="11" then
		if saomiao="11"  then
				saomiao:="00";
		else  
				saomiao:=saomiao+1;   --扫描
		end if;	
		case saomiao is   --对数码管进行位扫描
			when "00"=>sel<="0000";seg<=a;   --注意数码管的位选信号是低电平有效
			when "01"=>sel<="0000";seg<=b;
			when "10"=>sel<="0000";seg<=c;
			when "11"=>sel<="0000";seg<=d;
			when others=>sel<="0000";
		end case;
	end if;
	if state=0 then
		if init=1 then   --若初始化完成，开始写命令
			count2:=count2+1;
			if count2="0000000001" then   --将总线拉低
				DQ<='0';
			elsif count2="0000001100" then   --在15us内向总线写一比特数值
				DQ<=ml1(i);
			elsif count2="0001011010" then   --在写时序的15us~60us内，DS18B20对总线采样，所以取90us
				DQ<='1';
			elsif count2="1010110100" then   --在大于1us之后，总线拉低，产生下一写时序
				--DQ<='0';
				count2:="0000000000";   --计数器归零
				i:=i-1;   --写下1比特命令
				if i=-1 then    --写完命令，命令计数值归零，初始化标志归零，以产生下次初始化，状态转为1，即将写命令2
					i:=15;init:=0;state:=1;
				end if;
			end if;
		else   --init=0时进行初始化
			count1:=count1+1;
			if count1="000000000001" then
			    DQ<='1';
			elsif count1="000000000011" then   --拉低
				DQ<='0';
			elsif count1="01010111100" then   --初始化时要求，低电平至少保持480us，这里取500us
				DQ<='1';
			elsif count1="01011011010" then   --要求15us~60us，拉高，这里取30us（530），再释放总线，以让DS18B20发出存在脉冲
				DQ<='Z';
			elsif count1="01111001010" then   --存在脉冲为60us~240us，830，再拉高
				DQ<='1';
			elsif count1="10000000000" then   --整个时序要求960us，这里取1024us
				init:=1;count1:="00000000000";   --总线拉低（也可以不拉低），初始化标志置1，即下次不进行初始化，计数器归零
			end if;
		end if;
	elsif state=1 then   --state=1，写命令2
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
			elsif count1="000000000011" then   --拉低
				DQ<='0';
			elsif count1="01010111100" then   --初始化时要求，低电平至少保持480us，这里取500us
				DQ<='1';
			elsif count1="01011011010" then   --要求15us~60us，拉高，这里取30us（530），再释放总线，以让DS18B20发出存在脉冲
				DQ<='Z';
			elsif count1="01111001010" then   --存在脉冲为60us~240us，830，再拉高
				DQ<='1';
			elsif count1="10000000000" then   --整个时序要求960us，这里取1024us
				init:=1;count1:="00000000000";   --总线拉低（也可以不拉低），初始化标志置1，即下次不进行初始化，计数器归零
			end if;
		end if;
	else    --state=2，读取温度
		if k=0 then   --k=0，读取第一字节温度（低字节）
			count3:=count3+1;
			if count3="00000001" then
				DQ<='0';
			elsif count3="00000100" then   --低电平至少1us，在释放总线
				DQ<='Z';
			elsif count3="00001101" then   --要求在15us内读取温度
				templ(j):=DQ;
			elsif count3="01010000" then   --读时序至少60us，这里取80us
				DQ<='1';
			elsif count3="01010010" then   --计数器归零
				count3:="00000000";
				j:=j+1;   --读取下一比特
				if j=8 then   --读取完
					j:=0;   --归0
					k:=1;   --读第2字节
					templ1<=templ;
				end if;
			end if;
		else   --k=1 读第2字节
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
					state:=0;   --状态标志归零，进入下次大循环
					if (templ and "11111000")="11111000" then   --如果温度是负数则需要转换下
						templ:=(not templ);
						templ1<=(not templ1)+1;
						if templ1="0000000" then 
							templ:=templ+1;
						end if;
						ng<='1';   --负温度标志
					else
						ng<='0';
					end if;
					current_templ<=templ(2 downto 0) & templ1;   --温度值是templ_value2的低5位和templ_value1
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
if CONV_INTEGER(current_templ)/16>25 then   --如果温度大于25度，报警
	baojing<='1';
else
	baojing<='0';
end if;
templlreture<=current_templ; 

--if k1='1' then
	if ng='1' then
	d<="01000000";   --负号
	var3<=CONV_INTEGER(current_templ)/160 rem 10;   --十位
	var2<=CONV_INTEGER(current_templ)/16 rem 10;   --个位
	var1<=CONV_INTEGER(current_templ)*10/16 rem 10;   --小数点后一位
	else
	var4<=CONV_INTEGER(current_templ)/1600;   --百位
	var3<=CONV_INTEGER(current_templ)/160 rem 10;   --十位
	var2<=CONV_INTEGER(current_templ)/16 rem 10;   --个位
	var1<=CONV_INTEGER(current_templ)*10/16 rem 10;   --小数点后一位
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
     
case var4 is--百位
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

case var3 is--十位
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

case var2 is--个位
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

case var1 is--对小数点后第一位译码
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

