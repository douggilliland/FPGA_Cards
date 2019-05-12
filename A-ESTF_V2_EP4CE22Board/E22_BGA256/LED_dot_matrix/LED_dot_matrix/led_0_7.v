//���о΢����
//�绰 15815519071 QQ 906606596
//Email 906606596@qq.com
//��ʵ��ѧϰ����ģ���ʹ��
//��ʵԭ���ʹ�ö�̬����ܵ�ԭ��һ����
//�ڵ���������ʾһ����
//This experiment to study the use of dot matrix module
//In fact, the principle and the use of the principle of dynamic digital tube
//Show a Peach  on the dot matrix
module led_0_7 (clk,rst,dataout,U2_138_select,U3_138_select ,U3_138_A);

input clk,rst;         //ϵͳʱ��50M���� ��E1�����롣 CLK 50M
output[7:0] dataout;   //����Ķ������ dot array data output
output[2:0] U3_138_A;   //�������ѡʹ����� dot array 138 address select enable output
output  U2_138_select;  //�����ʹ�ܿ��� Digital tube enable control
output  U3_138_select;  //����ʹ�ܿ���  dot array  enable control
   
reg[7:0] dataout;     
reg[2:0] U3_138_A;

reg[15:0] cnt_scan;//ɨ��Ƶ�ʼ�����
reg[2:0] dataout_buf;

assign  U2_138_select = 0 ;  //��ֹ����ܹ���  Digital tube  not work 
assign  U3_138_select = 1 ;  //������ dot array  work

always@(posedge clk or negedge  rst)
begin
	if(!rst) begin
		cnt_scan<=0;
		
	 end
	else begin
		cnt_scan<=cnt_scan+1;
		end
end

always @(cnt_scan)
begin
   case(cnt_scan[15:13])
       3'b000 :
          U3_138_A = 3'b000;
       3'b001 :
          U3_138_A = 3'b001;
       3'b010 :
          U3_138_A = 3'b010;
       3'b011 :
          U3_138_A = 3'b011;
       3'b100 :
          U3_138_A = 3'b100;
       3'b101 :
          U3_138_A = 3'b101;
       3'b110 :
          U3_138_A = 3'b110;
       3'b111 :
          U3_138_A = 3'b111;
    endcase
end

always@(U3_138_A) //��Ӧ138 ��8��״̬ There are 8 states corresponding to the 138
begin
	case(U3_138_A)
		3'b000:
			dataout_buf=0;
		3'b001:
			dataout_buf=1;
		3'b010:
			dataout_buf=2;
		3'b011:
			dataout_buf=3;	
		3'b100:
			dataout_buf=4;
		3'b101:
			dataout_buf=5;
		3'b110:
			dataout_buf=6;
		3'b111:
			dataout_buf=7;

	 endcase
end

always@(dataout_buf)
begin
//�ڵ���������ʾһ��������Ҫ�ĵ������
	case(dataout_buf)
		3'b000:
			dataout=8'b11101111;
		3'b001:
		dataout=8'b11110111;
		3'b010:
		dataout=8'b10010001;
	   3'b011:
		dataout=8'b01100110;
	   3'b100:
		dataout=8'b01111110;
		3'b101:
		dataout=8'b10111101;
		3'b110:
		dataout=8'b11011011;
		3'b111:
			dataout=8'b11100111;
			
			

		
		
	 endcase
end

endmodule 