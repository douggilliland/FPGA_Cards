-- The FPGA-evb-S2 Xilinx Spartan-II evaluation board example
-- This example reads scan codes from a PS/2 keyboard and
-- displays them on LEDs.
-- (C)2001 Jan Pech, j.pech@sh.cvut.cz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
  port (resetn:  in  std_logic;                     -- active low reset
        clock:   in  std_logic;                     -- system clock
        ps2_clk: in  std_logic;                     -- PS/2 clock line
        ps2_dta: in  std_logic;                     -- PS/2 data line
        hit_1:     out std_logic;
        ascii:    out std_logic_vector(7 downto 0)); -- LED outputs
end ps2;

architecture behavioral of ps2 is
  type state_type is (IDLE, START, DATA, PARITY);   -- FSM states
  signal ps2_dv: std_logic;                         -- PS/2 data valid
  signal prv_ps2_clk, act_ps2_clk: std_logic;       -- auxiliary signals
  signal recdata: std_logic_vector(7 downto 0);     -- read data
  signal shift: std_logic;                          -- enable for shift reg.
  signal n_shift: std_logic;                        -- auxiliary signal
  signal latch: std_logic;                          -- latch read data
  signal n_latch: std_logic;                        -- auxiliary signal
  signal err: std_logic;                            -- parity or stop error
  signal n_err: std_logic;                          -- auxiliary signal
  signal parset: std_logic;                         -- preset for parity check
  signal n_parset: std_logic;                       -- auxiliary signal
  signal c_state, n_state: state_type;              -- current & next states
  signal cntval: std_logic_vector(2 downto 0);      -- counter of data bits
  signal zero: std_logic;                           -- counter is zero
  signal parbit: std_logic;                         -- odd parity of data
  signal leds:std_logic_vector(7 downto 0);
  signal hit_cnt:std_logic_vector(8 downto 0);
  signal hit:std_logic;
