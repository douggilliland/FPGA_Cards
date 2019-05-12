--if you put down the key,then the pc will display:WAVESHARE
--and the information will be displayde just one time 

--if you send 0-F ,then the seg will be displayed by the same ASCII
--the bouad is 9600bps

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

ENTITY serial IS
   PORT (
      clk                     : IN std_logic;  --the fpga clk is 50MHZ
      rst                     : IN std_logic;   
      rxd                     : IN std_logic;  
      txd                     : OUT std_logic; 
      en                      : OUT std_logic_vector(3 DOWNTO 0); 
      seg_data                : OUT std_logic_vector(7 DOWNTO 0);  
      key_input               : IN std_logic); 
END serial;

ARCHITECTURE arch OF serial IS


   --//////////////////inner reg////////////////////
   SIGNAL div_reg                  :  std_logic_vector(15 DOWNTO 0);  
   SIGNAL div8_tras_reg            :  std_logic_vector(2 DOWNTO 0); 
   SIGNAL div8_rec_reg             :  std_logic_vector(2 DOWNTO 0); 
   SIGNAL state_tras               :  std_logic_vector(3 DOWNTO 0); 
   SIGNAL state_rec                :  std_logic_vector(3 DOWNTO 0);
   SIGNAL clkbaud_tras             :  std_logic;  
   SIGNAL clkbaud_rec              :  std_logic;  
   SIGNAL clkbaud8x                :  std_logic;  
   SIGNAL recstart                 :  std_logic; 
   SIGNAL recstart_tmp             :  std_logic;
   SIGNAL trasstart                :  std_logic;   
   SIGNAL rxd_reg1                 :  std_logic;   
   SIGNAL rxd_reg2                 :  std_logic;   
   SIGNAL txd_reg                  :  std_logic;  
   SIGNAL rxd_buf                  :  std_logic_vector(7 DOWNTO 0);  
   SIGNAL txd_buf                  :  std_logic_vector(7 DOWNTO 0);
   SIGNAL send_state               :  std_logic_vector(3 DOWNTO 0);  
   SIGNAL cnt_delay                :  std_logic_vector(19 DOWNTO 0);   
   SIGNAL start_delaycnt           :  std_logic;   
   SIGNAL key_entry1               :  std_logic; 
   SIGNAL key_entry2               :  std_logic;  
   --//////////////////////////////////////////////
   CONSTANT  div_par               :  std_logic_vector(15 DOWNTO 0) := "0000000101000101"; 
   --????????????????????????????????????8???????9600???????????????9600*8	    
   SIGNAL txd_xhdl3                :  std_logic;   

