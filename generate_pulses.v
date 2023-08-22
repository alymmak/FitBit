`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module generate_pulses(
    input CLK,
    input fitbit_clock, 
    input START,
    input RESET, 
    
    output pulse,
    
    output [31:0] amtSteps,
    output reg [31:0] steps,
    input [1:0] MODE
    );
    
    
    reg pulseStep = 0;
    reg [31:0] amtTime = 0;  
    reg [31:0] count = 1;
    reg [31:0] pulse_check = 0; 

    assign amtSteps = count;
    assign pulse = pulseStep;

    always @ (posedge fitbit_clock)
    begin
        if (RESET | (~START))
            amtTime = 0;
        
        //hybrid mode
        if (MODE == 2'b11)   
            amtTime = amtTime + 1;
        else if(MODE == 2'b00)
            amtTime = 0;
        else if(MODE == 2'b01)
            amtTime = 0;
        else if(MODE == 2'b10)
            amtTime = 0;
            
    end
    
    always @(*)
    begin
        case(MODE)
            // walk 
            2'b00: count = 1562500;
            // jog 
            2'b01: count = 781250;
            // run 
            2'b10: count = 390625;

            //hybrid
            2'b11:
            begin
                //1 -20
                if (amtTime == 1)
                    count = 2500000;
                //2 -33
                else if (amtTime == 2)
                    count = 1515151;
                //3 -66
                else if (amtTime == 3)
                    count = 757575;
                //4 -27
                else if (amtTime == 4)
                    count = 1851851;
                //5 -70
                else if (amtTime == 5)
                    count = 714285;
                //6 -30
                else if (amtTime == 6)
                    count = 1666666;
                //7 -19
                else if (amtTime == 7)
                    count = 2631578;
                //8
                else if (amtTime == 9)
                    count = 1515151;
                //10th-73rd
                else if ((amtTime >= 10) && (amtTime <= 73))
                    count = 724637;
                //74th-79th
                else if ((amtTime >= 74) && (amtTime <= 79))
                    count = 147058;
                //80th-144th
                else if ((amtTime >= 79) && (amtTime <= 144))
                    count = 403225;
                //145th second onwards
                else
                    count = 0;
            end
        endcase
    end
    
    
    always @(posedge CLK) 
    begin
        if(pulse_check == count) 
        begin
            pulse_check = 1;
            pulseStep = ~pulseStep;
        end
        else if (RESET)
        begin
            pulse_check = 1;
            pulseStep = ~pulseStep;
        end
        else if (~START)
        begin
            pulse_check = 1;
        end
        
        

        //no steps should be zero
        else if (count != 0)
            pulse_check = pulse_check + 1;    
    end           
          
    always @ (posedge pulseStep)
    begin
        if (RESET)
            steps = 0;
        else 
            steps = steps + 1;
    end
    
    
endmodule