
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity keyboardVhdl is
	Port (	CLK, RST, KD, KC: in std_logic;
				an: out std_logic_vector (3 downto 0);
				sseg: out std_logic_vector (6 downto 0));


end keyboardVhdl;


architecture Behavioral of keyboardVhdl is

	------------------------------------------------------------------------
	-- Component Declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- Signal Declarations
	------------------------------------------------------------------------
	signal clkDiv : std_logic_vector (12 downto 0);
	signal sclk, pclk : std_logic;
	signal KDI, KCI : std_logic;
	signal DFF1, DFF2 : std_logic;
	signal shiftRegSig1: std_logic_vector(10 downto 0);
	signal shiftRegSig2: std_logic_vector(10 downto 1);
	signal MUXOUT: std_logic_vector (3 downto 0);
	signal WaitReg: std_logic_vector (7 downto 0);
	
	------------------------------------------------------------------------
	-- Module Implementation
	------------------------------------------------------------------------

	begin
	--Divide the master clock down to a lower frequency--
	CLKDivider: Process (CLK)
	begin
		if (CLK = '1' and CLK'Event) then 
			clkDiv <= clkDiv +1; 
		end if;	
	end Process;

	sclk <= clkDiv(12);
	pclk <= clkDiv(3);

	--Flip Flops used to condition siglans coming from PS2--
	Process (pclk, RST, KC, KD)
	begin
		if(RST = '0') then
			DFF1 <= '0'; DFF2 <= '0'; KDI <= '0'; KCI <= '0';
		else												
			if (pclk = '1' and pclk'Event) then
				DFF1 <= KD; KDI <= DFF1; DFF2 <= KC; KCI <= DFF2;
			end if;
		end if;
	end process;

	--Shift Registers used to clock in scan codes from PS2--
	Process(KDI, KCI, RST) --DFF2 carries KD and DFF4, and DFF4 carries KC
	begin																					  
		if (RST = '0') then
			ShiftRegSig1 <= "00000000000";
			ShiftRegSig2 <= "0000000000";
		else
			if (KCI = '0' and KCI'Event) then
				ShiftRegSig1(10 downto 0) <= KDI & ShiftRegSig1(10 downto 1);
				ShiftRegSig2(10 downto 1) <= ShiftRegSig1(0) & ShiftRegSig2(10 downto 2);
			end if;
		end if;
	end process;
	
	--Wait Register
	process(ShiftRegSig1, ShiftRegSig2, RST, KCI)
	begin
		if(RST = '0')then
			WaitReg <= "00000000";
		else
			if(KCI'event and KCI = '1' and ShiftRegSig2(8 downto 1) = "11110000")then 
				WaitReg <= ShiftRegSig1(8 downto 1);
			end if;			
		end if;
	end Process;

	--Multiplexer

	MUXOUT <=  WaitReg(7 downto 4) when sclk = '1' else
				  WaitReg(3 downto 0);
				  

	--Seven Segment Decoder--
	sseg <=	"1000000" when MUXOUT = "0000" else
			"1111001" when MUXOUT = "0001" else
			"0100100" when MUXOUT = "0010" else
			"0110000" when MUXOUT = "0011" else
			"0011001" when MUXOUT = "0100" else
			"0010010" when MUXOUT = "0101" else
			"0000010" when MUXOUT = "0110" else
			"1111000" when MUXOUT = "0111" else
			"0000000" when MUXOUT = "1000" else
			"0010000" when MUXOUT = "1001" else
			"0001000" when MUXOUT = "1010" else
			"0000011" when MUXOUT = "1011" else
			"1000110" when MUXOUT = "1100" else
			"0100001" when MUXOUT = "1101" else
			"0000110" when MUXOUT = "1110" else
			"0001110" when MUXOUT = "1111" else
			"1111111";

	--Anode Driver--
	an(3) <= '1'; an(2) <= '1'; --disable first two seven-segment decoders.
	an(1 downto 0) <= "10" when sclk = '1' else "01";

				
end Behavioral;