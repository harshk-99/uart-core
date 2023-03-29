`timescale 1ns / 1ns

module uart #(
  parameter VERIFICATION_MODE = 0,
  parameter SOC_COMPLIANT = 1,
  parameter BAUD = 9600,
  parameter LENGTH = 8,
  parameter PARITY_TYPE = 1,
  parameter PARITY_EN = 0,
	parameter STOP = 0
) (
	input 				clk_i, 
	input 				rst_i,
	input 			  tx_start_i,
	input 			  rx_start_i,
	input  [7:0]  tx_data_i,
	input  [7:0]  rx_data_i, //! external
	input  [16:0] baud_i,
	input  [3:0]  length_i,
	input 			  parity_type_i, 
	input 			  parity_en_i,
	input 			  stop2_i,
	output 			  tx_done_o,
	output        rx_done_o,
	output 			  tx_err_o,
	output 			  rx_err_o,
	output [7:0]  tx_data_o, //! external
	output [7:0]  rx_out_o
 );
 
 generate
	if (VERIFICATION_MODE == 1 || SOC_COMPLIANT == 1) begin: VERIFICATION_SOC
		wire tx_clk, rx_clk;
		wire tx_rx;

		clk_gen cg0 (
			.clk_i  	(clk_i),
			.rst_i  	(rst_i),
			.baud_i  	(baud_i),
			.tx_clk_o (tx_clk),
			.rx_clk_o (rx_clk)
		);

		uart_tx tx0 (
			.tx_clk_i   		(tx_clk),
			.tx_start_i   	(tx_start_i),
			.rst_i   				(rst_i), 
			.tx_data_i   		(tx_data_i),
			.length_i   		(length_i),
			.parity_type_i  (parity_type_i),
			.parity_en_i   	(parity_en_i),
			.stop2_i   			(stop2_i),
			.tx_o   				(tx_rx),
			.tx_done_o   		(tx_done_o),
			.tx_err_o   		(tx_err_o)
		);

		uart_rx rx0 (
			.rx_clk_i  			(rx_clk),
			.rx_start_i  		(rx_start_i),
			.rst_i  				(rst_i),
			.rx_i  					(tx_rx),
			.length_i  			(length_i),
			.parity_type_i  (parity_type_i),
			.parity_en_i  	(parity_en_i),
			.stop2_i  			(stop2_i),
			.rx_out_o  			(rx_out_o),
			.rx_done_o  		(rx_done_o),
			.rx_error_o  		(rx_err_o)
		);

	end else begin: BARE_METAL
		wire tx_clk, rx_clk;

		localparam TX_START = 1;
		localparam RX_START = 1;

		clk_gen cg0 (
			.clk_i  	(clk_i),
			.rst_i  	(rst_i),
			.baud_i  	(BAUD),
			.tx_clk_o (tx_clk),
			.rx_clk_o (rx_clk)
		);

		uart_tx tx0 (
			.tx_clk_i   		(tx_clk),
			.tx_start_i   	(TX_START),
			.rst_i   				(rst_i), 
			.tx_data_i   		(tx_data_i),
			.length_i   		(LENGTH),
			.parity_type_i  (PARITY_TYPE),
			.parity_en_i   	(PARITY_EN),
			.stop2_i   			(STOP),
			.tx_o   				(tx_data_o),
			.tx_done_o   		(),
			.tx_err_o   		()
		);

		uart_rx rx0 (
			.rx_clk_i  			(rx_clk),
			.rx_start_i  		(RX_START),
			.rst_i  				(rst_i),
			.rx_i  					(tx_data_o),
			.length_i  			(LENGTH),
			.parity_type_i  (PARITY_TYPE),
			.parity_en_i  	(PARITY_EN),
			.stop2_i  			(STOP),
			.rx_out_o  			(rx_out_o),
			.rx_done_o  		(),
			.rx_error_o  		()
		);
	end
endgenerate 
endmodule
