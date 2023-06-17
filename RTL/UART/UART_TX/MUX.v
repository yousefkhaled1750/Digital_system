module  MUX
(
    input   wire    [1:0]   SEL,
    input   wire            IN0,
    input   wire            IN1,
    input   wire            IN2,
    input   wire            IN3,    
    output  reg             out
);

    always @(*)
        begin
            case(SEL)
                2'b00:  out =   IN0;
                2'b01:  out =   IN1;
                2'b10:  out =   IN2;
                2'b11:  out =   IN3;
            endcase
        end



endmodule