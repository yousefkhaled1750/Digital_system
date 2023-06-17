module edge_bit_counter (
    input   wire            enable,
    input   wire            CLK,
    input   wire            RST,
    input   wire    [5:0]   prescale,             

    output  reg     [4:0]   edge_cnt,
    output  reg     [3:0]   bit_cnt

);





// Logic of edge counter
    always @(posedge CLK, negedge RST) begin
        if(!RST)
            begin
                edge_cnt <= 5'b0;
                bit_cnt  <= 5'b0; 
            end
        else
            if(enable)
                begin   
                    if(edge_cnt == prescale - 1)
                        begin
                            edge_cnt <= 5'b0;
                            bit_cnt  <= bit_cnt + 4'b1;
                        end
                    else
                        begin
                            edge_cnt <= edge_cnt + 5'b1;
                            bit_cnt  <= bit_cnt;
                        end
                end
            else
                begin
                    edge_cnt <= 5'b0;
                    bit_cnt  <= 5'b0;
                end

    end


endmodule