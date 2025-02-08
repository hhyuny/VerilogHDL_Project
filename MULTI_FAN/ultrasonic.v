`timescale 1ns / 1ps

module ultrasonic(                                  
    input clk, reset_p,
    input echo,
    output reg trigger,
    output reg [15:0] distance_cm,
    output reg [7:0] led_bar
    );
    
    parameter S_IDLE = 4'b0001;
    parameter S_TRIG = 4'b0010;
    parameter S_WAIT_PEDGE = 4'b0100;
    parameter S_WAIT_NEDGE = 4'b1000;
    
    reg [16:0] count_usec;
    wire clk_usec;
    reg count_usec_e;
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));
    
    always @(negedge clk or posedge reset_p)begin
        if(reset_p) count_usec = 0;
        else begin
            if(clk_usec && count_usec_e) count_usec = count_usec + 1;
            else if (!count_usec_e) count_usec = 0;
        end
    end
    
    wire echo_pedge, echo_nedge;
    edge_detector_p ed(.clk(clk), .cp_in(echo),
        .reset_p(reset_p), .p_edge(echo_pedge), .n_edge(echo_nedge));
        
    reg [5:0] state, next_state;
    always @(negedge clk or posedge reset_p)begin
        if(reset_p)state = S_IDLE;
        else state = next_state;
    end    
    reg old_usec;
    reg [16:0] temp_value [15:0];
    reg [20:0] sum_value;
    reg [3:0] index;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
            led_bar = 8'b11111111;
            index = 0;
            count_usec_e = 0;
            next_state = S_IDLE;
            trigger = 0;
        end
        else begin
            case(state)
                S_IDLE:begin
                    if(count_usec < 22'd80)begin
                        count_usec_e = 1;
                        led_bar[0] = 0;
                    end
                    else begin
                        next_state = S_TRIG;
                        led_bar = 8'b11111111;
                        count_usec_e = 0;
                    end
                end
                S_TRIG:begin
                    led_bar[1] = 0;
                    if(count_usec < 22'd10)begin
                        count_usec_e = 1;
                        trigger = 1;
                    end
                    else begin
                        next_state = S_WAIT_PEDGE;
                        count_usec_e = 0;
                        trigger = 0;
                    end
                end
                S_WAIT_PEDGE:begin
                    led_bar[2] = 0;
                    if(echo_pedge)begin
                        old_usec = count_usec; 
                        next_state = S_WAIT_NEDGE;
                    end
                    else begin
                        if(count_usec < 22'd80_000)begin
                        count_usec_e = 1;
                        next_state = S_WAIT_PEDGE;
                    end
                    else begin
                        count_usec_e = 0;
                        next_state = S_IDLE;
                    end
                end
             end
                S_WAIT_NEDGE:begin
                    led_bar[3] = 0;
                    if(echo_nedge)begin
                        temp_value[index] = count_usec - old_usec;
                        index = index + 1;
                        count_usec_e = 0;
                        next_state = S_IDLE;
                    end
                    else begin
                        if(count_usec<22'd80_000)begin
                        count_usec_e = 1;
                        next_state = S_WAIT_NEDGE;
                    end
                    else begin
                    next_state = S_IDLE;
                    count_usec_e = 0;
                end
                end
                end
                default: next_state = S_IDLE;
            endcase
        end
    end
    reg [4:0] i;
    always @(posedge clk_usec or posedge reset_p)begin
        if(reset_p)begin
            sum_value = 0;
            i = 0;
        end
        else begin
            sum_value = 0;
            for (i=0;i<16;i=i+1)begin
                sum_value = sum_value + temp_value[i];
            end
        end
    end
    
    always @(posedge clk_usec or posedge reset_p)begin
        if(reset_p) distance_cm = 0;
        else distance_cm = sum_value[20:4] / 58;
    end
endmodule

module ultra_sonic_top(
	input clk, reset_p,
	input echo,
	output trigger,
	output [3:0] com,
	output [7:0] seg_7,
	output [7:0] led_bar
    );
    
    wire [15:0] distance;
    wire [15:0] bcd_distance;
   // wire [15:0] distance_fnd;
    
    ultrasonic distance_check(.clk(clk), .reset_p(reset_p), .echo(echo), .trigger(trigger), .distance_cm(distance), .led_bar(led_bar));	// get distance value
    
    bin_to_dec btd_distance(.bin(distance), .bcd(bcd_distance));																		// change to decimal_distance
    		
    fnd_4digit_cntr FND_distance(.clk(clk), .value(bcd_distance), .com(com), .seg_7(seg_7));											// FND print decimal_distance
    // FND_4digit_cntr FND_distance(.clk(clk), .value(distance), .com(com), .seg_7(seg_7));
    
endmodule









