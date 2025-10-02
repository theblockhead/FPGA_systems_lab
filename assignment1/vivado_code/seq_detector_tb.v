`timescale 1ns/100ps
module tb_seq_detector();
    reg clk;
    reg reset;
    wire seq_input;  
    wire detected;
    wire clk_div;

    seq_detector uut (
      .clk(clk),
      .reset(reset),
      .detected(detected),
      .seq_input(seq_input),
      .clk_div(clk_div)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end


    initial begin
        $dumpfile("seq_detect_tb.vcd");
        $dumpvars(0, tb_seq_detector);
    end
    

    initial begin
        $monitor("Time: %0t, clk_div = %b, detected = %b", $time, 
                   uut.clk_div, detected);
        reset = 1;
        #100;     
        reset = 0;
        #1000;    
        #10000;   
        $finish;
    end
endmodule
