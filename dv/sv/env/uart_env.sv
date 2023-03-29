`ifndef UART_ENVIRONMENT
`define UART_ENVIRONMENT

//----------------------------------------------//
// create a custom class inherited from uvm_env //
// regsister with factory and call new			    //
//----------------------------------------------//

class uart_env extends uvm_env;
  // * declare environmnet components

  uart_agent			                        agnt;
  uart_scoreboard	                        scrbd;
  
  `uvm_component_utils(uart_env)   // ! register to factory as component

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------
  
  function new (string name="uart_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // * ------------------------------------------------------------------------
  // * Build Phase
  // * ------------------------------------------------------------------------
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // * instantiate environment components

    agnt	= uart_agent::type_id::create("agnt", this);
    scrbd	= uart_scoreboard::type_id::create("scrbd", this);
    

  endfunction
  
  // * ------------------------------------------------------------------------
  // * Connect Phase
  // * ------------------------------------------------------------------------

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnt.mon.mon2sb_port.connect(scrbd.mon2sb_imp);
  endfunction
    
endclass
  
`endif
