//tb for 4bit ripple carry adder
`timescale 1ns/1ps
`include "RPA.v"
module RPA_tb;
    reg [3:0] a_h, b_h, a_p, b_p;
    reg cin_h, cin_p;   
    wire [3:0] sum_h, sum_p;
    wire cout_h, cout_p;

    RPA_peres uut_peres (
        .a(a_p),
        .b(b_p),
        .cin(cin_p),
        .sum(sum_p),
        .cout(cout_p)
    );
    RPA_hng uut_hng (
        .a(a_h),
        .b(b_h),
        .cin(cin_h),
        .sum(sum_h),
        .cout(cout_h)
    );

    integer i, j, k;
    initial begin
        $monitor("PERES: a=%b b=%b cin=%b | sum=%b cout=%b || HNG: a=%b b=%b cin=%b | sum=%b cout=%b",
            a_p, b_p, cin_p, sum_p, cout_p,
            a_h, b_h, cin_h, sum_h, cout_h);
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    a_h = i; b_h = j; cin_h = k;
                    a_p = i; b_p = j; cin_p = k;
                    #10;
                end
            end
        end
        $finish;
    end
endmodule