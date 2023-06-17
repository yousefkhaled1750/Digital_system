module CTRL_RX #(parameter DATA_WIDTH = 8, RF_ADDR = 4)(
    input   wire                        clk,
    input   wire                        reset,
    input   wire    [DATA_WIDTH-1:0]    uart_rx_p_data,
    input   wire                        uart_rx_d_vld,
    
    output  reg                         alu_en,
    output  reg     [3:0]               alu_fun,
    output  reg                         clk_gate_en,

    output  reg     [RF_ADDR-1:0]       rf_address,
    output  reg                         rf_wrEn,
    output  reg                         rf_rdEn,
    output  reg     [DATA_WIDTH-1:0]    rf_wrData,
    
    input   wire                        alu_out_valid,
    input   wire    [2*DATA_WIDTH-1:0]  alu_out,

    input   wire                        rf_rdData,
    input   wire                        rf_rdData_vld,

    output  reg                         clk_div_en,

    output  reg                         tx_rf_send,
    output  reg                         tx_alu_send,
    output  reg    [DATA_WIDTH-1:0]     tx_rf_send_data,
    output  reg    [2*DATA_WIDTH-1:0]   tx_alu_send_data
);

// state encoding
localparam  [3:0]       IDLE_S          = 4'b0000 , 
                        RF_WR_ADDR_S    = 4'b0001 ,
                        RF_WR_DATA_S    = 4'b0010 ,
                        RF_RD_ADDR_S    = 4'b0011 ,
                        RF_RD_WAIT_S    = 4'b0100 ,
                        ALU_OP_A_S      = 4'b0101 ,
                        ALU_OP_B_S      = 4'b0110 ,
                        ALU_OP_FUN_S    = 4'b0111 ,
                        ALU_OP_WAIT_S   = 4'b1000 ;


localparam  [7:0]        RF_WRITE_CMD  = 8'hAA ,
                                    RF_READ_CMD   = 8'hBB ,
					                ALU_OP_CMD  = 8'hCC ,
					                ALU_NOP_CMD = 8'hDD ;

    
reg [3:0]           current_state, next_state ;

reg [RF_ADDR:0]     rf_address_reg;

reg rf_addr_en;


// state update logic
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        current_state <= IDLE_S;
    end else begin
        current_state <= next_state;
    end
end

// next state logic
always @(*) begin
    case (current_state)
        IDLE_S:
            begin
                if(uart_rx_d_vld & uart_rx_p_data == RF_WRITE_CMD)
                    next_state = RF_WR_ADDR_S;
                else if (uart_rx_d_vld & uart_rx_p_data == RF_READ_CMD)
                    next_state = RF_RD_ADDR_S;
                else if(uart_rx_d_vld & uart_rx_p_data == ALU_OP_CMD)
                    next_state = ALU_OP_A_S;
                else if(uart_rx_d_vld & uart_rx_p_data == ALU_NOP_CMD)
                    next_state = ALU_OP_FUN_S;
                else
                    next_state = IDLE_S;
            end 
        RF_WR_ADDR_S:
            begin
                if(uart_rx_d_vld)
                    next_state = RF_WR_DATA_S;
                else
                    next_state = RF_WR_ADDR_S;
            end
        RF_WR_DATA_S:
            begin
                if(uart_rx_d_vld)
                    next_state = IDLE_S;
                else
                    next_state = RF_WR_DATA_S;
            end
        RF_RD_ADDR_S:
            begin
                if(uart_rx_d_vld)
                    next_state = RF_RD_WAIT_S;
                else
                    next_state = RF_RD_ADDR_S;
            end
        RF_RD_WAIT_S:
            begin
                if(rf_rdData_vld)
                    next_state = IDLE_S;
                else 
                    next_state = RF_RD_WAIT_S;
            end
        ALU_OP_A_S:
            begin
                if(uart_rx_d_vld)
                    next_state = ALU_OP_B_S;
                else
                    next_state = ALU_OP_A_S;
            end
        ALU_OP_B_S:
            begin
                if(uart_rx_d_vld)
                    next_state = ALU_OP_FUN_S;
                else
                    next_state = ALU_OP_B_S;
            end
        ALU_OP_FUN_S:
            begin
                if(uart_rx_d_vld)
                    next_state = ALU_OP_WAIT_S;
                else
                    next_state = ALU_OP_WAIT_S;
            end
        ALU_OP_WAIT_S:
            begin
                if(alu_out_valid)
                    next_state = IDLE_S;
                else
                    next_state = ALU_OP_WAIT_S;
            end
        default: 
            begin
                next_state = IDLE_S;
            end
    endcase
