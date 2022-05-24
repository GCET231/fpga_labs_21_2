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
	//////////////////////	Clock Input	 	/////////////////////////////////////// 
	input 	wire 			CLOCK_50, //	50 MHz
	//////////////////////	 Push Button   ///////////////////////////////////////
	input	 	wire [3:0]	KEY, //	Pushbutton[3:0]
	//////////////////////	7-SEG Display  ///////////////////////////////////////
	output 	wire [6:0]  HEX0, // Display de 7-segmentos (HEX0)
	output 	wire [6:0]  HEX1, // Display de 7-segmentos (HEX1)
	output 	wire [6:0]  HEX2, // Display de 7-segmentos (HEX2)
	output 	wire [6:0]  HEX3, // Display de 7-segmentos (HEX3)
	output 	wire [6:0]  HEX4, // Display de 7-segmentos (HEX4)
	output 	wire [6:0]  HEX5, // Display de 7-segmentos (HEX5)
	output 	wire [6:0]  HEX6, // Display de 7-segmentos (HEX6)
	output 	wire [6:0]  HEX7  // Display de 7-segmentos (HEX7)
);

	//--------------------------------------------------------------------------
	//	Sinais internos
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//	Instanciação do módulo
	//--------------------------------------------------------------------------
	stopwatch fsm (.CLOCK_50(CLOCK_50), .KEY(KEY), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Lógica de saída
	//--------------------------------------------------------------------------	
	
   //--------------------------------------------------------------------------	

endmodule
