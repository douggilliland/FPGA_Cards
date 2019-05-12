----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:18:40 06/15/2009 
-- Design Name: 
-- Module Name:    slavefifo_wr - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity USB_LED is

    Port ( clk 		: in  STD_LOGIC;	--40M
           rst    	: in  STD_LOGIC;
			  FLAGA    	: in     std_logic; --empty for EP2
           FLAGB 		: in  STD_LOGIC; --FULL
			  FLAGC 		: in  std_logic; --EMPTY
			  SLOE     	: out    std_logic;
			  SLRD     	: out    std_logic;
           FIFOADR 	: out  STD_LOGIC_VECTOR (1 downto 0);
           SLWR    	: out  STD_LOGIC;
           FIFODATA 	: inout  STD_LOGIC_VECTOR (15 downto 0);
			  led     	: out std_logic_VECTOR (3 downto 0));
end USB_LED;

architecture Behavioral of USB_LED is

signal state_rd    : std_logic_vector(3 downto 0);
signal state       : std_logic_vector(3 downto 0);
signal flag_b      : std_logic;
signal count       : std_logic_vector(19 downto 0);
signal FIFOADR_Read: STD_LOGIC_VECTOR (1 downto 0);
signal flag_a      : std_logic;
signal SLRD_r      : std_logic;
signal SLOE_r      : std_logic;
--signal data_in   : std_logic_vector(15 downto 0);
SIGNAL dout        : std_logic_vector(15 downto 0);
signal empty       : std_logic;
signal read_finish : std_logic;
signal empty_r     : std_logic;
signal state_start : std_logic_vector(2 downto 0);
signal start_flag_n: std_logic;
signal start_flag  : std_logic;
signal led_cnt		 : std_logic_vector(25 downto 0);
signal led_clk		 : std_logic;
signal ledctrl		 : std_logic_vector(3 downto 0);
signal led_r		 : std_logic_vector(3 downto 0);

begin	


------------------------------------------------------------------------------

process(clk,rst)
begin
if(rst = '0')then
	start_flag <= '0';
	state_start<= "000";
elsif(falling_edge(clk))then
	case state_start is 
	when "000" =>
	   start_flag <= '0';
		if(flag_a = '1' )then
			state_start <= "001";
		else
		   state_start <= "000";
		end if;
	when "001" => --empty
	   if(flag_a = '0' )then--and wren = '0')then
			state_start <= "010";
		else
		   state_start <= "001";
		end if;
	when "010" => 
	   start_flag <= '0';
		   state_start <= "011";
	when "011" =>
	   start_flag <= '1';
		if(flag_a = '1' )then	--not empty
			state_start <= "100";
		else
			state_start <= "011";
		end if;
	when "100" => 
	   start_flag <= '1';
			state_start <= "101";
	when "101" => 
	   start_flag <= '0';
	   if(flag_a = '1' )then
			state_start <= "101";
		else
			state_start <= "000";
		end if;
	when others =>
	null;
	end case;
end if;
end process;


process(clk,rst)
begin
	if(rst = '0')then
		flag_b <= '0';
		flag_a <= '0';
		empty_r<= '1';
	elsif(rising_edge(clk))then
	   flag_b <= FLAGB;
		flag_a <= FLAGA;
		empty_r<= empty;
	end if;
end process;


---------state machine for read cmd-----------------
PROCESS(CLK,RST)
BEGIN
	IF(RST = '0')THEN
	   state_rd <= (OTHERS => '0');
		FIFOADR_Read  <= (OTHERS => '0');
		SLOE_r     <= '1';
		SLRD_r     <= '1';
		read_finish<= '0';
	ELSIF(fallING_EDGE(CLK))THEN
	   CASE state_rd IS 
		WHEN "0000" =>
		   FIFOADR_Read  <= (OTHERS => '0');
		   SLOE_r     <= '1';
		   SLRD_r     <= '1';
			read_finish<= '0';
		   IF(flag_a = '1')THEN	--not empty 
			   state_rd <= "0001";
		   ELSE
			   state_rd <= "0000";
			END IF;
		when "0001" => 
		--	IF(start_flag = '0' and start_flag_n = '0')THEN--????
			   state_rd <= "0010";
		--   ELSE
		--	   state_rd <= "0001";
		--	END IF;
		WHEN "0010" =>
		   FIFOADR_Read <=  "00";
			state_rd <= "0011";
		WHEN "0011" =>
		   SLOE_r     <= '0';
		   SLRD_r     <= '0';
			state_rd <= "0100";
		WHEN "0100" =>
		   SLOE_r     <= '0';
		   SLRD_r     <= '0';
			state_rd <= "0101";
		when "0101" => 
		   SLOE_r     <= '0';
		   SLRD_r     <= '0';
			state_rd <= "0110";
		when "0110" => 
		   SLOE_r     <= '0';
		   SLRD_r     <= '0';
			state_rd <= "0111";
		when "0111" => 
		   SLOE_r     <= '1';
		   SLRD_r     <= '1';
			state_rd <= "1000";
		when "1000" =>
		   read_finish<= '1';
		   state_rd <= "0000";
		WHEN OTHERS =>
		NULL;
		END CASE;
	END IF;
END PROCESS;



--
FIFOADR <= FIFOADR_Read;
SLRD <= SLRD_r;
SLOE <= SLOE_r;				

--FIFODATA <= (dout(15 downto 11)&dout_aec&dout(9 downto 0)) when (SLRD_r = '1') else
--            (others => 'Z');
---------------------------------------------------------------------------------------------
--read led ctrl bytes
ledctrl(3 downto 0) <= FIFODATA (3 downto 0)when (SLRD_r = '0');	
				--else
            --(others => 'Z');				

--led counter
process(clk,led_cnt)
begin
if(rst = '0')then
  led_cnt <= (others => '0');
elsif(rising_edge(clk))then
     led_cnt <= led_cnt + 1;
end if;
end process;

led_clk<=led_cnt(23);

--led ctrler		
process(rst,led_clk,ledctrl)
begin
if(rst = '0')then
	led_r<="1111";
elsif(rising_edge(led_clk))then
	case ledctrl is
		when "0001"=>	--led1
			led_r<="1110";
		when "0010"=>	--led2
			led_r<="1101";
		when "0011"=>	--led3
			led_r<="1011";
		when "0100"=>	--led4
			led_r<="0111";
		when "0101"=>	--led run
			led_r(3 downto 1)<= led_r(2 downto 0);
			led_r(0)<= led_r(3);
		when "0110"=>	--led reset
			led_r<="1111";
		when others =>
			led_r<="1111";
	end case;
end if;
end process;

--
led<=led_r;
		
end Behavioral;

