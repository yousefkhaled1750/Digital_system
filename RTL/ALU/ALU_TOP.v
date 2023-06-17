module ALU_TOP #(
    parameter WIDTH = 16
) (
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [     3    : 0]     ALU_FUN,
    input   wire                        clk,
    input   wire                        RST,
    input   wire                        Enable,
    output  wire     [2*WIDTH - 1 : 0]  ALU_OUT,
    output  wire                        OUT_VALID

);

    wire                        Arith_Enable;
    wire                        Logic_Enable;
    wire                        CMP_Enable;
    wire                        Shift_Enable;

    wire     [2*WIDTH - 1 : 0]   Arith_OUT;
    wire                         Arith_Flag;
    wire     [2*WIDTH - 1 : 0]   Logic_OUT;
    wire                         Logic_Flag;
    wire     [2*WIDTH - 1 : 0]   CMP_OUT;
    wire                         CMP_Flag;
    wire     [2*WIDTH - 1 : 0]   SHIFT_OUT;
    wire                         SHIFT_Flag;

    


/*
    wire    [WIDTH - 1 : 0]     Arith_OUT_Comb;
    wire                        Carry_OUT_Comb;
    wire                        Arith_Flag_Comb;
    wire    [WIDTH - 1 : 0]     Logic_OUT_Comb;
    wire                        Logic_Flag_Comb;
    wire    [WIDTH - 1 : 0]     CMP_OUT_Comb;
    wire                        CMP_Flag_Comb;
    wire    [WIDTH - 1 : 0]     SHIFT_OUT_Comb;
    wire                        SHIFT_Flag_Comb;    


    /*=====================Controller===================== */
    Controller #(.WIDTH(WIDTH)) C1 ( 
                    .clk(clk), .RST(RST),
                    .Enable(Enable),
                    .ALU_FUN(ALU_FUN[3:2]), 
                    .Arith_Enable(Arith_Enable), 
                    .Logic_Enable(Logic_Enable), 
                    .CMP_Enable(CMP_Enable),
                    .Shift_Enable(Shift_Enable),
                    .Arith_OUT(Arith_OUT),
                    .Arith_Flag(Arith_Flag),
                    .Logic_OUT(Logic_OUT),
                    .Logic_Flag(Logic_Flag),
                    .CMP_OUT(CMP_OUT),
                    .CMP_Flag(CMP_Flag),
                    .SHIFT_OUT(SHIFT_OUT),
                    .SHIFT_Flag(SHIFT_Flag),
                    .ALU_OUT(ALU_OUT),
                    .OUT_VALID(OUT_VALID)
                    );


    /*=====================Arithmetic===================== */
    ARITHMETIC_UNIT #(.WIDTH(WIDTH))    Arithmetic( .A(A),
                                                    .B(B),
                                                    .ALU_FUN(ALU_FUN[1:0]),
                                                    .clk(clk), .RST(RST),
                                                    .Arith_Enable(Arith_Enable),
                                                    .Arith_OUT(Arith_OUT),
                                                    .Carry_OUT(Carry_OUT),
                                                    .Arith_Flag(Arith_Flag)
                                                    );

    
    /*=====================Logic===================== */
    LOGIC_UNIT #(.WIDTH(WIDTH))    Logic(           .A(A),
                                                    .B(B),
                                                    .ALU_FUN(ALU_FUN[1:0]),
                                                    .clk(clk), .RST(RST),
                                                    .Logic_Enable(Logic_Enable),
                                                    .Logic_OUT(Logic_OUT),
                                                    .Logic_Flag(Logic_Flag)
                                                    );


    /*=====================CMP===================== */
    CMP_UNIT #(.WIDTH(WIDTH))    CMP(               .A(A),
                                                    .B(B),
                                                    .ALU_FUN(ALU_FUN[1:0]),
                                                    .clk(clk), .RST(RST),
                                                    .CMP_Enable(CMP_Enable),
                                                    .CMP_OUT(CMP_OUT),
                                                    .CMP_Flag(CMP_Flag)
                                                    );

    /*=====================SHIFT===================== */
    SHIFT_UNIT #(.WIDTH(WIDTH))    SHIFT(           .A(A),
                                                    .B(B),
                                                    .ALU_FUN(ALU_FUN[1:0]),
                                                    .clk(clk), .RST(RST),
                                                    .Shift_Enable(Shift_Enable),
                                                    .SHIFT_OUT(SHIFT_OUT),
                                                    .SHIFT_Flag(SHIFT_Flag)
                                                    );

endmodule