module Tx_FSM
(
    input   wire                CLK,
    input   wire                RST,
    input   wire                PAR_EN,
    input   wire                DATA_VALID,
    input   wire                ser_done,
    output  reg                 ser_en,
    output  reg                 sample,
    output  reg     [1:0]       mux_sel,
    output  reg                 Busy
);
    localparam [2:0]    IDLE_STATE      = 3'b000,
                        START_STATE     = 3'b001,
                        DATA_STATE      = 3'b010,
                        PARITY_STATE    = 3'b011,
                        STOP_STATE      = 3'b100;

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
                    Busy    =   0;
                    ser_en  =   0;
                    sample  =   0;
                    mux_sel =   2'b01;
                end
            START_STATE:
                begin
                    Busy    =   1;
                    ser_en  =   0;
                    sample  =   1;
                    mux_sel =   2'b00;
                end
            DATA_STATE:
                begin
                    Busy    =   1;
                    ser_en  =   1;
                    sample  =   0;
                    mux_sel =   2'b10;
                end
            PARITY_STATE:
                begin
                    Busy    =   1;
                    ser_en  =   0;
                    sample  =   0;
                    mux_sel =   2'b11;
                end
            STOP_STATE:
                begin
                    Busy    =   1;
                    ser_en  =   0;
                    sample  =   0;
                    mux_sel =   2'b01;
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
                    if(DATA_VALID)
                        next_state  =   START_STATE;
                    else
                        next_state  =   IDLE_STATE;    
                end
                
            START_STATE:
                begin
                    next_state  =   DATA_STATE;    
                end
                
            DATA_STATE:
                begin
                    if (ser_done) begin
                        if (PAR_EN) begin
                            next_state  =   PARITY_STATE;
                        end else begin
                            next_state  =   STOP_STATE;
                        end
                    end    
                end
                
            PARITY_STATE:
                begin
                    next_state  =   STOP_STATE;
                end
                
            STOP_STATE:
                begin
                    if(DATA_VALID)
                        next_state  =   START_STATE;
                    else
                        next_state  =   IDLE_STATE; 
                end
                
                    
        endcase
    end

endmodule