BEGIN
   en <="1111" ;--the seg enable   
   txd <= txd_xhdl3;

   txd_xhdl3 <= txd_reg ;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         cnt_delay <= "00000000000000000000";    
         start_delaycnt <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (start_delaycnt = '1') THEN
            IF (cnt_delay /= "11000011010100000000") THEN
               cnt_delay <= cnt_delay + "00000000000000000001";    
            ELSE
               cnt_delay <= "00000000000000000000";    
               start_delaycnt <= '0';    
            END IF;
         ELSE
            IF ((NOT key_input='1') AND (cnt_delay = "00000000000000000000")) THEN
               start_delaycnt <= '1';    
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         key_entry1 <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (key_entry2 = '1') THEN
            key_entry1 <= '0';    
         ELSE
            IF (cnt_delay = "11000011010100000000") THEN
               IF (NOT key_input = '1') THEN
                  key_entry1 <= '1';    
               END IF;
            END IF;
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)
   BEGIN
      
      IF (NOT rst = '1') THEN
         div_reg <= "0000000000000000";    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (div_reg = div_par - "0000000000000001") THEN
            div_reg <= "0000000000000000";    
         ELSE
            div_reg <= div_reg + "0000000000000001";    
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clk,rst)  --????8???????
   BEGIN
      
      IF (NOT rst = '1') THEN
         clkbaud8x <= '0';    
      ELSIF(clk'EVENT AND clk='1')THEN
         IF (div_reg = div_par - "0000000000000001") THEN
            clkbaud8x <= NOT clkbaud8x;    
         END IF;
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         div8_rec_reg <= "000";    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (recstart = '1') THEN  --??????
            div8_rec_reg <= div8_rec_reg + "001";--??????????8?????????1??    
         END IF;
	   END IF;
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         div8_tras_reg <= "000";    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (trasstart = '1') THEN
            div8_tras_reg <= div8_tras_reg + "001";--??????????8?????????1??    
         END IF;
	   END IF;
      END IF;
   END PROCESS;

   PROCESS(div8_rec_reg)
   BEGIN
      IF (div8_rec_reg = "111") THEN
         clkbaud_rec <= '1'; ---??7??????????????????   
      ELSE
         clkbaud_rec <= '0';    
      END IF;
   END PROCESS;

   PROCESS(div8_tras_reg)
   BEGIN
      IF (div8_tras_reg = "111") THEN
         clkbaud_tras <= '1';  --??7??????????????????  
      ELSE
         clkbaud_tras <= '0';    
      END IF;
   END PROCESS;

   PROCESS(clkbaud8x,rst)
   BEGIN
      IF (NOT rst = '1') THEN
         txd_reg <= '1';    
         trasstart <= '0';    
         txd_buf <= "00000000";    
         state_tras <= "0000";    
         send_state <= "0000";    
         key_entry2 <= '0';    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         IF (NOT key_entry2 = '1') THEN
            IF (key_entry1 = '1') THEN
               key_entry2 <= '1';    
 --              txd_buf <= "00110010";   --"2"
            END IF;
         ELSE
            CASE state_tras IS
               WHEN "0000" =>  --?????
                        IF ((NOT trasstart='1') AND (send_state < "1111") ) THEN
                           trasstart <= '1';    
                        ELSE
                           IF (send_state < "1111") THEN
                              IF (clkbaud_tras = '1') THEN
                                 txd_reg <= '0';    
                                 state_tras <= state_tras + "0001";    
                              END IF;
                           ELSE
                              key_entry2 <= '0';    
                              state_tras <= "0000";    
                           END IF;
                        END IF;
               WHEN "0001" => --???1?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0010" =>  --???2?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0011" =>  --???3?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0100" => --???4?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0101" => --???5?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0110" => --???6?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "0111" => --???7?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1000" =>  --???8?
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= txd_buf(0);    
                           txd_buf(6 DOWNTO 0) <= txd_buf(7 DOWNTO 1);    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1001" =>  --?????
                        IF (clkbaud_tras = '1') THEN
                           txd_reg <= '1';    
                           txd_buf <= "01010101";    
                           state_tras <= state_tras + "0001";    
                        END IF;
               WHEN "1111" =>
                        IF (clkbaud_tras = '1') THEN
                           state_tras <= state_tras + "0001";    
                           send_state <= send_state + "0001";    
                           trasstart <= '0';    
                           CASE send_state IS
                              WHEN "0000" =>
                                       txd_buf <= "01010111";  --"W"   
                              WHEN "0001" =>
                                       txd_buf <= "01000001";  --"A"   
                              WHEN "0010" =>
                                       txd_buf <= "01010110";  --"V"  
                              WHEN "0011" =>
                                       txd_buf <= "01000101";   --E"  
                              WHEN "0100" =>
                                       txd_buf <= "01010011";   --S"  													
                              WHEN "0101" =>
                                       txd_buf <= "01001000";   --H"  													
                              WHEN "0110" =>
                                       txd_buf <= "01000001";   --A"  													
                              WHEN "0111" =>
                                       txd_buf <= "01010010";   --R"  
                              WHEN "1000" =>
                                       txd_buf <= "01000101";   --E"  
													
                              WHEN "1001" =>
                                       txd_buf <= "00001010";  --"huanghang"  
                                       
                              WHEN OTHERS  =>
                                       txd_buf <= "00000000";  
                              
                           END CASE;
                        END IF;
               WHEN OTHERS  =>
                        IF (clkbaud_tras = '1') THEN
                           state_tras <= state_tras + "0001";    
                           trasstart <= '1';    
                        END IF;
               
            END CASE;
         END IF;
      END IF;
	END IF;
   END PROCESS;

PROCESS(clkbaud8x,rst)  --??PC????
   BEGIN
      IF (NOT rst = '1') THEN
         rxd_reg1 <= '0';    
         rxd_reg2 <= '0';    
         rxd_buf <= "00000000";    
         state_rec <= "0000";    
         recstart <= '0';    
         recstart_tmp <= '0';    
      ELSE IF(clkbaud8x'EVENT AND clkbaud8x = '1') THEN
         rxd_reg1 <= rxd;    
         rxd_reg2 <= rxd_reg1;    
         IF (state_rec = "0000") THEN
            IF (recstart_tmp = '1') THEN
               recstart <= '1';    
               recstart_tmp <= '0';    
               state_rec <= state_rec + "0001";    
            ELSE
               IF ((NOT rxd_reg1 AND rxd_reg2) = '1') THEN --?????????????????
                  recstart_tmp <= '1';    
               END IF;
            END IF;
         ELSE
            IF (state_rec >= "0001" AND state_rec<="1000") THEN
               IF (clkbaud_rec = '1') THEN
                  rxd_buf(7) <= rxd_reg2;    
                  rxd_buf(6 DOWNTO 0) <= rxd_buf(7 DOWNTO 1);    
                  state_rec <= state_rec + "0001";    
               END IF;
            ELSE
               IF (state_rec = "1001") THEN
                  IF (clkbaud_rec = '1') THEN
                     state_rec <= "0000";    
                     recstart <= '0';    
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
	END IF;
   END PROCESS;

   PROCESS(rxd_buf)   --??????????????
   BEGIN
      CASE rxd_buf IS
         WHEN "00110000" =>
                  seg_data <= "11000000"; --???????0???   
         WHEN "00110001" =>
                  seg_data <= "11111001"; --???????1???      
         WHEN "00110010" =>
                  seg_data <= "10100100";    
         WHEN "00110011" =>
                  seg_data <= "10110000";    
         WHEN "00110100" =>
                  seg_data <= "10011001";    
         WHEN "00110101" =>
                  seg_data <= "10010010";    
         WHEN "00110110" =>
                  seg_data <= "10000010";    
         WHEN "00110111" =>
                  seg_data <= "11111000";    
         WHEN "00111000" =>
                  seg_data <= "10000000"; --???????8???      
         WHEN "00111001" =>
                  seg_data <= "10010000";    
						
         WHEN "01000001" =>
                  seg_data <= "10001000";    
         WHEN "01000010" =>
                  seg_data <= "10000011";    
         WHEN "01000011" =>
                  seg_data <= "11000110";    
         WHEN "01000100" =>
                  seg_data <= "10100001";    
         WHEN "01000101" =>
                  seg_data <= "10000110";    
         WHEN "01000110" =>
                  seg_data <= "10001110";    
         WHEN OTHERS  =>
                  seg_data <= "11111111";    
      
      END CASE;
   END PROCESS;

END arch;
