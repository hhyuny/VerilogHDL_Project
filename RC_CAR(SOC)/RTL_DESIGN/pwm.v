`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 15:07:40
// Design Name: 
// Module Name: pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module pwm_100(
    input clk, reset_p,
    input [6:0] duty,
    input [13:0] pwm_preq,
//    input sel,
//    output [1:0] direction,
    output reg pwm_100pc 
    );
    
    parameter sys_clk_preq = 100_000_000;
    
    reg [26:0] cnt;
    reg clk_preqX100;
    
//    assign direction = sel ? 2'b10 : 2'b01;
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt = 0;
            clk_preqX100 = 0;
        end
        else begin
            if(cnt >= sys_clk_preq / pwm_preq / 200) begin 
                cnt = 0;
                clk_preqX100 = ~clk_preqX100;
            end
            else begin
                cnt = cnt + 1;
            end    
        end
    end   
         
    wire clk_preqX100_ne;
    edge_detector_p ed_start0(.clk(clk), .cp_in(clk_preqX100), .reset_p(reset_p), .n_edge(clk_preqX100_ne));   

    reg [6:0] cnt_duty;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt_duty = 0;
            pwm_100pc = 0;
        end
        else if(clk_preqX100_ne) begin
            if(cnt_duty >= 99) cnt_duty = 0;
            else cnt_duty = cnt_duty + 1;
            
            if(cnt_duty < duty) pwm_100pc = 1;
            else pwm_100pc = 0;
        end        
    end
    
endmodule


module pwm_1000(
    input clk, reset_p,
    input [9:0] duty,
    input [13:0] pwm_preq,
    output reg pwm_1000pc 
    );
    
    parameter sys_clk_preq = 125_000_000;
    
    reg [26:0] cnt;
    reg clk_preqX1000;
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt = 0;
            clk_preqX1000 = 0;
        end
        else begin
            if(cnt >= sys_clk_preq / pwm_preq / 2000) begin 
                cnt = 0;
                clk_preqX1000 = ~clk_preqX1000;
            end
            else begin
                cnt = cnt + 1;
            end    
        end
    end   
         
    wire clk_preqX1000_ne;
    edge_detector_p ed_start0(.clk(clk), .cp_in(clk_preqX1000), .reset_p(reset_p), .n_edge(clk_preqX1000_ne));   

    reg [9:0] cnt_duty;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            cnt_duty = 0;
            pwm_1000pc = 0;
        end
        else if(clk_preqX1000_ne) begin
            if(cnt_duty >= 999) cnt_duty = 0;
            else cnt_duty = cnt_duty + 1;
            
            if(cnt_duty < duty) pwm_1000pc = 1;
            else pwm_1000pc = 0;
        end        
    end
    
endmodule


module led_pwm_top(
    input clk, reset_p,
    output led_r, led_y, led_g
    );
    
    reg [27:0] clk_div;
    always @(posedge clk)clk_div = clk_div + 1;
    
    pwm_100 pwm_r(.clk(clk), .reset_p(reset_p), .duty({3'b000, clk_div[27:24]}), .pwm_preq(10000), .pwm_100pc(led_r));
    pwm_100 pwm_y(.clk(clk), .reset_p(reset_p), .duty({3'b000, clk_div[26:23]}), .pwm_preq(10000), .pwm_100pc(led_y));
    pwm_100 pwm_g(.clk(clk), .reset_p(reset_p), .duty({3'b000, clk_div[25:22]}), .pwm_preq(10000), .pwm_100pc(led_g));

endmodule


module servo_sg90(
    input clk, reset_p,
    output s_moter,
    output [3:0] com,
    output [7:0] seg_7
    );
    
    reg [9:0] duty;
    pwm_1000 servo(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm_preq(50), .pwm_1000pc(s_moter));
    
    reg [21:0] clk_div;
    always @(posedge clk) clk_div = clk_div + 1;
    wire clk_div_21_ne;
    edge_detector_n ed(.clk(clk), .reset_p(reset_p), .cp_in(clk_div[21]), .n_edge(clk_div_21_ne));
    
    reg down_up;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            duty = 20;
            down_up = 0;
        end
        else if(clk_div_21_ne) begin
            if(down_up) begin
                if(duty < 20) down_up = 0;
                else duty = duty - 1;
            end
            else begin
                if(duty > 130) down_up = 1;
                else duty = duty + 1;
            end
        end
    end
    
    wire [15:0] bcd_duty;
    bin_to_dec btd(.bin(duty), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7));
    
endmodule


module motor_fan_top(
    input clk, reset_p,
    output s_moter,
    output [3:0] com,
    output [7:0] seg_7
    );

    reg [6:0] duty;
    pwm_100 servo(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm_preq(100), .pwm_100pc(s_moter));
    
    reg [27:0] clk_div;
    always @(posedge clk) clk_div = clk_div + 1;
    wire clk_div_27_ne;
    edge_detector_n ed(.clk(clk), .reset_p(reset_p), .cp_in(clk_div[27]), .n_edge(clk_div_27_ne));

     reg down_up;
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin
            duty = 0;
            down_up = 0;
        end
        else if(clk_div_27_ne) begin
            if(down_up) begin
                if(duty < 1) down_up = 0;
                else duty = duty - 1;
            end
            else begin
                if(duty > 49) down_up = 1;
                else duty = duty + 1;
            end
        end
    end
    
    wire [15:0] bcd_duty;
    bin_to_dec btd(.bin(duty), .bcd(bcd_duty));
    FND_4digit_cntr fnd_cntr(.clk(clk), .reset_p(reset_p), .value(bcd_duty), .com(com), .seg_7(seg_7));

endmodule







