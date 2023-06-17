module CLK_GATE (
    input  wire     CLK_EN,
    input  wire     CLK,
    output wire     GATED_CLK
);

/

reg     Latch_Out ;

//latch (Level Sensitive Device)
always @(CLK or CLK_EN)
 begin
  if(!CLK)      // active low
   begin
    Latch_Out <= CLK_EN ;
   end
 end
 
assign  GATED_CLK = CLK && Latch_Out ;




/*
TLATNCAX12M U0_TLATNCAX12M (
.E(CLK_EN),
.CK(CLK),
.ECK(GATED_CLK)
);
*/



endmodule
