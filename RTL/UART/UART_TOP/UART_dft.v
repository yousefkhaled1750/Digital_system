module UART #(
    parameter WIDTH = 8, PRESCALE_WIDTH = 6
) (
    
    input   wire                                    RST,
    input   wire                                    parity_enable,
    input   wire                                    parity_type,
    input   wire                                    TX_CLK,
    input   wire                                    RX_CLK,

    input   wire        [WIDTH - 1 : 0]             TX_IN_P,
    input   wire                                    TX_IN_V,
    output  wire                                    TX_OUT_S,
    output  wire                                    TX_Busy,
    
    input   wire                                    RX_IN_S,
    output  wire        [WIDTH - 1 : 0]             RX_OUT_P,
    output  wire                                    RX_OUT_V,
    input   wire        [PRESCALE_WIDTH - 1:0]      Prescale,


//DFT signals 
    input   wire                                    SI,
    input   wire                                    SE,
    input   wire                                    scan_clk,
    input   wire                                    scan_rst,
    input   wire                                    test_mode,
    output  wire                                    SO

      
);


wire RX_CLK_M, TX_CLK_M, RST_M;

/*assign  RX_CLK_M = test_mode ? scan_clk : RX_CLK;
assign  TX_CLK_M = test_mode ? scan_clk : TX_CLK;
assign  RST_M = test_mode ? scan_rst : RST;
*/

mux2X1 M0 (
.IN_0(TX_CLK),
.IN_1(scan_clk),
.SEL(test_mode),
.OUT(TX_CLK_M) 
);

mux2X1 M1 (
.IN_0(RX_CLK),
.IN_1(scan_clk),
.SEL(test_mode),
.OUT(RX_CLK_M) 
);

mux2X1 M2 (
.IN_0(RST),
.IN_1(scan_rst),
.SEL(test_mode),
.OUT(RST_M) 
);



//module UART_TX #(parameter WIDTH = 8 )
//(
//    input   wire      [WIDTH - 1 : 0]       P_DATA,
//    input   wire                            DATA_VALID,
//    input   wire                            PAR_EN,
//    input   wire                            parity_type,
//    input   wire                            CLK,
//    input   wire                            RST,
//    output  wire                            TX_OUT,
//    output  wire                            Busy
//);
UART_TX  U0_UART_TX ( 
.P_DATA(TX_IN_P),
.DATA_VALID(TX_IN_V),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type),
//.CLK(TX_CLK),
//.RST(RST),
.CLK(TX_CLK_M),
.RST(RST_M),
.TX_OUT(TX_OUT_S),
.Busy(TX_Busy)
); 




//module UART_RX #(parameter WIDTH = 8, PRESCALE_WIDTH = 6 )
//(
//    input   wire               RX_IN,
//    input   wire    [5:0]      prescale,
//    input   wire               PAR_EN,
//    input   wire               PAR_TYP,
//    input   wire               CLK,
//    input   wire               RST,
//
//    output  wire    [7:0]      P_data,
//    output  wire               data_valid
//);
UART_RX U0_UART_RX (
.RX_IN(RX_IN_S),
.prescale(Prescale),
.PAR_EN(parity_enable),
.PAR_TYP(parity_type),
//.CLK(RX_CLK),
//.RST(RST),
.CLK(RX_CLK_M),
.RST(RST_M),
.P_data(RX_OUT_P),
.data_valid(RX_OUT_V)
);

endmodule
