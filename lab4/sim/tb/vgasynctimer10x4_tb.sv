// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : vgasynctimer10x4_tb.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//      Teste de Auto-verificacao
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module vgasynctimer10x4_tb();

   // Entradas
   reg clock;
   
   // Saidas
   wire hsync;
   wire vsync;
   wire activevideo;
   wire [3:0] x;
   wire [2:0] y;
 
   // Instancia o Design Under Verificatio (DUV)
   vgasynctimer DUT (.*);

   initial begin      // Produz o clock
      clock = 1;
      forever
         #10 clock = ~clock;
   end
   
   initial begin
      #4000 $finish;
   end
      
   // initial begin
   //   $monitor("#%04d {hsync, vsync, activevideo} <= 3'b%b%b%b;", $time, hsync, vsync, activevideo);
   // end
   
   selfcheckSync c();
   wire ERROR_hsync = (hsync != c.hsync)? 1'bx : 1'b0;
   wire ERROR_vsync = (vsync != c.vsync)? 1'bx : 1'b0;
   wire ERROR_activevideo = (activevideo != c.activevideo)? 1'bx : 1'b0;
 
endmodule


module selfcheckSync();
   reg hsync, vsync, activevideo;
   initial begin
      fork
      #0000 {hsync, vsync, activevideo} <= 3'b111;
      #0420 {hsync, vsync, activevideo} <= 3'b010;
      #0500 {hsync, vsync, activevideo} <= 3'b110;
      #0540 {hsync, vsync, activevideo} <= 3'b111;
      #0980 {hsync, vsync, activevideo} <= 3'b010;
      #1060 {hsync, vsync, activevideo} <= 3'b110;
      #1100 {hsync, vsync, activevideo} <= 3'b111;
      #1540 {hsync, vsync, activevideo} <= 3'b010;
      #1620 {hsync, vsync, activevideo} <= 3'b110;
      #1660 {hsync, vsync, activevideo} <= 3'b111;
      #2100 {hsync, vsync, activevideo} <= 3'b010;
      #2180 {hsync, vsync, activevideo} <= 3'b110;
      #2220 {hsync, vsync, activevideo} <= 3'b111;
      #2660 {hsync, vsync, activevideo} <= 3'b010;
      #2740 {hsync, vsync, activevideo} <= 3'b110;
      #2780 {hsync, vsync, activevideo} <= 3'b100;
      #3220 {hsync, vsync, activevideo} <= 3'b000;
      #3300 {hsync, vsync, activevideo} <= 3'b100;
      #3340 {hsync, vsync, activevideo} <= 3'b110;
      #3780 {hsync, vsync, activevideo} <= 3'b010;
      #3860 {hsync, vsync, activevideo} <= 3'b110;
      #3900 {hsync, vsync, activevideo} <= 3'b111;
      join
   end
endmodule
