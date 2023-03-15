`timescale 1ns / 1ps

module uart_rx (
  input              rx_clk_i,
  input              rx_start_i,
  input              rst_i,
  input              rx_i,
  input        [3:0] length_i,
  input              parity_type_i,
  input              parity_en_i,
  input              stop2_i,
  output reg   [7:0] rx_out_o,
  output logic       rx_done_o,
  output logic       rx_error_o
);
    
logic       parity = 0;   
logic [7:0] datard = 0;
 
integer count      = 0;
integer bit_count  = 0;
 
typedef enum bit [2:0] {
  IDLE              = 0, 
  START_BIT         = 1, 
  RECV_DATA         = 2, 
  CHECK_PARITY      = 3, 
  CHECK_FIRST_STOP  = 4, 
  CHECK_SEC_STOP    = 5, 
  DONE              = 6} state_type;

state_type state      = IDLE;
state_type next_state = IDLE;

always @(posedge rx_clk_i) begin
  if (rst_i)
    state <= IDLE;
  else
    state <= next_state;
end

always @(*) begin
  case (state)
    IDLE:
      begin
        rx_done_o  = 0;
        rx_error_o = 0;
        if (rx_start_i && !rx_i)
          next_state = START_BIT;
        else
          next_state = IDLE;
      end
    START_BIT: 
      begin
        if (count == 7 && rx_i)
          next_state = IDLE;
        else if (count == 15)
          next_state = RECV_DATA;
        else
          next_state = START_BIT;
      end 
    RECV_DATA: 
      begin   
        if (count == 7)
          datard[7:0] = {rx_i, datard[7:1]};
        else if (count == 15 && bit_count == (length_i - 1)) begin
          case (length_i)
            5       : rx_out_o = datard[7:3];
            6       : rx_out_o = datard[7:2];
            7       : rx_out_o = datard[7:1];
            8       : rx_out_o = datard[7:0];
            default : rx_out_o = 8'h00;
          endcase
          
          if (parity_type_i)
            parity = ^datard;
          else
            parity  = ~^datard;                  

          if (parity_en_i)
            next_state = CHECK_PARITY;
          else
            next_state = CHECK_FIRST_STOP;
        end else
          next_state = RECV_DATA;
      end  
    CHECK_PARITY: 
      begin
        if (count == 7) begin
          if (rx_i == parity)
            rx_error_o = 1'b0;
          else
            rx_error_o = 1'b1;
        end else if (count == 15)
          next_state = CHECK_FIRST_STOP;
        else
          next_state = CHECK_PARITY;                        
      end       
    CHECK_FIRST_STOP: 
      begin
        if (count == 7) begin
          if (rx_i != 1'b1)
            rx_error_o = 1'b1;
          else
            rx_error_o = 1'b0;
        end else if (count == 15) begin
          if (stop2_i)
            next_state = CHECK_SEC_STOP;
          else
            next_state = DONE; 
        end
      end
    CHECK_SEC_STOP: 
      begin
        if (count == 7) begin
          if (rx_i != 1'b1)
            rx_error_o = 1'b1;
          else
            rx_error_o = 1'b0;
        end else if (count == 15)
          next_state = DONE; 
      end
    DONE:
      begin
        rx_done_o  = 1'b1;
        next_state = IDLE;
        rx_error_o = 1'b0;
      end    
  endcase
end
    
always @(posedge rx_clk_i) begin
  case (state)
    IDLE: 
      begin
        count     <= 0;
        bit_count <= 0;
      end
    START_BIT: 
      begin
        if(count < 15)
          count <= count + 1;
        else
          count <= 0;
      end
    RECV_DATA:
      begin
        if(count < 15)
          count <= count + 1;
        else begin
          count <= 0;
          bit_count <= bit_count + 1;
        end
      end  
    CHECK_PARITY:
      begin
        if(count < 15)
          count <= count + 1;
        else
          count <= 0;   
      end       
    CHECK_FIRST_STOP: 
      begin
        if(count < 15)
          count <= count + 1;
        else
          count <= 0;
      end
    CHECK_SEC_STOP: 
      begin
        if(count < 15)
          count <= count + 1;
        else
          count <= 0; 
      end
    DONE:
      begin
        count     <= 0;
        bit_count <= 0;
      end    
  endcase
end

endmodule
