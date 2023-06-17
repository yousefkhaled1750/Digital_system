module RST_SYNC #(parameter NUM_STAGES = 2)
(
    input   wire    CLK         ,
    input   wire    RST         ,
    output  wire    SYNC_RST
);

BIT_SYNC #(.NUM_STAGES(NUM_STAGES)) U0
(
    .ASYNC(1'b1)   ,
    .CLK(CLK)      ,
    .RST(RST)      ,
    .SYNC(SYNC_RST)    
);



endmodule