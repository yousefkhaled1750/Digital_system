module MUX  #(parameter BUS_WIDTH = 1)
(
    input   wire    [BUS_WIDTH - 1 : 0]     IN0   ,
    input   wire    [BUS_WIDTH - 1 : 0]     IN1   ,
    input   wire                            sel   ,
    output  wire    [BUS_WIDTH - 1 : 0]     OUT
);

    assign OUT = sel? IN1   :  IN0;

endmodule