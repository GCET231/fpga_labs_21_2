// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : alu.sv
// Create : 2019-04-13 15:56:57
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		ALU de 32-bits para o processador RISC231
// -----------------------------------------------------------------------------
// Entradas: 
// 	A: a 32-bit value
// 	B: a 32-bit value
// 	aluop: Selects the ALU's operation 
// -----------------------------------------------------------------------------					
// Saidas:
// 	out: The chosen function mapped to A and B.
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none
`include "opcode.svh"
`include "aluop.svh"

module alu(
   input  wire  [31:0] A,B,
   input  wire  [3:0] aluop,
   output logic [31:0] out
);

   // Implemente sua ALU aqui, e em seguida remova este comentário

always_comb out <= A + B;

endmodule
