library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------

ENTITY lcdm_data IS
	PORT
	(	M	:   IN	INTEGER RANGE 0 TO 55;
	    clk1 :   IN  STD_LOGIC;
	    s1  :   in  std_logic_vector(10 downto 0); 
--	    h1,h10,m1,m10: in std_logic_vector(7 downto 0);
	    D0, D1, D2, D3, D4, D5, D6, D7, RS	: OUT	STD_LOGIC );
END lcdm_data;

ARCHITECTURE a OF lcdm_data IS
	SIGNAL Q : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal var1,var2,var3,var4:integer;--分别对应将二进制数据转化为十进制数后的个位、小数点第一位、第二位
	SIGNAL a : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL b : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL c : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0);
    --SIGNAL F : STD_LOGIC;
BEGIN
    ( D7,D6,D5,D4,D3,D2,D1,D0)<=Q ;

 PROCESS (clk1,M)
  BEGIN
   if clk1'event and clk1='1' then 
     case  M  is
      --when  0 => Q <=x"01"; RS<='0';
	  when  1 => Q <=x"38"; RS<='0';--工作方式设置（初始化）
      --when  2 => Q <=x"04"; RS<='0';--输入方式设置
      when  6 => Q <=X"0f"; RS<='0';--显示开关控制（设置显示、光标及闪烁开、关）
      when  4 => Q <=X"06"; RS<='0';
      
      when  16 => Q <=x"c0"; RS<='0';  --2Row " 2012年1月10日! "
--      when  18  => Q <=x"78"; RS<='1';  -- x
--      when  19  => Q <=x"79"; RS<='1';  -- y
--      when  20  => Q <=x"A0"; RS<='1';  
--      when  21  => Q <=x"70"; RS<='1';  -- P
--      when  22  => Q <=x"73"; RS<='1';  -- s
--      when  23  => Q <=x"6c"; RS<='1';  -- l
--      when  24  => Q <=x"A0"; RS<='1';    
--      when  25  => Q <=x"70"; RS<='1';  -- p
--      when  26  => Q <=x"68"; RS<='1';  -- h
--      when  27  => Q <=x"A0"; RS<='1';
      when  17 => Q <=x"40"; RS<='0';  -- CGRAM
      when  18 => Q <=x"08"; RS<='1';  -- 年
      when  19 => Q <=x"0f"; RS<='1';  -- 
      when  20=> Q <=x"12"; RS<='1';  -- 
      when  21 => Q <=x"0f"; RS<='1';  -- 
      when  22 => Q <=x"0a"; RS<='1';
      when  23 => Q <=x"1f"; RS<='1';  -- 
      when  24 => Q <=x"02"; RS<='1';  -- 
      when  25 => Q <=x"02"; RS<='1';  -- 
      when  26 => Q <=x"0f"; RS<='1';  -- 月
      when  27 => Q <=x"09"; RS<='1';  -- 
      when  28 => Q <=x"0f"; RS<='1';  -- 
      when  29 => Q <=x"09"; RS<='1';  -- 
      when  30 => Q <=x"0f"; RS<='1';  -- 
      when  31 => Q <=x"09"; RS<='1';  -- 
      when  32 => Q <=x"13"; RS<='1';  -- 
      when  33 => Q <=x"00"; RS<='1';  -- 
      when  34 => Q <=x"1f"; RS<='1';  -- 日
      when  35 => Q <=x"11"; RS<='1';  -- 
      when  36 => Q <=x"11"; RS<='1';  -- 
      when  37 => Q <=x"1f"; RS<='1';  -- 
      when  38 => Q <=x"11"; RS<='1';  -- 
      when  39 => Q <=x"11"; RS<='1';  -- 
      when  40 => Q <=x"1f"; RS<='1';  -- 
      when  41 => Q <=x"00"; RS<='1';  -- 
            
      when  42 => Q <=x"c5"; RS<='0';  -- Second Row
      when  43 => Q <=x"32"; RS<='1';  -- 2
      when  44 => Q <=x"30"; RS<='1';  -- 0
      when  45 => Q <=x"31"; RS<='1';  -- 1
      when  46 => Q <=x"32"; RS<='1';  -- 2
      when  47 => Q <=x"00"; RS<='1';  -- 年
      when  48 => Q <=x"31"; RS<='1';  -- 1
      when  49 => Q <=x"01"; RS<='1';  -- 月
      when  50 => Q <=x"31"; RS<='1';  -- 1
      when  51 => Q <=x"30"; RS<='1';  -- 0
      when  52 => Q <=x"02"; RS<='1';  -- 日
            
      when  7 => Q <=x"81"; RS<='0';  -- 1 Row
      when  8 => Q <=D ; RS<='1';  
      when  9 => Q <=C ; RS<='1';
      when  10 => Q <=B ; RS<='1';
      when  11 => Q <=x"A5" ; RS<='1';
      when  12 => Q <=A ; RS<='1';
      when  13 => Q <=x"df";rs<='1';
      when  14 => Q <=x"43";rs<='1';
    
      when 53 => Q <=x"0c"; RS<='0'; 
      when  others => Q <=x"A0"; RS<='1';  
    end  case;
    
