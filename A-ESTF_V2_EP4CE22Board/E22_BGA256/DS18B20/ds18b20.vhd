--视飓芯微电子
--开发板型号:A-ESTF
--email: 906606596@qq.com
--电话 15815519071
--学习DS18B20温度传感器的使用，数码管显示温度数据。
--两个手指抓住SD18B20.温度会变化。
--learn the use of DS18B20 temperature sensor, digital tube display temperature data.
--two fingers hold SD18B20. temperature will change.
library IEEE;  
use IEEE.STD_LOGIC_1164.ALL;  
use IEEE.STD_LOGIC_ARITH.ALL;  
use IEEE.STD_LOGIC_UNSIGNED.ALL;  

entity ds18B20 is  
port(clk : in std_logic;   --系统时钟 CLK 50MHz 
      dq  : inout std_logic;   --DS18B20数据引脚
LED : out std_logic; 
LED2 : out std_logic; 
U2_138_select: out std_logic; --数码管138使能控制 - digital tube 138 enable control
U3_138_select: out std_logic; --点阵138使能控制 dot array 138 enable control
LED3 : out std_logic; 
rst: in std_logic; 
---------------- 
dataout : out std_logic_vector(7 downto 0); --数码管显示  digital tube display
U2_138_A : out std_logic_vector(2 downto 0) --数码管位选择 Digital tube selection
);   
end ds18B20;  

architecture Behavioral of ds18B20 is  

TYPE STATE_TYPE is (RESET,CMD_CC,WRITE_BYTE,WRITE_LOW,WRITE_HIGH,READ_BIT, 
CMD_44,CMD_BE,WAIT800MS,GET_TMP,WAIT4MS);  
signal STATE: STATE_TYPE:=RESET;  

signal clk_temp : std_logic:='0';  
signal clk1m : std_logic; --分频后得到的1M时钟  - after the frequency of the 1M clock

signal write_temp : std_logic_vector(7 downto 0):="00000000";  

signal TMP : std_logic_vector(11 downto 0);  
signal tmp_bit : std_logic;  

signal WRITE_BYTE_CNT : integer range 0 to 8:=0;  
signal WRITE_LOW_CNT : integer range 0 to 2:=0;  
signal WRITE_HIGH_CNT : integer range 0 to 2:=0;  
signal READ_BIT_CNT : integer range 0 to 3:=0;  
signal GET_TMP_CNT : integer range 0 to 13:=0;  

signal cnt : integer range 0 to 100001:=0;  

----------****************************** 
signal cnt2 : integer range 0 to 4000001:=0;  
signal seg_temp : std_logic_vector(2 downto 0); 
--signal temp_h : std_logic_vector(7 downto 0); 
--signal temp_l : std_logic_vector(7 downto 0);  

signal temp : std_logic; 
signal data_temp0 : std_logic_vector(15 downto 0); 
signal decimal0 : std_logic_vector(15 downto 0); 
signal decimal1 : std_logic_vector(15 downto 0); 
signal decimal2 : std_logic_vector(15 downto 0); 
signal decimal3 : std_logic_vector(15 downto 0); 
signal data_temp1 : std_logic_vector(7 downto 0); 
signal integer0 : std_logic_vector(7 downto 0); 
signal integer1 : std_logic_vector(7 downto 0); 
signal integer2 : std_logic_vector(7 downto 0); 
signal integer3 : std_logic_vector(7 downto 0); 
signal integer4 : std_logic_vector(7 downto 0); 
signal integer5 : std_logic_vector(7 downto 0); 
signal integer6 : std_logic_vector(7 downto 0); 

signal sign : std_logic_vector(7 downto 0); 
-----------**************** 

signal count : integer range 0 to 51:=0;  

signal WRITE_BYTE_FLAG : integer range 0 to 4:=0;  

begin  
U3_138_select <= '0' ;
U2_138_select <= '1';

ClkDivider:process (clk,clk_temp)  
begin  
if rising_edge(clk) then  
   if (count = 24) then  
      count <= 0;  
      clk_temp<= not clk_temp;  
   else  
      count <= count +1;  
   end if;  
end if;   
   clk1m<=clk_temp;  
end Process;  


STATE_TRANSITION:process(STATE,clk1m) 
begin 
if rising_edge(clk1m) then  
if(rst='0') then  
STATE<=RESET; 
else 
case STATE is  
     when RESET=>  
--********** 
LED2<='0';--*************- 
LED3<='0'; 
--********* 
            if (cnt>=0 and cnt<500) then  
               dq<='0';  
     cnt<=cnt+1;  
    STATE<=RESET;  
elsif (cnt>=500 and cnt<510) then 
dq<='Z'; 
cnt<=cnt+1; 
STATE<=RESET; 
            elsif (cnt>=510 and cnt<750) then  
temp<=dq; 
if(cnt=580) then 
temp<=dq; 
if(temp='1') then 
LED<='0'; 
else LED<='1'; 
end if; 
end if; 
     cnt<=cnt+1;  
     STATE<=RESET;  
