module CTRL_TX #(parameter DATA_WIDTH = 8, RF_ADDR = 4) (
    input   wire                        clk,
    input   wire                        reset,

    input   wire                        tx_rf_send,
    input   wire                        tx_alu_send,
    input   wire    [DATA_WIDTH-1:0]    tx_rf_send_data,
    input   wire    [2*DATA_WIDTH-1:0]  tx_alu_send_data,


    input   wire                        uart_tx_busy,
    output  reg     [DATA_WIDTH-1:0]    uart_tx_p_data,
    output  reg                         uart_tx_d_vld

);


localparam  [1:0]       IDLE_S          = 2'b00 , 
                        SEND_UART_RF    = 2'b01 ,
                        SEND_UART_ALU0  = 2'b10 ,
                        SEND_UART_ALU1  = 2'b11 ;

reg [2:0] current_state, next_state ;

reg [2*DATA_WIDTH-1:0]  tx_alu_send_data_reg;
reg [DATA_WIDTH-1:0]   tx_rf_send_data_reg;


// state update
always @(posedge clk, negedge reset) begin
    if(!reset)
        current_state <= IDLE_S;
    else
        current_state <= next_state;
end

// next state logic
always @(*) begin
    case (current_state)
        IDLE_S:
            begin
                if (tx_rf_send) begin
                    next_state = SEND_UART_RF;
                end else if (tx_alu_send) begin
                    next_state = SEND_UART_ALU0;
                end else begin
                    next_state = IDLE_S;
                end
            end
        SEND_UART_RF:
            begin
                if (!uart_tx_busy) begin
                    next_state = IDLE_S;
                end else begin
                    next_state = SEND_UART_RF;
                end
            end
        SEND_UART_ALU0:
            begin
                if (!uart_tx_busy) begin
                    next_state = SEND_UART_ALU1;
                end else begin
                    next_state = SEND_UART_ALU0;
                end
            end
        SEND_UART_ALU1:
            begin
                if (!uart_tx_busy) begin
                    next_state = IDLE_S;
                end else begin
                    next_state = SEND_UART_ALU1;
                end
            end 
        default: 
            next_state <= IDLE_S;
    endcase
end

// output logic
always @(*) begin
    uart_tx_p_data = 'b0;
    uart_tx_d_vld  = 1'b0;
    case (current_state)
        IDLE_S:
            begin
                
            end
        SEND_UART_RF:
            begin
                if(!uart_tx_busy) begin
                    uart_tx_p_data = tx_rf_send_data_reg ;
                    uart_tx_d_vld  = 1'b1;
                end else begin
                    uart_tx_p_data = 'b0 ;
                    uart_tx_d_vld  = 1'b0 ;
                end
            end
        SEND_UART_ALU0:
            begin
                if(!uart_tx_busy) begin
                    uart_tx_p_data = tx_alu_send_data_reg[DATA_WIDTH-1:0] ;
                    uart_tx_d_vld  = 1'b1;
                end else begin
                    uart_tx_p_data = 'b0 ;
                    uart_tx_d_vld  = 1'b0 ;
                end
            end
        SEND_UART_ALU1:
            begin
                if(!uart_tx_busy) begin
                    uart_tx_p_data = tx_alu_send_data_reg[2*DATA_WIDTH-1:DATA_WIDTH] ;
                    uart_tx_d_vld  = 1'b1;
                end else begin
                    uart_tx_p_data = 'b0 ;
                    uart_tx_d_vld  = 1'b0 ;
                end
            end 
        default: 
            begin
                uart_tx_p_data = 'b0;
                uart_tx_d_vld  = 1'b0;
            end
    endcase
end


always @(posedge clk, negedge reset) begin
    if(!reset)
        tx_rf_send_data_reg <= 'b0;
    else
        if (tx_rf_send) begin
            tx_rf_send_data_reg <= tx_rf_send_data;
        end
end

always @(posedge clk, negedge reset) begin
    if(!reset)
        tx_alu_send_data_reg <= 16'b0;
    else
        if (tx_alu_send) begin
            tx_alu_send_data_reg <= tx_alu_send_data;
        end
end

endmodule