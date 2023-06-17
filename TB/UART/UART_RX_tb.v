`timescale 1ns/100ps
module UART_RX_tb;

parameter CLOCK_PERIOD = 20 ;

////////////////////////////////////////////////////////
/////////////////// DUT Signals //////////////////////// 
////////////////////////////////////////////////////////

    reg               RX_IN_tb         ;
    reg    [6:0]      prescale_tb      ;
    reg               PAR_EN_tb        ;
    reg               PAR_TYP_tb       ;
    reg               CLK_tb           ;
    reg               RST_tb           ;

    wire   [7:0]      P_data_tb        ;
    wire              data_valid_tb    ;




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
    
        Test_with_even_parity();
    
    #100
    
        $finish ;
    
    end



////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize;
    begin
        RX_IN_tb        =   1'b1;
        prescale_tb     =   6'd8;
        PAR_EN_tb       =   1'b1;
        PAR_TYP_tb      =   1'b0;
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

task Test_with_even_parity;
    integer I;
    begin
        #CLOCK_PERIOD
        PAR_EN_tb       =   1'b1;
        PAR_TYP_tb      =   1'b0;
        //start bit
        RX_IN_tb        =   1'b0;
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        $display("<<<<<<<<<<<<Testing the frame with EVEN parity>>>>>>>>>>>>>");
        
        #(CLOCK_PERIOD*8)
        RX_IN_tb        =   1'b1;   //first data bit
        
        #(CLOCK_PERIOD)
        if(DUT.deser_en == 1)   //check if the start bit is read and got into the data state
            $display("start bit is received properly.");
        else
            $display("start bit was NOT received properly.");
        
        for(I = 0; I < 4'b1000; I = I + 1'b1)
            begin
                #(CLOCK_PERIOD*8)
                $display("Checking on bit no.%0d...",I);
                if(P_data_tb[I] == 1'b1)   //check if the start bit is read and got into the data state
                    $display("Check is success");
                else
                    $display("Check is failed");  

            end


        //check for the even parity bit
        RX_IN_tb        =   1'b0;
        #(CLOCK_PERIOD*7)
        if(DUT.par_err== 1'b0)
            $display("even parity bit is received correctly.");
        else
            $display("even parity bit NOT received correctly");
        
        #CLOCK_PERIOD
        //check for the stop bit
        RX_IN_tb        =   1'b1;
        #(CLOCK_PERIOD*6)
        if(DUT.stp_err== 1'b0)
            $display("stop bit is received correctly.");
        else
            $display("stop bit NOT received correctly");
        
        #CLOCK_PERIOD
        if(data_valid_tb == 1)
            $display("data is valid at the output");
        else    
            $display("data is NOT valid");
        
        #CLOCK_PERIOD
        if(data_valid_tb == 0)
            $display("data_valid is resetted after 1 clk");
        else    
            $display("data is NOT working properly");
        

    end

endtask



///////////////////////////////////////////////////////
////////////////// Clock Generator  ////////////////////
////////////////////////////////////////////////////////

always #(CLOCK_PERIOD/2)  CLK_tb = ~CLK_tb;   // period = 20 ns (50 MHz)



UART_RX DUT (
                .RX_IN(RX_IN_tb),
                .prescale(prescale_tb),
                .PAR_EN(PAR_EN_tb),
                .PAR_TYP(PAR_TYP_tb),
                .CLK(CLK_tb),
                .RST(RST_tb),
                .P_data(P_data_tb),
                .data_valid(data_valid_tb)
);



endmodule