`ifndef UART_AGENT_PKG
`define UART_AGENT_PKG

package uart_agent_pkg;

  import uvm_pkg::*;
 `include "uvm_macros.svh"

   //////////////////////////////////////////////////////////
   // include Agent components : driver,monitor,sequencer
   /////////////////////////////////////////////////////////

  `include "uart_seq_item.sv"
  `include "uart_sequencer.sv"
  `include "uart_driver.sv"
  `include "uart_monitor.sv"
  `include "uart_agent.sv"


endpackage

`endif
