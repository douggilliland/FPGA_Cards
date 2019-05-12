//���о΢����
//�绰 15815519071 QQ 906606596
//Email 906606596@qq.com
//LED��ˮ������
//���÷�Ƶ�������õ���ʾ��ˮ�Ƶ�Ч��
//LED water lamp test
//Using the frequency counter to get the effect of displaying the water lamp
module ledwater (clk_50M,rst,dataout);

input clk_50M,rst;     //ϵͳʱ��50M���� ��E1�����롣
output [7:0] dataout;  //����������8��LED�ƣ� LED OUTPUT

reg [7:0] dataout;
reg [25:0] count; //��Ƶ������  Counter

//��Ƶ������
always @ ( posedge clk_50M )
 begin
  count<=count+1;
 end

always @ ( posedge clk_50M or negedge rst)

 begin
  case ( count[25:22] ) // Count time setting
  //  case ( count[25:22] )��һ��ϣ����ѧ�߿�����,
  //  Ҳ�Ƿ�Ƶ�Ĺؼ�
  //  ֻ����0����һλ ��Ӧ��LED�Ʋ�����
  0: dataout<=12'b11111110;    //X miao
  1: dataout<=12'b11111101;    //Y miao
  2: dataout<=12'b11111011;
  3: dataout<=12'b11110111;
  4: dataout<=12'b11101111;
  5: dataout<=12'b11011111;  
  6: dataout<=12'b10111111; 
  7: dataout<=12'b01111111;
  8: dataout<=12'b01111111;
  9: dataout<=12'b10111111;
  10:dataout<=12'b11011111;
  11:dataout<=12'b11101111;
  12:dataout<=12'b11110111;
  13:dataout<=12'b11111011;
  14:dataout<=12'b11111101;
  15:dataout<=12'b11111110;

  endcase
 end
endmodule










