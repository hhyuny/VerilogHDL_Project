`timescale 1ns / 1ps

module ultrasonic(
    input clk, reset_p,
    input echo,
    output reg trig,
    output reg [15:0] distance_cm
//    output reg [15:0] led_bar
    );
    
    parameter S_IDLE = 4'b0001;
    parameter S_TRIG = 4'b0010;
    parameter S_WAIT_PEDGE = 4'b0100;
    parameter S_WAIT_NEDGE = 4'b1000;
    parameter S_RESET = 4'b1001;
    
    reg [16:0] count_usec;
    wire clk_usec;
    reg count_usec_e;        
    
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));    
    
     always @(negedge clk or posedge reset_p)begin
        if(reset_p) count_usec <= 0;
        else begin
            if(clk_usec && count_usec_e) count_usec <= count_usec + 1;
            else if (!count_usec_e) count_usec <= 0;
        end
    end   
    wire echo_pedge, echo_nedge;
    edge_detector_p ed_start0(.clk(clk), .cp_in(echo), .reset_p(reset_p), .p_edge(echo_pedge), .n_edge(echo_nedge));   
   
    reg [3:0] state, next_state;
    always @(negedge clk or posedge reset_p)begin
        if(reset_p)state <= S_IDLE;
        else state <= next_state;
    end
    
    reg [16:0] temp_value;   // 17bit 16
//    reg [16:0] old_usec;
//    reg [20:0] sum_value;
//    reg [3:0] index;
    always @(posedge clk or posedge reset_p)begin
        if(reset_p)begin
//            led_bar[7:0] <= 8'b11111111;
//            index = 0;
            count_usec_e <= 0;
            trig <= 0;
            next_state <= S_IDLE;
//            distance_cm <= 0;
            temp_value <= 0;
        end
        else begin
            case(state)
                S_IDLE : begin
//                    led_bar[0] <= 1;
//                    led_bar[4] <= 0;
                    if(count_usec < 17'd40_000) begin // 80_000
                        count_usec_e <= 1;
                    end
                    else begin
                        count_usec_e <= 0;
                        next_state <= S_TRIG;
//                        led_bar = 8'b11111111;
                        
                    end
                end
                S_TRIG : begin
//                    led_bar[0] <= 0;
//                    led_bar[1] <= 1;
                     if(count_usec < 17'd12) begin
                        count_usec_e <= 1;
                        trig <= 1;
                     end
                     else begin
                        count_usec_e <= 0;     
                        trig <= 0;
                        next_state <= S_WAIT_PEDGE;
                     end
                end
                S_WAIT_PEDGE : begin
//                    led_bar[1] <= 0;
//                    led_bar[2] <= 1;
                    if(echo_pedge) begin
//                        old_usec = count_usec;
                        count_usec_e <= 1;
                        next_state <= S_WAIT_NEDGE;                     
                    end
                    else begin
//                        if(count_usec < 17'd80_000) begin
                            count_usec_e <= 0;
                            next_state <= S_WAIT_PEDGE;
//                        end
//                        else begin
//                            next_state = S_IDLE;
//                            count_usec_e = 0;
//                        end
                    end
                end
                S_WAIT_NEDGE : begin
//                    led_bar[2] <= 0;
//                    led_bar[3] <= 1;
                    if(echo_nedge) begin
                        temp_value <= count_usec;
//                        distance_cm = temp_value / 58;
//                        index = index + 1;
                        count_usec_e <= 0;
//                        next_state = S_IDLE;
                        next_state <= S_RESET;
                    end
                    else begin
//                        if(count_usec < 17'd80_000) begin
                            count_usec_e <= 1;
                            next_state <= S_WAIT_NEDGE;
//                        end
//                        else begin
//                            next_state = S_IDLE;
//                            count_usec_e = 0;
//                        end
                    end
                end
                S_RESET: begin
//                    led_bar[3] <= 0;
//                    led_bar[4] <= 1;
                    count_usec_e <= 0;
                    next_state <= S_IDLE;
                end
                default : begin
                    count_usec_e <= 0;
                    next_state <= S_IDLE;
                end
            endcase
        end
    end
    
//    reg [4:0] i;
//    always @(posedge clk_usec or posedge reset_p) begin
//        if(reset_p) begin
//            sum_value = 0;
//            i = 0;
//        end
//        else begin
//            sum_value = 0;
//            for (i = 0; i < 16; i = i + 1) begin
//                sum_value = sum_value + temp_value[i];    
//            end
//        end    
//    end
          
    always @(posedge clk_usec or posedge reset_p) begin
        if(reset_p) begin
//            led_bar[15:8] = 8'b11111111;
            distance_cm <= 0;
        end
        else begin
//            led_bar[15:8] = distance_cm[7:0];
            distance_cm <= temp_value / 58;
        end
    end   
        
endmodule




module ultrasonic1(
    input clk, reset_p,
    input Echo_data,                        //input Echo
    output reg Trig_sig,                    //output Trig
    output reg [11:0] Trig_data
    );

    parameter S_START = 4'b0001;            //State1 : 60ms? ???(?? Echo??? ?? ? ??? ??)
    parameter S_START_BIT = 4'b0010;        //State2 : Start?? "1" 12us?? ? Trig_out ?? "0"??
    parameter S_WAIT_ECHO = 4'b0100;        //State3 : ??????? 40kHz? 8?? ?? ?? Wait
    parameter S_RECEIVE_PULSE = 4'b1000;    //State4 : Pedge???? usec? count?? Nedge? ???? count??
                                            //usec_count? 58? ??? 1cm??? ??

    reg [15:0] count_usec;                  //usec? count? reg
    
    wire clk_usec;                  
    clock_usec usec_clk(.clk(clk), .reset_p(reset_p), .clk_usec(clk_usec));

    reg count_usec_e;    //enable 1??? count

    always @(negedge clk or posedge reset_p) begin
        if(reset_p) count_usec = 0;
        else begin
            if(clk_usec && count_usec_e) count_usec = count_usec + 1;      //enable = 1??? count_usec? ?????
            else if(!count_usec_e) count_usec = 0;                         //enable = 0?? count_usee CLR
        end
    end

    wire dht_pedge, dht_nedge;
    edge_detector_n e_d_n(.clk(clk), .cp_in(Echo_data), .reset_p(reset_p), .p_edge(dht_pedge), .n_edge(dht_nedge));
    //Echo_data??? Rising Edge, Falling Edge ???? ?? ??

    //State ??? ?? reg
    reg [3:0] state, next_state;

    always @(negedge clk or posedge reset_p) begin
        if(reset_p) state = S_START;      //State1?? ??
        else state = next_state;         //? CLK?? state? next_state? ????.
    end
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin               //???
            count_usec_e = 0;
            next_state = S_START;
            Trig_sig = 0;
            Trig_data = 0;
        end

        else begin
            case(state)
                S_START: begin                      //State1 : 60ms? ???(?? Echo??? ?? ? ??? ??)
                    if(count_usec < 22'd60_000)begin
                        count_usec_e = 1;           //usec count start
                        Trig_sig = 0;               //Trig LOW         
                    end
                    else begin                      //60ms??
                        next_state = S_START_BIT;   //?? Nedge?? State? ??
                        count_usec_e = 0;           //usec count stop , CLR
                    end
                end
                S_START_BIT: begin                  //State2 : Start?? "1" 12us?? ? Trig_out ?? "0"??
                    
                    if(count_usec < 12)begin        //12us??
                        count_usec_e = 1;           //usec count start
                        Trig_sig = 1;               //Trig HIGH
                    end
                    else begin                      //12us??
                        next_state = S_WAIT_ECHO;   //?? Nedge?? State? ??
                        count_usec_e = 0;           //usec count stop, CLR
                        Trig_sig = 0;               //TRIG LOW
                    end
                end

                S_WAIT_ECHO: begin                  //State3 : ??????? 40kHz? 8?? ?? ?? Wait
                                    //40kHz 8? = 200us?? ??? 4us? ????
                    if(count_usec < 200) begin      //200us??
                        count_usec_e = 1;           //usec count start
                    end
                    else begin                          //4us??
                        next_state = S_RECEIVE_PULSE;   //?? Nedge?? State? ??
                        count_usec_e = 0;               //usec count stop
                    end
                end

                S_RECEIVE_PULSE: begin                          //State4 : Pedge???? usec? count?? Nedge? ???? count??
                    
                    if(dht_pedge) begin                         //Echo??? Pedge????
                        count_usec_e = 1;                       //usec count start
                    end
                    else if(dht_nedge) begin                    //Echo??? Nedge????
                        count_usec_e = 0;                       //usec count stop
                        Trig_data = (count_usec / 6'b11_1010);  //usec_count? 58? ??? 1cm??? ??
                                                                //usec_count? count_usec_e = 0?? ??????
                                                                //?? negedge clk?? count_usec? ????? ??? ??? ??
                        next_state = S_START;                   //?? Nedge?? State? ??
                    end
                end
                default : next_state = S_START;
            endcase
        end

    end

endmodule


