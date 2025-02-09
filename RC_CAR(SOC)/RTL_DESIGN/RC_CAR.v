`timescale 1ns / 1ps

module RC_CAR(
input clk, reset_p,
input [3:0] btn,
input [15:0] value,
input [2:0] echo,
output [2:0] trig,
output in1, in2, in3, in4,
output pwm_right, pwm_left,
output [3:0] com,
output [7:0] seg_7
//output [15:0] led_bar
);
    
    wire go, right, left, auto;
    button_cntr bcntr_go(.clk(clk), .reset_p(reset_p), .btn(btn[0]), .btn_pe(go));
    button_cntr bcntr_right(.clk(clk), .reset_p(reset_p), .btn(btn[1]), .btn_pe(right));
    button_cntr bcntr_left(.clk(clk), .reset_p(reset_p), .btn(btn[2]), .btn_pe(left));
    button_cntr bcntr_back(.clk(clk), .reset_p(reset_p), .btn(btn[3]), .btn_pe(auto));
    // skip in soc
    
    wire [15:0] distance_front, distance_right, distance_left;
    ultrasonic ultra_front(.clk(clk), .reset_p(reset_p), .echo(echo[0]), .trig(trig[0]), .distance_cm(distance_front));
    ultrasonic ultra_right(.clk(clk), .reset_p(reset_p), .echo(echo[1]), .trig(trig[1]), .distance_cm(distance_right));
    ultrasonic ultra_left(.clk(clk), .reset_p(reset_p), .echo(echo[2]), .trig(trig[2]), .distance_cm(distance_left));

//    reg [5:0] front;
//    always @(posedge clk or posedge reset_p) begin
//        if(reset_p) front = 0;
//        else if(value[3]) front = 24;
//        else if(value[4]) front = 26;
//        else if(value[5]) front = 28;
//        else if(value[6]) front = 30;
//        else if(value[7]) front = 32;
//        else if(value[8]) front = 34;
//        else if(value[9]) front = 36;
//        else if(value[10]) front = 38;
//        else if(value[11]) front = 40;
//        else if(value[12]) front = 42;
//        else if(value[13]) front = 44;
//        else if(value[14]) front = 46;
//        else if(value[15]) front = 48;
//    end
    motor_driver motor_cntr(.clk(clk), .reset_p(reset_p), .distance_front(distance_front),
    .distance_right(distance_right), .distance_left(distance_left), .btn({auto, left, right, go}), 
    .in1(in1), .in2(in2), .in3(in3), .in4(in4), .right_duty(right_duty), .left_duty(left_duty));
    
    wire [6:0] right_duty, left_duty;
//    wire pwm_right, pwm_left;
    pwm_100 pwm_r(.clk(clk), .reset_p(reset_p), .duty(right_duty), .pwm_preq(100), .pwm_100pc(pwm_right));
    pwm_100 pwm_l(.clk(clk), .reset_p(reset_p), .duty(left_duty), .pwm_preq(100), .pwm_100pc(pwm_left));
    
    wire [15:0] sel_sw;
    assign sel_sw = value[0] ? distance_front : (value[1] ? distance_right : (value[2] ? distance_left : 0)); 
    wire [15:0] bcd;
    bin_to_dec b2d(.bin(sel_sw[11:0]), .bcd(bcd));
    
    FND_4digit_cntr fnd_c(.clk(clk), .reset_p(reset_p), .value(bcd), .com(com), .seg_7(seg_7));
    
endmodule


module motor_driver(
input clk, reset_p,
input [15:0] distance_front,
input [15:0] distance_right,
input [15:0] distance_left,
input [3:0] btn,
//input [5:0] front,
output reg in1, in2, in3, in4,
output reg [6:0] right_duty, left_duty
//output reg [7:0] led_bar
);

reg flag;

always @(posedge clk or posedge reset_p) begin
    if(reset_p) begin
        in1 = 0; in2 = 0; in3 = 0; in4 = 0; flag = 0;
    end
    else if(flag)begin    
//        if(distance_front < 5) begin
//           if(distance_right > distance_left) begin
//                in1 = 0; in2 = 1; in3 = 0; in4 = 1;
//                right_duty = 30; 
//                left_duty = 0;
//            end
//            else begin
//                in1 = 0; in2 = 1; in3 = 0; in4 = 1;
//                right_duty = 0; 
//                left_duty = 30;
//            end    
//        end    
        if(distance_front < 32) begin
            if(distance_right > distance_left) begin
                in1 = 0; in2 = 1; in3 = 1; in4 = 0;
                right_duty = 20; 
                left_duty = 40;
//                led_bar[0] = 0;
//                led_bar[1] = 0;
//                led_bar[2] = 0;
//                led_bar[3] = 0;
            end
            else begin
                in1 = 1; in2 = 0; in3 = 0; in4 = 1;
                right_duty = 40; 
                left_duty = 20;
//                led_bar[0] = 0;
//                led_bar[1] = 0;
//                led_bar[2] = 0;
//                led_bar[3] = 0;
            end      
        end
        else if(distance_front < 60) begin
            if(distance_left < 30 || distance_right < 30) begin
				if(distance_right > distance_left)
				begin
                    in1 = 1; in2 = 0; in3 = 1; in4 = 0;
                    right_duty = 0; 
                    left_duty = 40;
//                    led_bar[0] = 0;
//                    led_bar[1] = 1;
//                    led_bar[2] = 0;
//                    led_bar[3] = 0;
                            
				end
				else begin
                    in1 = 1; in2 = 0; in3 = 1; in4 = 0;
                    right_duty = 40; 
                    left_duty = 0;
//                    led_bar[0] = 0;
//                    led_bar[1] = 0;
//                    led_bar[2] = 1;
//                    led_bar[3] = 0;
			    end
			end
			else begin
                in1 = 1; in2 = 0; in3 = 1; in4 = 0;
                right_duty = 40; 
                left_duty = 40;
//                led_bar[0] = 1;
//                led_bar[1] = 1;
//                led_bar[2] = 1;
//                led_bar[3] = 0;
			end
        end 

        else if(distance_left < 20 || distance_right < 20) begin
		    if(distance_right > distance_left) begin
                in1 = 1; in2 = 0; in3 = 1; in4 = 0;
                right_duty = 0; 
                left_duty = 40;
//                led_bar[0] = 1;
//                led_bar[1] = 1;
//                led_bar[2] = 0;
//                led_bar[3] = 0;
			end
			else begin
                in1 = 1; in2 = 0; in3 = 1; in4 = 0;
                right_duty = 40; 
                left_duty = 0;
//                led_bar[0] = 0;
//                led_bar[1] = 0;
//                led_bar[2] = 1;
//                led_bar[3] = 1;
			end
	    end
		else begin
		    in1 = 1; in2 = 0; in3 = 1; in4 = 0;
            right_duty = 40; 
            left_duty = 40;
//            led_bar[0] = 1;
//            led_bar[1] = 0;
//            led_bar[2] = 0;
//            led_bar[3] = 0;
		end     
    end
    else if(btn[0])begin
        in1 = 1; in2 = 0; in3 = 1; in4 = 0;
        right_duty = 80; 
        left_duty = 80;
        flag = 0;
//        led_bar[0] = 1;
//        led_bar[1] = 1;
//        led_bar[2] = 1;
//        led_bar[3] = 1;
//        led_bar[7] = 0;
    end
    else if(btn[1])begin
        in1 = 1; in2 = 0; in3 = 1; in4 = 0;
        right_duty = 0; 
        left_duty = 100;
        flag = 0;
//        led_bar[0] = 0;
//        led_bar[1] = 0;
//        led_bar[2] = 1;
//        led_bar[3] = 0;
//        led_bar[7] = 0;
    end
    else if(btn[2])begin
        in1 = 1; in2 = 0; in3 = 1; in4 = 0;
        right_duty = 60; 
        left_duty = 0;
        flag = 0;
//        led_bar[0] = 0;
//        led_bar[1] = 0;
//        led_bar[2] = 0;
//        led_bar[3] = 1;
//        led_bar[7] = 0;
    end
    else if(btn[3])begin
        flag = 1;
    end
end

endmodule


    

