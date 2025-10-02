`timescale 1ns/100ps
`define SIM_MODE
`include "seq_detector_alt.v"
module tb_seq_detector();
    reg clk;
    reg reset;
    wire seq_input;  // This is an output from seq_detector
    wire detected;

    seq_detector uut (
      .clk(clk),
      .reset(reset),
      .detected(detected),
      .seq_input(seq_input)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period (100MHz)
    end


    initial begin
        $dumpfile("seq_detect_tb.vcd");
        $dumpvars(0, tb_seq_detector);
    end
    

    initial begin
        $monitor("Time: %0t, clk_div = %b, detected = %b", $time, 
                   uut.clk_div, detected);
        reset = 1;
        #100;     // 100ns reset
        reset = 0;
        #1000;    // Wait for a few divided clock cycles
        #10000;   // Run for enough time to see several divided clock edges
        $finish;
    end
endmodule
