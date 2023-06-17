module UART_RX #(parameter WIDTH = 8, PRESCALE_WIDTH = 6 )
(
    input   wire                                            RX_IN,
    input   wire    [PRESCALE_WIDTH - 1 : 0]                prescale,
    input   wire                                            PAR_EN,
    input   wire                                            PAR_TYP,
    input   wire                                            CLK,
    input   wire                                            RST,
                    
    output  wire    [WIDTH - 1 : 0]                         P_data,
    output  wire                                            data_valid
);

wire    [4:0]   edge_cnt;
wire    [3:0]   bit_cnt;
wire            data_sample_en;
wire            par_chk_en;
wire            par_err;
wire            strt_chk_en;
wire            strt_glitch;
wire            stp_chk_en;
wire            stp_err;
wire            deser_en;
wire            sampled_bit;





//module Rx_FSM (
//    input   wire    [3:0]   bit_cnt,
//    input   wire    [4:0]   edge_cnt,
//    input   wire            PAR_EN,
//    input   wire            par_err,
//    input   wire            strt_glitch,
//    input   wire            stp_err,
//    input   wire            RX_IN,
//    input   wire            RST,
//    input   wire            CLK,
//    input   wire    [5:0]   prescale, 
//
//    output  reg             data_sample_en,
//    output  reg             enable,
//    output  reg             par_chk_en,
//    output  reg             strt_chk_en,
//    output  reg             stp_chk_en,
//    output  reg             deser_en,
//    output  reg             data_valid
//);

Rx_FSM Rx_FSM_module(
                        .bit_cnt(bit_cnt),
                        .edge_cnt(edge_cnt),
                        .PAR_EN(PAR_EN),
                        .par_err(par_err),
                        .strt_glitch(strt_glitch),
                        .stp_err(stp_err),
                        .RX_IN(RX_IN),
                        .RST(RST),
                        .CLK(CLK),
                        .prescale(prescale), 
                        .data_sample_en(data_sample_en),
                        .enable(enable),
                        .par_chk_en(par_chk_en),
                        .strt_chk_en(strt_chk_en),
                        .stp_chk_en(stp_chk_en),
                        .deser_en(deser_en),
                        .data_valid(data_valid)
);




//module data_sampling (
//    input   wire            data_sample_en,
//    input   wire            RX_IN,
//    input   wire    [4:0]   edge_cnt,
//    input   wire    [5:0]   prescale,
//    input   wire            CLK,
//    input   wire            RST,
//
//    output  reg             sampled_bit
//);

data_sampling data_sampling_module(
                                    .data_sample_en(data_sample_en),
                                    .RX_IN(RX_IN),
                                    .edge_cnt(edge_cnt),
                                    .prescale(prescale),
                                    .CLK(CLK),
                                    .RST(RST),
                                    .sampled_bit(sampled_bit)
);


//module edge_bit_counter (
//    input   wire            enable,
//    input   wire            CLK,
//    input   wire            RST,
//    input   wire    [5:0]   prescale,             
//
//    output  reg     [4:0]   edge_cnt,
//    output  reg     [3:0]   bit_cnt
//
//);

edge_bit_counter edge_bit_counter_module(
                                            .enable(enable),
                                            .CLK(CLK),
                                            .RST(RST),
                                            .prescale(prescale),
                                            .edge_cnt(edge_cnt),
                                            .bit_cnt(bit_cnt)
);

//module deserializer (
//    input   wire            sampled_bit,
//    input   wire    [3:0]   bit_cnt,
//    input   wire            RST,
//    input   wire            deser_en,
//
//    output  reg     [7:0]   P_data
//
//);

deserializer deserializer_module(
                                    .sampled_bit(sampled_bit),
                                    .bit_cnt(bit_cnt),
                                    .RST(RST),
                                    .deser_en(deser_en),
                                    .P_data(P_data)
);


//module parity_check (
//    input   wire            PAR_TYP,
//    input   wire    [7:0]   P_data,
//    input   wire            par_chk_en,
//    input   wire            sampled_bit,
//    input   wire    [4:0]   edge_cnt,
//    input   wire    [5:0]   prescale,
//    input   wire            RST,
//    
//    output  reg             par_err
//);

parity_check parity_check_module(
                                    .PAR_TYP(PAR_TYP),
                                    .P_data(P_data),
                                    .par_chk_en(par_chk_en),
                                    .sampled_bit(sampled_bit),
                                    .edge_cnt(edge_cnt),
                                    .prescale(prescale),
                                    .RST(RST),
                                    .par_err(par_err)
);

//module stop_check (
//    input   wire            stp_chk_en,
//    input   wire            sampled_bit,
//    input   wire    [4:0]   edge_cnt,
//    input   wire    [5:0]   prescale,
//    input   wire            RST,
//    
//    output  reg             stp_err
//);

stop_check stop_check_module(
                                .stp_chk_en(stp_chk_en),
                                .sampled_bit(sampled_bit),
                                .edge_cnt(edge_cnt),
                                .prescale(prescale),
                                .RST(RST),
                                .stp_err(stp_err)
);


//module start_check (
//    input   wire            strt_chk_en,
//    input   wire            sampled_bit,
//    input   wire    [4:0]   edge_cnt,
//    input   wire    [5:0]   prescale,
//    input   wire            RST,
//    
//    output  reg             strt_glitch
//);

start_check start_check_module(
                                .strt_chk_en(strt_chk_en),
                                .sampled_bit(sampled_bit),
                                .edge_cnt(edge_cnt),
                                .prescale(prescale),
                                .RST(RST),
                                .strt_glitch(strt_glitch)
);


endmodule