library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity LCD1602 is
Port ( CLK : in std_logic; --状态机时钟信号，同时也是液晶时钟信号，其周期应该满足液晶数据的建立时间
Reset:in std_logic; 
LCD_RS : out std_logic; --寄存器选择信号
LCD_RW : out std_logic; --液晶读写信号
LCD_EN : out std_logic; --液晶时钟信号

LCD_Data : out std_logic_vector(7 downto 0)); --液晶数据信号
end LCD1602;
architecture Behavioral of LCD1602 is
type state is (set_dlnf,set_cursor,set_dcb,set_cgram,write_cgram,set_ddram,write_LCD_Data);
signal Current_State:state;
type ram1 is array(0 to 30) of std_logic_vector(7 downto 0);
type ram2 is array(0 to 30) of std_logic_vector(7 downto 0);
type ram3 is array(0 to 30) of std_logic_vector(7 downto 0);
constant cgram1:ram1:=(x"46",x"50",x"47",x"41",x"2f",x"43",x"50",x"4c",x"44",x"2f",x"4D",x"43",x"55",x"20",x"20",x"20",x"57",x"57"
,x"57",x"2e",x"32",x"31",x"45",x"44",x"41",x"2e",x"43",x"4f",x"4d",x"20",x"20"); 
--显示我的名字的汉语拼音，以及FPGA/CPLD/CMU  Lyc Free EDA
constant cgram3:ram3:=(x"68",x"74",x"74",x"70",x"3a",x"2f",x"2f",x"73",x"68",x"6F",x"70",x"33",x"35",x"31",x"38",x"31",x"33",x"30",x"37"
,x"2E",x"74",x"61",x"6F",x"62",x"61",x"6F",x"2E",x"63",x"6f",x"6d",x"2f"); 
--显示我的主页：http://shop35181307.taobao.com
constant cgram2:ram2:=(x"51",x"51",x"3a",x"39",x"30",x"36",x"36",x"30",x"36",x"35",x"39",x"36",x"20",x"20",x"20",x"20",x"54",x"65"
,x"6c",x"3a",x"31",x"35",x"38",x"31",x"35",x"35",x"31",x"39",x"30",x"37",x"31"); 
--显示我的QQ号码和手机号码：QQ：906606596 Tel：15815519071
signal CLK1 : std_logic;
signal Clk_Out : std_logic;
signal LCD_Clk : std_logic;
signal m :std_logic_vector(1 downto 0);
begin
LCD_EN <= Clk_Out ; 
LCD_RW <= '0' ; 
process(CLK)
variable n1:integer range 0 to 19999;
begin 
if rising_edge(CLK) then
if n1<19999 then
n1:=n1+1;
else 
n1:=0;
Clk_Out<=not Clk_Out;
end if;
end if;
end process;
LCD_Clk <= Clk_Out;
process(Clk_Out)
variable n2:integer range 0 to 499;
begin 
if rising_edge(Clk_Out) then
if n2<499 then
n2:=n2+1;
else
n2:=0;
Clk1<=not Clk1;
end if;
end if;
end process;
process(Clk1)
variable n3:integer range 0 to 14;
begin
if rising_edge(Clk1) then
n3:=n3+1;
if n3<=4 then
m<="00";
elsif n3<=9 and n3>4 then
m<="01";
else
m<="10";
end if;
end if;
end process;
process(LCD_Clk,Reset,Current_State) 
variable cnt1: std_logic_vector(4 downto 0);
begin
if Reset='0'then
Current_State<=set_dlnf;
cnt1:="11110";
LCD_RS<='0';
elsif rising_edge(LCD_Clk)then
Current_State <= Current_State ;
LCD_RS <= '0';
case Current_State is
when set_dlnf=> 
cnt1:="00000"; 
LCD_Data<="00000001";   --  /*清除显示*/ 
Current_State<=set_cursor;
when set_cursor=>
LCD_Data<="00111000";   --/*设置8位格式,2行,5*7*/  
Current_State<=set_dcb;
when set_dcb=>
LCD_Data<="00001100";   --/*整体显示,关光标,不闪烁*/  
Current_State<=set_cgram;
when set_cgram=>
LCD_Data<="00000110";
Current_State<=write_cgram;
when write_cgram=> 
LCD_RS<='1';
if m="00" then
LCD_Data<=cgram1(conv_integer(cnt1));
elsif m="01"then
LCD_Data<=cgram2(conv_integer(cnt1));
else
LCD_Data<=cgram3(conv_integer(cnt1));
end if;
Current_State<=set_ddram; 
when set_ddram=> 
if cnt1<"11110" then
cnt1:=cnt1+1;
else
cnt1:="00000";
end if;
if cnt1<="01111" then
LCD_Data<="10000000"+cnt1;--80H 
else
LCD_Data<="11000000"+cnt1-"10000";--80H 
end if;
Current_State<=write_LCD_Data;
when write_LCD_Data=> 
LCD_Data<="00000000"; 
Current_State<=set_cursor;
when others => null;
end case;
end if;
end process;
end Behavioral;

