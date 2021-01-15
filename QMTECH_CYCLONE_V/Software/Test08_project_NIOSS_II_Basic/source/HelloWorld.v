module HelloWorld(clk, rst);
input clk;
input rst;

nios_ii u0(
	.clk_clk(clk),
	.reset_reset_n(rst)
	);

endmodule
