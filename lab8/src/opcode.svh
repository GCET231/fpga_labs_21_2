// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : João Carlos Bittencourt joaocarlos@(no-spam)ufrb.edu.br
// File   : opcode.svh
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Header description:
//		Identificadores para os opcodes do RISC231
// -----------------------------------------------------------------------------

// Essas são as instruções não-tipo-R.  
// OPCODES são definidos aqui:

`define LW     6'b 100011
`define SW     6'b 101011

`define ADDI   6'b 001000
`define ADDIU  6'b 001001     // NOTE:  addiu *estende o sinal* do imediato
`define SLTI   6'b 001010
`define SLTIU  6'b 001011
`define ORI    6'b 001101
`define LUI    6'b 001111
`define ANDI   6'b 001100
`define XORI   6'b 001110

`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011


// Essas são todas as instruções tipo-R, i.e., OPCODE=0.  
// Campo FUNC definido aqui:

`define ADD    6'b 100000
`define ADDU   6'b 100001
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SLLV   6'b 000100
`define SRL    6'b 000010
`define SRA    6'b 000011
`define JR     6'b 001000  
