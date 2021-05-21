`timescale 1ns / 1ps

module uart_tx_path(
	input clk_i,

	input [7:0] uart_tx_data_i,
	input uart_tx_en_i,
	
	output uart_tx_o
);

parameter BAUD_DIV     = 13'd5208;      //9600bps��50Mhz/9600=5208�������ʿɵ�
parameter BAUD_DIV_CAP = 13'd2604;      //50Mhz/9600/2=2604�������ʿɵ�

reg [12:0] baud_div=0;			         //���������ü�����
reg baud_bps=0;				             //���ݷ��͵��ź�,����Ч
(* MARKDEBUG = "TRUE" *)reg [9:0] send_data=10'b1111111111;     //���������ݼĴ�����1bit��ʼ�ź�+8bit��Ч�ź�+1bit�����ź�
(* MARKDEBUG = "TRUE" *)reg [3:0] bit_num=0;	                //�������ݸ���������
reg uart_send_flag=0;	                //���ݷ��ͱ�־λ
reg uart_tx_o_r=1;		                //�������ݼĴ����ʼ״̬λ��

always@(posedge clk_i)
begin
	if(baud_div==BAUD_DIV_CAP)	        //�������ʼ��������������ݷ����е�ʱ�����������ź�baud_bps�������������
		begin
			baud_bps<=1'b1;
			baud_div<=baud_div+1'b1;
		end
	else if(baud_div<BAUD_DIV && uart_send_flag)//���ݷ��ͱ�־λ��Ч�ڼ䣬�����ʼ������ۼӣ��Բ���������ʱ��
		begin
			baud_div<=baud_div+1'b1;
			baud_bps<=0;	
		end
	else
		begin
			baud_bps<=0;
			baud_div<=0;
		end
end

always@(posedge clk_i)
begin
	if(uart_tx_en_i)	//�������ݷ���ʹ���ź�ʱ���������ݷ��ͱ�־�ź�
		begin
			uart_send_flag<=1'b1;
			send_data<={1'b1,uart_tx_data_i,1'b0};//���������ݼĴ���װ�1bit��ʼ�ź�0+8bit��Ч�ź�+1bit�����ź�
		end
	else if(bit_num==4'd10)	//���ͽ���ʱ�����������ͱ�־�źţ����������������ݼĴ����ڲ��ź�
		begin
			uart_send_flag<=1'b0;
			send_data<=10'b1111_1111_11;
		end
end

always@(posedge clk_i)
begin
	if(uart_send_flag)	//������Чʱ��
		begin
			if(baud_bps)//���ⷢ�͵��ź�
				begin
					if(bit_num<=4'd9)
						begin
							uart_tx_o_r<=send_data[bit_num];	//���ʹ����ͼĴ��������ݣ��ӵ�λ����λ
							bit_num<=bit_num+1'b1;
						end
				end
			else if(bit_num==4'd10)
				bit_num<=4'd0;
		end
	else
		begin
			uart_tx_o_r<=1'b1;	//����״̬ʱ�����ַ��Ͷ�λ�ߵ�ƽ���Ա�����ʱ�������͵�ƽ�ź�
			bit_num<=0;
		end
end

assign uart_tx_o=uart_tx_o_r;

endmodule
