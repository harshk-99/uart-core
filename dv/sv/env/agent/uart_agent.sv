`ifndef UART_AGENT
`define UART_AGENT

`include "uart_sequencer.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"

//------------------------------------------------//
// create a custom class inherited from uvm_agent //
// regsister with factory and call new			  //
//------------------------------------------------//

class uart_agent extends uvm_agent;

  // * declare agent components
  
  uart_sequencer sqr;
  uart_driver	  dvr;
  uart_monitor	  mon;

  `uvm_component_utils(uart_agent) // ! regsiter to factory as component

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------
  
  function new(string name="uart_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  // * ------------------------------------------------------------------------
  // * Build Phase
  // * ------------------------------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = uart_sequencer::type_id::create("sqr", this);
    dvr	= uart_driver::type_id::create("dvr", this);
    mon	= uart_monitor::type_id::create("mon", this);
  endfunction

  // * ------------------------------------------------------------------------
  // * Connect Phase
  // * ------------------------------------------------------------------------
  
  function void connect_phase(uvm_phase phase);
    dvr.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass
`endif
