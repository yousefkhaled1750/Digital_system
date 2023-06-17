module  DATA_SYNC #(parameter NUM_STAGES = 2, parameter BUS_WIDTH = 8)
(
    input   wire    [BUS_WIDTH - 1 : 0]     unsync_bus  ,
    input   wire                            bus_enable  ,
    input   wire                            CLK         ,
    input   wire                            RST         ,

    output  wire    [BUS_WIDTH - 1 : 0]     sync_bus    ,
    output  wire                            enable_pulse
);

    wire                            enable  ;
    wire    [BUS_WIDTH - 1 : 0]     MUX_out ;
    //Data bus
    MUX #(.BUS_WIDTH(BUS_WIDTH))   M0    (.IN0(sync_bus), .IN1(unsync_bus), .sel(enable), .OUT(MUX_out));
    REG #(.BUS_WIDTH(BUS_WIDTH))   S_BUS (.D(MUX_out), .CLK(CLK), .RST(RST), .Q(sync_bus));

    //enable 
    wire    pulse_gen   ;
    //synchronizing the enable
    BIT_SYNC    #(.NUM_STAGES(NUM_STAGES))  U0  (.ASYNC(bus_enable), .CLK(CLK), .RST(RST), .SYNC(pulse_gen));
    //generating enable pulse
    PULSE_GEN   P0 (.IN(pulse_gen), .CLK(CLK), .RST(RST), .pulse_gen(enable));

    REG #(.BUS_WIDTH(1))   E_PUL (.D(enable), .CLK(CLK), .RST(RST), .Q(enable_pulse));


endmodule