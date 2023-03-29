`ifndef UART_DRIVER
`define UART_DRIVER

//-----------------------------------------------------------------------//
// create custom class inheriting from uvm_driver, register with factory //
// and call function new											                           //
// Use base class to extend other class, to create user defined classes  //
//-----------------------------------------------------------------------//

class uart_driver extends uvm_driver #(uart_seq_item);
  virtual uart_interface uart_vif;
  uart_seq_item item;

  `uvm_component_utils(uart_driver)

  function new(string name="uart_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
//------------------------------------------------//
// Declare handle and get them in build phase //
//------------------------------------------------//
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(! uvm_config_db #(virtual uart_interface)::get(this, "", "uart_interface", uart_vif)) begin
      `uvm_fatal (get_type_name(), "Didnt get handle to virtual interface uart_vif");
    end
  endfunction

//-------------------------------------------------------//
// Code the run phase 									                 //
// This is main piece of driver code					           //
// Transaction level objects pin wiggle at DUT interface //
//-------------------------------------------------------//
  
  virtual task run_phase (uvm_phase phase); 
    
    super.run_phase(phase);

    reset_dut();
    
    forever begin
    `uvm_info (get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_MEDIUM)
    seq_item_port.get_next_item(item);
    
    uart_vif.rst         <= 1'b0;
    uart_vif.tx_start    <= item.tx_start;
    uart_vif.rx_start    <= item.rx_start;
    uart_vif.tx_data     <= item.tx_data;
    uart_vif.baud        <= item.baud;
    uart_vif.length      <= item.length;
    uart_vif.parity_type <= item.parity_type;
    uart_vif.parity_en   <= item.parity_en;
    uart_vif.stop2       <= item.stop2;

    `uvm_info("DRV", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d", item.baud, item.length, item.parity_type, item.parity_en, item.stop2, item.tx_data), UVM_NONE);
    
    @(posedge uart_vif.clk); 
    @(posedge uart_vif.tx_done);
    @(negedge uart_vif.rx_done);
                             
    seq_item_port.item_done();

    end
  endtask

  task reset_dut(); 
    repeat(5) begin
      uart_vif.rst          <= 1'b1;  ///active high reset
      uart_vif.tx_start     <= 1'b0;
      uart_vif.rx_start     <= 1'b0;
      uart_vif.tx_data      <= 8'h00;
      uart_vif.baud         <= 16'h0;
      uart_vif.length       <= 4'h0;
      uart_vif.parity_type  <= 1'b0;
      uart_vif.parity_en    <= 1'b0;
      uart_vif.stop2        <= 1'b0;
      `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
      @(posedge uart_vif.clk);
    end
  endtask
endclass

`endif
