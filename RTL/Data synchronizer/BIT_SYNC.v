module BIT_SYNC #(parameter NUM_STAGES = 2)
(
    input   wire         ASYNC   ,
    input   wire         CLK     ,
    input   wire         RST     ,
    output  wire         SYNC    
);

    wire     [NUM_STAGES - 1 : 0]     Q;
    genvar i;

    assign SYNC = Q[NUM_STAGES - 1];

    generate
        for(i = 0 ; i < NUM_STAGES ; i = i + 1)
            begin
                if(i == 0)
                    REG    U0  (.D(ASYNC), .CLK(CLK), .RST(RST), .Q(Q[i]));
                else
                    REG    U0  (.D(Q[i-1]), .CLK(CLK), .RST(RST), .Q(Q[i]));
            end
    
    endgenerate


endmodule