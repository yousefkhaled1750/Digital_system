`timescale 1ns/1ps

module SYS_TOP_TB ();

//parameters
parameter DATA_WIDTH  = 8 ;
parameter REF_CLK_PER = 20 ;
parameter UART_RX_CLK_PER = 24 ;     
parameter WR_NUM_OF_FRAMES = 3 ;
parameter RD_NUM_OF_FRAMES = 2 ;
parameter ALU_WP_NUM_OF_FRAMES = 4 ;
parameter ALU_NP_NUM_OF_FRAMES = 2 ; 

//Testbench Signals
reg                     rst_n;
reg                     ref_clk;
reg                     uart_clk;
wire                    rx_ser_in;
wire                    tx_ser_out;


reg   [WR_NUM_OF_FRAMES*8-1:0]        WR_div_ratio_8_CMD           = 'b01111000_00000011_10101010 ;
reg   [WR_NUM_OF_FRAMES*8-1:0]        WR_urt_confg_par_even_CMD    = 'b00100001_00000010_10101010 ;

reg   [WR_NUM_OF_FRAMES*8-1:0]        WR_a_CMD    = 'b00000101_00000000_10101010 ;
reg   [WR_NUM_OF_FRAMES*8-1:0]        WR_b_CMD    = 'b00000100_00000001_10101010 ;
reg   [RD_NUM_OF_FRAMES*8-1:0]        RD_a_CMD    = 'b00000000_10111011    ;


reg   [WR_NUM_OF_FRAMES*8-1:0]        WR_CMD     = 'b01110111_00000101_10101010 ;
reg   [RD_NUM_OF_FRAMES*8-1:0]        RD_CMD     = 'b00000101_10111011    ;

reg   [ALU_WP_NUM_OF_FRAMES*8-1:0]    ALU_WP_CMD = 'b00000001_00000011_00000101_11001100 ;
reg   [ALU_NP_NUM_OF_FRAMES*8-1:0]    ALU_NP_CMD = 'b00000001_11011101 ;


//UART TX signals
reg       [DATA_WIDTH - 1 : 0]  uart_tx_p_data_tb;
reg                             uart_tx_d_vld_tb;
reg                             parity_enable_tb;
reg                             parity_type_tb;
//wire                            uart_tx_ser_out_tb;
wire                            uart_tx_busy_state_tb;

//UART RX signals
//input   wire                                            uart_rx_ser_in_tb;
reg     [   4  : 0]                             uart_rx_prescale_tb;
wire    [DATA_WIDTH - 1 : 0]                    uart_rx_p_data_tb;
wire                                            uart_rx_d_vld_tb;



// reg                         TX_CLK_TB;
// reg                         Data_Stimulus_En;
// reg   [5:0]                 count = 6'b0 ;

integer i;

//Initial 
initial
 begin

//initial values
rst_n             = 1'b1   ;
ref_clk           = 1'b0   ;
uart_clk          = 1'b0   ;
// rx_ser_in         = 1'b1   ;    // rst is deactivated
// tx_ser_out        = 1'b1   ;

uart_tx_p_data_tb   = 'b0;  
uart_tx_d_vld_tb    = 'b0;
parity_enable_tb    = 'b1;  
parity_type_tb      = 'b0;  //even parity same as the default
uart_rx_prescale_tb = 'd8;  //same as the default

//Reset the design
#5
rst_n = 1'b0;    // rst is activated
#5
rst_n = 1'b1;    // rst is deactivated

#20 
// Data_Stimulus_En = 1'b1 ;
// test the writing and reading operations

uart_tx_p_data_tb = WR_a_CMD[7:0];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = WR_a_CMD[15:8];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = WR_a_CMD[23:16];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission



uart_tx_p_data_tb = WR_b_CMD[7:0];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = WR_b_CMD[15:8];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = WR_b_CMD[23:16];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission




 uart_tx_p_data_tb = RD_a_CMD[7:0];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission


uart_tx_p_data_tb = RD_a_CMD[15:8];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission



// start receiving the data from uart_rx
@(posedge uart_rx_d_vld_tb)
if (uart_rx_p_data_tb == WR_a_CMD[3*DATA_WIDTH - 1 : 2*DATA_WIDTH]) begin
    $display("Success!!");
end else begin
    $display("Failure!!");
end


 uart_tx_p_data_tb = ALU_WP_CMD[7:0];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = ALU_WP_CMD[15:8];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = ALU_WP_CMD[23:16];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

uart_tx_p_data_tb = ALU_WP_CMD[31:24];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

@(posedge uart_rx_d_vld_tb)
$display("a = %b, b = %b and result = %b",ALU_WP_CMD[2*DATA_WIDTH-1:DATA_WIDTH], ALU_WP_CMD[3*DATA_WIDTH-1:2*DATA_WIDTH], uart_rx_p_data_tb );


uart_tx_p_data_tb = ALU_NP_CMD[7:0];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission


uart_tx_p_data_tb = ALU_NP_CMD[15:8];
    @(posedge DUT.clk_div_i.o_div_clk);     //at the posedge of the uart_tx clock
    uart_tx_d_vld_tb = 'b1;
    @(posedge DUT.clk_div_i.o_div_clk);
    uart_tx_d_vld_tb = 'b0;
    @(negedge uart_tx_busy_state_tb);        // wait until the uart finish the transmission

@(posedge uart_rx_d_vld_tb)
$display("result = %b",uart_rx_p_data_tb );

#400

$stop ;

end

 
 
// REF Clock Generator
always #(REF_CLK_PER/2) ref_clk = ~ref_clk ;

// UART RX Clock Generator
always #(UART_RX_CLK_PER/2) uart_clk = ~uart_clk ;


// Design Instaniation
SYS_TOP DUT (
.uart_clk(uart_clk),
.ref_clk(ref_clk),
.rst_n(rst_n),
.rx_ser_in(rx_ser_in),
.tx_ser_out(tx_ser_out)
);


UART_TX #(.WIDTH(DATA_WIDTH)) uart_tx_tb
(
    .P_DATA(uart_rx_p_data_tb),
    .DATA_VALID(uart_tx_d_vld_tb),
    .PAR_EN(parity_enable_tb),
    .PAR_TYP(parity_type_tb),
    .CLK(DUT.clk_div_i.o_div_clk),
    .RST(rst_n),
    .TX_OUT(rx_ser_in),
    .Busy(uart_tx_busy_state_tb)
);


// module UART_TX #(parameter WIDTH = 8 )
// (
//     input   wire      [WIDTH - 1 : 0]       P_DATA,
//     input   wire                            DATA_VALID,
//     input   wire                            PAR_EN,
//     input   wire                            PAR_TYP,
//     input   wire                            CLK,
//     input   wire                            RST,
//     output  wire                            TX_OUT,
//     output  wire                            Busy
// );


UART_RX #(.WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(5))
(
    .RX_IN(tx_ser_out),
    .prescale(uart_rx_prescale_tb),
    .PAR_EN(parity_enable_tb),
    .PAR_TYP(parity_type_tb),
    .CLK(uart_clk),
    .RST(rst_n),                   
    .P_data(uart_rx_p_data_tb),
    .data_valid(uart_rx_d_vld_tb)
);


// module UART_RX #(parameter WIDTH = 8, PRESCALE_WIDTH = 6 )
// (
//     input   wire                                            RX_IN,
//     input   wire    [PRESCALE_WIDTH - 1 : 0]                prescale,
//     input   wire                                            PAR_EN,
//     input   wire                                            PAR_TYP,
//     input   wire                                            CLK,
//     input   wire                                            RST,
                    
//     output  wire    [WIDTH - 1 : 0]                         P_data,
//     output  wire                                            data_valid
// );


endmodule