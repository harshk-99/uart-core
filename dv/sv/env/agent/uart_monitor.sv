// The user-defined monitor is extended from uvm_monitor, uvm_monitor is inherited by uvm_component
// A monitor is a passive entity that samples the DUT signals through the virtual interface and converts the signal level activity to the transaction level
// Monitor samples DUT signals but does not drive them
// The monitor should have an analysis port (TLM port) and a virtual interface handle that points to DUT signals.

`ifndef UART_MONITOR
`define UART_MONITOR

class uart_monitor extends uvm_monitor;

  `uvm_component_utils(uart_monitor)
  // * Declare virtual interface
  virtual uart_interface uart_vif;

  uvm_analysis_port #(uart_seq_item) mon2sb_port;
  // * Used as a place holder for sampled signal activity
  uart_seq_item tx_collected;

  // * ------------------------------------------------------------------------
  // * Constructor
  // * ------------------------------------------------------------------------  
    
  function new(string name="uart_monitor", uvm_component parent=null); 
      super.new(name, parent);
      tx_collected =  new();
      mon2sb_port = new("mon2sb_port", this);
  endfunction

  // * ------------------------------------------------------------------------
  // * Build Phase
  // * ------------------------------------------------------------------------

  function void build_phase(uvm_phase phase); 
      super.build_phase(phase);
      // * Connect interface to Virtual interface by using get method
      if(! uvm_config_db #(virtual uart_interface)::get(this, "", "uart_interface", uart_vif)) begin
          `uvm_fatal (get_type_name(), "Didnt get handle to virtual interface uart_vif");
      end
  endfunction

  // * ------------------------------------------------------------------------
  // * Run Phase
  // * ------------------------------------------------------------------------

  virtual task run_phase(uvm_phase phase); 
      // using the write method send the sampled transaction packet to the scoreboard
    forever begin
     collect_tx();
      mon2sb_port.write(tx_collected);
    end
  endtask

  task collect_tx();
    @(posedge uart_vif.clk)
    if (uart_vif.rst) begin
      tx_collected.rst = 1'b1;
      `uvm_info("MON", "SYSTEM RESET DETECTED", "UVM_NONE");
      tx_collected.print();
    end else begin
      @(posedge uart_vif.tx_done);
      tx_collected.rst         = 1'b0;
      tx_collected.tx_start    = uart_vif.tx_start;
      tx_collected.rx_start    = uart_vif.rx_start;
      tx_collected.tx_data     = uart_vif.tx_data;
      tx_collected.baud        = uart_vif.baud;
      tx_collected.length      = uart_vif.length;
      tx_collected.parity_type = uart_vif.parity_type;
      tx_collected.parity_en   = uart_vif.parity_en;
      tx_collected.stop2       = uart_vif.stop2;
      @(negedge uart_vif.rx_done);
      tx_collected.rx_out      = uart_vif.rx_out;
      `uvm_info("MON", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d", tx_collected.baud, tx_collected.length, tx_collected.parity_type, tx_collected.parity_en, tx_collected.stop2, tx_collected.tx_data, tx_collected.rx_out), UVM_NONE);
      tx_collected.print();
    end
  endtask
endclass

`endif
