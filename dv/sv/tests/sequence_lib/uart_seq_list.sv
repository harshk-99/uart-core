`ifndef UART_SEQ_LIST
`define UART_SEQ_LIST

package uart_seq_list;

import uvm_pkg::*;
`include "uvm_macros.svh"

import uart_agent_pkg::*;
import uart_env_pkg::*;

`include "uart_seq_cfg.sv"
`include "uart_seq.sv"
`include "rand_baud_sequence.sv"
`include "rand_baud_with_stop_sequence.sv"
`include "rand_baud_len5p_sequence.sv"
`include "rand_baud_len6p_sequence.sv"
`include "rand_baud_len7p_sequence.sv"
`include "rand_baud_len8p_sequence.sv"
`include "rand_baud_len5_sequence.sv"
`include "rand_baud_len6_sequence.sv"
`include "rand_baud_len7_sequence.sv"
`include "rand_baud_len8_sequence.sv"

endpackage 

`endif
