module  serializer #(parameter  WIDTH = 8, parameter BITS = 3 )
(
    input   wire                        CLK,
    input   wire                        RST,
    input   wire    [WIDTH - 1 : 0]     DATA,
    input   wire                        ser_en,
    input   wire                        sample,
    input   wire                        DATA_VALID,
    output  wire                        ser_done,
    output  reg                         ser_data
);

    reg [BITS : 0]          counter;
    reg [WIDTH - 1 : 0]     shift_reg;
    reg [WIDTH - 1 : 0]     buffer_reg;

    always @(negedge RST,posedge CLK)
        begin
            if(!RST)
                counter <= 'b000;
            else
                if (ser_en) begin
                    counter <= counter + 1'b1;
                end else begin
                    counter <= 'b0;
                end
        end

    assign ser_done = counter[BITS];

    always @(negedge RST, posedge CLK) begin
        if(!RST) begin
            shift_reg   <=  'b0;
            ser_data    <= 1'b0;
        end
        else if (sample) begin
            shift_reg <= buffer_reg;
            ser_data    <= 1'b0;
        end   
        else    begin
            if (ser_en) begin
                    shift_reg   <= (shift_reg >> 1'b1);
                    ser_data    <= shift_reg[0];
                end else begin
                    shift_reg <= 'b0;
                end
        end
    end
    
    always @(*) begin
        if(DATA_VALID)
            buffer_reg  =   DATA;
        else
            buffer_reg  =   buffer_reg;
    end
endmodule