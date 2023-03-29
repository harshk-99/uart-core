//`ifndef UART_SEQ
//`define UART_SEQ

class uart_seq extends uvm_sequence #(uart_seq_item);

  `uvm_object_utils(uart_seq)
//  uart_seq_cfg cfg_m;

  function new(string name="uart_seq");
    super.new(name);
  endfunction

  virtual function bit get_opr_mode (uart_seq_item item);
    return (item.randomize() with {
      op inside {
        RAND_BAUD_1_STOP,
        RAND_LENGTH_1_STOP,
        LENGTH5WP,
        LENGTH6WP,
        LENGTH7WP,
        LENGTH8WP,
        LENGTH5WOP,
        LENGTH6WOP,
        LENGTH7WOP,
        LENGTH8WOP,
        RAND_BAUD_2_STOP,
        RAND_LENGTH_2_STOP
      };
    });
  endfunction

/*  virtual task pre_body;
    
    assert(uvm_config_db#(uart_seq_cfg)::get(m_sequencer, "", "uart_seq_cfg", cfg_m))
    else
      `uvm_fatal("UART_SEQ", "Unable to get UART seq config")
  endtask
*/
  virtual task body;
    
    uart_seq_item item;

    repeat (5) begin
      item = new;
      start_item(item);
      if (!get_opr_mode(item))
        `uvm_fatal("UART_SEQ", "Randomized Test Failed!")
      finish_item(item);
    end
  endtask
endclass

//`endif
