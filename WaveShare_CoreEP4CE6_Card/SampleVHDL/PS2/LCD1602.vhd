library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity LCD1602 is
Port ( CLK : in std_logic; 
Reset:in std_logic; 
LCD_RS : out std_logic; 
LCD_RW : out std_logic; 
LCD_EN : out std_logic; 
ps2_data: in std_logic_vector(7 downto 0);
key_ready: in std_logic; 
LCD_Data : out std_logic_vector(7 downto 0));
end LCD1602;

architecture Behavioral of LCD1602 is
type state is (set_dlnf,set_cursor,set_dcb,set_cgram,write_cgram,set_ddram,write_LCD_Data);
signal Current_State:state;
type ram1 is array(0 to 30) of std_logic_vector(7 downto 0);
signal cgram:ram1:=(x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
                    x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
						  x"20",x"20",x"20",x"20",x"20",x"20",x"20",x"20",
						  x"20",x"20",x"20",x"20",x"20",x"20",x"20");
signal CLK1 : std_logic;
signal Clk_Out : std_logic;
signal LCD_Clk : std_logic;
signal m :std_logic_vector(1 downto 0);
signal key_cnt:integer range 0 to 31;
begin
LCD_EN <= Clk_Out ; 
LCD_RW <= '0' ; 
process(key_ready)
begin
  if key_ready'event and key_ready='1' then
			if key_cnt=31 then 	
			   key_cnt<=0;
		   else 
            cgram(key_cnt)<=ps2_data;
            key_cnt<=key_cnt+1;
			end if;
  end if;
end process;
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
process(LCD_Clk,Reset,Current_State) 
variable cnt1: std_logic_vector(4 downto 0);
begin
if Reset='0' then
Current_State<=set_dlnf;
cnt1:="11110";
LCD_RS<='0';
elsif rising_edge(LCD_Clk)then
Current_State <= Current_State ;
LCD_RS <= '0';
case Current_State is
when set_dlnf=> 
cnt1:="00000"; 
LCD_Data<="00000001";
Current_State<=set_cursor;
when set_cursor=>
LCD_Data<="00111000";
Current_State<=set_dcb;
when set_dcb=>
LCD_Data<="00001110";
Current_State<=set_cgram;
when set_cgram=>
LCD_Data<="00000110";
Current_State<=write_cgram;
when write_cgram=> 
LCD_RS<='1';
LCD_Data<=cgram(conv_integer(cnt1));
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
