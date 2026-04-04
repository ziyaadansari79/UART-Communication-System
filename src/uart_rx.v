`timescale 1ns / 1ps
module uart_rx(
    input clk,
    input rst,
    input tick,
    input rx,
    output reg [7:0] data_out,
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
        bit_index <= 0;
        done <= 0;
    end else begin
        case(state)

            IDLE: begin
                done <= 0;
                if (rx == 0) // detect start bit
                    state <= START;
            end

            START: begin
                if (tick) begin
                    state <= DATA;
                    bit_index <= 0;
                end
            end

            DATA: begin
                if (tick) begin
                    data_reg[bit_index] <= rx;
                    if (bit_index < 7)
                        bit_index <= bit_index + 1;
                    else
                        state <= STOP;
                end
            end

            STOP: begin
                if (tick) begin
                    data_out <= data_reg;
                    done <= 1;
                    state <= IDLE;
                end
            end

        endcase
    end
end

endmodule