`timescale 1ns / 1ps

module clock_display(
    input CLK,
    output clk_out
);

    reg[15:0] COUNT = 0;
    assign clk_out = COUNT[15];
    
    always @(posedge CLK) begin
        COUNT = COUNT + 1;
    end
endmodule
