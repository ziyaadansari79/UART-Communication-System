`timescale 1ns / 1ps
module uart_tx(
    input clk,
    input rst,
    input start,
    input tick,
    input [7:0] data_in,
    output reg tx,
    output reg done
);

reg [3:0] state;
reg [3:0] bit_index;
reg [7:0] data_reg;

parameter IDLE  = 0,
          START = 1,
          DATA  = 2,
          STOP  = 3;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        tx <= 1;
        done <= 0;
        bit_index <= 0;
    end else begin
        case(state)

    IDLE: begin
        tx <= 1;
        done <= 0;
        if (start) begin
            data_reg <= data_in;
            state <= START;
        end
    end

    START: begin
        if (tick) begin
            tx <= 0;
            state <= DATA;
            bit_index <= 0;
        end
    end

    DATA: begin
        if (tick) begin
            tx <= data_reg[bit_index];
            if (bit_index < 7)
                bit_index <= bit_index + 1;
            else
                state <= STOP;
        end
    end

    STOP: begin
        if (tick) begin
            tx <= 1;
            done <= 1;
            state <= IDLE;
        end
    end

endcase
    end
end

endmodule