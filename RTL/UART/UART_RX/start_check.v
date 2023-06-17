module start_check (
    input   wire            strt_chk_en,
    input   wire            sampled_bit,
    input   wire    [4:0]   edge_cnt,
    input   wire    [5:0]   prescale,
    input   wire            RST,
    
    output  reg             strt_glitch
);


    reg [4:0]   sampling_time;
//we check at 6th edge count for prescale = 8 
//or 10th for prescale 16
//or 18th for prescale 32
    always @(*) begin
        case (prescale)
            6'd8:     sampling_time <= 5'd6;
            6'd16:    sampling_time <= 5'd10;
            6'd32:    sampling_time <= 5'd18;
            default:  sampling_time <= 5'd6;
        endcase
    end

    always @(negedge RST, edge_cnt) begin
        if(!RST)
            begin
                strt_glitch <= 1'b0;
            end
        else    begin
            if(strt_chk_en)
                begin
                    if(edge_cnt == sampling_time)
                        begin
                            if(sampled_bit == 1'b0)
                                strt_glitch <= 1'b0;
                            else
                                strt_glitch <= 1'b1;
                        end
                    else 
                        begin
                            strt_glitch <= strt_glitch;
                        end
                end
            else    
                begin
                    strt_glitch <= 1'b0;
                end
        end
    end


endmodule