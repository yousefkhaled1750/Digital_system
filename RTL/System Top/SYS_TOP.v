module SYS_TOP #(parameter DATA_WIDTH = 8, RF_ADDR = 4, RF_DEPTH = 16) (
    input   wire                    rst_n,
    input   wire                    ref_clk,
    input   wire                    uart_clk,
    input   wire                    rx_ser_in,
    output  wire                    tx_ser_out
);

wire                            alu_clk;
wire                            rst_ref_sync;
wire                            rst_uart_sync;
wire                            uart_tx_clk;

wire    [2*DATA_WIDTH-1:0]      alu_out;    
wire                            alu_out_valid;  // ALU result valid
wire    [DATA_WIDTH-1:0]        rf_rdData;      // read data bus from RegFile
wire                            rf_rdData_vld; // read data valid from RegFile
wire    [DATA_WIDTH-1:0]        uart_rx_p_data;      // uart_rx data
wire                            uart_rx_d_vld;       // uart_rx data valid
wire    [DATA_WIDTH-1:0]        uart_rx_p_data_sync;      
wire                            uart_rx_d_vld_sync;       
wire                            alu_en; 
wire    [3:0]                   alu_fun;
wire                            clk_gate_en;     // for clock gating
wire    [RF_ADDR-1:0]           rf_address;    // address of RegFile
wire                            rf_wrEn;       // regfile
wire                            rf_rdEn;       // regfile
wire    [DATA_WIDTH-1:0]        rf_wrData;     // regfile
wire                            uart_tx_busy;           // uart_tx status
wire    [DATA_WIDTH-1:0]        uart_tx_p_data; 
wire                            uart_tx_d_vld; 
wire                            uart_tx_busy_sync;           // uart_tx status
wire    [DATA_WIDTH-1:0]        uart_tx_p_data_sync; 
wire                            uart_tx_d_vld_sync;  
wire                            clk_div_en; // clock divider

wire    [DATA_WIDTH-1:0]        alu_op_a;
wire    [DATA_WIDTH-1:0]        alu_op_b;
wire    [DATA_WIDTH-1:0]        uart_config;
wire    [DATA_WIDTH-1:0]        div_ratio;



////////////////////////////////////////////////////////////////
/////////////////////  System Controller  //////////////////////
////////////////////////////////////////////////////////////////
SYS_CTRL #(.DATA_WIDTH(DATA_WIDTH), .RF_ADDR(RF_ADDR)) sys_ctrl_i
(
    .clk(ref_clk),
    .reset(rst_ref_sync),
    .alu_out(alu_out),
    .alu_out_valid(alu_out_valid),
    .rf_rdData(rf_rdData),
    .rf_rdData_vld(rf_rdData_vld),
    .uart_rx_p_data(uart_rx_p_data_sync),    //data synch 
    .uart_rx_d_vld(uart_rx_d_vld_sync),      //bit synch
    .uart_tx_busy(uart_tx_busy_sync),
    .alu_en(alu_en),
    .alu_fun(alu_fun),
    .clk_gate_en(clk_gate_en),
    .rf_address(rf_address),
    .rf_wrEn(rf_wrEn),
    .rf_rdEn(rf_rdEn),
    .rf_wrData(rf_wrData),
    .uart_tx_p_data(uart_tx_p_data),
    .uart_tx_d_vld(uart_tx_d_vld),
    .clk_div_en(clk_div_en) 
);


////////////////////////////////////////////////////////////////
///////////////////////  Register File  ////////////////////////
////////////////////////////////////////////////////////////////

Register_File #(
.DATA_WIDTH(DATA_WIDTH),
.ADDR_WIDTH(RF_ADDR),
.DEPTH(RF_DEPTH)
) rf_i (
    .WrData(rf_wrData),
    .Address(rf_address),
    .WrEn(rf_wrEn),
    .RdEn(rf_rdEn),
    .clk(ref_clk),
    .RST(rst_ref_sync),
    .RdData(rf_rdData),
    .RdData_Valid(rf_rdData_vld),
    .REG0(alu_op_a),
    .REG1(alu_op_b),
    .REG2(uart_config),
    .REG3(div_ratio)
);