elsif (cnt>=750) then  
    cnt<=0;  
    STATE<=CMD_CC;  
end if;  
when CMD_CC=>  
LED2<='1'; 
LED3<='0'; 
write_temp<="11001100";  
STATE<=WRITE_BYTE; 
when WRITE_BYTE=> 
case WRITE_BYTE_CNT is  
when 0 to 7=>  
if (write_temp(WRITE_BYTE_CNT)='0') then  
     STATE<=WRITE_LOW;  
LED3<='1';      
else 
     STATE<=WRITE_HIGH;  
    end if;  
      WRITE_BYTE_CNT<=WRITE_BYTE_CNT+1;  
when 8=> 
if (WRITE_BYTE_FLAG=0) then -- 第一次写0XCC完毕   The first time to write 0XCC finished
     STATE<=CMD_44;  
       WRITE_BYTE_FLAG<=1;  
    elsif (WRITE_BYTE_FLAG=1) then --写0X44完毕   Write 0X44 finished
       STATE<=RESET;  
       WRITE_BYTE_FLAG<=2;  
    elsif (WRITE_BYTE_FLAG=2) then --第二次写0XCC完毕  Second write 0XCC finished 
       STATE<=CMD_BE;  
       WRITE_BYTE_FLAG<=3;  
    elsif (WRITE_BYTE_FLAG=3) then --写0XBE完毕   Write 0XBE finished
       STATE<=GET_TMP;  
       WRITE_BYTE_FLAG<=0;  
    end if;  
WRITE_BYTE_CNT<=0; 
when others=>STATE<=RESET; 
end case;  
when WRITE_LOW=>  
LED3<='1'; 
case WRITE_LOW_CNT is  
    when 0=>  
        dq<='0';  
        if (cnt=70) then  
          cnt<=0;  
          WRITE_LOW_CNT<=1;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 1=>  
       dq<='Z';  
       if (cnt=5) then  
          cnt<=0;  
          WRITE_LOW_CNT<=2;  
    else  
         cnt<=cnt+1;  
    end if;  
when 2=>  
    STATE<=WRITE_BYTE;  
     WRITE_LOW_CNT<=0;  
    when others=>WRITE_LOW_CNT<=0;  
end case;  
when WRITE_HIGH=>  
 case WRITE_HIGH_CNT is  
    when 0=>  
       dq<='0';  
       if (cnt=8) then  
          cnt<=0;  
          WRITE_HIGH_CNT<=1;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 1=>  
       dq<='Z';  
       if (cnt=72) then  
          cnt<=0;  
          WRITE_HIGH_CNT<=2;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 2=>  
       STATE<=WRITE_BYTE;  
       WRITE_HIGH_CNT<=0;  
    when others=>WRITE_HIGH_CNT<=0;  
end case;  
when CMD_44=>  
write_temp<="01000100";  
STATE<=WRITE_BYTE;  
when CMD_BE=>  
write_temp<="10111110";  
STATE<=WRITE_BYTE;  
    when READ_BIT=>  
 case READ_BIT_CNT is  
    when 0=>  
       dq<='0';  
       if (cnt=4) then  
READ_BIT_CNT<=1;  
cnt<=0;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 1=>  
       dq<='Z';  

       if (cnt=4) then  
          READ_BIT_CNT<=2;  
          cnt<=0;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 2=>  
   dq<='Z'; 
       TMP_BIT<=dq;  
       if (cnt=1) then  
          READ_BIT_CNT<=3;  
          cnt<=0;  
       else  
          cnt<=cnt+1;  
       end if;  
    when 3=>  
--------------------- 
   dq<='Z'; 
--------------------- 
       if (cnt=55) then  
          cnt<=0;  
          READ_BIT_CNT<=0;  
          STATE<=GET_TMP;  
       else  
          cnt<=cnt+1;  
       end if;  
    when others=>READ_BIT_CNT<=0;  
 end case;  
    when WAIT800MS=>  
if (cnt>=100000) then  
STATE<=RESET;  
cnt<=0;  
else  
cnt<=cnt+1;  
STATE<=WAIT800MS;  
end if;  

    when GET_TMP=>  
 case GET_TMP_CNT is  
when 0 => 
STATE<=READ_BIT; 
GET_TMP_CNT<=GET_TMP_CNT+1; 
    when 1 to 12=>  
       STATE<=READ_BIT;  
       TMP(GET_TMP_CNT-1)<=TMP_BIT;  
       GET_TMP_CNT<=GET_TMP_CNT+1;  
    when 13=>  
       GET_TMP_CNT<=0;  
       STATE<=WAIT4MS;  
 end case;  
         when WAIT4MS=>  
 if (cnt>=4000) then  
--STATE<=WAIT4MS; 
    STATE<=RESET;  
    cnt<=0;  
 else  
    cnt<=cnt+1;  
    STATE<=WAIT4MS;  
 end if;  
when others=>STATE<=RESET; 
LED<='0'; 
LED2<='0'; 
LED3<='0';  
end case;  

end if; 
end if; 
end process;  

