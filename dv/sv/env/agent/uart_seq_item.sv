`ifndef UART_SEQ_ITEM
`define UART_SEQ_ITEM

typedef enum bit [3:0] {
  RAND_BAUD_1_STOP    = 0, 
  RAND_LENGTH_1_STOP  = 1, 
  LENGTH5WP           = 2, 
  LENGTH6WP           = 3, 
  LENGTH7WP           = 4, 
  LENGTH8WP           = 5, 
  LENGTH5WOP          = 6, 
  LENGTH6WOP          = 7, 
  LENGTH7WOP          = 8, 
  LENGTH8WOP          = 9,
  RAND_BAUD_2_STOP    = 11, 
  RAND_LENGTH_2_STOP  = 12 } oper_mode;

class uart_seq_item extends uvm_sequence_item;

  rand oper_mode    op;
  rand bit	        tx_start;
  rand bit	        rx_start;
  rand bit        	rst;
  rand logic [7:0]  tx_data;
  rand logic [16:0] baud;
  rand logic [3:0]  length;
  rand logic        parity_type;
  rand logic        parity_en;
  rand bit	        stop2;
       logic        tx_done;
       logic        rx_done;
       logic        tx_err;
       logic        rx_err;
       logic [7:0]  rx_out;
  
  `uvm_object_utils(uart_seq_item)
       
  // TODO: register to uvm object factory

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------  

  function new(string name="uart_seq_item");
  	super.new(name);
  endfunction

	constraint baud_c   {baud inside {4800,9600,14400,19200,38400,57600}; }
  constraint length_c {length inside {5,6,7,8}; }
endclass

`endif
