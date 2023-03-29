`ifndef UART_SCOREBOARD
`define UART_SCOREBOARD

class uart_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(uart_scoreboard)

  uvm_analysis_imp#(uart_seq_item, uart_scoreboard) mon2sb_imp;
  uart_seq_item exp, res;
  uart_seq_item exp_fifo[$], res_fifo[$];
  bit error;

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------

  function new(string name="uart_scoreboard", uvm_component parent); 
    super.new(name, parent);
  endfunction

  // * ------------------------------------------------------------------------
  // * Build Phase
  // * ------------------------------------------------------------------------

  function void build_phase(uvm_phase phase); 
    super.build_phase(phase);
    mon2sb_imp = new("mon2sb_imp", this);
  endfunction

  // * ------------------------------------------------------------------------
  // * Connect Phase
  // * ------------------------------------------------------------------------

  function void connect_phase(uvm_phase phase); 
    super.connect_phase(phase);
  endfunction

  // * ------------------------------------------------------------------------
  // * Run Phase
  // * ------------------------------------------------------------------------

  virtual function void write(uart_seq_item item);
    `uvm_info("SCO", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d", item.baud, item.length, item.parity_type, item.parity_en, item.stop2, item.tx_data, item.rx_out), UVM_NONE);
    if(item.rst == 1'b1)
      `uvm_info("SCO", "System Reset", UVM_NONE)
    else if(item.tx_data == item.rx_out)
      `uvm_info("SCO", "Test Passed", UVM_NONE)
    else
      `uvm_info("SCO", "Test Failed", UVM_NONE)
    $display("----------------------------------------------------------------");
    endfunction

endclass
`endif
