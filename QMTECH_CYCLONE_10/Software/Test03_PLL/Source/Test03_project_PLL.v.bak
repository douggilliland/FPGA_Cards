`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:40:55 02/28/2016 
// Design Name: 
// Module Name:    Test03_project_PLL 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Test03_project_PLL(
    input sys_clk,
    input sys_rst_n,
    output led_1
    );

parameter DLY_CNT = 32'd50000000;
parameter HALF_DLY_CNT = 32'd25000000;

(*mark_debug = "true"*)reg r_led;
(*mark_debug = "true"*)reg [31:0]count;

wire  clock_50_pll;
wire sys_clk_200m;

//counter control
always@(posedge sys_clk_200m or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		begin
			count <= 32'd0;
		end
	else if(count == DLY_CNT)
		begin
			count <= 32'd0;
		end
	else
		begin
			count <= count+32'd1;
		end
end

//led output register control
always@(posedge sys_clk_200m or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		begin
			r_led <= 1'b0;
		end
	else if(count < HALF_DLY_CNT)
		begin
			r_led <= 1'b1;
		end
	else
		begin
			r_led <= 1'b0;
		end
end

assign led_1 = r_led;

pll u0(
		.refclk(clock_50_pll),   	// refclk.clk
		.rst(1'b0),      				// reset.reset
		.outclk_0(sys_clk_200m) 	// outclk0.clk
);

cv_altclkctrl cv_altclkctrl_inst(
		.inclk  (sys_clk),  			// altclkctrl_input.inclk
		.outclk (clock_50_pll)  	// altclkctrl_output.outclk
);

endmodule
