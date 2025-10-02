`timescale 1ns/1ps
`include "gates.v"
//////////////////////////////////////////////////////////////////////////////////
module full_adder_peres(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    wire p2, p3, g1, g2;
    peres gate1 (a, b, 1'b0, g1, p2, p3);
    peres gate2 (p2, cin, p3, g2, sum, cout);
endmodule

module full_adder_hng(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    wire g1, g2;
    hng gate1 (a, b, cin, 1'b0, g1, g2, sum, cout);
endmodule

module full_adder_cum_subtractor(
    input a,
    input b,
    input cin,
    input mode, // mode = 0 for add, mode = 1 for sub
    output result,
    output cout_brw
    );
    wire p1, p2, q1, q2, q3,r1,r2,r3,s1,s2 ;
    feyGate gate1 (mode, a, p1, p2);
    peres gate2 (p2, b, 1'b0, q1, q2, q3);
    peres gate3 (cin, q2, q3, r1, r2, r3);
    feyGate gate4 (p1, r2, s1, s2);
    assign result = s2;
    assign cout_brw = r3;
endmodule
