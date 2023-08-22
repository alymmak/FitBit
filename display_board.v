`timescale 1ns / 1ps

module display_board(input clk,
    input [6:0] in0,
    input [6:0] in1,
    input [6:0] in2,
    input [6:0] in3,
    output reg[3:0] an,
    output reg[6:0] sseg,
    output reg dp
);

    reg[1:0] state = 0;
    reg[1:0] next_state;
    
    always @(*) begin
        case(state)
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b11;
            2'b11: next_state = 2'b00;
        endcase
    end
    
    always @(*) begin
        case(state)
            2'b00: begin sseg = in0; dp = 1; end
            2'b01: begin sseg = in1; dp = 1; end
            2'b10: begin sseg = in2; dp = 1; end
            2'b11: begin sseg = in3; dp = 1; end
        endcase
    end
    
    always @(*) begin
        case(state)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
        endcase
    end
    
    always @(posedge clk) begin
        state <= next_state;
    end
endmodule