////////////////////////////////////////////////////////////////
////////////////////////////  ALU  /////////////////////////////
////////////////////////////////////////////////////////////////

ALU_TOP #(
.WIDTH(DATA_WIDTH)
) alu_i (
    .A(alu_op_a),
    .B(alu_op_b),
    .ALU_FUN(alu_fun),
    .clk(ref_clk),
    .RST(rst_ref_sync),
    .Enable(alu_en),
    .ALU_OUT(alu_out),
    .OUT_VALID(alu_out_valid)
);

////////////////////////////////////////////////////////////////
////////////////////////  Clock Gate  //////////////////////////
////////////////////////////////////////////////////////////////

CLK_GATE clk_gate_i (
    .CLK_EN(clk_gate_en),
    .CLK(ref_clk),
    .GATED_CLK(alu_clk)
);


////////////////////////////////////////////////////////////////
/////////////////////  reset synchronizers  ////////////////////
////////////////////////////////////////////////////////////////

RST_SYNC #(.NUM_STAGES(2)) rst_sync_1_i
(
    .CLK(ref_clk),
    .RST(rst_n),
    .SYNC_RST(rst_ref_sync)
);

RST_SYNC #(.NUM_STAGES(2)) rst_sync_2_i
(
    .CLK(uart_clk),
    .RST(rst_n),
    .SYNC_RST(rst_uart_sync)
);

////////////////////////////////////////////////////////////////
////////////////////////  Clock Divider /// ////////////////////
////////////////////////////////////////////////////////////////

clk_div #(.RATIO_WD(5)) clk_div_i (
    .i_ref_clk(uart_clk),
    .i_rst_n(rst_uart_sync),
    .i_clk_en(clk_div_en),
    .i_div_ratio(div_ratio[3:0]),
    .o_div_clk(uart_tx_clk)
);


////////////////////////////////////////////////////////////////
/////////////////////////////  UART ////////////////////////////
////////////////////////////////////////////////////////////////

UART #(.WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(5)) uart_top_i
(
    .RST(rst_uart_sync),
    .parity_enable(uart_config[0]),
    .parity_type(uart_config[1]),
    .TX_CLK(uart_tx_clk),
    .RX_CLK(uart_clk),
    .TX_IN_P(uart_tx_p_data_sync),
    .TX_IN_V(uart_tx_d_vld_sync),
    .TX_OUT_S(tx_ser_out),
    .TX_Busy(uart_tx_busy),   
    .RX_IN_S(rx_ser_in),
    .RX_OUT_P(uart_rx_p_data),
    .RX_OUT_V(uart_rx_d_vld),
    .Prescale(uart_config[6:2])
);

////////////////////////////////////////////////////////////////
////////////////////////  Synchronizers ////////////////////////
////////////////////////////////////////////////////////////////

DATA_SYNC #(.NUM_STAGES(2), .BUS_WIDTH(DATA_WIDTH)) data_sync_uart_ref_i
(
    .unsync_bus(uart_rx_p_data),
    .bus_enable(uart_rx_d_vld),
    .CLK(ref_clk),
    .RST(rst_ref_sync),
    .sync_bus(uart_rx_p_data_sync),
    .enable_pulse(uart_rx_d_vld_sync)
);


DATA_SYNC #(.NUM_STAGES(2), .BUS_WIDTH(DATA_WIDTH)) data_sync_ref_uart_i
(
    .unsync_bus(uart_tx_p_data),
    .bus_enable(uart_tx_d_vld),
    .CLK(uart_tx_clk),
    .RST(rst_uart_sync),
    .sync_bus(uart_tx_p_data_sync),
    .enable_pulse(uart_tx_d_vld_sync)
);


BIT_SYNC #(.NUM_STAGES(2)) bit_sync_tx_busy_i
(
    .ASYNC(uart_tx_busy),
    .CLK(ref_clk),
    .RST(rst_ref_sync),
    .SYNC(uart_tx_busy_sync)    
);




endmodule