end



// output logic
always @(*) begin
    alu_en              = 1'b0;
    alu_fun             = 4'b0;
    clk_gate_en         = 1'b0;
    rf_addr_en          = 1'b0; 
    rf_address          = 'b0;
    rf_wrEn             = 1'b0;
    rf_rdEn             = 1'b0;
    rf_wrData           = 'b0;
    clk_div_en          = 1'b1;
    tx_rf_send          = 1'b0;
    tx_alu_send         = 1'b0;
    tx_alu_send_data    = 'b0;
    tx_rf_send_data     = 'b0; 
    case (current_state)
        IDLE_S:
            begin
                
            end
        RF_WR_ADDR_S:
            begin
                if (uart_rx_d_vld) begin
                   rf_addr_en = 1'b1; 
                end else begin
                    rf_addr_en = 1'b0;
                end
            end
        RF_WR_DATA_S:
            begin
                if (uart_rx_d_vld) begin
                   rf_wrEn = 1'b1;
                   rf_wrData = uart_rx_p_data; 
                end else begin
                    rf_wrEn = 1'b0;
                    rf_wrData = 'b0; 
                end
            end
        RF_RD_ADDR_S:
            begin
                if (uart_rx_d_vld) begin
                   rf_addr_en = 1'b1; 
                end else begin
                    rf_addr_en = 1'b0;
                end
            end
        RF_RD_WAIT_S:
            begin
                rf_rdEn = 1'b1;
                rf_address = rf_address_reg;
                if (rf_rdData_vld) begin
                    tx_rf_send = 1'b1;
                    tx_rf_send_data = rf_rdData;
                end
                else begin
                    tx_rf_send = 1'b0;
                    tx_rf_send_data = 8'b0;
                end

            end
        ALU_OP_A_S:
            begin
                rf_address = 'b0;
                if (uart_rx_d_vld) begin   
                   rf_wrEn = 1'b1;
                   rf_wrData = uart_rx_p_data;
                end else begin
                    rf_wrEn = 1'b0;
                    rf_wrData = 'b0;
                end 
            end
        ALU_OP_B_S:
            begin
                rf_address = 'b1;
                if (uart_rx_d_vld) begin   
                   rf_wrEn = 1'b1;
                   rf_wrData = uart_rx_p_data;
                end else begin
                    rf_wrEn = 1'b0;
                    rf_wrData = 'b0;
                end   
            end
        ALU_OP_FUN_S:
            begin
                clk_gate_en = 1'b1;
                if (uart_rx_d_vld) begin   
                    alu_fun = uart_rx_p_data[3:0];
                    alu_en = 1'b1;
                end 
                else begin
                    alu_fun = 4'b0;
                    alu_en = 1'b0;
                end
            end
        ALU_OP_WAIT_S:
            begin
                clk_gate_en = 1'b1;
                if (alu_out_valid) begin
                    tx_alu_send = 1'b1;
                    tx_alu_send_data = alu_out;
                end else begin
                    tx_alu_send = 1'b0;
                    tx_alu_send_data = 'b0;
                end
            end
        default: 
            begin
                alu_en              = 1'b0;
                alu_fun             = 4'b0;
                clk_gate_en         = 1'b0;
                rf_addr_en          = 1'b0; 
                rf_address          = 'b0;
                rf_wrEn             = 1'b0;
                rf_rdEn             = 1'b0;
                rf_wrData           = 'b0;
                clk_div_en          = 1'b1;
                tx_rf_send          = 1'b0;
                tx_alu_send         = 1'b0;
                tx_alu_send_data    = 'b0;
                tx_rf_send_data     = 'b0;    
            end
    endcase
end


always @(posedge clk, negedge reset) begin
    if(!reset)
        rf_address_reg <= 'b0;
    else
        if (rf_addr_en) begin
            rf_address_reg <= uart_rx_p_data;
        end
end





endmodule