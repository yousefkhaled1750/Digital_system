module parity_check (
    input   wire            PAR_TYP,
    input   wire    [7:0]   P_data,
    input   wire            par_chk_en,
    input   wire            sampled_bit,
    input   wire    [4:0]   edge_cnt,
    input   wire    [5:0]   prescale,
    input   wire            RST,
    
    output  reg             par_err
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

    reg     Par_bit;
    //PAR_TYP = 0 -> Even (XOR)
    //PAR_TYP = 1 -> ODD  (XNOR)
    always @(*)
        begin
            if(par_chk_en) begin                
                case(PAR_TYP)
                    1'b0:   Par_bit =  ^P_data;
                    1'b1:   Par_bit = ~^P_data;
                endcase
            end
        end

    always @(negedge RST, edge_cnt) begin
        if(!RST)
            begin
                par_err <= 1'b0;
            end
        else    begin
            if(par_chk_en)
                begin
                    if(edge_cnt == sampling_time)
                        begin
                            if(sampled_bit == Par_bit)
                                par_err <= 1'b0;
                            else
                                par_err <= 1'b1;
                        end
                    else 
                        begin
                            par_err <= par_err;
                        end
                end
            else    
                begin
                    par_err <= 1'b0;
                end
        end
    end


endmodule