`ifndef UART_SEQ_CFG
`define UART_SEQ_CFG

class uart_seq_cfg extends uvm_object;

  `uvm_object_utils(uart_seq_cfg)

  rand int num_trans_m;

  constraint c_num_trans {
    num_trans_m inside {[1:50]};
  }

  function new(string name="uart_seq_cfg");
    super.new(name);
  endfunction : new
endclass
`endif
