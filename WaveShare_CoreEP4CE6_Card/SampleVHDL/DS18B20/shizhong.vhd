library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------------------------
entity shizhong is
  port( Clk       :  in   std_logic;   --ʱ������
        Rst       :  in   std_logic;   --��λ����
        S1,S2     :  in   std_logic;   --ʱ��������� 
        spk       :  out  std_logic;
        h1,h10,m1,m10: out std_logic_vector(7 downto 0)
       );      
end shizhong;
--------------------------------------------------------------------
architecture behave of shizhong is
  signal Disp_Decode   : std_logic_vector(6 downto 0);
  signal SEC1,SEC10    : integer range 0 to 9; 
  signal MIN1,MIN10    : integer range 0 to 9;
  signal HOUR1,HOUR10  : integer range 0 to 9;
  signal Disp_temp     : integer range 0 to 9;

  signal Clk1kHz        : std_logic;--�����ɨ��ʱ�� 
  signal Clk1Hz        : std_logic;--ʱ�Ӽ�ʱʱ��
  signal lcdDecode     : std_logic_vector(7 downto 0);
  begin
PROCESS(clk)       --����1hz�ź� 
        variable cnt : INTEGER RANGE 0 TO 49999999; --����1Hzʱ�ӵķ�Ƶ������
     BEGIN 
       IF clk='1' AND clk'event THEN 
         IF cnt=49999999 THEN cnt:=0; 
           ELSE 
            IF cnt<25000000 THEN clk1hz<='1'; 
               ELSE clk1hz<='0'; 
            END IF; 
            cnt:=cnt+1; 
         END IF; 
     END IF; 
    end  process;
   
PROCESS(clk)       --����1khz�ź� 
        variable cnt1 : INTEGER RANGE 0 TO 49999; --����1KHzʱ�ӵķ�Ƶ������
     BEGIN 
       IF clk='1' AND clk'event THEN 
         IF cnt1=49999 THEN cnt1:=0; 
           ELSE 
            IF cnt1<25000 THEN clk1khz<='1'; 
               ELSE clk1khz<='0'; 
            END IF; 
            cnt1:=cnt1+1; 
         END IF; 
     END IF; 
    end  process;
    process(Clk1Hz,Rst)
    variable i:integer range 0 to 3:=0;
    
    begin
        if(Rst='0') then    --ϵͳ��λ
           SEC1<=0;
           SEC10<=0;
           MIN1<=0;
           MIN10<=0;
           HOUR1<=0;
           HOUR10<=0;
        elsif(Clk1Hz'event and Clk1Hz='1') then    --��������
           if(S1='0') then   --����Сʱ
              if(HOUR1=9) then
                 HOUR1<=0;
                 HOUR10<=HOUR10+1;
              elsif(HOUR10=2 and HOUR1=3) then
                 HOUR1<=0;
                 HOUR10<=0;
              else 
                 HOUR1<=HOUR1+1;
              end if;
           elsif(S2='0') then  --���ڷ���
              if(MIN1=9) then
                 MIN1<=0;
                 if(MIN10=5) then
                    MIN10<=0;
                 else 
                    MIN10<=MIN10+1;
                 end if;
              else
                 MIN1<=MIN1+1;
              end if;
           elsif(SEC1=9) then
              SEC1<=0;
              if(SEC10=5) then
                 SEC10<=0;
                 if(MIN1=9) then
                    MIN1<=0;
                    if(MIN10=5) then
                       MIN10<=0;
                       if(HOUR1=9) then
                         HOUR1<=0;
                         HOUR10<=HOUR10+1;
                       elsif(HOUR10=2 and HOUR1=3) then
                         HOUR1<=0;
                         HOUR10<=0;
                       else 
                         HOUR1<=HOUR1+1;
                       end if;
                    else 
                       MIN10<=MIN10+1;
                    end if;
                 else
                    MIN1<=MIN1+1;
                 end if;
              else
                 SEC10<=SEC10+1;
              end if;
           else 
              SEC1<=SEC1+1;
           end if;
        end if; 
      if i=0 then
         Disp_Temp<=hour1;
         h1<=lcddecode;
         i:=1;
      elsif i=1 then
         Disp_Temp<=hour10;
         h10<=lcddecode;
         i:=2;
      elsif i=2 then
         Disp_Temp<=min1;
         m1<=lcddecode;
         i:=3;
       else
       Disp_Temp<=min10;
       m10<=lcddecode;
       i:=0;
       end if;
                  
    end process;
 process(Disp_Temp)      --��ʾת��
   begin
        case Disp_Temp is
          when 0=>lcdDecode<=x"30";   --0
          when 1=>lcdDecode<=x"31";   --1
          when 2=>lcdDecode<=x"32";   --2
          when 3=>lcdDecode<=x"33";   --3
          when 4=>lcdDecode<=x"34";   --4
          when 5=>lcdDecode<=x"35";   --5
          when 6=>lcdDecode<=x"36";   --6
          when 7=>lcdDecode<=x"37";   --7
          when 8=>lcdDecode<=x"38";   --8
          when 9=>lcdDecode<=x"39";   --9
          when others=>lcdDecode<=x"ff";   --ȫ��
        end case;
    end process;   


end behave;
