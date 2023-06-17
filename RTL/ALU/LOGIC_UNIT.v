module LOGIC_UNIT #(
    parameter WIDTH = 16
) (
    input   wire    [WIDTH - 1 : 0]     A,
    input   wire    [WIDTH - 1 : 0]     B,
    input   wire    [     1    : 0]     ALU_FUN,
    input   wire                        clk, RST,
    input   wire                        Logic_Enable,

    output  reg     [2*WIDTH - 1 : 0]     Logic_OUT,
    output  reg                         Logic_Flag

);
    
    always @(posedge clk, negedge RST) begin
        if (!RST) begin
            Logic_Flag <= 1'b0;
            Logic_OUT <= 'b0;
        end else begin
            if (Logic_Enable) 
            begin
                Logic_Flag <= 1'b1;
                case (ALU_FUN)
                    2'b00: begin
                        Logic_OUT <= A & B;
                    end
                    2'b01: begin
                        Logic_OUT <= A | B;
                    end
                    2'b10: begin
                        Logic_OUT <= ~(A & B);
                    end
                    2'b11: begin
                        Logic_OUT <= ~(A | B);
                    end
                endcase
            end
            else 
            begin
                Logic_OUT <=  'b0;   //parameterized assignment
                Logic_Flag <= 1'b0;
            end
            end
        
        

    end

endmodule