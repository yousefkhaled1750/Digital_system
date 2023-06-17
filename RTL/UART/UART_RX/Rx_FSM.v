module Rx_FSM (
    input   wire    [3:0]   bit_cnt,
    input   wire    [4:0]   edge_cnt,
    input   wire            PAR_EN,
    input   wire            par_err,
    input   wire            strt_glitch,
    input   wire            stp_err,
    input   wire            RX_IN,
    input   wire            RST,
    input   wire            CLK,
    input   wire    [5:0]   prescale, 

    output  reg             data_sample_en,
    output  reg             enable,
    output  reg             par_chk_en,
    output  reg             strt_chk_en,
    output  reg             stp_chk_en,
    output  reg             deser_en,
    output  reg             data_valid
);

    reg parity_error;
    reg stop_error;

    reg     [4:0]   first_bit;
    reg     [4:0]   second_bit;
    reg     [4:0]   third_bit;
    reg     [4:0]   max_count;


    always @(*) begin
        first_bit       = (prescale >> 1) - 1 ;
        second_bit      = prescale >> 1       ;
        third_bit       = (prescale >> 1) + 1 ;
        max_count       = prescale - 1;
    end

    localparam [2:0]    IDLE_STATE      = 3'b000,
                        START_STATE     = 3'b001,
                        DATA_STATE      = 3'b010,
                        PARITY_STATE    = 3'b011,
                        STOP_STATE      = 3'b100,
                        OUTPUT_STATE    = 3'b101;

    reg     [2:0]   next_state;
    reg     [2:0]   current_state;
    /*******************************************************/
    /****************** state transition *******************/
    /*******************************************************/
    always @(posedge CLK, negedge RST ) 
        begin
            if (!RST) begin
                current_state <= IDLE_STATE;
            end else begin
                current_state <= next_state;    
            end
        end


    /*******************************************************/
    /****************** output logic ***********************/
    /*******************************************************/
    always @(*) begin
        case(current_state)
            IDLE_STATE:
                begin
                    enable          =   0;
                    data_sample_en  =   0;
                    strt_chk_en     =   0;
                    par_chk_en      =   0;
                    stp_chk_en      =   0;
                    deser_en        =   0;
                    data_valid      =   0;
                end
            START_STATE:
                begin
                    enable          =   1;
                    data_sample_en  =   1;
                    strt_chk_en     =   1;
                    par_chk_en      =   0;
                    stp_chk_en      =   0;
                    deser_en        =   0;
                    data_valid      =   0;
                end
            DATA_STATE:
                begin
                    enable          =   1;
                    data_sample_en  =   1;
                    strt_chk_en     =   0;
                    par_chk_en      =   0;
                    stp_chk_en      =   0;
                    deser_en        =   1;
                    data_valid      =   0;
                end
            PARITY_STATE:
                begin
                    enable          =   1;
                    data_sample_en  =   1;
                    strt_chk_en     =   0;
                    par_chk_en      =   1;
                    stp_chk_en      =   0;
                    deser_en        =   0;
                    data_valid      =   0;
                end
            STOP_STATE:
                begin
                    enable          =   1;
                    data_sample_en  =   1;
                    strt_chk_en     =   0;
                    par_chk_en      =   0;
                    stp_chk_en      =   1;
                    deser_en        =   0;
                    data_valid      =   0;
                end
            OUTPUT_STATE:
                begin
                    enable          =   0;
                    data_sample_en  =   0;
                    strt_chk_en     =   0;
                    par_chk_en      =   0;
                    stp_chk_en      =   0;
                    deser_en        =   0;
                    data_valid      =   ~parity_error & ~stop_error;
                end
        endcase
    end




    /*******************************************************/
    /****************** next state logic *******************/
    /*******************************************************/
    always @(*) begin
        case (current_state)
            IDLE_STATE:
                begin
                    if(RX_IN == 0)
                        next_state  =   START_STATE;
                    else
                        next_state  =   IDLE_STATE;    
                end
                
            START_STATE:
                begin
                    if(bit_cnt == 0 && edge_cnt == max_count)   //check for the start_glitch
                        if(strt_glitch == 0)
                            next_state = DATA_STATE;
                        else    
                            next_state  = IDLE_STATE;
                    else
                        next_state = START_STATE;    
                end
                
            DATA_STATE:
                begin
                    if(bit_cnt == 8 && edge_cnt == max_count)
                        if (PAR_EN)
                            next_state = PARITY_STATE;
                        else
                            next_state = STOP_STATE;
                    else
                        next_state = DATA_STATE;
                end
                
            PARITY_STATE:
                begin
                    if(bit_cnt == 9 && edge_cnt == max_count)
                        begin
                            parity_error = par_err;
                            next_state = STOP_STATE;
                        end
                    else
                        begin
                            parity_error = 0;
                            next_state = PARITY_STATE;
                        end
                end
                
            STOP_STATE:
                begin
                    if(bit_cnt == 4'd10 && edge_cnt == max_count - 1)
                        begin
                            stop_error = stp_err;
                            next_state = OUTPUT_STATE;
                        end
                    else
                        begin
                            stop_error = 0;
                            next_state = STOP_STATE;
                        end
                end
            
            OUTPUT_STATE:
                begin
                    next_state = IDLE_STATE;
                end
                
                    
        endcase
    end



endmodule