module PULSE_GEN
(
    input   wire    IN      ,
    input   wire    CLK     ,
    input   wire    RST     ,
    output  wire    pulse_gen
);
    wire    Q;
    
    assign  pulse_gen = ~Q & IN;
    
    REG #(.BUS_WIDTH(1))   U0  (.D(IN), .CLK(CLK), .RST(RST), .Q(Q));



endmodule