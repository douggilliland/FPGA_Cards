module Test05_NIOS(
      ///////// Input CLOCK /////////
      input             clk,
      ///////// RESET /////////
      input            	rst
);

HelloWorld u0(
	.clk_clk(clk),
	.reset_reset_n(rst)
	);

endmodule