end if;	
END PROCESS;
process(s1)
begin
	var4<=CONV_INTEGER(s1)/1600;   --百位
	var3<=CONV_INTEGER(s1)/160 rem 10;   --十位
	var2<=CONV_INTEGER(s1)/16 rem 10;   --个位
	var1<=CONV_INTEGER(s1)*10/16 rem 10;   --小数点后一位
case var4 is--百位
    when 0=>d<= x"30";
    when 1=>d<= x"31"; 
	when 2=>d<= x"32";  
	when 3=>d<= x"33";  
	when 4=>d<= x"34" ; 
	when 5=>d<= x"35" ; 
	when 6=>d<= x"36" ; 
	when 7=>d<= x"37" ; 
	when 8=>d<= x"38" ; 
	when 9=>d<= x"39" ; 
	when others =>d<=  x"b0" ;
	end case;
case var3 is--十位
	when 0=>c<= x"30";
    when 1=>c<= x"31"; 
	when 2=>c<= x"32";  
	when 3=>c<= x"33";  
	when 4=>c<= x"34" ; 
	when 5=>c<= x"35" ; 
	when 6=>c<= x"36" ; 
	when 7=>c<= x"37" ; 
	when 8=>c<= x"38" ; 
	when 9=>c<= x"39" ; 
	when others =>c<=  x"ff" ;
	end case;

case var2 is--个位
	when 0=>b<= x"30";
    when 1=>b<= x"31"; 
	when 2=>b<= x"32";  
	when 3=>b<= x"33";  
	when 4=>b<= x"34"; 
	when 5=>b<= x"35"; 
	when 6=>b<= x"36"; 
	when 7=>b<= x"37"; 
	when 8=>b<= x"38"; 
	when 9=>b<= x"39"; 
	when others =>b<= x"ff" ;
	end case;

case var1 is--对小数点后第一位译码
when 0 =>A<= x"30";
    when 1 =>A<= x"31"; 
	when 2=>A<= x"32";  
	when 3=>A<= x"33";  
	when 4=>A<= x"34" ; 
	when 5=>A<= x"35" ; 
	when 6=>A<= x"36" ; 
	when 7=>A<= x"37" ; 
	when 8=>A<= x"38" ; 
	when 9=>A<= x"39" ; 
	when others =>a<=x"ff" ;
	end case;
end process;

--process(s2,s1)
--  begin
--  if s2="0001" then
--  case s1 is
--    when "00111111"=>A<= x"30";
--    when "00000110"=>A<= x"31"; 
--	when "01011011"=>A<= x"32";  
--	when "01001111"=>A<= x"33";  
--	when "01100110"=>A<= x"34" ; 
--	when "01101101"=>A<= x"35" ; 
--	when "01111101"=>A<= x"36" ; 
--	when "00000111"=>A<= x"37" ; 
--	when "01111111"=>A<= x"38" ; 
--	when "01101111"=>A<= x"39" ; 
--	when others =>a<=x"24" ;
--	end case;
--	elsif s2="0010" then
--	case s1 is
--    when "10111111"=>b<= x"30";
--    when "10000110"=>b<= x"31"; 
--	when "11011011"=>b<= x"32";  
--	when "11001111"=>b<= x"33";  
--	when "11100110"=>b<= x"34"; 
--	when "11101101"=>b<= x"35"; 
--	when "11111101"=>b<= x"36"; 
--	when "10000111"=>b<= x"37"; 
--	when "11111111"=>b<= x"38"; 
--	when "11101111"=>b<= x"39"; 
--	when others =>b<= x"25" ;
--	end case;
--	elsif s2="0011" then
--	case s1 is
--    when "00111111"=>c<= x"30";
--    when "00000110"=>c<= x"31"; 
--	when "01011011"=>c<= x"32";  
--	when "01001111"=>c<= x"33";  
--	when "01100110"=>c<= x"34" ; 
--	when "01101101"=>c<= x"35" ; 
--	when "01111101"=>c<= x"36" ; 
--	when "00000111"=>c<= x"37" ; 
--	when "01111111"=>c<= x"38" ; 
--	when "01101111"=>c<= x"39" ; 
--	when others =>c<=  x"26" ;
--	end case;
--	elsif s2="0100" then
--	case s1 is
--    when "00111111"=>d<= x"30";
--    when "00000110"=>d<= x"31"; 
--	when "01011011"=>d<= x"32";  
--	when "01001111"=>d<= x"33";  
--	when "01100110"=>d<= x"34" ; 
--	when "01101101"=>d<= x"35" ; 
--	when "01111101"=>d<= x"36" ; 
--	when "00000111"=>d<= x"37" ; 
--	when "01111111"=>d<= x"38" ; 
--	when "01101111"=>d<= x"39" ; 
--	when "10111111"=>d<= x"b0";
--	when others =>d<=  x"2a" ;
--	end case;
--	end if;
--	end process; 

END a;
