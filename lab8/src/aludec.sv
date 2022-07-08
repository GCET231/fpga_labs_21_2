// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : aludec.v
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Decodificar a operação a ser realizada na ALU
// -----------------------------------------------------------------------------
// Entradas: 
//    opcode: os 6 bits mais significativos da instrução
//    funct : a função, no caso de instruções do tipo-R
// -----------------------------------------------------------------------------
// Saidas:
// 	aluop: A função escolhida para ser mapeada na ALU
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none
`include "opcode.svh"

module aludec(
   input  wire  [5:0] funct, opcode,
   output logic [4:0] alufn
);

   always @(*)
      case(opcode)                        // instruções não-tipo-R
         `LW,                             // LW
         `SW,                             // SW
         `ADDI,                           // ADDI
         `ADDIU: alufn <= 5'b 0xx01;      // ADDIU
         ... // adicione as instruções não-tipo-R restantes aqui
         6'b000000: 
         case(funct)                      // Tipo-R
            `ADD,
            `ADDU:   alufn <= 5'b 0xx01; // ADD e ADDU
            `SUB:    alufn <= 5'b 1xx01; // SUB
            ... // adicione as instruções tipo-R restantes aqui
            default: alufn <= 5'b xxxxx; // função desconhecida
         endcase
         default: alufn <= 5'b xxxxx;    // para todas as outras instruções, alufn é um don't-care.
    endcase
endmodule
