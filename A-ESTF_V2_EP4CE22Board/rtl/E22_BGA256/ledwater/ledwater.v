//视飓芯微电子
//电话 15815519071 QQ 906606596
//Email 906606596@qq.com
//LED流水灯试验
//利用分频计数器得到显示流水灯的效果
//LED water lamp test
//Using the frequency counter to get the effect of displaying the water lamp
module ledwater (clk_50M,rst,dataout);

input clk_50M,rst;     //系统时钟50M输入 从E1脚输入。
output [7:0] dataout;  //我们这里用8个LED灯， LED OUTPUT

reg [7:0] dataout;
reg [25:0] count; //分频计数器  Counter

//分频计数器
always @ ( posedge clk_50M )
 begin
  count<=count+1;
 end

always @ ( posedge clk_50M or negedge rst)

 begin
  case ( count[25:22] ) // Count time setting
  //  case ( count[25:22] )这一句希望初学者看明白,
  //  也是分频的关键
  //  只有在0的那一位 对应的LED灯才亮。
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










