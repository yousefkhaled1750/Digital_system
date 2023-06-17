 module ARITHMETIC_UNIT #(
    parameter WIDTH = 16
) (
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [     1    : 0]     ALU_FUN,
    input   wire                        clk,
    input   wire                        RST,
    input   wire                        Arith_Enable,

    output  reg     [2*WIDTH - 1 : 0]   Arith_OUT,
    output  reg                         Arith_Flag

);

    reg     [2*WIDTH - 1 : 0]     Arith_OUT_comb;


    always @(*) begin
        case (ALU_FUN)
            2'b00: begin
                Arith_OUT_comb <= A + B;
            end
            2'b01: begin
                Arith_OUT_comb <= A - B;
            end
            2'b10: begin
                Arith_OUT_comb <= A * B;
            end
            2'b11: begin
                Arith_OUT_comb <= A / B;
            end
        endcase
    end

    always @ (posedge clk, negedge RST)  begin
        if (!RST) begin
            Arith_OUT <= 'b0;
            Arith_Flag <= 'b0;
        end else begin
            if(Arith_Enable) begin
                Arith_OUT <= Arith_OUT_comb ;
                Arith_Flag <= 1'b1          ;
            end else begin
                Arith_OUT <=    'b0;
                Arith_Flag <=   1'b0;
            end    
        end 
    end



endmodule