module CLK_DIV (CLK, CLK2);

  input CLK;

  output CLK2;

 

  reg [16:0] counter;

  reg CLK2;

  wire CLKi;

 

  LCELL U9 (.in(CLK), .out(CLKi));

 

  always @ (posedge CLKi) begin

    counter = counter + 1;

       if (counter == 0) CLK2 = ~CLK2;

  end

endmodule
