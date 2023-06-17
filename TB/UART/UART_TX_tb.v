`timescale 1ns/100ps
module UART_TX_tb;


parameter WIDTH = 8         ;
parameter CLOCK_PERIOD = 20 ;

////////////////////////////////////////////////////////
/////////////////// DUT Signals //////////////////////// 
////////////////////////////////////////////////////////

    reg       [WIDTH - 1 : 0]       P_DATA_tb       ;
    reg                             DATA_VALID_tb   ;
    reg                             PAR_EN_tb       ;
    reg                             PAR_TYP_tb      ;
    reg                             CLK_tb          ;
    reg                             RST_tb          ;
    wire                            TX_OUT_tb       ;
    wire                            Busy_tb         ;



    reg       [WIDTH - 1 : 0]       OLD_P_DATA_tb   ;

////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial begin
    // save waveform
    $dumpfile("UART_TX.vcd");
    $dumpvars;
    CLK_tb = 1'b1;

    initialize();

    reset();

    Test_with_no_parity();
    
    Test_with_even_parity();

    Test_with_odd_parity();

    miscellaneous_tests();
#100

    $finish ;
end



////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        P_DATA_tb       = 'b01101001    ;
        DATA_VALID_tb   = 1'b0          ;
        PAR_EN_tb       = 1'b0          ;
        PAR_TYP_tb      = 1'b0          ;   
    end
endtask

task reset;
    begin
        RST_tb = 1'b1;
        #5
        RST_tb = 1'b0;
        #6
        RST_tb = 1'b1;
    end
endtask

task Test_with_no_parity;
    integer   I;
    begin
        P_DATA_tb       = 'b01101001    ;
        DATA_VALID_tb   = 1'b1          ;
        PAR_EN_tb       = 1'b0          ;
        PAR_TYP_tb      = 1'b0          ;
        $display("<<<<<<<<<<<<Testing the frame with NO parity>>>>>>>>>>>>>");
        #CLOCK_PERIOD
        DATA_VALID_tb   = 1'b0          ;
        //we check on start bit = 0
        if(TX_OUT_tb == 1'b0)
            $display("start bit is working correctly.");
        else
            $display("start bit not working");
        
        //checking on each bit in P_DATA_tb
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #CLOCK_PERIOD
                $display("Checking on bit no.%0d...",I);
                if(TX_OUT_tb == P_DATA_tb[I])
                    $display("Check is success");
                else
                    $display("Check is failed");        
            end
        
        //check for the stop bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b1)
            $display("stop bit is working correctly.");
        else
            $display("stop bit not working");
        
    end

endtask


task Test_with_even_parity;
    integer   I;
    begin
        #CLOCK_PERIOD
        P_DATA_tb       = 'b01101001    ;
        DATA_VALID_tb   = 1'b1          ;
        PAR_EN_tb       = 1'b1          ;
        PAR_TYP_tb      = 1'b0          ;
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<Testing the frame with EVEN parity>>>>>>>>>>>>>");

        #CLOCK_PERIOD
        DATA_VALID_tb   = 1'b0          ;
        //we check on start bit = 0
        if(TX_OUT_tb == 1'b0)
            $display("start bit is working correctly.");
        else
            $display("start bit not working");
        
        //checking on each bit in P_DATA_tb
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #CLOCK_PERIOD
                $display("Checking on bit no.%0d...",I);
                if(TX_OUT_tb == P_DATA_tb[I])
                    $display("Check is success");
                else
                    $display("Check is failed");        
            end
        //check for the even parity bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b0)
            $display("even parity bit is working correctly.");
        else
            $display("even parity bit not working");
        //check for the stop bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b1)
            $display("stop bit is working correctly.");
        else
            $display("stop bit not working");
        
    end

endtask



task Test_with_odd_parity;
    integer   I;
    begin
        #CLOCK_PERIOD
        P_DATA_tb       = 'b01101001    ;
        DATA_VALID_tb   = 1'b1          ;
        PAR_EN_tb       = 1'b1          ;
        PAR_TYP_tb      = 1'b1          ;
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<Testing the frame with ODD parity>>>>>>>>>>>>>");

        #CLOCK_PERIOD
        DATA_VALID_tb   = 1'b0          ;
        //we check on start bit = 0
        if(TX_OUT_tb == 1'b0)
            $display("start bit is working correctly.");
        else
            $display("start bit not working");
        
        //checking on each bit in P_DATA_tb
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #CLOCK_PERIOD
                $display("Checking on bit no.%0d...",I);
                if(TX_OUT_tb == P_DATA_tb[I])
                    $display("Check is success");
                else
                    $display("Check is failed");        
            end
        //check for the odd parity bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b1)
            $display("odd parity bit is working correctly.");
        else
            $display("odd parity bit not working");
        //check for the stop bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b1)
            $display("stop bit is working correctly.");
        else
            $display("stop bit not working");
        
    end

endtask

task miscellaneous_tests;
    integer   I;
    begin
        #CLOCK_PERIOD
        P_DATA_tb       = 'b01101001    ;
        DATA_VALID_tb   = 1'b1          ;
        PAR_EN_tb       = 1'b0          ;
        PAR_TYP_tb      = 1'b0          ;

        //changing the P_DATA while working on already sampled data
        #CLOCK_PERIOD
        DATA_VALID_tb   =   1'b0            ; 
        OLD_P_DATA_tb   =   P_DATA_tb       ;
        #1
        P_DATA_tb       =   'b10110110      ;
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<Changing the input data after resetting DATA_VALID>>>>>>>>");
        $display("We check that the output data is the old one");
        //checking on each bit in P_DATA_tb
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #CLOCK_PERIOD
                $display("Checking on bit no.%0d...",I);
                if(TX_OUT_tb == OLD_P_DATA_tb[I])
                    $display("Check is success");
                else
                    $display("Check is failed");        
            end
        
       
        #(CLOCK_PERIOD)
        //during the STOP bit we set DATA_VALID signal for 1 clock cycle
        DATA_VALID_tb = 1'b1;
        #(CLOCK_PERIOD)
        DATA_VALID_tb = 1'b0;
        // here we sampled the new data input
        // so, we make a full test to see the timing and the new data
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<Raising the DATA_VALID flag during the stop bit>>>>>>>>");
        $display("We check that the output data is the new data input sampled");
        //we check on start bit = 0
        if(TX_OUT_tb == 1'b0)
            $display("start bit is working correctly.");
        else
            $display("start bit not working");
        
        //checking on each bit in P_DATA_tb
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #CLOCK_PERIOD
                $display("Checking on bit no.%0d...",I);
                if(TX_OUT_tb == P_DATA_tb[I])
                    $display("Check is success");
                else
                    $display("Check is failed");        
            end
        //check for the stop bit
        #CLOCK_PERIOD
        if(TX_OUT_tb == 1'b1)
            $display("stop bit is working correctly.");
        else
            $display("stop bit not working");
        
        
    end

endtask

////////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(CLOCK_PERIOD/2)  CLK_tb = ~CLK_tb;   // period = 20 ns (50 MHz)

////////////////////////////////////////////////////////
/////////////////// DUT Instantation ///////////////////
////////////////////////////////////////////////////////

UART_TX DUT (
    .P_DATA(P_DATA_tb),
    .DATA_VALID(DATA_VALID_tb),
    .PAR_EN(PAR_EN_tb),
    .PAR_TYP(PAR_TYP_tb),
    .CLK(CLK_tb),
    .RST(RST_tb),
    .TX_OUT(TX_OUT_tb),
    .Busy(Busy_tb)
);




endmodule