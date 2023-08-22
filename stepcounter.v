`timescale 1ns / 1ps

module stepcounter(clk, twosec_clk, PULSE, RESET, step_out0, step_out1, step_out2, step_out3, SI, START, steps);
input clk, twosec_clk,PULSE, RESET, START;
input [31:0] steps;
output reg[3:0] step_out0;
output reg[3:0] step_out1;
output reg[3:0] step_out2;
output reg[3:0] step_out3;

output reg SI;

reg[15:0] count;
reg[15:0] display_value;
reg[10:0] miles;
reg[31:0] second_count;
reg[31:0] second_count2;
reg[31:0] high_act_count;
reg[15:0] temp_step;
reg[15:0] temp_step2;
reg[3:0] step32second;
reg[3:0] second32count;
reg[1:0] module_type;
reg[1:0] next_module;


initial 
begin
    SI <= 0;
    count <= 0;
    miles <= 0;
    display_value <= 0;
    second_count <= 0;
    second_count2 <= 0;
    high_act_count <= 0;
    temp_step <=0;
    temp_step2 <=0;
    second32count <= 0;
    step32second <= 0;
end

// steps and distance
always @(posedge PULSE)
begin
    if (!RESET) 
    begin
        count <= count + 1;
        if(count <= 9999)
        begin
            display_value <= count;
        end
        if(count > 9999)
        begin
            SI = 1;
        end
        if((count % 2048 == 0) && (count != 0))
        begin
            miles <= miles + 5;
        end
    end
    else
    begin
        if(RESET)
        begin
            count <= 0;
            SI <= 0;
            miles <= 0;
            display_value <= 0;
        end
    end
end

//always @(posedge onesec_clk)
//begin
//    if((!RESET) && (count != 0))
//    begin
//        if(second_count <= 9) //9 seconds
//        begin
//            if((count - temp_step) > 32)
//            begin
//                 temp_step <= count;
//                 second32count <= second32count + 1;
//            end
//        end
//        if(second_count > 9)
//        begin 
//            step32second <= second32count;
//        end
//        second_count <= second_count + 1;
//    end
//    else
//    begin
//        second_count <= 0;
//        temp_step <= 0; 
//        second32count <= 0;
//        step32second <= 0;
//    end
//end

// 32+ steps per second 
always @(posedge clk, posedge RESET)
begin
    if (!RESET && START)
    begin
        second_count = second_count + 1;
    end
    else if (!RESET)
    begin
        second_count = second_count;
    end
    else 
    begin
        second_count = 0;
    end
end

always @(posedge clk, posedge RESET)
begin
    if((second_count > 9) && (steps < 1562500) && (steps != 0) && (!RESET) && (second_count != 0) && START)
    begin
        second_count2 = temp_step2;
    end
    else if((second_count <= 9) && (steps < 1562500) && (steps != 0) && (!RESET) && (second_count != 0) && START) 
    begin
        temp_step2 = temp_step2 + 1; 
    end
    else if(RESET == 1) 
    begin
        temp_step2 = 0;
        second_count2 = 0;
    end
    else if(second_count == 0)
    begin
        temp_step2 = 0;
        second_count2 = 0;
    end
    else
    begin
        temp_step2 = temp_step2;
    end
end
    
// high activity
//always @(posedge CLK, posedge RESET)
//begin
//    if(!RESET)
//    begin
//        second_count2 <= second_count2 + 1;
//        if(second_count2 <= 60) //9 seconds
//        begin
//            if((count - temp_step2) >= 64)
//            begin
//                 temp_step2 <= count;
//                 high_act_count <= high_act_count + 1;
//            end
//        end
//        if(second_count2 > 60)
//        begin 
//            if(high_act_count >= 60)
//            begin
//                if((count - temp_step2) >= 64)
//                begin
//                end
//            end
//        end
//    end
//    else
//    begin
//        second_count2 <= 0;
//        temp_step2 <= 0; 
//        high_act_count <= 0;
//    end
//end

// high activity
always @(posedge clk, posedge RESET)
begin
    if(RESET == 1)
    begin
        temp_step = 0;
        high_act_count = 0;
    end
    else if(steps == 0)
    begin
        temp_step = 0;
    end
    else if(steps > 781250)
    begin
        temp_step = 0;
    end
    else if((steps <= 781250) && (temp_step < 60))
    begin
        temp_step = temp_step + 1;
    end
    else if(temp_step == 60)
    begin
        high_act_count = high_act_count + temp_step;
        temp_step = temp_step + 1;
    end
    else if(temp_step > 60)
    begin
        high_act_count = high_act_count + 1;
        temp_step = temp_step + 1;
    end
    else
    begin
        high_act_count = high_act_count;
    end
end

always @(*) 
    begin
        case(module_type)   
            2'b00: next_module = 2'b01;
            2'b01: next_module = 2'b10;
            2'b10: next_module = 2'b11;
            2'b11: next_module = 2'b00;
        endcase
    end    

always @(*)
    begin    
        case (module_type)
            2'b00: 
                begin
                    step_out0 = (display_value % 10);
                    step_out1 = ((display_value / 10) % 10);
                    step_out2 = ((display_value / 100) % 10);
                    step_out3 = ((display_value / 1000) % 10);
                end
            2'b01:
                begin
                    step_out0 = (miles % 10);
                    step_out1 = 0;
                    step_out2 = ((miles / 10) % 10);
                    step_out3 = ((miles / 100) % 10);                                  
                end
             
            2'b10:
                begin 
                    step_out0 = second_count2;
                    step_out1 = 0;
                    step_out2 = 0;
                    step_out3 = 0;
                end
        2'b11:
            begin
                step_out0 = (high_act_count % 10);
                step_out1 = ((high_act_count / 10) % 10);
                step_out2 = ((high_act_count / 100) % 10);
                step_out3 = ((high_act_count / 1000) % 10);
            end 
        default: 
            begin
                step_out0 = 0;
                step_out1 = 0;
                step_out2 = 0;
                step_out3 = 0;
            end
    endcase
end
    
always @ (posedge twosec_clk) 
    begin
        module_type <= next_module;
    end
endmodule
