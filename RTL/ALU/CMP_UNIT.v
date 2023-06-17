module CMP_UNIT #(
    parameter WIDTH = 16
) (
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [     1    : 0]     ALU_FUN,
    input   wire                        clk, RST,
    input   wire                        CMP_Enable,

    output  reg     [2*WIDTH - 1 : 0]     CMP_OUT,
    output  reg                         CMP_Flag

);
    
    reg     [WIDTH - 1 : 0]         CMP_OUT_comb;

    always @(*) begin
        case (ALU_FUN)
            2'b00: begin    //NOP
                CMP_OUT_comb <= 'b0;
            end
            2'b01: begin
                if (A == B) begin
                    CMP_OUT_comb <= 'b01;
                end
                else    begin
                    CMP_OUT_comb <= 'b0;
                end
            end
            2'b10: begin
                if (A > B) begin
                    CMP_OUT_comb <= 'b010;
                end
                else    begin
                    CMP_OUT_comb <= 'b0;
                end
            end
            2'b11: begin
                if (A < B) begin
                    CMP_OUT_comb <= 'b011;
                end
                else    begin
                    CMP_OUT_comb <= 'b0;
                end
            end
        endcase 
    end

    always @ (posedge clk, negedge RST) begin
        if (!RST) begin
            CMP_OUT <= 'b0;
            CMP_Flag <= 1'b0;
        end else begin
            if (CMP_Enable) begin
                CMP_OUT <= CMP_OUT_comb;    
                CMP_Flag <= 1'b1;
            end else begin
                CMP_OUT <= 'b0;
                CMP_Flag <= 1'b0;
            end
        end     
    end


endmodule