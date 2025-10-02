`include "gates.v"
`timescale 1ns/1ps

module hierarchical_CLA(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout
);
    wire [3:0] P, G; // Propagate and Generate
    wire [3:0] C;    // Carry bits

    // Generate Propagate and Generate signals
    assign P = A ^ B; // Propagate
    assign G = A & B; // Generate

    // Calculate carry bits
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);

    // Calculate sum bits
    assign S = P ^ C;

endmodule

module 4bit_cla_generator(
    input  [3:0] g,
    input  [3:0] p, 
    input cin,
    output [2:0] c,


)