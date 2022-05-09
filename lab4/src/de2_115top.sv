// -----------------------------------------------------------------------------
// Universidade Federal do Recôncavo da Bahia
// -----------------------------------------------------------------------------
// Author : <seu nome aqui> <seu email>
// File   : de2_115top.sv
// Editor : Sublime Text 3, tab size (3)
// -----------------------------------------------------------------------------
// Module Purpose:
//    Top level interface from a DE2-115 FPGA board
// -----------------------------------------------------------------------------
`timescale 1ns / 1ps
`default_nettype none

module de2_115top
	(
		////////////////////	Clock Input	 	///////////////////////////////// 
		input  logic CLOCK_50,					//	50 MHz
		////////////////////	VGA DAC Output /////////////////////////////////	
		output logic VGA_CLK,					// Clock para o controlador VGA
		output logic VGA_SYNC_N,				// Sincronismo VGA
		output logic VGA_BLANK_N, 				// Ativação do vídeo
		output logic [7:0] VGA_R,				// Cor Red
		output logic [7:0] VGA_G,				// Cor Green
		output logic [7:0] VGA_B,				// Cor Blue
		////////////////////	VGA Display		/////////////////////////////////	
		output logic VGA_HS,						// Sincronismo horizontal
		output logic VGA_VS						// Sincronismo vertical
	);

	//--------------------------------------------------------------------------
	//	Sinais internos
	//--------------------------------------------------------------------------
	logic [3:0] red, green, blue;
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Instanciação do módulo
	//--------------------------------------------------------------------------
	vgadriver vgadriver_top (
		.clock (CLOCK_50),
		.red   (red),
		.green (green),
		.blue  (blue),
		.hsync (VGA_HS),
		.vsync (VGA_VS),
		.avideo(VGA_BLANK_N)
	);

	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Lógica de saída
	//--------------------------------------------------------------------------	
	assign VGA_R = {red,4'b0000};
	assign VGA_G = {green,4'b0000};
	assign VGA_B = {blue,4'b0000};

	assign VGA_CLK = CLOCK_50;
   //--------------------------------------------------------------------------	

endmodule
