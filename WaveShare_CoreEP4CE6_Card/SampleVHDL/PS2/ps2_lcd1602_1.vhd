library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2_lcd1602_1 is
  port (reset1:in std_logic;                                            -- active low reset
        ps2_clk: in  std_logic;                     -- PS/2 clock line
        ps2_dta: in  std_logic;                     -- PS/2 data line
        CLK : in std_logic; 
        Reset2:in std_logic; 
        LCD_RS : out std_logic; 
        LCD_RW : out std_logic; 
        LCD_EN : out std_logic; 
		  
LCD_N : out std_logic; --??????
LCD_P : out std_logic; --??????
VSS : out std_logic; --??????
VDD : out std_logic; --??????
VO : out std_logic; --??????
		 		  
        LCD_Data : out std_logic_vector(7 downto 0));
end ps2_lcd1602_1;

architecture Behavioral of ps2_lcd1602_1 is
signal data  :    std_logic_vector(7 downto 0);
signal d_ps2   :    std_logic_vector(7 downto 0);
signal hitout  :    std_logic;
signal keyin   :  std_logic;
component ps2 is
  port (resetn:  in  std_logic;                     -- active low reset
        clock:   in  std_logic;                     -- system clock
        ps2_clk: in  std_logic;                     -- PS/2 clock line
        ps2_dta: in  std_logic;                     -- PS/2 data line
		  hit_1  : out std_logic;
        ascii:    out std_logic_vector(7 downto 0)); -- LED outputs
end component ps2;
component LCD1602 is
Port(CLK : in std_logic; 
     Reset:in std_logic; 
     LCD_RS : out std_logic; 
     LCD_RW : out std_logic; 
     LCD_EN : out std_logic; 
     PS2_DATA:in std_logic_vector(7 downto 0);
     key_ready: in std_logic; 
     LCD_Data : out std_logic_vector(7 downto 0));
end  component LCD1602;
begin
LCD_N<='0';
LCD_P<='1';
VSS<='0';
VDD<='1';
VO<='1'; 

 data<=d_ps2; 
 keyin<=hitout;
 a0:ps2 port map(reset1,clk,ps2_clk,ps2_dta,hitout,d_ps2);
 a1:lcd1602 port map(clk,reset2,lcd_rs,lcd_rw,lcd_en,data,keyin ,lcd_data);  
end Behavioral;

