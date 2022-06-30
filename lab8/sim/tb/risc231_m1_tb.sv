// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : João Carlos Bittencourt
// File   : risc231_m1_tb.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Description:
//
// Este é um teste auto-verificável para o seu processador RISC231-M1 
// Use o programa de teste para um teste completo, ou seja, inicialize
// a memória de instruções com full_imem.mem, e a memória de dados com
// full_dmem.mem.
//
// Use esse teste com cuidado! Os nomes das suas entradas/saídas e sinais
// internos podem ser diferentes. Portanto, modifique todos os nomes de sinais
// no lado direito das atribuições de "wire" que aparecem acima da instancia
// da uut. Observe que a uut apenas possui os sinais de clock e reset agora,
// e nenhuma saída de depuração. No lugar delas, os sinais internas são
// "postos para fora" usando o operador seletor de membro, ou ponto (".").
//
// Se você escolher não usar alguns destes sinais internos para depuração, 
// você pode comentar as linhas relevantes. Certifique-se de comentar a linha
// de "ERROR_*" correspondente, a qual aparece logo abaixo.
//
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module risc231_m1_tb;

   // Inputs
   logic clk;
   logic reset;
   logic enable = 1'b1;

   // Signals inside top-level module uut
   wire [31:0] pc             = uut.pc;                     // PC
   wire [31:0] instr          = uut.instr;                  // instr vinda da memória de instr
   wire [31:0] mem_addr       = uut.mem_addr;               // endereço enviado para a memória de dados
   wire        mem_wr         = uut.mem_wr;                 // write enable para a memória de dados
   wire [31:0] mem_readdata   = uut.mem_readdata;           // dado lido da memória de dados
   wire [31:0] mem_writedata  = uut.mem_writedata;          // dado enviado para escrita na memória de dados

   // Sinais dentro do módulo uut.risc231_m1
   wire        werf           = uut.risc231_m1.werf;              // WERF = write enable para o register file
   wire  [4:0] alufn          = uut.risc231_m1.alufn;             // função da ALU
   wire        Z              = uut.risc231_m1.Z;                 // flag Zero

   // Sinais dentro do módulo uut.risc231_m1.dp (datapath)
   wire [31:0] ReadData1      = uut.risc231_m1.dp.ReadData1;       // Reg[rs]
   wire [31:0] ReadData2      = uut.risc231_m1.dp.ReadData2;       // Reg[rt]
   wire [31:0] alu_result     = uut.risc231_m1.dp.alu_result;      // saída da ALU
   wire [4:0]  reg_writeaddr  = uut.risc231_m1.dp.reg_writeaddr;   // registrador de destino
   wire [31:0] reg_writedata  = uut.risc231_m1.dp.reg_writedata;   // dado a ser escrito no register file
   wire [31:0] signImm        = uut.risc231_m1.dp.signImm;         // imediado sign-/zero-extended
   wire [31:0] aluA           = uut.risc231_m1.dp.aluA;            // operando A da ALU
   wire [31:0] aluB           = uut.risc231_m1.dp.aluB;            // operando B da ALU

   // Sinais dentro do módulo uut.risc231_m1.c (controller)
   wire [1:0] pcsel           = uut.risc231_m1.c.pcsel;
   wire [1:0] wasel           = uut.risc231_m1.c.wasel;
   wire sext                  = uut.risc231_m1.c.sext;
   wire bsel                  = uut.risc231_m1.c.bsel;
   wire [1:0] wdsel           = uut.risc231_m1.c.wdsel;
   wire wr                    = uut.risc231_m1.c.wr;
   wire [1:0] asel            = uut.risc231_m1.c.asel;


   // Instancia a Unit Under Test (UUT)
   top #(
      .Dbits(32),                            // tamanho da palavra do processador
      .Nreg(32),                             // quantidade de registradores
      .imem_size(64),                        // tamanho da imem, deve ser >= # de instruções no programa
      .imem_init("../tests/full_imem.mem"),  // nome do arquivo com o programa a ser carregado na memória de instruções
      .dmem_size(64),                        // tamanho da dmem, deve ser >= # de palavras em dados do programa + tamanho da pilha
      .dmem_init("../tests/full_dmem.mem")   // nome do arquivo com o conteúdo inicial da memória de dados
   ) uut (
      .clk(clk), 
      .reset(reset),
      .enable(enable)
   );

   initial begin
      // Inicializa as entradas
      clk = 1'b0;
      reset = 1'b0;
      enable = 1'b1;
      #70.5 enable = 1'b0;
      #5  enable = 1'b1;
   end

   initial begin
      #0.5 clk = 0;
      forever
         #0.5 clk = ~clk;
   end

   initial begin
      #90 $finish;
   end

   // Código de auto-verificação

   selfcheck c();

   wire [31:0] c_pc = c.pc;
   wire [31:0] c_instr = c.instr;
   wire [31:0] c_mem_addr = c.mem_addr;
   wire        c_mem_wr = c.mem_wr;
   wire [31:0] c_mem_readdata = c.mem_readdata;
   wire [31:0] c_mem_writedata = c.mem_writedata;
   wire        c_werf = c.werf;
   wire  [4:0] c_alufn = c.alufn;
   wire        c_Z = c.Z;
   wire [31:0] c_ReadData1 = c.ReadData1;
   wire [31:0] c_ReadData2 = c.ReadData2;
   wire [31:0] c_alu_result = c.alu_result;
   wire [4:0]  c_reg_writeaddr = c.reg_writeaddr;
   wire [31:0] c_reg_writedata = c.reg_writedata;
   wire [31:0] c_signImm = c.signImm;
   wire [31:0] c_aluA = c.aluA;
   wire [31:0] c_aluB = c.aluB;
   wire [1:0]  c_pcsel = c.pcsel;
   wire [1:0]  c_wasel = c.wasel;
   wire        c_sext = c.sext;
   wire        c_bsel = c.bsel;
   wire [1:0]  c_wdsel = c.wdsel;
   wire        c_wr = c.wr;
   wire [1:0]  c_asel = c.asel;

   function mismatch;  // ajuste necessário para comparar dois valores com don't cares
      input p, q;      // diferença em uma posição de bit é ignorada de q tem um 'x' naquele bit
      integer p, q;
      mismatch = (((p ^ q) ^ q) !== q);
   endfunction

   wire ERROR;

   wire ERROR_pc             = mismatch(pc, c.pc) ? 1'bx : 1'b0;
   wire ERROR_instr          = mismatch(instr, c.instr) ? 1'bx : 1'b0;
   wire ERROR_mem_addr       = mismatch(mem_addr, c.mem_addr) ? 1'bx : 1'b0;
   wire ERROR_mem_wr         = mismatch(mem_wr, c.mem_wr) ? 1'bx : 1'b0;
   wire ERROR_mem_readdata   = mismatch(mem_readdata, c.mem_readdata) ? 1'bx : 1'b0;
   wire ERROR_mem_writedata  = c.mem_wr & (mismatch(mem_writedata, c.mem_writedata) ? 1'bx : 1'b0);
   wire ERROR_werf           = mismatch(werf, c.werf) ? 1'bx : 1'b0;
   wire ERROR_alufn          = mismatch(alufn, c.alufn) ? 1'bx : 1'b0;
   wire ERROR_Z              = mismatch(Z, c.Z) ? 1'bx : 1'b0;
   wire ERROR_ReadData1      = mismatch(ReadData1, c.ReadData1) ? 1'bx : 1'b0;
   wire ERROR_ReadData2      = mismatch(ReadData2, c.ReadData2) ? 1'bx : 1'b0;
   wire ERROR_alu_result     = mismatch(alu_result, c.alu_result) ? 1'bx : 1'b0;
   wire ERROR_reg_writeaddr  = c.werf & (mismatch(reg_writeaddr, c.reg_writeaddr) ? 1'bx : 1'b0);
   wire ERROR_reg_writedata  = c.werf & (mismatch(reg_writedata, c.reg_writedata) ? 1'bx : 1'b0);
   wire ERROR_signImm        = mismatch(signImm, c.signImm) ? 1'bx : 1'b0;
   wire ERROR_aluA           = mismatch(aluA, c.aluA) ? 1'bx : 1'b0;
   wire ERROR_aluB           = mismatch(aluB, c.aluB) ? 1'bx : 1'b0;
   wire ERROR_pcsel          = mismatch(pcsel, c.pcsel) ? 1'bx : 1'b0;
   wire ERROR_wasel          = c.werf & (mismatch(wasel, c.wasel) ? 1'bx : 1'b0);
   wire ERROR_sext           = mismatch(sext, c.sext) ? 1'bx : 1'b0;
   wire ERROR_bsel           = mismatch(bsel, c.bsel) ? 1'bx : 1'b0;
   wire ERROR_wdsel          = mismatch(wdsel, c.wdsel) ? 1'bx : 1'b0;
   wire ERROR_wr             = mismatch(wr, c.wr) ? 1'bx : 1'b0;
   wire ERROR_asel           = mismatch(asel, c.asel) ? 1'bx : 1'b0;

   assign ERROR = ERROR_pc | ERROR_instr | ERROR_mem_addr | ERROR_mem_wr | ERROR_mem_readdata 
            | ERROR_mem_writedata | ERROR_werf | ERROR_alufn | ERROR_Z
            | ERROR_ReadData1 | ERROR_ReadData2 | ERROR_alu_result | ERROR_reg_writeaddr
            | ERROR_reg_writedata | ERROR_signImm | ERROR_aluA | ERROR_aluB
            | ERROR_pcsel | ERROR_wasel | ERROR_sext | ERROR_bsel | ERROR_wdsel | ERROR_wr | ERROR_asel;

   initial begin
      $monitor("#%02d {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h%h, 32'h%h, 32'h%h, 1'b%b, 32'h%h, 32'h%h, 1'b%b, 5'b%b, 1'b%b, 32'h%h, 32'h%h, 32'h%h, 5'h%h, 32'h%h, 32'h%h, 32'h%h, 32'h%h, 2'b%b, 2'b%b, 1'b%b, 1'b%b, 2'b%b, 1'b%b, 2'b%b};",
         $time, pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel);
   end
   
