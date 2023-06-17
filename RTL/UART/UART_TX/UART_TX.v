module UART_TX #(parameter WIDTH = 8 )
(
    input   wire      [WIDTH - 1 : 0]       P_DATA,
    input   wire                            DATA_VALID,
    input   wire                            PAR_EN,
    input   wire                            PAR_TYP,
    input   wire                            CLK,
    input   wire                            RST,
    output  wire                            TX_OUT,
    output  wire                            Busy
);
    localparam  START_BIT   =   1'b0,
                STOP_BIT    =   1'b1;
    
    wire    [1:0]   mux_sel;
    wire            ser_data;
    wire            ser_en;
    wire            ser_done;
    wire            sample;
    wire            Par_bit;

//module FSM
//(
//    input   wire                CLK,
//    input   wire                RST,
//    input   wire                PAR_EN,
//    input   wire                DATA_VALID,
//    input   wire                ser_done,
//    output  reg                 ser_en,
//    output  reg                 sample,
//    output  reg     [1:0]       mux_sel,
//    output  reg                 Busy
//);

Tx_FSM Tx_FSM_module(   .CLK(CLK),
                        .RST(RST),
                        .PAR_EN(PAR_EN),
                        .DATA_VALID(DATA_VALID),
                        .ser_done(ser_done),
                        .ser_en(ser_en),
                        .sample(sample),
                        .mux_sel(mux_sel),
                        .Busy(Busy)
                        );


//  module  serializer #(parameter  WIDTH = 8, parameter BITS = 3 )
//  (
//      input   wire                        CLK,
//      input   wire                        RST,
//      input   wire    [WIDTH - 1 : 0]     DATA,
//      input   wire                        ser_en,
//      input   wire                        sample,
//      output  wire                        ser_done,
//      output  reg                         ser_data
//  );

serializer ser_module(  .CLK(CLK),
                        .RST(RST),
                        .DATA(P_DATA),
                        .ser_en(ser_en),
                        .sample(sample),
                        .DATA_VALID(DATA_VALID),
                        .ser_done(ser_done),
                        .ser_data(ser_data)
                        );


//  module parity_calc #(parameter WIDTH = 8)
//  (
//      input   wire    [WIDTH - 1 : 0]     DATA,
//      input   wire                        DATA_VALID,
//      input   wire                        PAR_TYP,
//      output  reg                         Par_bit
//  );
parity_calc parity_module(  .RST(RST),
                            .DATA(P_DATA),
                            .DATA_VALID(DATA_VALID),
                            .PAR_TYP(PAR_TYP),
                            .Par_bit(Par_bit)
                            );

//      module  MUX
//      (
//          input   wire    [1:0]   SEL,
//          input   wire            IN0,
//          input   wire            IN1,
//          input   wire            IN2,
//          input   wire            IN3,    
//          output  reg             out
//      );
MUX mux_module( .SEL(mux_sel),
                .IN0(START_BIT),
                .IN1(STOP_BIT),
                .IN2(ser_data),
                .IN3(Par_bit),
                .out(TX_OUT)
                );


endmodule