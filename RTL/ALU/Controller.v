module Controller #(
    parameter WIDTH = 16
) (
    input   wire                         clk, RST,
    input   wire                         Enable,
    input   wire    [1 : 0]              ALU_FUN,
         
    output  reg                          Arith_Enable,
    output  reg                          Logic_Enable,
    output  reg                          CMP_Enable,
    output  reg                          Shift_Enable,

    input   wire     [2*WIDTH - 1 : 0]     Arith_OUT,
    input   wire                         Arith_Flag,
    input   wire     [2*WIDTH - 1 : 0]     Logic_OUT,
    input   wire                         Logic_Flag,
    input   wire     [2*WIDTH - 1 : 0]     CMP_OUT,
    input   wire                         CMP_Flag,
    input   wire     [2*WIDTH - 1 : 0]     SHIFT_OUT,
    input   wire                         SHIFT_Flag,
    output  wire     [2*WIDTH - 1 : 0]     ALU_OUT,
    output  wire                         OUT_VALID

    );


    reg                 Arith_Enable_comb    ;
    reg                 Logic_Enable_comb    ;
    reg                 CMP_Enable_comb      ;
    reg                 Shift_Enable_comb    ;

    assign {OUT_VALID, ALU_OUT} =   Arith_Flag ? {Arith_Flag,Arith_OUT}  :
                                    Logic_Flag ? {Logic_Flag,Logic_OUT}  :
                                    CMP_Flag   ? {CMP_Flag,CMP_OUT}      :
                                    SHIFT_Flag ? {SHIFT_Flag,SHIFT_OUT}  :
                                    'b0;



    always @(*) begin
        case (ALU_FUN)
            2'b00:  begin
                Arith_Enable_comb = 1'b1;
                Logic_Enable_comb = 1'b0;
                CMP_Enable_comb   = 1'b0;
                Shift_Enable_comb = 1'b0;
            end
            2'b01:  begin
                Arith_Enable_comb = 1'b0;
                Logic_Enable_comb = 1'b1;
                CMP_Enable_comb   = 1'b0;
                Shift_Enable_comb = 1'b0;
            end
            2'b10:  begin
                Arith_Enable_comb = 1'b0;
                Logic_Enable_comb = 1'b0;
                CMP_Enable_comb   = 1'b1;
                Shift_Enable_comb = 1'b0;
            end
            2'b11:  begin
                Arith_Enable_comb = 1'b0;
                Logic_Enable_comb = 1'b0;
                CMP_Enable_comb   = 1'b0;
                Shift_Enable_comb = 1'b1;
            end
        endcase
    end

    always @(posedge clk, negedge RST) begin
        if(!RST) begin
            Arith_Enable   = 1'b0   ;
            Logic_Enable   = 1'b0   ;
            CMP_Enable     = 1'b0   ;
            Shift_Enable   = 1'b0   ;
        end else begin
            if (Enable) begin
                Arith_Enable   = Arith_Enable_comb ;
                Logic_Enable   = Logic_Enable_comb ;
                CMP_Enable     = CMP_Enable_comb   ;
                Shift_Enable   = Shift_Enable_comb ;
            end else begin
                Arith_Enable   = 1'b0   ;
                Logic_Enable   = 1'b0   ;
                CMP_Enable     = 1'b0   ;
                Shift_Enable   = 1'b0   ;
            end
        end

    end

endmodule