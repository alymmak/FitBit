`timescale 1ns / 1ps

module twosec_clk(fastclk, slowclk);
    input fastclk; //fast clock
    output reg slowclk; //slow clock

    reg[31:0] counter;

    initial begin
        counter = 0;
        slowclk = 0;
    end

    always @ (posedge fastclk)
    begin
    if(counter == 100000000) 
    begin
              counter <= 1;
              slowclk <= ~slowclk;
        end
    else 
    begin
              counter <= counter + 1;
        end
    end

endmodule
