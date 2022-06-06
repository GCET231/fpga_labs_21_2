// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : João Carlos Bittencourt
// File   : opcode.svh
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Header description:
//		Identificadores para os opcodes do processador MIPS231
// -----------------------------------------------------------------------------
`ifndef OPCODE
`define OPCODE

   `define ADD 5'b0xx01
   `define SUB 5'b1xx01
   `define SLL 5'bx0010
   `define SRL 5'bx1010
   `define SRA 5'bx1110
   `define AND 5'bx0000
   `define OR  5'bx0100
   `define XOR 5'bx1000
   `define NOR 5'bx1100
   `define LT  5'b1x011
   `define LTU 5'b1x111

`endif //OPCODE
