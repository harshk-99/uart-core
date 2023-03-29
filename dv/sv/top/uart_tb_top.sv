`ifndef UART_TB_TOP
`define UART_TB_TOP

// * --------------------------
// * Include Files
// * --------------------------

import uvm_pkg::*;
import uart_test_list::*;

`include "uvm_macros.svh"
`include "uart_interface.sv"

module uart_tb_top;

  // * ------------------------
  // * Instantiation
  // * ------------------------
  
  // * interface instantiate

  uart_interface uart_vif ();
  
  // * dut instantiate
  
  uart #(.VERIFICATION_MODE(1)) dut (
    .clk_i          (uart_vif.clk), 
    .rst_i          (uart_vif.rst), 
    .tx_start_i     (uart_vif.tx_start), 
    .rx_start_i     (uart_vif.rx_start), 
    .tx_data_i      (uart_vif.tx_data), 
    .baud_i         (uart_vif.baud), 
    .length_i       (uart_vif.length), 
    .parity_type_i  (uart_vif.parity_type), 
    .parity_en_i    (uart_vif.parity_en),
    .stop2_i        (uart_vif.stop2),
    .tx_done_o      (uart_vif.tx_done), 
    .rx_done_o      (uart_vif.rx_done), 
    .tx_err_o       (uart_vif.tx_err), 
    .rx_err_o       (uart_vif.rx_err), 
    .rx_out_o       (uart_vif.rx_out)
  );

  initial begin
    uart_vif.clk <= 0;
  end
 
  always #10 uart_vif.clk <= ~uart_vif.clk;

  // * At start of the simulation, set the interface handle as uvm_config object
  // * so the handle can be retrieved using get() method. 
  // * run_test accepts the name as argument

  initial begin
    uvm_config_db #(virtual uart_interface)::set(null, "*", "uart_interface", uart_vif);
  end


  initial begin 
    run_test("rand_baud_test");  // ! if the run_test is blank
                 // ! need to be specified by +UVM_TESTNAME
  end
  
  initial begin 
    $dumpvars;			       // ! dumps variables
    $dumpfile("dump.vcd"); // ! generates waveform
  end
endmodule

`endif
