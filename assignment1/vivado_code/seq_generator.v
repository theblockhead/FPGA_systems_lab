`timescale 1ns/1ps

module seq_generator (
    input wire clk,
    input wire reset,
    output reg seq_input
);

    parameter MEM_SIZE = 64;
    parameter COUNTER_WIDTH = 8;

    reg [0:0] test_memory [0:MEM_SIZE-1];

    reg [COUNTER_WIDTH-1:0] mem_index;
 
    integer i;
    
    initial begin
        // Initialize all memory to 0
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            test_memory[i] = 1'b0;
        end
        
        // Test Case 1: Basic pattern 1000 (should detect)
        test_memory[0] = 1'b1;
        test_memory[1] = 1'b0;
        test_memory[2] = 1'b0;
        test_memory[3] = 1'b0;  // Detection at clock 4
        
        // Spacer bits
        test_memory[4] = 1'b0;
        test_memory[5] = 1'b0;
        
        // Test Case 2: Basic pattern 0001 (should detect)
        test_memory[6] = 1'b0;
        test_memory[7] = 1'b0;
        test_memory[8] = 1'b0;
        test_memory[9] = 1'b1;  // Detection at clock 10
        
        // Spacer bits
        test_memory[10] = 1'b0;
        test_memory[11] = 1'b0;
        
        // Test Case 3: False start for 1000 -> 1001 (should NOT detect 1000)
        test_memory[12] = 1'b1;
        test_memory[13] = 1'b0;
        test_memory[14] = 1'b0;
        test_memory[15] = 1'b1;  // 0
        
        // Spacer bits
        test_memory[16] = 1'b0;
        test_memory[17] = 1'b0;
        
        // Test Case 4: 0001 -> 0000 
        test_memory[18] = 1'b0; //1
        test_memory[19] = 1'b0;
        test_memory[20] = 1'b0;
        test_memory[21] = 1'b1;  //0
        
        // Spacer bits
        test_memory[22] = 1'b1; 
        test_memory[23] = 1'b1;
        
        // Test Case 5: Back-to-back patterns with reset after detection
        // 1000 followed immediately by 0001 (non-overlapping)
        test_memory[24] = 1'b1;
        test_memory[25] = 1'b0;
        test_memory[26] = 1'b0;
        test_memory[27] = 1'b0;  // 1
        test_memory[28] = 1'b0;  
        test_memory[29] = 1'b0;
        test_memory[30] = 1'b0;
        test_memory[31] = 1'b1;  // 1
        
        // Test Case 6
        
        test_memory[32] = 1'b1;
        test_memory[33] = 1'b0;
        test_memory[34] = 1'b0;
        test_memory[35] = 1'b0;  //1
        test_memory[36] = 1'b0; 
        
        // Spacer bits
        test_memory[37] = 1'b1; //0
        test_memory[38] = 1'b1;
        
        // Test Case 7: Mixed patterns
        test_memory[39] = 1'b0;
        test_memory[40] = 1'b0;
        test_memory[41] = 1'b0;
        test_memory[42] = 1'b1;  // 1
        test_memory[43] = 1'b1;  
        test_memory[44] = 1'b0;
        test_memory[45] = 1'b0;
        test_memory[46] = 1'b0;  //1
        
        // Test Case 8
        test_memory[47] = 1'b1;
        test_memory[48] = 1'b1;
        test_memory[49] = 1'b1;
        test_memory[50] = 1'b1; //0
        
        // Test Case 9
        test_memory[51] = 1'b1;
        test_memory[52] = 1'b0;
        test_memory[53] = 1'b1;
        test_memory[54] = 1'b0;//0
        
        // Test Case 10
        test_memory[55] = 1'b1;
        test_memory[56] = 1'b0;
        test_memory[57] = 1'b0;
        test_memory[58] = 1'b0; // 1
        
        test_memory[59] = 1'b0;
        test_memory[60] = 1'b0;
        test_memory[61] = 1'b0;
        test_memory[62] = 1'b1;  //1
        test_memory[63] = 1'b0;  
    end
    
    // Sequential logic for memory access
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_index <= 0;
            seq_input <= 1'b0;
        end 
        else begin
            mem_index <= mem_index + 1;
            seq_input <= test_memory[mem_index];
        end
    end

endmodule