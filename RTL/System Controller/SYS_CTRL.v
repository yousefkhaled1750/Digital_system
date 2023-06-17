module SYS_CTRL #(parameter DATA_WIDTH = 8, RF_ADDR = 4)(
    input   wire                            clk,
    input   wire                            reset,      //reset synch
    input   wire    [2*DATA_WIDTH-1:0]      alu_out,    
    input   wire                            alu_out_valid,  // ALU result valid
    input   wire    [DATA_WIDTH:0]          rf_rdData,      // read data bus from RegFile
    input   wire                            rf_rdData_vld, // read data valid from RegFile
    input   wire    [DATA_WIDTH-1:0]        uart_rx_p_data,      // uart_rx data
    input   wire                            uart_rx_d_vld,       // uart_rx data valid
    input   wire                            uart_tx_busy,           // uart_tx status

    output  wire                            alu_en, 
    output  wire    [3:0]                   alu_fun,
    output  wire                            clk_gate_en,     // for clock gating
    output  wire    [RF_ADDR-1:0]           rf_address,    // address of RegFile
    output  wire                            rf_wrEn,       // regfile
    output  wire                            rf_rdEn,       // regfile
    output  wire    [DATA_WIDTH-1:0]        rf_wrData,     // regfile
    output  wire    [DATA_WIDTH-1:0]        uart_tx_p_data, 
    output  wire                            uart_tx_d_vld,  
    output  wire                            clk_div_en // clock divider
);



wire                        tx_rf_send;
wire                        tx_alu_send;
wire  [DATA_WIDTH-1:0]      tx_rf_send_data;
wire  [2*DATA_WIDTH-1:0]    tx_alu_send_data;


// module CTRL_RX #(parameter DATA_WIDTH = 8, RF_ADDR = 4)(
//     input   wire            clk,
//     input   wire            reset,
//     input   wire    [DATA_WIDTH-1:0]   uart_rx_p_data,
//     input   wire            uart_rx_d_vld,
//     
//     output  reg             alu_en,
//     output  reg     [3:0]   alu_fun,
//     output  reg             clk_gate_en,
// 
//     output  reg     [3:0]   rf_address,
//     output  reg             rf_wrEn,
//     output  reg             rf_rdEn,
//     output  reg     [DATA_WIDTH-1:0]   rf_wrData,
//     
//     input   wire            alu_out_valid,
//     input   wire    [2*DATA_WIDTH-1:0]  alu_out,
// 
//     input   wire            rf_rdData,
//     input   wire            rf_rdData_vld,
// 
//     output  reg             clk_div_en,
// 
//     output  reg             tx_rf_send,
//     output  reg             tx_alu_send,
//     output  reg    [DATA_WIDTH-1:0]    tx_rf_send_data,
//     output  reg    [2*DATA_WIDTH-1:0]   tx_alu_send_data
// );

CTRL_RX #(.DATA_WIDTH(DATA_WIDTH), .RF_ADDR(RF_ADDR))   ctrl_rx_i  (
.clk(clk),
.reset(reset),
.uart_rx_p_data(uart_rx_p_data),
.uart_rx_d_vld(uart_rx_d_vld),   
.alu_en(alu_en),
.alu_fun(alu_fun),
.clk_gate_en(clk_gate_en),
.rf_address(rf_address),
.rf_wrEn(rf_wrEn),
.rf_rdEn(rf_rdEn),
.rf_wrData(rf_wrData),
.alu_out_valid(alu_out_valid),
.alu_out(alu_out),
.rf_rdData(rf_rdData),
.rf_rdData_vld(rf_rdData_vld),
.clk_div_en(clk_div_en),
.tx_rf_send(tx_rf_send),
.tx_alu_send(tx_alu_send),
.tx_rf_send_data(tx_rf_send_data),
.tx_alu_send_data(tx_alu_send_data)
);



// module CTRL_TX (
//     input   wire            clk,
//     input   wire            reset,
// 
//     input   wire            tx_rf_send,
//     input   wire            tx_alu_send,
//     input   wire    [DATA_WIDTH-1:0]   tx_rf_send_data,
//     input   wire    [2*DATA_WIDTH-1:0]  tx_alu_send_data,
// 
// 
//     input   wire            uart_tx_busy,
//     output  reg     [DATA_WIDTH-1:0]   uart_tx_p_data,
//     output  reg             uart_tx_d_vld
// 
// );

CTRL_TX ctrl_tx_i (
.clk(clk),
.reset(reset),
.tx_rf_send(tx_rf_send),
.tx_alu_send(tx_alu_send),
.tx_rf_send_data(tx_rf_send_data),
.tx_alu_send_data(tx_alu_send_data), 
.uart_tx_busy(uart_tx_busy),
.uart_tx_p_data(uart_tx_p_data),
.uart_tx_d_vld(uart_tx_d_vld)   
);



endmodule