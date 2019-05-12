//-------------------------------------------------------------------------------------------------
//*************************************************************************************************
//  CreateDate  :  2009-03-29 
//  ModifData   :  2009-03-30 
//  Description :  KeyBoard ( Verilog HDL )
//  Author      :  Explorer01 
//  Version     :  V1.1  
//*************************************************************************************************
//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Module declaration 
module key44
(
	code      ,
	col       ,
	valid     ,
	row       ,
	sys_clk   ,
	rst  
);

//-------------------------------------------------------------------------------------------------
// Port declaration 
output  [3:0]  col     ;
output         valid   ;
output  [3:0]  code    ;

input   [3:0]  row     ;
input          sys_clk,rst ;

//-------------------------------------------------------------------------------------------------
// 
reg     [3:0]  col,code;
reg     [5:0]  state,next_state;

parameter  S_0 = 6'b000001,
           S_1 = 6'b000010,
           S_2 = 6'b000100,
           S_3 = 6'b001000,
           S_4 = 6'b010000,
           S_5 = 6'b100000;
reg        S_row ; 
reg [3:0] count,row_reg,col_reg;
reg       clk2,clk4;
 
 
reg [4:0] Mega_cnt;
wire      clk;

//-------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------
// 
always @( posedge sys_clk, negedge rst )
begin
	if(!rst)	Mega_cnt<=0;
	else		Mega_cnt<=Mega_cnt+1;
end

assign clk = Mega_cnt[4];

//-------------------------------------------------------------------------------------------------
// Frequency Division Two 
always @( posedge clk )
clk2 <= ~clk2;

// A quarter of the clk 
always @( posedge clk2 )
clk4 <= ~clk4;

//-------------------------------------------------------------------------------------------------
// Check the Key 
//-------------------------------------------------------------------------------------------------
always @( posedge clk4, negedge rst )
if(!rst)
	begin
		count <= 0;
		S_row <= 0;
	end
else
	begin
		if(!(row[0]&row[1]&row[2]&row[3]))
			begin
				if(count < 'd4)	count <= count + 1;		// Filter 
				else			S_row <= 1;
			end
	//	else if(state[5]||state[0])
		else if((state == S_0) || (state == S_5))
			begin
				count <= 0;
				S_row <= 0;
			end
	end

assign valid = ((state == S_1)||(state == S_2)||(state == S_3)||(state == S_4)) &&  (!(row[3]&row[2]&row[1]&row[0]));

//-------------------------------------------------------------------------------------------------
// Save the value of row and col 
always @( negedge clk )
if( valid )
	begin
		row_reg <= row ;
		col_reg <= col ;
	end
/*
else
	begin
		row_reg <= row_reg ;
		col_reg <= col_reg ;
	end*/

//-------------------------------------------------------------------------------------------------
// Decode the Key 
always @( row_reg, col_reg, clk )
	case( {row_reg,col_reg} )
		8'B1110_1110: code = 4'hd;
		8'B1110_1101: code = 4'h9;
		8'B1110_1011: code = 4'h5;
		8'B1110_0111: code = 4'h1;
		
		8'B1101_1110: code = 4'he;
		8'B1101_1101: code = 4'ha;
		8'B1101_1011: code = 4'h6;
		8'B1101_0111: code = 4'h2;
		
		8'B1011_1110: code = 4'hf;
		8'B1011_1101: code = 4'hb;
		8'B1011_1011: code = 4'h7;
		8'B1011_0111: code = 4'h3;
		
		8'B0111_1110: code = 4'h0;
		8'B0111_1101: code = 4'hc;
		8'B0111_1011: code = 4'h8;
		8'B0111_0111: code = 4'h4;
		default		: code = 4'h0;
	endcase
 
//-------------------------------------------------------------------------------------------------
// State Machine : Mealy 
//-------------------------------------------------------------------------------------------------
always @( posedge clk4, negedge rst )
	if( !rst )
		state <= S_0 ;
	else
		state <= next_state ;

//-------------------------------------------------------------------------------------------------
always @( state, row, S_row )
begin
	col = 0;
	//----------------------------------------------
	case( state )
	S_0 :  begin
			col = 4'b0000;
			if(S_row)	next_state = S_1;
			else		next_state = S_0;
		end
	//----------------------------------------------
	// Decoding... 
	S_1 :  begin
			col = 4'b1110;
			if(row!='hf)	next_state = S_5;
			else			next_state = S_2;
		end
	S_2 :  begin
			col = 4'b1101;
			if(row!='hf)	next_state = S_5;
			else			next_state = S_3;
		end 
	S_3 :  begin
			col = 4'b1011;
			if(row!='hf)	next_state = S_5;
			else			next_state = S_4;
		end  
	S_4 :  begin
			col = 4'b0111;
			if(row!='hf)	next_state = S_5;
			else			next_state = S_0;
		end  
	//----------------------------------------------
	S_5 :  begin
			col = 4'b0000;
			if(row == 4'b1111) 	next_state = S_0;
			else 				next_state = S_5;
		end
	default: next_state = S_0;
	endcase
end

endmodule