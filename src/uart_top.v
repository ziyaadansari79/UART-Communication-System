`timescale 1ns / 1ps

module uart_top(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output tx,
    output [7:0] data_out,
    output done_tx,
    output done_rx
);

wire tick;

baud_gen bg (
    .clk(clk),
    .rst(rst),
    .tick(tick)
);

uart_tx tx_unit (
    .clk(clk),
    .rst(rst),
    .start(start),
    .tick(tick),
    .data_in(data_in),
    .tx(tx),
    .done(done_tx)
);

uart_rx rx_unit (
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .rx(tx), // LOOPBACK
    .data_out(data_out),
    .done(done_rx)
);

endmodule