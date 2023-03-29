`ifndef UART_RAND_BAUD_WITH_LENGTH_8_TEST
`define UART_RAND_BAUD_WITH_LENGTH_8_TEST

class rand_baud_len8_test extends base_test;
  `uvm_component_utils(rand_baud_test)

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    uart_seq::type_id::set_type_override(rand_baud_len8_sequence::type_id::get());
    super.build_phase(phase);
endfunction

endclass

`endif
