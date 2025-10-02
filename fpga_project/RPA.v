`timescale 1ns/1ps
`include "gates.v"
module RPA_peres(a, b, cin, sum, cout);
    parameter bits= 4;
    input [bits-1:0] a, b;
    input cin;
    output [bits-1:0] sum;
    output cout;
    wire [2*bits-1:0] p, g, q;
    wire [2*bits:0] c;
    
    assign c[0] = cin;
    assign cout = c[bits];
    generate
        for(genvar i = 0; i < bits; i = i + 1) begin : gen_pg
            peres p_gate_l1(a[i], b[i], 1'b0, g[i], p[i], q[i]);
            peres p_gate_l2(p[i], c[i], q[i], g[i+bits], sum[i], c[i+1]);
        end
    endgenerate
endmodule

module RPA_hng(a, b, cin, sum, cout);
    parameter bits= 4;
    input [bits-1:0] a, b;
    input cin;
    output [bits-1:0] sum;
    output cout;
    wire [2*bits-1:0] g;
    wire [2*bits:0] c;
    
    assign c[0] = cin;
    assign cout = c[bits];
    generate
        for(genvar i = 0; i < bits; i = i + 1) begin : gen_pg
            hng h_gate(a[i], b[i], c[i],1'b0, g[2*i],g[2*1+1], sum[i], c[i+1]);
        end
    endgenerate
endmodule