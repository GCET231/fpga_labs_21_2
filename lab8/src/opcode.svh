// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : João Carlos Bittencourt joaocarlos@(no-spam)ufrb.edu.br
// File   : opcode.svh
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Header description:
//		Identificadores para os opcodes do MIPS231
// -----------------------------------------------------------------------------
`ifndef OPCODE
   `define OPCODE

   // Opcode
   `define RTYPE   6'b000000
   // Load/store
   `define LW      6'b100011
   `define SW      6'b101011

   // I-type
   `define ADDI    6'b001000 // ***
   `define ADDIU   6'b001001 // NOTE:  addiu *não* estende o sinal do imediato
   `define SLTI    6'b001010
   `define SLTIU   6'b001011
   `define ANDI    6'b001100
   `define ORI     6'b001101
   `define XORI    6'b001110
   `define LUI     6'b001111 

   `define BEQ    6'b 000100
   `define BNE    6'b 000101
   `define J      6'b 000010
   `define JAL    6'b 000011

   // valores de funct para instruções R-type
   `define ADD     6'b100000 // ***
   `define ADDU    6'b100001
   `define SUB     6'b100010 // ***
   `define AND     6'b100100
   `define OR      6'b100101
   `define XOR     6'b100110
   `define NOR     6'b100111
   `define SLT     6'b101010
   `define SLTU    6'b101011
   `define SLL     6'b000000
   `define SLLV    6'b000100
   `define SRL     6'b000010
   `define SRA     6'b000011
   `define JR      6'b001000 

`endif //OPCODE
