`ifndef UART_INTERFACE
`define UART_INTERFACE

interface uart_interface;
    logic        clk;
    logic        rst;
    logic        tx_start;
    logic        rx_start;
    logic [7:0]  tx_data;
    logic [16:0] baud;
    logic [3:0]  length;
    logic        parity_type;
    logic        parity_en;
    logic        stop2;
    logic        tx_done;
    logic        rx_done;
    logic        tx_err;
    logic        rx_err;
    logic [7:0]  rx_out;

endinterface
`endif
