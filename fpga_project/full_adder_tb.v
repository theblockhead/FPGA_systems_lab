//full adder testbench
`timescale 1ns/1ps
`include "full_adder.v"
module full_adder_tb;
    reg a_p, b_p, cin_p, a_h, b_h, cin_h, a_as, b_as, cin_as;
    wire sum_h, cout_h, sum_p, cout_p;
    wire result, cout_brw;
    reg mode;
    
    // Variables for expected results calculation
    reg [1:0] expected_add;
    integer expected_sub;
    reg expected_diff, expected_borrow; 
    
    full_adder_peres uut_peres (
        .a(a_p),
        .b(b_p),
        .cin(cin_p),
        .sum(sum_p),
        .cout(cout_p)
    );

    full_adder_hng uut_hng (
        .a(a_h),
        .b(b_h),
        .cin(cin_h),
        .sum(sum_h),
        .cout(cout_h)
    );

    full_adder_cum_subtractor uut_cum_subtractor (
        .a(a_as),
        .b(b_as),
        .cin(cin_as),
        .mode(mode),
        .result(result),
        .cout_brw(cout_brw)
    );
    
    initial begin
        $display("=== Full Adder/Subtractor Testbench ===");
        $display("Addition: result = a + b + cin");
        $display("Subtraction: result = a - b - cin (borrow)");
        $display("");

        // Test addition mode (mode = 0)
        mode = 1'b0;
        $display("=== Testing Addition Mode (mode=0) ===");
        $display("Expected: result = a + b + cin, cout = carry out");
        $display("a b cin | Expected | Actual");
        $display("        | sum cout | result cout_brw");
        $display("--------|----------|----------------");
        
        for (integer i = 0; i < 8; i = i + 1) begin
            {a_p, b_p, cin_p} = i; 
            {a_h, b_h, cin_h} = i;
            {a_as, b_as, cin_as} = i;
            #1; // Small delay for signal propagation
            
            // Calculate expected results for addition
            expected_add = a_as + b_as + cin_as;
            $display("%b %b %b   |  %b   %b   |   %b      %b     | %s", 
                     a_p, b_p, cin_p, 
                     expected_add[0], expected_add[1],
                     result, cout_brw,
                     (result == expected_add[0] && cout_brw == expected_add[1]) ? "PASS" : "FAIL");
            #9; 
        end
        
        $display("");
        
        // Test subtraction mode (mode = 1)
        mode = 1'b1;
        $display("=== Testing Subtraction Mode (mode=1) ===");
        $display("Expected: result = a - b - cin, cout_brw = borrow out");
        $display("Note: Subtraction using 2's complement method");
        $display("a b cin | Expected | Actual");
        $display("        | diff brw | result cout_brw");
        $display("--------|----------|----------------");
        
        for (integer i = 0; i < 8; i = i + 1) begin
            {a_p, b_p, cin_p} = i; 
            {a_h, b_h, cin_h} = i;
            {a_as, b_as, cin_as} = i;
            #1; // Small delay for signal propagation
            
            // Calculate expected results for subtraction
            // For subtraction: a - b - cin (borrow)
            // Using signed arithmetic to handle negative results
            expected_sub = a_as - b_as - cin_as;
            
            if (expected_sub >= 0) begin
                expected_diff = expected_sub[0];
                expected_borrow = 1'b0;
            end else begin
                expected_diff = (expected_sub + 2) & 1'b1;  // 2's complement
                expected_borrow = 1'b1;
            end
            
            $display("%b %b %b   |  %b   %b   |   %b      %b     | %s", 
                     a_as, b_as, cin_as, 
                     expected_diff, expected_borrow,
                     result, cout_brw,
                     (result == expected_diff && cout_brw == expected_borrow) ? "PASS" : "FAIL");
            #9; 
        end
        
        $finish;
    end
endmodule