begin
  -- Provides a one-shot pulse after every falling edge of PS/2 clock
  PS_CLK_SYNC: process(clock, resetn)
  begin
    if (resetn = '0') then
      prv_ps2_clk <= '1';
      act_ps2_clk <= '1';
    elsif (clock'event and clock = '1') then
      act_ps2_clk <= ps2_clk;
      prv_ps2_clk <= act_ps2_clk;
    end if;
  end process;
  ps2_dv <= (not act_ps2_clk) and prv_ps2_clk;

  -- Serial input, parallel output shift register
  SIPO: process(clock, resetn)
  begin
    if (resetn = '0') then
      recdata <= (others => '0');
    elsif (clock'event and clock = '1') then
      if (shift = '1') then
        recdata <= ps2_dta & recdata(7 downto 1);
      end if;
    end if;
  end process;

  -- Counter of data bits
  COUNT8: process(resetn, clock)
  begin
    if (resetn = '0') then
      cntval <= (others => '0');
    elsif (clock'event and clock = '1') then
      if (shift = '1') then
        cntval <= cntval + 1;
      end if;
    end if;
  end process;
  zero <= not (cntval(0) or cntval(1) or cntval(2));

  -- Parity check of received data
  PARITY_CHECK: process(clock, parset)
  begin
    if (parset = '1') then
      parbit <= '1';
    elsif (clock'event and clock = '1') then
      if (shift = '1' and ps2_dta = '1') then
        parbit <= not parbit;
      end if;
    end if;
  end process;

  -- Synchronous process of control state machine
  FSM_SYNC: process(clock, resetn)
  begin
    if (resetn = '0') then
      c_state <= IDLE;
      shift <= '0';
      latch <= '0';
      err <= '0';
      parset <= '1';
    elsif (clock'event and clock = '1') then
      c_state <= n_state;
      shift <= n_shift;
      latch <= n_latch;
      err <= n_err;
      parset <= n_parset;
    end if;
  end process;

  -- Combinatorial process of control state machine
  FSM_COMB: process(c_state, ps2_dv, ps2_dta, zero)
  begin                 -- default values
    n_shift <= '0';
    n_latch <= '0';
    n_err <= '0';
    n_parset <= '0';
    case c_state is              -- wait to receive data
      when IDLE =>   if ((ps2_dv and (not ps2_dta)) = '1') then
                       n_state <= START;
                       n_parset <= '1';
                     else
                       n_state <= IDLE;
                     end if;
      -- receive first data bit
      when START =>  if (ps2_dv = '0') then
                       n_state <= START;
                     else
                       n_state <= DATA;
                       n_shift <= '1';
                     end if;
      -- receive remaining data bits and parity
      when DATA =>   if (ps2_dv = '0') then
                       n_state <= DATA;
                     elsif (zero = '0') then
                       n_state <= DATA;
                       n_shift <= '1';
                     else
                       n_state <= PARITY;
                       if (parbit /= ps2_dta) then
                         n_err <= '1';
                       end if;
                     end if;
      -- receive stop bit
      when PARITY => if (ps2_dv = '0') then
                       n_state <= PARITY;
                     else
                       n_state <= IDLE;
                       n_latch <= '1';
                       n_err <= not ps2_dta;
                     end if;
    end case;
  end process;

  -- Output latch
  LED_OUTPUTS: process(resetn, clock)
  begin
    if (resetn = '0') then
      leds <= (others => '1');
    elsif (clock'event and clock = '1') then
      if (err = '1') then
        leds <= (others => '1');
      elsif (latch = '1') then
        leds <=  recdata;
      end if;
    end if;
  end process;
 PROCESS(leds)
   BEGIN
	case leds is
      when "01000101"=> ascii <= "00110000"; hit<='1';  --0
      when "00010110"=> ascii <= "00110001"; hit<='1';  --1 
      when "00011110"=> ascii <= "00110010"; hit<='1';  --2 
      when "00100110"=> ascii <= "00110011"; hit<='1';  --3 
      when "00100101"=> ascii <= "00110100"; hit<='1';  --4 
      when "00101110"=> ascii <= "00110101"; hit<='1';  --5 
      when "00110110"=> ascii <= "00110110"; hit<='1';  --6 
      when "00111101"=> ascii <= "00110111"; hit<='1';  --7 
      when "00111110"=> ascii <= "00111000"; hit<='1';  --8 
      when "01000110"=> ascii <= "00111001"; hit<='1';  --9 
      when "00011100"=> ascii <= "01100001"; hit<='1';  --a
      when "00110010"=> ascii <= "01100010"; hit<='1';  --b
      when "00100001"=> ascii <= "01100011"; hit<='1';  --c
      when "00100011"=> ascii <= "01100100"; hit<='1';  --d 
      when "00100100"=> ascii <= "01100101"; hit<='1';  --e 
      when "00101011"=> ascii <= "01100110"; hit<='1';  --f 
      when "00110100"=> ascii <= "01100111"; hit<='1';  --g 
      when "00110011"=> ascii <= "01101000"; hit<='1';  --h  
      when "01000011"=> ascii <= "01101001"; hit<='1';  --i  
      when "00111011"=> ascii <= "01101010"; hit<='1';  --j  
      when "01000010"=> ascii <= "01101011"; hit<='1';  --k  
      when "01001011"=> ascii <= "01101100"; hit<='1';  --l  
      when "00111010"=> ascii <= "01101101"; hit<='1';  --m  
      when "00110001"=> ascii <= "01101110"; hit<='1';  --n  
      when "01000100"=> ascii <= "01101111"; hit<='1';  --o  
      when "01001101"=> ascii <= "01110000"; hit<='1';  --p  
      when "00010101"=> ascii <= "01110001"; hit<='1';  --q  
      when "00101101"=> ascii <= "01110010"; hit<='1';  --r  
      when "00011011"=> ascii <= "01110011"; hit<='1';  --s  
      when "00101100"=> ascii <= "01110100"; hit<='1';  --t  
      when "00111100"=> ascii <= "01110101"; hit<='1';  --u  
      when "00101010"=> ascii <= "01110110"; hit<='1';  --v 
      when "00011101"=> ascii <= "01110111"; hit<='1';  --w 
      when "00100010"=> ascii <= "01111000"; hit<='1';  --x  
      when "00110101"=> ascii <= "01111001"; hit<='1';  --y  
      when "00011010"=> ascii <= "01111010"; hit<='1';  --z
      when "00111001"=> ascii <= "00100000"; hit<='1';  --spacebar
      when "01100110"=> ascii <= "00100000"; hit<='1';  --backspace
      when "01110001"=> ascii <= "11100000"; hit<='1';  --del
      when others =>    ascii <= "00100000"; hit<='0';  --' ' for unlisted characters.
    end case;	
    	  if hit='1' then
	       if  hit_cnt="111111111" then
	  	       hit_1<='1';
		       hit_cnt<="000000000";
		    else
		       hit_cnt<=hit_cnt+1;
		    end if;
	     else
		    hit_1<=hit;
	     end if;	 
   END PROCESS;

end behavioral;
