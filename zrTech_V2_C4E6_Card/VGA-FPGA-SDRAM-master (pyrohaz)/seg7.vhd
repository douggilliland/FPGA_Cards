library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg7 is
	port(
		clk, nrst:  in std_logic;
    
        rseg1:      in std_logic_vector(15 downto 0);
		seg7en:		out std_logic_vector(3 downto 0);
		seg7c:		out std_logic_vector(6 downto 0)
	);
end entity;

architecture rtl of seg7 is
	type segarray is array (0 to 15) of std_logic_vector(6 downto 0);	
	constant zeros: std_logic_vector(63 downto 0) := (others => '0');
	constant N_REGS: natural := 2;
	--								0			1		2			3			4			5			6		7			8			9		A			b			C			d		E			F
	constant CSEG: segarray := ("0111111", "0000110", "1011011", "1001111", "1100110", "1101101", "1111101", "0000111", "1111111", "1101111", "1110111", "1111100", "0111001", "1011110", "1111001", "1110001");

	--Registers		0	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15
	--rctrl	(0)	E	X	X	X	X	X	X	X	X	X	X	X	X	X	X	X	
	--rseg	(1)	|	Seg 1		|	 Seg2		|	  Seg3	|	 Seg4	 |
    
	signal cnt: unsigned(1 downto 0) := (others => '0');
	signal psc: unsigned(15 downto 0) := (others => '0');
	
begin
	process(clk, nrst)
		variable index: std_logic_vector(3 downto 0);
	begin
		if(nrst = '0') then
			seg7en <= (others => '0');
			seg7c <= (others => '0');
			psc <= (others => '0');
		elsif(rising_edge(clk)) then
			psc <= psc + 1;
			if(psc = 0) then
				cnt <= cnt + 1;
			end if;
			
			case cnt is
			when "00" =>
				index := rseg1(3 downto 0);
				seg7en <= "0111";
				
			when "01" =>
				index := rseg1(7 downto 4);
				seg7en <= "1011";
				
			when "10" =>
				index := rseg1(11 downto 8);
				seg7en <= "1101";
			
			when "11" =>
				index := rseg1(15 downto 12);
				seg7en <= "1110";
                
            when others => null;
			end case;
			
			seg7c <= CSEG(to_integer(unsigned(index)));
		end if;
	end process;
end rtl;