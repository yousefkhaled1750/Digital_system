module parity_calc #(parameter WIDTH = 8)
(
    input   wire                        RST,
    input   wire    [WIDTH - 1 : 0]     DATA,
    input   wire                        DATA_VALID,
    input   wire                        PAR_TYP,
    output  reg                         Par_bit
);
    reg [WIDTH - 1 : 0] SAMPLED_DATA;
    //PAR_TYP = 0 -> Even (XOR)
    //PAR_TYP = 1 -> ODD  (XNOR)
    always @(*)
        begin
            case(PAR_TYP)
                1'b0:   Par_bit =  ^SAMPLED_DATA;
                1'b1:   Par_bit = ~^SAMPLED_DATA;
            endcase
        end

    always @(*) begin
        if (!RST) begin
            SAMPLED_DATA = 'b0;
        end
        else if(DATA_VALID)
            begin
                SAMPLED_DATA = DATA;
            end
        else
            begin
                SAMPLED_DATA = SAMPLED_DATA;
            end
    end



endmodule