endmodule

// Módulo de Verificação
module selfcheck();
   logic  [31:0] pc;
   logic  [31:0] instr;
   logic  [31:0] mem_addr;
   logic         mem_wr;
   logic  [31:0] mem_readdata;
   logic  [31:0] mem_writedata;
   logic         werf;
   logic   [3:0] alufn; // mesmo que aluop do lab6.
   logic         Z;
   logic  [31:0] ReadData1;
   logic  [31:0] ReadData2;
   logic  [31:0] alu_result;
   logic  [4:0]  reg_writeaddr;
   logic  [31:0] reg_writedata;
   logic  [31:0] signImm;
   logic  [31:0] aluA;
   logic  [31:0] aluB;
   logic  [1:0] pcsel;
   logic  [1:0] wasel;
   logic        sext;
   logic        bsel;
   logic  [1:0] wdsel;
   logic        wr;
   logic  [1:0] asel;
   
   initial begin
      fork
         #00 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400000, 32'h3c1d1001, 32'h10010000, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, `ALU_LUI, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h10010000, 5'h1d, 32'h10010000, 32'h00001001, 32'h00000010, 32'h00001001, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10}; // LUI
         #01 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400004, 32'h37bd0100, 32'h10010100, 1'b0, 32'h00000000, 32'h10010000, 1'b1, `ALU_OR, 1'b0, 32'h10010000, 32'h10010000, 32'h10010100, 5'h1d, 32'h10010100, 32'h00000100, 32'h10010000, 32'h00000100, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #02 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400008, 32'h3c08ffff, 32'hffff0000, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, `ALU_LUI, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'hffff0000, 5'h08, 32'hffff0000, 32'hxxxxffff, 32'h00000010, 32'hxxxxffff, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10};
         #03 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040000c, 32'h3508ffff, 32'hffffffff, 1'b0, 32'hxxxxxxxx, 32'hffff0000, 1'b1, `ALU_OR, 1'b0, 32'hffff0000, 32'hffff0000, 32'hffffffff, 5'h08, 32'hffffffff, 32'h0000ffff, 32'hffff0000, 32'h0000ffff, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #04 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400010, 32'h2009ffff, 32'hffffffff, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, `ALU_ADDU, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'hffffffff, 5'h09, 32'hffffffff, 32'hffffffff, 32'h00000000, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #05 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400014, 32'h15090023, 32'h00000000, 1'b0, 32'h00000000, 32'hffffffff, 1'b0, `ALU_SUBU, 1'b1, 32'hffffffff, 32'hffffffff, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'h00000023, 32'hffffffff, 32'hffffffff, 2'b00, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #06 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400018, 32'h00084600, 32'hff000000, 1'b0, 32'h00000000, 32'hffffffff, 1'b1, `ALU_SLL, 1'b0, 32'h00000000, 32'hffffffff, 32'hff000000, 5'h08, 32'hff000000, 32'h00004600, 32'h00000018, 32'hffffffff, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b01};
         #07 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040001c, 32'h3508f000, 32'hff00f000, 1'b0, 32'h00000000, 32'hff000000, 1'b1, `ALU_OR, 1'b0, 32'hff000000, 32'hff000000, 32'hff00f000, 5'h08, 32'hff00f000, 32'h0000f000, 32'hff000000, 32'h0000f000, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #08 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400020, 32'h00084203, 32'hffff00f0, 1'b0, 32'hxxxxxxxx, 32'hff00f000, 1'b1, `ALU_SRA, 1'b0, 32'h00000000, 32'hff00f000, 32'hffff00f0, 5'h08, 32'hffff00f0, 32'h00004203, 32'h00000008, 32'hff00f000, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b01};
         #09 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400024, 32'h00084102, 32'h0ffff00f, 1'b0, 32'hxxxxxxxx, 32'hffff00f0, 1'b1, `ALU_SRL, 1'b0, 32'h00000000, 32'hffff00f0, 32'h0ffff00f, 5'h08, 32'h0ffff00f, 32'h00004102, 32'h00000004, 32'hffff00f0, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b01};
         #10 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400028, 32'h340a0003, 32'h00000003, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, `ALU_OR, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h00000003, 5'h0a, 32'h00000003, 32'h00000003, 32'h00000000, 32'h00000003, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #11 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040002c, 32'h01495022, 32'h00000004, 1'b0, 32'h00000003, 32'hffffffff, 1'b1, `ALU_SUBU, 1'b0, 32'h00000003, 32'hffffffff, 32'h00000004, 5'h0a, 32'h00000004, 32'h00005022, 32'h00000003, 32'hffffffff, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #12 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400030, 32'h01484004, 32'hffff00f0, 1'b0, 32'hxxxxxxxx, 32'h0ffff00f, 1'b1, `ALU_SLL, 1'b0, 32'h00000004, 32'h0ffff00f, 32'hffff00f0, 5'h08, 32'hffff00f0, 32'h00004004, 32'h00000004, 32'h0ffff00f, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #13 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400034, 32'h010a582a, 32'h00000001, 1'b0, 32'h00000000, 32'h00000004, 1'b1, `ALU_SLT, 1'b0, 32'hffff00f0, 32'h00000004, 32'h00000001, 5'h0b, 32'h00000001, 32'h0000582a, 32'hffff00f0, 32'h00000004, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #14 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400038, 32'h010a582b, 32'h00000000, 1'b0, 32'h00000000, 32'h00000004, 1'b1, `ALU_SLTU, 1'b1, 32'hffff00f0, 32'h00000004, 32'h00000000, 5'h0b, 32'h00000000, 32'h0000582b, 32'hffff00f0, 32'h00000004, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #15 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040003c, 32'h20080005, 32'h00000005, 1'b0, 32'h00000003, 32'hffff00f0, 1'b1, `ALU_ADDU, 1'b0, 32'h00000000, 32'hffff00f0, 32'h00000005, 5'h08, 32'h00000005, 32'h00000005, 32'h00000000, 32'h00000005, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #16 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400040, 32'h290b000a, 32'h00000001, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_SLT, 1'b0, 32'h00000005, 32'h00000000, 32'h00000001, 5'h0b, 32'h00000001, 32'h0000000a, 32'h00000005, 32'h0000000a, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #17 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400044, 32'h2d0b0004, 32'h00000000, 1'b0, 32'h00000000, 32'h00000001, 1'b1, `ALU_SLTU, 1'b1, 32'h00000005, 32'h00000001, 32'h00000000, 5'h0b, 32'h00000000, 32'h00000004, 32'h00000005, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #18 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400048, 32'h2008fffb, 32'hfffffffb, 1'b0, 32'hxxxxxxxx, 32'h00000005, 1'b1, `ALU_ADDU, 1'b0, 32'h00000000, 32'h00000005, 32'hfffffffb, 5'h08, 32'hfffffffb, 32'hfffffffb, 32'h00000000, 32'hfffffffb, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #19 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040004c, 32'h2d0b0005, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_SLTU, 1'b1, 32'hfffffffb, 32'h00000000, 32'h00000000, 5'h0b, 32'h00000000, 32'h00000005, 32'hfffffffb, 32'h00000005, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #20 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400050, 32'h20080014, 32'h00000014, 1'b0, 32'hxxxxxxxx, 32'hfffffffb, 1'b1, `ALU_ADDU, 1'b0, 32'h00000000, 32'hfffffffb, 32'h00000014, 5'h08, 32'h00000014, 32'h00000014, 32'h00000000, 32'h00000014, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #21 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400054, 32'h2d0bffff, 32'h00000001, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_SLTU, 1'b0, 32'h00000014, 32'h00000000, 32'h00000001, 5'h0b, 32'h00000001, 32'hffffffff, 32'h00000014, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #22 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400058, 32'h3c0b1010, 32'h10100000, 1'b0, 32'h00000000, 32'h00000001, 1'b1, `ALU_LUI, 1'b0, 32'h00000000, 32'h00000001, 32'h10100000, 5'h0b, 32'h10100000, 32'h00001010, 32'h00000010, 32'h00001010, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10};
         #23 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040005c, 32'h356b1010, 32'h10101010, 1'b0, 32'hxxxxxxxx, 32'h10100000, 1'b1, `ALU_OR, 1'b0, 32'h10100000, 32'h10100000, 32'h10101010, 5'h0b, 32'h10101010, 32'h00001010, 32'h10100000, 32'h00001010, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #24 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400060, 32'h3c0c0101, 32'h01010000, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, `ALU_LUI, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h01010000, 5'h0c, 32'h01010000, 32'h00000101, 32'h00000010, 32'h00000101, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10};
         #25 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400064, 32'h218c1010, 32'h01011010, 1'b0, 32'hxxxxxxxx, 32'h01010000, 1'b1, `ALU_ADDU, 1'b0, 32'h01010000, 32'h01010000, 32'h01011010, 5'h0c, 32'h01011010, 32'h00001010, 32'h01010000, 32'h00001010, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #26 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400068, 32'h318dffff, 32'h00001010, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, `ALU_AND, 1'b0, 32'h01011010, 32'hxxxxxxxx, 32'h00001010, 5'h0d, 32'h00001010, 32'h0000ffff, 32'h01011010, 32'h0000ffff, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #27 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040006c, 32'h39adffff, 32'h0000efef, 1'b0, 32'hxxxxxxxx, 32'h00001010, 1'b1, `ALU_XOR, 1'b0, 32'h00001010, 32'h00001010, 32'h0000efef, 5'h0d, 32'h0000efef, 32'h0000ffff, 32'h00001010, 32'h0000ffff, 2'b00, 2'b01, 1'b0, 1'b1, 2'b01, 1'b0, 2'b00};
         #28 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400070, 32'h016c6824, 32'h00001010, 1'b0, 32'hxxxxxxxx, 32'h01011010, 1'b1, `ALU_AND, 1'b0, 32'h10101010, 32'h01011010, 32'h00001010, 5'h0d, 32'h00001010, 32'h00006824, 32'h10101010, 32'h01011010, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #29 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400074, 32'h016c6825, 32'h11111010, 1'b0, 32'hxxxxxxxx, 32'h01011010, 1'b1, `ALU_OR, 1'b0, 32'h10101010, 32'h01011010, 32'h11111010, 5'h0d, 32'h11111010, 32'h00006825, 32'h10101010, 32'h01011010, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #30 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400078, 32'h016c6826, 32'h11110000, 1'b0, 32'h00000000, 32'h01011010, 1'b1, `ALU_XOR, 1'b0, 32'h10101010, 32'h01011010, 32'h11110000, 5'h0d, 32'h11110000, 32'h00006826, 32'h10101010, 32'h01011010, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #31 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040007c, 32'h016c6827, 32'heeeeefef, 1'b0, 32'hxxxxxxxx, 32'h01011010, 1'b1, `ALU_NOR, 1'b0, 32'h10101010, 32'h01011010, 32'heeeeefef, 5'h0d, 32'heeeeefef, 32'h00006827, 32'h10101010, 32'h01011010, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #32 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400080, 32'h3c011001, 32'h10010000, 1'b0, 32'h00000000, 32'hxxxxxxxx, 1'b1, `ALU_SLL, 1'b0, 32'h00000000, 32'hxxxxxxxx, 32'h10010000, 5'h01, 32'h10010000, 32'h00001001, 32'h00000010, 32'h00001001, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10};
         #33 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400084, 32'h00200821, 32'h10010000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_ADDU, 1'b0, 32'h10010000, 32'h00000000, 32'h10010000, 5'h01, 32'h10010000, 32'h00000821, 32'h10010000, 32'h00000000, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #34 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400088, 32'h8c240004, 32'h10010004, 1'b0, 32'h00000003, 32'hxxxxxxxx, 1'b1, `ALU_ADDU, 1'b0, 32'h10010000, 32'hxxxxxxxx, 32'h10010004, 5'h04, 32'h00000003, 32'h00000004, 32'h10010000, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #35 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040008c, 32'h20840002, 32'h00000005, 1'b0, 32'h00000003, 32'h00000003, 1'b1, `ALU_ADDU, 1'b0, 32'h00000003, 32'h00000003, 32'h00000005, 5'h04, 32'h00000005, 32'h00000002, 32'h00000003, 32'h00000002, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #36 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400090, 32'h2484fffe, 32'h00000003, 1'b0, 32'h00000000, 32'h00000005, 1'b1, `ALU_ADDU, 1'b0, 32'h00000005, 32'h00000005, 32'h00000003, 5'h04, 32'h00000003, 32'hfffffffe, 32'h00000005, 32'hfffffffe, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #37 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400094, 32'h0c10002a, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, `ALU_XXX, 1'bx, 32'h00000000, 32'hxxxxxxxx, 32'hxxxxxxxx, 5'h1f, 32'h00400098, 32'h0000002a, 32'hxxxxxxxx, 32'hxxxxxxxx, 2'b10, 2'b10, 1'bx, 1'bx, 2'b00, 1'b0, 2'bxx};
         #38 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000a8, 32'h23bdfff8, 32'h100100f8, 1'b0, 32'hxxxxxxxx, 32'h10010100, 1'b1, `ALU_ADDU, 1'b0, 32'h10010100, 32'h10010100, 32'h100100f8, 5'h1d, 32'h100100f8, 32'hfffffff8, 32'h10010100, 32'hfffffff8, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #39 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000ac, 32'hafbf0004, 32'h100100fc, 1'b1, 32'hxxxxxxxx, 32'h00400098, 1'b0, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h00400098, 32'h100100fc, 5'hxx, 32'hxxxxxxxx, 32'h00000004, 32'h100100f8, 32'h00000004, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #40 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b0, 32'hafa40000, 32'h100100f8, 1'b1, 32'hxxxxxxxx, 32'h00000003, 1'b0, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h00000003, 32'h100100f8, 5'hxx, 32'hxxxxxxxx, 32'h00000000, 32'h100100f8, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #41 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b4, 32'h28880002, 32'h00000000, 1'b0, 32'h00000000, 32'h00000014, 1'b1, `ALU_SLT, 1'b1, 32'h00000003, 32'h00000014, 32'h00000000, 5'h08, 32'h00000000, 32'h00000002, 32'h00000003, 32'h00000002, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #42 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b8, 32'h11000002, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b0, `ALU_SUBU, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'h00000002, 32'h00000000, 32'h00000000, 2'b01, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #43 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000c4, 32'h2084ffff, 32'h00000002, 1'b0, 32'h00000000, 32'h00000003, 1'b1, `ALU_ADDU, 1'b0, 32'h00000003, 32'h00000003, 32'h00000002, 5'h04, 32'h00000002, 32'hffffffff, 32'h00000003, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #44 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000c8, 32'h0c10002a, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, `ALU_XXX, 1'bx, 32'h00000000, 32'hxxxxxxxx, 32'hxxxxxxxx, 5'h1f, 32'h004000cc, 32'h0000002a, 32'hxxxxxxxx, 32'hxxxxxxxx, 2'b10, 2'b10, 1'bx, 1'bx, 2'b00, 1'b0, 2'bxx};
         #45 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000a8, 32'h23bdfff8, 32'h100100f0, 1'b0, 32'hxxxxxxxx, 32'h100100f8, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h100100f8, 32'h100100f0, 5'h1d, 32'h100100f0, 32'hfffffff8, 32'h100100f8, 32'hfffffff8, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #46 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000ac, 32'hafbf0004, 32'h100100f4, 1'b1, 32'hxxxxxxxx, 32'h004000cc, 1'b0, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h004000cc, 32'h100100f4, 5'hxx, 32'hxxxxxxxx, 32'h00000004, 32'h100100f0, 32'h00000004, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #47 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b0, 32'hafa40000, 32'h100100f0, 1'b1, 32'hxxxxxxxx, 32'h00000002, 1'b0, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h00000002, 32'h100100f0, 5'hxx, 32'hxxxxxxxx, 32'h00000000, 32'h100100f0, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #48 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b4, 32'h28880002, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_SLT, 1'b1, 32'h00000002, 32'h00000000, 32'h00000000, 5'h08, 32'h00000000, 32'h00000002, 32'h00000002, 32'h00000002, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #49 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b8, 32'h11000002, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b0, `ALU_SUBU, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'h00000002, 32'h00000000, 32'h00000000, 2'b01, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #50 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000c4, 32'h2084ffff, 32'h00000001, 1'b0, 32'h00000000, 32'h00000002, 1'b1, `ALU_ADDU, 1'b0, 32'h00000002, 32'h00000002, 32'h00000001, 5'h04, 32'h00000001, 32'hffffffff, 32'h00000002, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #51 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000c8, 32'h0c10002a, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b1, `ALU_XXX, 1'bx, 32'h00000000, 32'hxxxxxxxx, 32'hxxxxxxxx, 5'h1f, 32'h004000cc, 32'h0000002a, 32'hxxxxxxxx, 32'hxxxxxxxx, 2'b10, 2'b10, 1'bx, 1'bx, 2'b00, 1'b0, 2'bxx};
         #52 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000a8, 32'h23bdfff8, 32'h100100e8, 1'b0, 32'hxxxxxxxx, 32'h100100f0, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h100100f0, 32'h100100e8, 5'h1d, 32'h100100e8, 32'hfffffff8, 32'h100100f0, 32'hfffffff8, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #53 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000ac, 32'hafbf0004, 32'h100100ec, 1'b1, 32'hxxxxxxxx, 32'h004000cc, 1'b0, `ALU_ADDU, 1'b0, 32'h100100e8, 32'h004000cc, 32'h100100ec, 5'hxx, 32'hxxxxxxxx, 32'h00000004, 32'h100100e8, 32'h00000004, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #54 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b0, 32'hafa40000, 32'h100100e8, 1'b1, 32'hxxxxxxxx, 32'h00000001, 1'b0, `ALU_ADDU, 1'b0, 32'h100100e8, 32'h00000001, 32'h100100e8, 5'hxx, 32'hxxxxxxxx, 32'h00000000, 32'h100100e8, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #55 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b4, 32'h28880002, 32'h00000001, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_SLT, 1'b0, 32'h00000001, 32'h00000000, 32'h00000001, 5'h08, 32'h00000001, 32'h00000002, 32'h00000001, 32'h00000002, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #56 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000b8, 32'h11000002, 32'h00000001, 1'b0, 32'h00000000, 32'h00000000, 1'b0, `ALU_SUBU, 1'b0, 32'h00000001, 32'h00000000, 32'h00000001, 5'hxx, 32'hxxxxxxxx, 32'h00000002, 32'h00000001, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #57 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000bc, 32'h00041020, 32'h00000001, 1'b0, 32'h00000000, 32'h00000001, 1'b1, `ALU_ADDU, 1'b0, 32'h00000000, 32'h00000001, 32'h00000001, 5'h02, 32'h00000001, 32'h00001020, 32'h00000000, 32'h00000001, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #58 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000c0, 32'h08100038, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b0, `ALU_XXX, 1'bx, 32'h00000000, 32'hxxxxxxxx, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000038, 32'hxxxxxxxx, 32'hxxxxxxxx, 2'b10, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
         #59 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e0, 32'h8fbf0004, 32'h100100ec, 1'b0, 32'h004000cc, 32'h004000cc, 1'b1, `ALU_ADDU, 1'b0, 32'h100100e8, 32'h004000cc, 32'h100100ec, 5'h1f, 32'h004000cc, 32'h00000004, 32'h100100e8, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #60 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e4, 32'h23bd0008, 32'h100100f0, 1'b0, 32'h00000002, 32'h100100e8, 1'b1, `ALU_ADDU, 1'b0, 32'h100100e8, 32'h100100e8, 32'h100100f0, 5'h1d, 32'h100100f0, 32'h00000008, 32'h100100e8, 32'h00000008, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #61 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e8, 32'h03e00008, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b0, `ALU_XXX, 1'bx, 32'h004000cc, 32'h00000000, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000008, 32'hxxxxxxxx, 32'h0000000X, 2'b11, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
         #62 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000cc, 32'h8fa40000, 32'h100100f0, 1'b0, 32'h00000002, 32'h00000001, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h00000001, 32'h100100f0, 5'h04, 32'h00000002, 32'h00000000, 32'h100100f0, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #63 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d0, 32'h00441020, 32'h00000003, 1'b0, 32'h00000000, 32'h00000002, 1'b1, `ALU_ADDU, 1'b0, 32'h00000001, 32'h00000002, 32'h00000003, 5'h02, 32'h00000003, 32'h00001020, 32'h00000001, 32'h00000002, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #64 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d4, 32'h00441021, 32'h00000005, 1'b0, 32'h00000003, 32'h00000002, 1'b1, `ALU_ADDU, 1'b0, 32'h00000003, 32'h00000002, 32'h00000005, 5'h02, 32'h00000005, 32'h00001021, 32'h00000003, 32'h00000002, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #65 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d8, 32'h2042ffff, 32'h00000004, 1'b0, 32'h00000003, 32'h00000005, 1'b1, `ALU_ADDU, 1'b0, 32'h00000005, 32'h00000005, 32'h00000004, 5'h02, 32'h00000004, 32'hffffffff, 32'h00000005, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #66 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000dc, 32'h1400fff9, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b0, `ALU_SUBU, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'hfffffff9, 32'h00000000, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #67 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e0, 32'h8fbf0004, 32'h100100f4, 1'b0, 32'h004000cc, 32'h004000cc, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h004000cc, 32'h100100f4, 5'h1f, 32'h004000cc, 32'h00000004, 32'h100100f0, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #68 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e4, 32'h23bd0008, 32'h100100f8, 1'b0, 32'h00000003, 32'h100100f0, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f0, 32'h100100f0, 32'h100100f8, 5'h1d, 32'h100100f8, 32'h00000008, 32'h100100f0, 32'h00000008, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #69 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e8, 32'h03e00008, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b0, `ALU_XXX, 1'bx, 32'h004000cc, 32'h00000000, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000008, 32'hxxxxxxxx, 32'h0000000X, 2'b11, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
         #70 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000cc, 32'h8fa40000, 32'h100100f8, 1'b0, 32'h00000003, 32'h00000002, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h00000002, 32'h100100f8, 5'h04, 32'h00000003, 32'h00000000, 32'h100100f8, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #70.5 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000cc, 32'h8fa40000, 32'h100100f8, 1'b0, 32'h00000003, 32'h00000002, 1'b0, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h00000002, 32'h100100f8, 5'h04, 32'h00000003, 32'h00000000, 32'h100100f8, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #75.5 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000cc, 32'h8fa40000, 32'h100100f8, 1'b0, 32'h00000003, 32'h00000002, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h00000002, 32'h100100f8, 5'h04, 32'h00000003, 32'h00000000, 32'h100100f8, 32'h00000000, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #76 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d0, 32'h00441020, 32'h00000007, 1'b0, 32'h00000003, 32'h00000003, 1'b1, `ALU_ADDU, 1'b0, 32'h00000004, 32'h00000003, 32'h00000007, 5'h02, 32'h00000007, 32'h00001020, 32'h00000004, 32'h00000003, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #77 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d4, 32'h00441021, 32'h0000000a, 1'b0, 32'hxxxxxxxx, 32'h00000003, 1'b1, `ALU_ADDU, 1'b0, 32'h00000007, 32'h00000003, 32'h0000000a, 5'h02, 32'h0000000a, 32'h00001021, 32'h00000007, 32'h00000003, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #78 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000d8, 32'h2042ffff, 32'h00000009, 1'b0, 32'hxxxxxxxx, 32'h0000000a, 1'b1, `ALU_ADDU, 1'b0, 32'h0000000a, 32'h0000000a, 32'h00000009, 5'h02, 32'h00000009, 32'hffffffff, 32'h0000000a, 32'hffffffff, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #79 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000dc, 32'h1400fff9, 32'h00000000, 1'b0, 32'h00000000, 32'h00000000, 1'b0, `ALU_SUBU, 1'b1, 32'h00000000, 32'h00000000, 32'h00000000, 5'hxx, 32'hxxxxxxxx, 32'hfffffff9, 32'h00000000, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b0, 2'bxx, 1'b0, 2'b00};
         #80 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e0, 32'h8fbf0004, 32'h100100fc, 1'b0, 32'h00400098, 32'h004000cc, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h004000cc, 32'h100100fc, 5'h1f, 32'h00400098, 32'h00000004, 32'h100100f8, 32'h00000004, 2'b00, 2'b01, 1'b1, 1'b1, 2'b10, 1'b0, 2'b00};
         #81 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e4, 32'h23bd0008, 32'h10010100, 1'b0, 32'h00000000, 32'h100100f8, 1'b1, `ALU_ADDU, 1'b0, 32'h100100f8, 32'h100100f8, 32'h10010100, 5'h1d, 32'h10010100, 32'h00000008, 32'h100100f8, 32'h00000008, 2'b00, 2'b01, 1'b1, 1'b1, 2'b01, 1'b0, 2'b00};
         #82 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000e8, 32'h03e00008, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'h00000000, 1'b0, `ALU_XXX, 1'bx, 32'h00400098, 32'h00000000, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000008, 32'hxxxxxxxx, 32'h0000000X, 2'b11, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
         #83 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h00400098, 32'h3c011001, 32'h10010000, 1'b0, 32'h00000000, 32'h10010000, 1'b1, `ALU_SLL, 1'b0, 32'h00000000, 32'h10010000, 32'h10010000, 5'h01, 32'h10010000, 32'h00001001, 32'h00000010, 32'h00001001, 2'b00, 2'b01, 1'bx, 1'b1, 2'b01, 1'b0, 2'b10};
         #84 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h0040009c, 32'h00200821, 32'h10010000, 1'b0, 32'h00000000, 32'h00000000, 1'b1, `ALU_ADDU, 1'b0, 32'h10010000, 32'h00000000, 32'h10010000, 5'h01, 32'h10010000, 32'h00000821, 32'h10010000, 32'h00000000, 2'b00, 2'b00, 1'bx, 1'b0, 2'b01, 1'b0, 2'b00};
         #85 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000a0, 32'hac220000, 32'h10010000, 1'b1, 32'h00000000, 32'h00000009, 1'b0, `ALU_ADDU, 1'b0, 32'h10010000, 32'h00000009, 32'h10010000, 5'hxx, 32'hxxxxxxxx, 32'h00000000, 32'h10010000, 32'h00000000, 2'b00, 2'bxx, 1'b1, 1'b1, 2'bxx, 1'b1, 2'b00};
         #86 {pc, instr, mem_addr, mem_wr, mem_readdata, mem_writedata, werf, alufn, Z, ReadData1, ReadData2, alu_result, reg_writeaddr, reg_writedata, signImm, aluA, aluB, pcsel, wasel, sext, bsel, wdsel, wr, asel} <= {32'h004000a4, 32'h08100029, 32'hxxxxxxxx, 1'b0, 32'hxxxxxxxx, 32'hxxxxxxxx, 1'b0, `ALU_XXX, 1'bx, 32'h00000000, 32'hxxxxxxxx, 32'hxxxxxxxx, 5'hxx, 32'hxxxxxxxx, 32'h00000029, 32'hxxxxxxxx, 32'hxxxxxxxx, 2'b10, 2'bxx, 1'bx, 1'bx, 2'bxx, 1'b0, 2'bxx};
      join
   end
endmodule