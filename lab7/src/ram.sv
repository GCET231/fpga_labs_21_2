// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : ram.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Single-port RAM
// -----------------------------------------------------------------------------
// Entradas: 
//      clock  : clock do sistema
//      wr     : write enable
//      addr   : endereço para especificar a posição da memória
//      din    : dado a ser escrito na memória (se wr == 1)
// -----------------------------------------------------------------------------
// Saidas:
//      dout   : dado lido da memória 
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module ram #(
   parameter Nloc = 16,                         // Quantidade de posições de memória
   parameter Dbits = 4,                         // Número de bits do dado
   parameter initfile = "mem_data.mem"          // Nome do arquivo contendo os valores iniciais
)(
   input wire clock,
   input wire wr,                               // WriteEnable:  se wr==1, o dado é escrito na memória
   input wire [$clog2(Nloc)-1 : 0] addr,        // Endereço para especificar a posição da memória
                                                //   número de bits em addr é ceiling(log2(quantidade de posições))
   input wire [Dbits-1 : 0] din,                // Dado para escrita dentro da memória (se wr==1)
   output logic [Dbits-1 : 0] dout              // Dado lido da memória (assíncrono, ou seja, contínuo)
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];        // Unidade de armazenamento onde o dado será guardado
   logic [Nloc-1:0] addr_reg;                   // sinal para armazenar o endereço

   always @(posedge clock) begin                // Escrita na memória: apenas quando wr==1, e apenas na borda de subida do clock
      if(wr)
         mem[addr] <= din;
      addr_reg <= addr;
   end
   assign dout = mem[addr];                     // Leitura da memória: leitura contínua, sem envolvimento do clock

endmodule
