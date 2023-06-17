module data_sampling (
    input   wire            data_sample_en,
    input   wire            RX_IN,
    input   wire    [4:0]   edge_cnt,
    input   wire    [5:0]   prescale,
    input   wire            CLK,
    input   wire            RST,

    output  reg             sampled_bit
);
    
    reg     A, B, C;


//  A, B, C logic
    always @(posedge CLK, negedge RST) begin
        if(!RST)
            begin
                A   <= 1'b0;
                B   <= 1'b0;
                C   <= 1'b0;
            end
        else
            begin
                if(data_sample_en)
                    A   <=      A;
                    B   <=      B;
                    C   <=      C;
                    if (prescale == 6'd8) begin //take 3rd, 4th and 5th bit   
                        case (edge_cnt)
                            5'd3:   A <= RX_IN;
                            5'd4:   B <= RX_IN;
                            5'd5:   C <= RX_IN;
                            default: begin
                                A   <=      A;
                                B   <=      B;
                                C   <=      C;
                            end 
                        endcase
                    end else if (prescale == 6'd16) begin
                        case (edge_cnt)
                            5'd7:   A <= RX_IN;
                            5'd8:   B <= RX_IN;
                            5'd9:   C <= RX_IN;
                            default: begin
                                A   <=      A;
                                B   <=      B;
                                C   <=      C;
                            end 
                        endcase
                    end else if (prescale == 6'd32) begin
                        case (edge_cnt)
                            5'd15:   A <= RX_IN;
                            5'd16:   B <= RX_IN;
                            5'd17:   C <= RX_IN;
                            default: begin
                                A   <=      A;
                                B   <=      B;
                                C   <=      C;
                            end 
                        endcase
                    end else    begin
                        case (edge_cnt)
                            5'd3:   A <= RX_IN;
                            5'd4:   B <= RX_IN;
                            5'd5:   C <= RX_IN;
                            default: begin
                                A   <=      A;
                                B   <=      B;
                                C   <=      C;
                            end 
                        endcase
                    end 
            end
    end

// sampled bit logic
    always @(*) begin
        sampled_bit = A&C | A&B | B&C;
    end


endmodule