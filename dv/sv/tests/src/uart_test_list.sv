`ifndef UART_TEST_LIST
`define UART_TEST_LIST 

package uart_test_list;

import uvm_pkg::*;
`include "uvm_macros.svh"

 import uart_env_pkg::*;
 import uart_seq_list::*;

 //////////////////////////////////////////////////////////////////////////////
 // including uart test list
 //////////////////////////////////////////////////////////////////////////////

 `include "uart_base_test.sv"
 `include "uart_rand_baud_test.sv"
 `include "uart_rand_baud_with_stop_test.sv"
 `include "uart_rand_baud_len5_test.sv"
 `include "uart_rand_baud_len6_test.sv"
 `include "uart_rand_baud_len7_test.sv"
 `include "uart_rand_baud_len8_test.sv"
 `include "uart_rand_baud_len5p_test.sv"
 `include "uart_rand_baud_len6p_test.sv"
 `include "uart_rand_baud_len7p_test.sv"
 `include "uart_rand_baud_len8p_test.sv"
 
endpackage 

`endif
