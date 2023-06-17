`timescale 1us/1us

module ALU_tb ();
    
    //parameters
    parameter CLOCK_PERIOD  = 10 ,
                HIGH_PERIOD = 0.5 * CLOCK_PERIOD ,
                LOW_PERIOD  = 0.5 * CLOCK_PERIOD ;
    parameter WIDTH         = 16 ;

    //port declaration
    reg     [WIDTH - 1 : 0]     A_tb;
    reg     [WIDTH - 1 : 0]     B_tb;
    reg     [     3    : 0]     ALU_FUN_tb;
    reg                         clk_tb;
    reg                         RST_tb;
    reg                         Enable_tb;
    wire    [WIDTH - 1 : 0]     ALU_OUT_tb;
    wire                        OUT_VALID_tb;
    

    //Clock Generation of period 10 us -> frequency = 100 KHz
    //Duty cycle 60%
    always  
    begin
        #HIGH_PERIOD clk_tb = ~clk_tb;
        #LOW_PERIOD clk_tb = ~clk_tb;
    end

    //Design Instantiation
    ALU_TOP #(.WIDTH(WIDTH))    DUT(
                                //inputs
                                .A(A_tb),
                                .B(B_tb),
                                .ALU_FUN(ALU_FUN_tb),
                                .clk(clk_tb),
                                .RST(RST_tb),
                                .Enable(Enable_tb),
                                //outputs
                                .ALU_OUT(ALU_OUT_tb),
                                .OUT_VALID(OUT_VALID_tb)
                                );

    initial begin
        $dumpfile("ALU.vcd") ;
        $dumpvars;
        //initial values
        A_tb = 4'b1010; //10 decimal
        B_tb = 4'b0101; //5 decimal
        ALU_FUN_tb = 4'b0000;
        clk_tb = 1'b1;

        // resetting
        RST_tb = 'b1;
        #1
        RST_tb = 'b0;
        #(CLOCK_PERIOD-3)
        RST_tb = 'b1;


        $display ("TEST CASE 1") ;  // test add Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0000;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd15 )
            $display ("TEST CASE 1 IS PASSED") ;
        else
            $display ("TEST CASE 1 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 2") ;  // test subtract Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0001;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd5 )
            $display ("TEST CASE 2 IS PASSED") ;
        else
            $display ("TEST CASE 2 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 3") ;  // test multiply Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0010;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd50 )
            $display ("TEST CASE 3 IS PASSED") ;
        else
            $display ("TEST CASE 3 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 4") ;  // test division Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0011;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd2 )
            $display ("TEST CASE 4 IS PASSED") ;
        else
            $display ("TEST CASE 4 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 5") ;  // test AND Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0100;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd0 )
            $display ("TEST CASE 5 IS PASSED") ;
        else
            $display ("TEST CASE 5 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 6") ;  // test OR Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0101;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd15 )
            $display ("TEST CASE 6 IS PASSED") ;
        else
            $display ("TEST CASE 6 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 7") ;  // test NAND Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0110;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd65535 )
            $display ("TEST CASE 7 IS PASSED") ;
        else
            $display ("TEST CASE 7 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 8") ;  // test NOR Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b0111;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd65520 )
            $display ("TEST CASE 8 IS PASSED") ;
        else
            $display ("TEST CASE 8 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 9") ;  // test NOP Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1000;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd0 )
            $display ("TEST CASE 9 IS PASSED") ;
        else
            $display ("TEST CASE 9 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 10") ;  // test == Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1001;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd0 )
            $display ("TEST CASE 10 IS PASSED") ;
        else
            $display ("TEST CASE 10 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 11") ;  // test greater than Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1010;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd2 )
            $display ("TEST CASE 11 IS PASSED") ;
        else
            $display ("TEST CASE 11 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 12") ;  // test less than Function
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1011;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd0 )
            $display ("TEST CASE 12 IS PASSED") ;
        else
            $display ("TEST CASE 12 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 13") ;  // test A shift right
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1100;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd5 )
            $display ("TEST CASE 13 IS PASSED") ;
        else
            $display ("TEST CASE 13 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 14") ;  // test A shift left 
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1101;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd20 )
            $display ("TEST CASE 14 IS PASSED") ;
        else
            $display ("TEST CASE 14 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 15") ;  // test B shift right
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1110;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd2 )
            $display ("TEST CASE 15 IS PASSED") ;
        else
            $display ("TEST CASE 15 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 16") ;  // test B shift left
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1111;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd10 )
            $display ("TEST CASE 16 IS PASSED") ;
        else
            $display ("TEST CASE 16 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 17") ;  // test equality Function when the inputs are equal
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1001;
        A_tb = 16'b0101;    //A = B = 5
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd1 )
            $display ("TEST CASE 17 IS PASSED") ;
        else
            $display ("TEST CASE 17 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 18") ;  // test greater than Function when A is less than B
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1010;
        A_tb = 16'b0010;    //A = 2 < B
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd0 )
            $display ("TEST CASE 18 IS PASSED") ;
        else
            $display ("TEST CASE 18 IS FAILED") ;
/***************************************************************************/
        $display ("TEST CASE 19") ;  // test less than Function when A is less than B
        #3
        Enable_tb = 1'b1;
        ALU_FUN_tb = 4'b1011;
        #(CLOCK_PERIOD)
        Enable_tb = 1'b0;
        @(posedge OUT_VALID_tb)
        if(ALU_OUT_tb == 'd3 )
            $display ("TEST CASE 19 IS PASSED") ;
        else
            $display ("TEST CASE 19 IS FAILED") ;
    
        #100
        $finish ;
    end


endmodule 