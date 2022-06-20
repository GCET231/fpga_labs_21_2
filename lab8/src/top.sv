// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : top.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//		Estrutura top level do processador RISC231 com memórias
// -----------------------------------------------------------------------------
// Entradas: 
// 	enable : sinal de controle de escrita
// 	clk    : clock do processador
// 	reset  : sinal de reset
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="wherever_code_is.mem",		// corrija o nome do arquivo dentro da pasta ../sim/test 
    parameter dmem_init="wherever_data_is.mem"		// corrija o nome do arquivo dentro da pasta ../sim/test 
)(
    input wire clk, reset, enable
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;

   risc231 risc231 (clk, reset, enable, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);

   imem #(.Nloc(64), .Dbits(32), .initfile(imem_init)) imem (pc[31:2], instr);      
   							// ignore os dois LSBs do endereço para a memória de instruções
   							
   dmem #(.Nloc(64), .Dbits(32), .initfile(dmem_init)) dmem (clk, mem_wr, mem_addr[31:2], mem_writedata, mem_readdata);  
   							// ignore os dois LSBs para o endereço da memória de dados

endmodule
