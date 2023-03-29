`ifndef UART_BASE_TEST
`define UART_BASE_TEST

//---------------------------------------------------------------------//
// create custom class inheriting from uvm_test, register with factory //
// and call function new											                         //
// Use base test to extend other tests, to create test cases.		       //
//---------------------------------------------------------------------//

class base_test extends uvm_test;
  
  `uvm_component_utils(base_test) // ! Registering to factory for Re-usable test

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------  
  
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
// * Declare other environments and verification components and build them
  uart_env      env;
  uart_seq      seq;
  uart_seq_cfg  cnfg;

  // * ------------------------------------------------------------------------
  // * Build Phase
  // * ------------------------------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = uart_env::type_id::create("env", this);
    seq  = uart_seq::type_id::create("seq", this);

    //cnfg = uart_seq_cfg::type_id::create("cnfg", this);
    //uvm_config_db #(uart_seq_cfg)::set(this, "env*", "uart_seq_cfg", cnfg);
  endfunction

  // * ------------------------------------------------------------------------
  // * Run Phase
  // * ------------------------------------------------------------------------

// start virtual sequence
  virtual task run_phase(uvm_phase phase);
    // create and instantiate sequence
   phase.raise_objection(this);
    seq.start(env.agnt.sqr);
    uvm_top.print_topology();
   phase.drop_objection(this);
  endtask

endclass

`endif
