`timescale 1ns / 1ps

module uart_tx(
  input 					 tx_clk_i,
	input 					 tx_start_i,
  input 					 rst_i, 
  input 		 [7:0] tx_data_i,
  input 		 [3:0] length_i,
  input						 parity_type_i,
	input						 parity_en_i,
  input						 stop2_i,
  output reg 			 tx_o,
	output reg 			 tx_done_o,
	output reg 			 tx_err_o
);
    
logic [7:0] tx_reg;    

logic start_b 	 = 0;
logic stop_b  	 = 1;
logic parity_bit = 0;

integer count = 0;
    
typedef enum bit [2:0] {
	IDLE 						= 0, 
	START_BIT 			= 1, 
	SEND_DATA 			= 2, 
	SEND_PARITY 		= 3, 
	SEND_FIRST_STOP = 4, 
	SEND_SEC_STOP 	= 5, 
	DONE 						= 6 } state_type;

state_type state 			= IDLE; 
state_type next_state = IDLE;
    
always @(posedge tx_clk_i) begin
  if (parity_type_i == 1'b1) begin //! odd
    case (length_i)
      4'd5    : parity_bit = ^(tx_data_i[4:0]); 
      4'd6    : parity_bit = ^(tx_data_i[5:0]); 
      4'd7    : parity_bit = ^(tx_data_i[6:0]);
      4'd8    : parity_bit = ^(tx_data_i[7:0]);
      default : parity_bit = 1'b0; 
    endcase
  end else begin
    case(length_i)
      4'd5    : parity_bit = ~^(tx_data_i[4:0]);
      4'd6    : parity_bit = ~^(tx_data_i[5:0]); 
      4'd7    : parity_bit = ~^(tx_data_i[6:0]);
      4'd8    : parity_bit = ~^(tx_data_i[7:0]);
      default : parity_bit = 1'b0; 
    endcase
  end 
end
    
always @(posedge tx_clk_i) begin
  if (rst_i)
    state <= IDLE;
  else
    state <= next_state;
end
        
always @(*) begin
	case (state)
    IDLE:
      begin
        tx_done_o     = 1'b0; 
        tx_o          = 1'b1;
        tx_reg        = {(8){1'b0}}; 
        tx_err_o      = 0;

        if (tx_start_i) 
          next_state = START_BIT;
        else
          next_state = IDLE;
      end
    START_BIT: 
      begin
        tx_reg        = tx_data_i;
        tx_o          = start_b;
        next_state    = SEND_DATA;
      end          
    SEND_DATA:
      begin
        if (count < (length_i - 1)) begin
          next_state = SEND_DATA;
          tx_o       = tx_reg[count];
				end else if (parity_en_i) begin
          tx_o         = tx_reg[count];
          next_state   = SEND_PARITY;
        end else begin
          tx_o         = tx_reg[count];
          next_state   = SEND_FIRST_STOP;
        end
      end  
    SEND_PARITY: 
      begin
        tx_o          = parity_bit;
        next_state    = SEND_FIRST_STOP;
      end
    SEND_FIRST_STOP: 
      begin
      	tx_o = stop_b;
       	if (stop2_i)
        	next_state = SEND_SEC_STOP;       
        else
        	next_state = DONE;
      end
    SEND_SEC_STOP: 
      begin
        tx_o        = stop_b;
        next_state  = DONE;
      end
   	DONE:
    	begin
      	tx_done_o   = 1'b1;
      	next_state  = IDLE;
    	end
    default: next_state  = IDLE;
  endcase
end
 
always @(posedge tx_clk_i) begin
	case(state)
  	IDLE						: count <= 0;
  	START_BIT				: count <= 0;
  	SEND_DATA				: count <= count + 1;
  	SEND_PARITY			: count <= 0;
  	SEND_FIRST_STOP : count <= 0; 
  	SEND_SEC_STOP		: count <= 0;
  	DONE						: count <= 0;
    default					: count <= 0;
 	endcase
end
    
endmodule
