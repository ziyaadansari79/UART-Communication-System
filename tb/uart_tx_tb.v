`timescale 1ns / 1ps

module uart_tx_tb;

reg clk;
reg rst;
reg start;
reg [7:0] data_in;
wire tx;
wire [7:0] data_out;
wire done_tx, done_rx;


uart_top uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),
    .tx(tx),
    .data_out(data_out),
    .done_tx(done_tx),
    .done_rx(done_rx)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    start = 0;
    data_in = 8'b10101010;

    #10 rst = 0;

    #10 start = 1;
    #10 start = 0;

    #1000 $finish;
end

endmodule