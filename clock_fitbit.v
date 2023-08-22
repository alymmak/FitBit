`timescale 1ns / 1ps
module clock_fitbit(otherclk, slowclk);
    input otherclk; //fast clock
    output reg slowclk; //slow clock

    reg[27:0] counter;

    initial 
    begin
        counter = 0;
        slowclk = 0;
    end

    always @ (posedge otherclk)
    begin
    if(counter == 50000000) 
    begin
      counter <= 1;
      slowclk <= ~slowclk;
    end
    else begin
      counter <= counter + 1;
    end
end


endmodule