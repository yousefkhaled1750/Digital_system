module clk_div #(parameter RATIO_WD = 4) (
    input   wire                            i_ref_clk,
    input   wire                            i_rst_n,
    input   wire                            i_clk_en,
    input   wire    [RATIO_WD - 1 : 0]      i_div_ratio,

    output  reg                             o_div_clk
);


reg [RATIO_WD - 1 : 0]  posedge_cnt, negedge_cnt;


//posedge
always @(posedge i_ref_clk, negedge i_rst_n) begin
    if (!i_rst_n) 
        posedge_cnt <= 'b0;
    else if(posedge_cnt == i_div_ratio - 1)       
        posedge_cnt <= 'b0;
    else
        posedge_cnt = posedge_cnt + 'b1;    
end

//negedge
always @(negedge i_ref_clk, negedge i_rst_n) begin
    if (!i_rst_n) 
        negedge_cnt <= 'b0;
    else if(negedge_cnt == i_div_ratio - 1)       
        negedge_cnt <= 'b0;
    else
        negedge_cnt = negedge_cnt + 'b1;    
end

//odd number division
// we need to check for posedge and negedge if any is >= ratio/2 then reset the clock
// if it less than ratio/2 then set the clock

always @(*) begin
    if(!i_rst_n)
        o_div_clk = i_ref_clk;
    else if (!i_clk_en || (i_clk_en && i_div_ratio == 'b1)) begin
        o_div_clk = i_ref_clk;
    end else begin
        if (i_div_ratio[0]) begin   //divide by odd number
            o_div_clk = posedge_cnt < ((i_div_ratio>>1) + 1) && negedge_cnt < ((i_div_ratio>>1) + 1);
        end else begin
             o_div_clk = posedge_cnt < i_div_ratio>>1;
        end
    end
end
    
endmodule