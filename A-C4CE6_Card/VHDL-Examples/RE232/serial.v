
module serial(clk,rst,rxd,txd,en,seg_data,key_input,lowbit);

input clk,rst;
input rxd;//???????
input key_input;//????

output[7:0] en;
output[7:0] seg_data;
reg[7:0] seg_data;
output txd;//???????
output lowbit;


////////////////////inner reg////////////////////
reg[15:0] div_reg;//???????????????????????8???????
reg[2:0]  div8_tras_reg;//?????????????????????
reg[2:0]  div8_rec_reg;//?????????????????????
reg[3:0] state_tras;//???????
reg[3:0] state_rec;//???????
reg clkbaud_tras;//??????????????
reg clkbaud_rec;//??????????????
reg clkbaud8x;//?8????????????????????????bit???????8???

reg recstart;//??????
reg recstart_tmp;

reg trasstart;//??????

reg rxd_reg1;//?????1
reg rxd_reg2;//?????2???????????????????
reg txd_reg;//?????
reg[7:0] rxd_buf;//??????
reg[7:0] txd_buf;//??????

reg[2:0] send_state;//?????PC??"Welcome"?????????????
reg[19:0] cnt_delay;//???????
reg start_delaycnt;//????????
reg key_entry1,key_entry2;//????????

////////////////////////////////////////////////
parameter div_par=16'h145;//????????????????????????????????????8	
		  //???????9600???????????????9600*8  (CLK  50M)

////////////////////////////////////////////////
assign txd=txd_reg;
assign lowbit=0;

assign en=0;//7??????????

always@(posedge clk )
begin
	if(!rst) begin 
		cnt_delay<=0;
		start_delaycnt<=0;
	 end
	else if(start_delaycnt) begin
		if(cnt_delay!=20'd800000) begin
			cnt_delay<=cnt_delay+1;
		 end
		else begin
			cnt_delay<=0;
			start_delaycnt<=0;
		 end
	 end
	else begin
		if(!key_input&&cnt_delay==0)
				start_delaycnt<=1;
	 end
end

always@(posedge clk)
begin
	if(!rst) 
		key_entry1<=0;
	else begin
		if(key_entry2)
			key_entry1<=0;
		else if(cnt_delay==20'd800000) begin
			if(!key_input)
				key_entry1<=1;
		 end
	 end
end

always@(posedge clk )
begin
	if(!rst)
		div_reg<=0;
	else begin
		if(div_reg==div_par-1)
			div_reg<=0;
		else
			div_reg<=div_reg+1;
	 end
end

always@(posedge clk)//????8???????
begin
	if(!rst)
		clkbaud8x<=0;
	else if(div_reg==div_par-1)
		clkbaud8x<=~clkbaud8x;
end


always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst)
		div8_rec_reg<=0;
	else if(recstart)//??????
		div8_rec_reg<=div8_rec_reg+1;//??????????8?????????1??
end

always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst)
		div8_tras_reg<=0;
	else if(trasstart)
		div8_tras_reg<=div8_tras_reg+1;//??????????8?????????1??
end

always@(div8_rec_reg)
begin
	if(div8_rec_reg==7)
		clkbaud_rec=1;//??7??????????????????
	else
		clkbaud_rec=0;
end

always@(div8_tras_reg)
begin
	if(div8_tras_reg==7)
		clkbaud_tras=1;//??7??????????????????
	else
		clkbaud_tras=0;
end

always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst) begin
		txd_reg<=1;
		trasstart<=0;
		txd_buf<=0;
		state_tras<=0;
		send_state<=0;
		key_entry2<=0;
	 end
	else begin
		if(!key_entry2) begin
			if(key_entry1) begin
				key_entry2<=1;
				txd_buf<=8'd119; //"w"
			 end
		 end
		else  begin
			case(state_tras)
				4'b0000: begin  //?????
					if(!trasstart&&send_state<7) 
						trasstart<=1;
					else if(send_state<7) begin
						if(clkbaud_tras) begin
							txd_reg<=0;
							state_tras<=state_tras+1;
						 end
					 end
					else begin
						key_entry2<=0;
						state_tras<=0;
					 end					
				end		
				4'b0001: begin //???1?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0010: begin //???2?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				 4'b0011: begin //???3?
				 	if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0100: begin //???4?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0101: begin //???5?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0110: begin //???6?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0111: begin //???7?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b1000: begin //???8?
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b1001: begin //?????
					if(clkbaud_tras) begin
						txd_reg<=1;
						txd_buf<=8'h55;
						state_tras<=state_tras+1;
					 end
				 end
				4'b1111:begin 
					if(clkbaud_tras) begin
						state_tras<=state_tras+1;
						send_state<=send_state+1;
						trasstart<=0;
						case(send_state)
							3'b000:
								txd_buf<=8'd101;//"e"
							3'b001:
								txd_buf<=8'd108;//"l"
							3'b010:
								txd_buf<=8'd99;//"c"
							3'b011:
								txd_buf<=8'd111;//"o"
							3'b100:
								txd_buf<=8'd109;//"m"
							3'b101:
								txd_buf<=8'd101;//"e"
							default:
								txd_buf<=0;
						 endcase
					 end
				 end
				default: begin
					if(clkbaud_tras) begin
						state_tras<=state_tras+1;
						trasstart<=1;
					 end
				 end
			 endcase
		 end
	 end
end

always@(posedge clkbaud8x or negedge rst)//??PC????
begin
	if(!rst) begin
		rxd_reg1<=0;
		rxd_reg2<=0;
		rxd_buf<=0;
		state_rec<=0;
		recstart<=0;
		recstart_tmp<=0;
	 end
	else  begin
		 rxd_reg1<=rxd;
		 rxd_reg2<=rxd_reg1;
		 if(state_rec==0) begin
			 if(recstart_tmp==1) begin
		 		recstart<=1;
		 		recstart_tmp<=0;
				state_rec<=state_rec+1;
		  	  end
		 	 else if(!rxd_reg1&&rxd_reg2) //?????????????????
				recstart_tmp<=1;
		   end
		 else if(state_rec>=1&&state_rec<=8) begin
		 	 if(clkbaud_rec) begin
			 	rxd_buf[7]<=rxd_reg2;
				rxd_buf[6:0]<=rxd_buf[7:1];
				state_rec<=state_rec+1;
			  end
		  end
		 else if(state_rec==9) begin
		 	if(clkbaud_rec) begin
		 		state_rec<=0;
				recstart<=0;
			 end
		  end
	  end
end

always@(rxd_buf) //??????????????
begin
      case (rxd_buf)
		8'h30:
			seg_data=8'b11000000;
		8'h31:
			seg_data=8'b11111001;
		8'h32:
			seg_data=8'b10100100;
		8'h33:
			seg_data=8'b10110000;
		8'h34:
			seg_data=8'b10011001;
		8'h35:
			seg_data=8'b10010010;
		8'h36:
			seg_data=8'b10000010;
		8'h37:
			seg_data=8'b11111000;
		8'h38:
			seg_data=8'b10000000;
		8'h39:
			seg_data=8'b10010000;
		8'h41:
			seg_data=8'b00010001;
		8'h42:
			seg_data=8'b11000001;
		8'h43:
			seg_data=8'b0110_0011;
		8'h44:
			seg_data=8'b1000_0101;
		8'h45:
			seg_data=8'b0110_0001;
		8'h46:
			seg_data=8'b0111_0001;
		default:
			seg_data=8'b1111_1111;
	 endcase
end	

endmodule
	
