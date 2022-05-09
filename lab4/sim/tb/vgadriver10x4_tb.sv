// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : vgadriver10x4_tb.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//      Teste de Auto-verificacao
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps

module vgadriver10x4_tb();

   // Entradas
   logic clock;

   // Saidas
   wire [3:0] red;
   wire [3:0] green;
   wire [3:0] blue;
   wire hsync;
   wire vsync;
   wire avideo;
 
   // Instancia o Design Under Test (DUT)
   vgadriver DUT (.*);

   initial begin      // Produz o clock
      clock = 1;
      forever
         #10 clock = ~clock;
   end
   
   initial begin
      #4000 $finish;
   end
      
   // initial begin
   //   $monitor("#%05d {hsync, vsync, red, green, blue} <= {2'b%b%b, 4'd%d, 4'd%d, 4'd%d};", $time, hsync, vsync, red, green, blue);
   // end
   
   selfcheckDriver c();
   wire ERROR_hsync = (hsync != c.hsync)? 1'bx : 1'b0;
   wire ERROR_vsync = (vsync != c.vsync)? 1'bx : 1'b0;
   wire ERROR_red   = (red != c.red)? 1'bx : 1'b0;
   wire ERROR_green = (green != c.green)? 1'bx : 1'b0;
   wire ERROR_blue  = (blue != c.blue)? 1'bx : 1'b0;
   
endmodule


module selfcheckDriver();
   logic hsync, vsync;
   logic [3:0] red, green, blue;
   initial begin
      fork
      #0000 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #0020 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 0, 4'd 0};
      #0060 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 4, 4'd 0};
      #0100 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 3, 4'd 4, 4'd 0};
      #0140 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 4, 4'd 8, 4'd 0};
      #0180 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 5, 4'd 8, 4'd 0};
      #0220 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 6, 4'd12, 4'd 0};
      #0260 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 7, 4'd12, 4'd 0};
      #0300 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 8, 4'd 0, 4'd 0};
      #0340 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 9, 4'd 0, 4'd 0};
      #0380 {hsync, vsync, red, green, blue} <= {2'b11, 4'd10, 4'd 4, 4'd 0};
      #0420 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #0500 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #0540 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 1, 4'd 2};
      #0580 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 1, 4'd 2};
      #0620 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 5, 4'd 2};
      #0660 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 3, 4'd 5, 4'd 2};
      #0700 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 4, 4'd 9, 4'd 2};
      #0740 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 5, 4'd 9, 4'd 2};
      #0780 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 6, 4'd13, 4'd 2};
      #0820 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 7, 4'd13, 4'd 2};
      #0860 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 8, 4'd 1, 4'd 2};
      #0900 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 9, 4'd 1, 4'd 2};
      #0940 {hsync, vsync, red, green, blue} <= {2'b11, 4'd10, 4'd 5, 4'd 2};
      #0980 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #1060 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #1100 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 2, 4'd 4};
      #1140 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 2, 4'd 4};
      #1180 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 6, 4'd 4};
      #1220 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 3, 4'd 6, 4'd 4};
      #1260 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 4, 4'd10, 4'd 4};
      #1300 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 5, 4'd10, 4'd 4};
      #1340 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 6, 4'd14, 4'd 4};
      #1380 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 7, 4'd14, 4'd 4};
      #1420 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 8, 4'd 2, 4'd 4};
      #1460 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 9, 4'd 2, 4'd 4};
      #1500 {hsync, vsync, red, green, blue} <= {2'b11, 4'd10, 4'd 6, 4'd 4};
      #1540 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #1620 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #1660 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 3, 4'd 6};
      #1700 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 3, 4'd 6};
      #1740 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 7, 4'd 6};
      #1780 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 3, 4'd 7, 4'd 6};
      #1820 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 4, 4'd11, 4'd 6};
      #1860 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 5, 4'd11, 4'd 6};
      #1900 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 6, 4'd15, 4'd 6};
      #1940 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 7, 4'd15, 4'd 6};
      #1980 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 8, 4'd 3, 4'd 6};
      #2020 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 9, 4'd 3, 4'd 6};
      #2060 {hsync, vsync, red, green, blue} <= {2'b11, 4'd10, 4'd 7, 4'd 6};
      #2100 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #2180 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #2220 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 8};
      #2260 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 0, 4'd 8};
      #2300 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 4, 4'd 8};
      #2340 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 3, 4'd 4, 4'd 8};
      #2380 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 4, 4'd 8, 4'd 8};
      #2420 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 5, 4'd 8, 4'd 8};
      #2460 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 6, 4'd12, 4'd 8};
      #2500 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 7, 4'd12, 4'd 8};
      #2540 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 8, 4'd 0, 4'd 8};
      #2580 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 9, 4'd 0, 4'd 8};
      #2620 {hsync, vsync, red, green, blue} <= {2'b11, 4'd10, 4'd 4, 4'd 8};
      #2660 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #2740 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #2780 {hsync, vsync, red, green, blue} <= {2'b10, 4'd 0, 4'd 0, 4'd 0};
      #3220 {hsync, vsync, red, green, blue} <= {2'b00, 4'd 0, 4'd 0, 4'd 0};
      #3300 {hsync, vsync, red, green, blue} <= {2'b10, 4'd 0, 4'd 0, 4'd 0};
      #3340 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #3780 {hsync, vsync, red, green, blue} <= {2'b01, 4'd 0, 4'd 0, 4'd 0};
      #3860 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 0, 4'd 0, 4'd 0};
      #3940 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 1, 4'd 0, 4'd 0};
      #3980 {hsync, vsync, red, green, blue} <= {2'b11, 4'd 2, 4'd 4, 4'd 0};
      join
   end
endmodule
