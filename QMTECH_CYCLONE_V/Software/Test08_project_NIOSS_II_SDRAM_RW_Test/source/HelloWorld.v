module HelloWorld(
		input clk, 
		input rst,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N
);

nios_ii u0(
	.clk_clk(clk),		
	.pll_0_outclk1_clk(DRAM_CLK),											// .sdram_clk
	.new_sdram_controller_0_wire_addr(DRAM_ADDR),  					// .addr
	.new_sdram_controller_0_wire_ba(DRAM_BA),    					// .ba
	.new_sdram_controller_0_wire_cas_n(DRAM_CAS_N), 				// .cas_n
	.new_sdram_controller_0_wire_cke(DRAM_CKE),   					// .cke
	.new_sdram_controller_0_wire_cs_n(DRAM_CS_N),  					// .cs_n
	.new_sdram_controller_0_wire_dq(DRAM_DQ),    					// .dq
	.new_sdram_controller_0_wire_dqm( {DRAM_UDQM,DRAM_LDQM} ),  // .dqm
	.new_sdram_controller_0_wire_ras_n(DRAM_RAS_N), 				// .ras_n
	.new_sdram_controller_0_wire_we_n(DRAM_WE_N),  					// .we_n
	.reset_reset_n(rst)
	);

endmodule
