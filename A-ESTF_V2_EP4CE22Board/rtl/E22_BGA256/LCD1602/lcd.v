//���о΢����
//�绰15815519071  QQ906606596
//email 906606596@qq.com
//��ʵ������LCD1602��ʾӢ�ġ���LCD���ֿ⣩
//This experiment is to use LCD1602 display english. (LCD with font)
module lcd(clk, rs, rw, en,dat);  

input clk;          //ϵͳʱ������50M , clk input 50m
 output [7:0] dat;  //LCD��8λ���ݿ�  LCD data
 output  rs,rw,en;  //LCD�Ŀ��ƽ�   LCD control pin
  
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [4:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 
 parameter  set0=4'h0; 
 parameter  set1=4'h1; 
 parameter  set2=4'h2; 
 parameter  set3=4'h3; 
 parameter  dat0=4'h4; 
 parameter  dat1=4'h5; 
 parameter  dat2=4'h6; 
 parameter  dat3=4'h7; 
 parameter  dat4=4'h8; 
 parameter  dat5=4'h9; 

 parameter  dat6=4'hA; 
 parameter  dat7=4'hB; 
 parameter  dat8=4'hC; 
 parameter  dat9=4'hD; 
 parameter  dat10=4'hE; 
 parameter  dat11=5'h10; 
 parameter  nul=4'hF; 
always @(posedge clk)      
 begin 
  counter=counter+1; 
  if(counter==16'h000f)  
  clkr=~clkr; 
end 
always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0:   begin  rs<=0; dat<=8'h38; next<=set1; end  //*����8λ��ʽ,2��,5*7*   * set 8 bit format, line 2, 5*7*
    set1:   begin  rs<=0; dat<=8'h0C; next<=set2; end  //*������ʾ,�ع��,����˸*/ the whole show, close the cursor, not blinking.
    set2:   begin  rs<=0; dat<=8'h6; next<=set3; end   //*�趨���뷽ʽ,��������λ*/ * set the input mode, not incremental shift. 
    set3:   begin  rs<=0; dat<=8'h1; next<=dat0; end   //*�����ʾ*/    

    //������LCD�ĳ�ʼ��  Above is the initialization of LCD
    dat0:   begin  rs<=1; dat<=8'h3C; next<=dat1; end 
    dat1:   begin  rs<=1; dat<="F"; next<=dat2; end 
    dat2:   begin  rs<=1; dat<="P"; next<=dat3; end 
    dat3:   begin  rs<=1; dat<="G"; next<=dat4; end 
    dat4:   begin  rs<=1; dat<="A"; next<=dat5; end 
    dat5:   begin  rs<=1; dat<=8'h3E; next<=dat6; end 
    dat6:   begin  rs<=1; dat<="G"; next<=dat7; end 
    dat7:   begin  rs<=1; dat<="O"; next<=dat8; end 
    dat8:   begin  rs<=1; dat<="O"; next<=dat9; end 
    dat9:   begin  rs<=1; dat<="D"; next<=dat10; end 
    dat10:   begin  rs<=1; dat<="!"; next<=dat11; end 
    dat11:   begin  rs<=1; dat<="!"; next<=nul; end 
    //����������12��״̬��Ҫ��ʾ���ַ� FPGA GOOD!!
     nul:   begin rs<=0;  dat<=8'h00;                    //��һ�� Ȼ�� ��Һ����E �� ���� 
              if(cnt!=2'h2)  
                  begin  
                       e<=0;next<=set0;cnt<=cnt+1;  
                  end  
                   else  
                     begin next<=nul; e<=1; 
                    end    
              end 
   default:   next=set0; 
    endcase 
 end 
assign en=clkr|e; 
assign rw=0; 
endmodule  