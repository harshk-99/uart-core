`ifndef UART_SEQUENCER
`define UART_SEQUENCER

class uart_sequencer extends uvm_sequencer#(uart_seq_item);

  // * Register to factory
  `uvm_component_utils(uart_sequencer)

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------  
  

  function new(string name="uart_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass

`endif