--temp_h<=TMP(11 downto 8); 
--temp_h(7 downto 4) <= "1111";  
--temp_l<=TMP(7 downto 0); 

-----------************************** 
--temp_h<='0'&TMP(11 downto 5);  
--temp_l<="0000"&TMP(4 downto 1);  
-------------------------------------------- 
---------------------------------------------- 
process(seg_temp,clk)--,temp_l,temp_h) 
begin 
if rising_edge( clk ) then 
if(seg_temp="000") then--"1110") then--"11110") then  
case TMP(3 downto 0) is--temp_l(3 downto 0) is 
        WHEN "0000" =>  dataout <= "11000000" ; --0 
        WHEN "0001" =>  dataout <= "11111001" ; --1 
        WHEN "0010" =>  dataout <= "10100100" ; --2 
        WHEN "0011" =>  dataout <= "10110000" ; --3 
        WHEN "0100" =>  dataout <= "10011001" ; --4 
        WHEN "0101" =>  dataout <= "10010010" ; --5 
        WHEN "0110" =>  dataout <= "10000010" ; --6 
        WHEN "0111" =>  dataout <= "11111000" ; --7 
WHEN "1000" =>  dataout <= "10000000" ; --8 
WHEN "1001" =>  dataout <= "10010000" ; --9 
WHEN "1010" =>  dataout <= "10001000" ; --a 
WHEN "1011" =>  dataout <= "10000011" ; --b 
WHEN "1100" =>  dataout <= "11000110" ; --c 
WHEN "1101" =>  dataout <= "10100001" ; --d 
WHEN "1110" =>  dataout <= "10000110" ; --e 
WHEN "1111" =>  dataout <= "10001110" ; --f 
WHEN others=>   dataout <= "11000000";--0 
end case; 
elsif(seg_temp="001") then--"1101") then--"11101") then 
case TMP(7 downto 4) is--temp_l(7 downto 4) is 
        WHEN "0000" =>  dataout <= "11000000" ; --0 
        WHEN "0001" =>  dataout <= "11111001" ; --1 
        WHEN "0010" =>  dataout <= "10100100" ; --2 
        WHEN "0011" =>  dataout <= "10110000" ; --3 
        WHEN "0100" =>  dataout <= "10011001" ; --4 
        WHEN "0101" =>  dataout <= "10010010" ; --5 
        WHEN "0110" =>  dataout <= "10000010" ; --6 
        WHEN "0111" =>  dataout <= "11111000" ; --7 
WHEN "1000" =>  dataout <= "10000000" ; --8 
WHEN "1001" =>  dataout <= "10010000" ; --9 
WHEN "1010" =>  dataout <= "10001000" ; --a 
WHEN "1011" =>  dataout <= "10000011" ; --b 
WHEN "1100" =>  dataout <= "11000110" ; --c 
WHEN "1101" =>  dataout <= "10100001" ; --d 
WHEN "1110" =>  dataout <= "10000110" ; --e 
WHEN "1111" =>  dataout <= "10001110" ; --f 
WHEN others=>   dataout <= "11000000";--0 
end case; 
elsif(seg_temp="010") then--"1011") then--"11011") then 
case TMP(11 downto 8) is--temp_h(3 downto 0) is 
        WHEN "0000" =>  dataout <= "11000000" ; --0 
        WHEN "0001" =>  dataout <= "11111001" ; --1 
        WHEN "0010" =>  dataout <= "10100100" ; --2 
        WHEN "0011" =>  dataout <= "10110000" ; --3 
        WHEN "0100" =>  dataout <= "10011001" ; --4 
        WHEN "0101" =>  dataout <= "10010010" ; --5 
        WHEN "0110" =>  dataout <= "10000010" ; --6 
        WHEN "0111" =>  dataout <= "11111000" ; --7 
WHEN "1000" =>  dataout <= "10000000" ; --8 
WHEN "1001" =>  dataout <= "10010000" ; --9 
WHEN "1010" =>  dataout <= "10001000" ; --a 
WHEN "1011" =>  dataout <= "10000011" ; --b 
WHEN "1100" =>  dataout <= "11000110" ; --c 
WHEN "1101" =>  dataout <= "10100001" ; --d 
WHEN "1110" =>  dataout <= "10000110" ; --e 
WHEN "1111" =>  dataout <= "10001110" ; --f 
WHEN others=>   dataout <= "11000000" ;--0 
end case; 
end if; 
end if; 
end process; 

U2_138_A<=seg_temp; 

process(clk1m) 
begin 
if rising_edge(clk1m) then 
if(cnt2<20) then 
cnt2<=cnt2+1; 
seg_temp<="000";--"1110";--"11110"; 
elsif(cnt2<40 AND cnt2>=20) then 
cnt2<=cnt2+1; 
seg_temp<="001";--"1101";--"11101"; 
elsif(cnt2<60 AND cnt2>=40) then 
cnt2<=cnt2+1; 
seg_temp<="010";--"1011";--"11011"; 
else 
cnt2<=0; 
seg_temp<="000";--"1110";--"11110"; 
end if; 
end if; 
end process; 
end Behavioral; 