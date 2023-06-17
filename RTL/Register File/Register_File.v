module Register_File #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH = 16
) (
    input   wire    [DATA_WIDTH - 1 : 0]    WrData,
    input   wire    [ADDR_WIDTH - 1 : 0]    Address,
    input   wire                            WrEn,
    input   wire                            RdEn,
    input   wire                            clk,
    input   wire                            RST,
    output  reg     [DATA_WIDTH - 1 : 0]    RdData,
    output  reg                             RdData_Valid,
    output  wire    [DATA_WIDTH - 1 : 0]    REG0,REG1,REG2,REG3
);
    
    integer i ; 

    reg [DATA_WIDTH - 1 : 0] Reg_File   [0 : DEPTH - 1];
    
    assign REG0 = Reg_File[0];
    assign REG1 = Reg_File[1];
    assign REG2 = Reg_File[2];
    assign REG3 = Reg_File[3];

    always @(posedge clk, negedge RST ) begin
        if (!RST) begin
            RdData <= 'b0;
            for (i = 0 ; i < DEPTH ; i = i + 1)
                begin
                    if(i == 2)
                        Reg_File[i] <= 'b001000_01 ;    // enable parity, prescale = 8 
		            else if (i == 3) 
                        Reg_File[i] <= 'b0000_1000 ;    // division ratio = 8
                    else
                        Reg_File[i] <= 'b0 ;		 
                end
        end else begin
            if(WrEn && !RdEn) begin   //writing has higher priority
                Reg_File[Address] <= WrData;
            end
            else if (RdEn && !WrEn) begin
                RdData <= Reg_File[Address];
            end
        end
    end

    always @(posedge clk, negedge RST ) begin
        if (!RST) begin
            RdData_Valid <= 1'b0;
        end else begin
            if(RdEn && !WrEn)
                RdData_Valid <= 1'b1;
            else
                RdData_Valid <= 1'b0;
        end
    end


endmodule