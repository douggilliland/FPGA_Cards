//���о΢����
//�绰 15815519071 QQ 906606596
//Email 906606596@qq.com
//��������ܲ���ʵ�飺�Զ�̬ɨ�跽ʽ�ڣ�λ����ͬ��ʾ��--7
//ʵ���Ŀ�������û����ܶ������ܶ�̬��ʾ�ķ�����
//��̬��ʾ�ķ����ǣ���һ����Ƶ���������������ܵ�COM���ͳ��͵�ƽ
//ͬʱ�ͳ���Ӧ�����ݸ�����
//7 digital tube test: dynamic scanning mode in the digital display with 0--7
//The purpose of the experiment is to introduce a number of digital tube dynamic display method.
//Dynamic display method is, according to a certain frequency in turn to each digital tube COM terminal send low level
//At the same time send the corresponding data to each paragraph

module led_0_7 (clk,rst,dataout,U2_138,U2_138_select,U3_138_select);

input clk,rst;         //ϵͳʱ��50M���� ��E1�����롣
output[7:0] dataout;   //����ܵĶ������ Digital tube data
output[2:0] U2_138;        //����ܵ�λѡʹ����� 
output  U2_138_select;     //�����138ʹ�ܿ��� Digital tube enable control
output  U3_138_select;     //����138ʹ�ܿ��� dot array  enable control

reg[7:0] dataout;     
reg[2:0] U2_138;

reg[15:0] cnt_scan;//ɨ��Ƶ�ʼ����� Scanning frequency counter
reg[4:0] dataout_buf;

assign  U2_138_select = 1 ;   //�����138����    Digital tube  work
assign  U3_138_select = 0 ;   //����138������   dot array not work

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
          U2_138 = 8'b000;
       3'b001 :
          U2_138 = 8'b001;
       3'b010 :
          U2_138 = 8'b010;
       3'b011 :
          U2_138 = 8'b011;
       3'b100 :
          U2_138 = 8'b100;
       3'b101 :
          U2_138 = 8'b101;
       3'b110 :
          U2_138 = 8'b110;
       3'b111 :
          U2_138 = 8'b111;
       default :
          U2_138 = 8'b111;
    endcase
end

always@(U2_138) //��ӦCOM�źŸ�����������
begin
	case(U2_138)
		8'b000:
			dataout_buf=0;
		8'b001:
			dataout_buf=1;
		8'b010:
			dataout_buf=2;
		8'b011:
			dataout_buf=3;	
		8'b100:
			dataout_buf=4;
		8'b101:
			dataout_buf=5;
		8'b110:
			dataout_buf=6;
		8'b111:
			dataout_buf=7;
		default: 
			dataout_buf=8;
	 endcase
end

always@(dataout_buf)
begin

	case(dataout_buf)
		4'b0000:
			dataout=8'b1100_0000;
		4'b0001:
			dataout=8'b1111_1001;
		4'b0010:
			dataout=8'b1010_0100;
		4'b0011:
			dataout=8'b1011_0000;
		4'b0100:
			dataout=8'b1001_1001;
		4'b0101:
			dataout=8'b1001_0010;
		4'b0110:
			dataout=8'b1000_0010;
		4'b0111:
			dataout=8'b1111_1000;
		4'b1000:
			dataout=8'b1000_0000;
		4'b1001:
			dataout=8'b1001_1000;
		4'b1010:
			dataout=8'b1000_1000;
		4'b1011:
			dataout=8'b1000_0011;
		4'b1100:
			dataout=8'b1100_0110;
		4'b1101:
			dataout=8'b1010_0001;
		4'b1110:
			dataout=8'b1000_0110;
		4'b1111:
			dataout=8'b1000_1110;
	 endcase
end

endmodule 