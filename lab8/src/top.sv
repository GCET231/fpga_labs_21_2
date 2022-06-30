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
// Comments:
// Não deve haver necessidade de modificar nada do que está abaixo!!!
// Quaisquer alterações nos parâmetros devem ser feitas no testbench, a partir 
// do qual os valores reais dos parâmetros são herdados.
// -----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter Dbits=32,                             // tamanho da palavra do processador
    parameter Nreg=32,                              // quantidade de registradores
    parameter imem_size=128,                        // tamanho da imem, deve ser >= # de instruções no programa
    parameter imem_init="wherever_code_is.mem",		// corrija o nome do arquivo dentro da pasta ../sim/test 
    parameter dmem_size=64,                         // tamanho da dmem, deve ser >= # de palavras em dados do programa + tamanho da pilha
    parameter dmem_init="wherever_data_is.mem"		// corrija o nome do arquivo dentro da pasta ../sim/test 
)(
    input wire clk, reset, enable
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;

   risc231_m1 #(.Dbits(Dbits), .Nreg(Nreg)) risc231_m1 (clk, reset, enable, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);

   rom_module #(.Nloc(imem_size), .Dbits(Dbits), .initfile(imem_init)) imem (pc[31:2], instr);      
   			    // ignoramos os dois LSBs do endereço para a memória de instruções para converter o endereçamento em byte por endereço de palavras
   							
   ram_module #(.Nloc(dmem_size), .Dbits(Dbits), .initfile(dmem_init)) dmem (clk, mem_wr, mem_addr[31:2], mem_writedata, mem_readdata);  
   				// ignoramos os dois LSBs para o endereço da memória de dados para converter o endereçamento em byte por endereço de palavras

endmodule
