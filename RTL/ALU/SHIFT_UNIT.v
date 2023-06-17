module SHIFT_UNIT #(
	parameter WIDTH  = 16
)
(
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [     1    : 0]     ALU_FUN,
    input   wire                        clk,RST,
    input   wire                        Shift_Enable,

    output  reg     [2*WIDTH - 1 : 0]     SHIFT_OUT,
    output  reg                         SHIFT_Flag

);


    always @(posedge clk, negedge RST) begin
        if (!RST) begin
            SHIFT_Flag <= 1'b0;
            SHIFT_OUT <= 'b0;
        end else begin
            if (Shift_Enable) 
                begin
                    SHIFT_Flag <= 1'b1;
                    case (ALU_FUN)
                        2'b00: begin
                            SHIFT_OUT <= A >> 1;
                        end
                        2'b01: begin
                            SHIFT_OUT <= A << 1;
                        end
                        2'b10: begin
                            SHIFT_OUT <= B >> 1;
                        end
                        2'b11: begin
                            SHIFT_OUT <= B << 1;
                        end
                    endcase
                end
            else 
                begin
                    SHIFT_OUT <=  'b0;   //parameterized assignment
                    SHIFT_Flag <= 1'b0;
                end    
            end
        
    end

endmodule