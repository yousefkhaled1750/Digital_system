module deserializer (
    input   wire            sampled_bit,
    input   wire    [3:0]   bit_cnt,
    input   wire            RST,
    input   wire            deser_en,

    output  reg     [7:0]   P_data

);


    always @(bit_cnt, negedge RST) begin
        if(!RST)
            P_data <= 8'b0;
        else    begin
            if(deser_en)
                begin
                    P_data[bit_cnt - 2] <= sampled_bit;
                end
        end
    end
    
endmodule