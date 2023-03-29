`ifndef UART_RAND_BAUD_WITH_STOP_SEQ
`define UART_RAND_BAUD_WITH_STOP_SEQ

class rand_baud_with_stop_sequence extends uart_seq;

// * Declaration of Sequence utils /////////////////////////////////////////////

`uvm_object_utils(rand_baud_with_stop_sequence)

// * Sequence constructor //////////////////////////////////////////////////////

function new(string name="rand_baud_with_stop_sequence");
    super.new(name);
endfunction

virtual function bit get_opr_mode(uart_seq_item item);
  return (item.randomize() with {
        op        == RAND_BAUD_2_STOP;
        length    == 8;
        rst       == 1'b0;
        tx_start  == 1'b1;
        rx_start  == 1'b1;
        parity_en == 1'b1;
        stop2     == 1'b1;
  });
endfunction

// * Body of sequence to send randomized transaction through ///////////////////

virtual task body;
  super.body();
endtask
endclass

`endif
