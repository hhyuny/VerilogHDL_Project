`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/23 12:30:48
// Design Name: 
// Module Name: exam02_sequential_logic
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
//// 
////////////////////////////////////////////////////////////////////////////////////


//module RS_latch(
//    input R, S,
//    output Q, Qbar
//); 

//    nor (Q, R, Qbar);
//    nor (Qbar, S, Q);
    
//endmodule


//module RS_latch_en(
//    input R, S,
//    output Q, Qbar
//); 
    
//    wire w_r, w_s;
    
//    and (w_r, R, en);
//    and (w_s, S, en);

//    nor (Q, w_r, Qbar);
//    nor (Qbar, w_s, Q);
    
    
//endmodule



module D_flip_flop_n (
    input d,
    input clk, 
    input reset_p,
    output reg q
);

    always @(negedge clk or posedge reset_p) begin     // flip - flop
        if(reset_p) q = 0;
        else q = d;  

    end
    
    
endmodule

module D_flip_flop_p (
    input d,
    input clk, 
    input reset_p,
    output reg q
);

    always @(posedge clk or posedge reset_p) begin     // flip - flop
        if(reset_p) q = 0;
        else q = d;  

    end
      
endmodule


module T_flip_flop_n (
    input clk,
    input t,
    input reset_p,
    output reg q

);

//    wire d;
//    assign d = ~q;
    
//    always @(negedge clk) begin
//        q = d;    
//    end    
    always @(negedge clk or posedge reset_p) begin
        if(reset_p) q = 0;
        else if(t) q = ~q;    
    end

endmodule


module T_flip_flop_p (
    input clk,
    input t,
    input reset_p,
    output reg q
);


    always @(posedge clk or posedge reset_p) begin
        if(reset_p) q = 0;
        else if(t) q = ~q;
        else q = q;    
    end

endmodule



module up_counter_asyc (
    input clk,
    input reset_p,
    output [3:0] count
);
        
    T_flip_flop_n T0(.clk(clk), .reset_p(reset_p), .q(count[0]));
    T_flip_flop_n T1(.clk(count[0]), .reset_p(reset_p), .q(count[1]));
    T_flip_flop_n T2(.clk(count[1]), .reset_p(reset_p), .q(count[2]));
    T_flip_flop_n T3(.clk(count[2]), .reset_p(reset_p), .q(count[3]));


endmodule


module down_counter_asyc (
    input clk,
    input reset_p,
    output [3:0] count
);
        
    T_flip_flop_p T0(.clk(clk), .reset_p(reset_p), .q(count[0]));
    T_flip_flop_p T1(.clk(count[0]), .reset_p(reset_p), .q(count[1]));
    T_flip_flop_p T2(.clk(count[1]), .reset_p(reset_p), .q(count[2]));
    T_flip_flop_p T3(.clk(count[2]), .reset_p(reset_p), .q(count[3]));


endmodule



module up_counter_p (
    input clk,
    input reset_p,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;
        else count = count +1;
    end

endmodule


module down_counter_p (
    input clk,
    input reset_p,
    output reg [3:0] count
);
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;
        else count = count -1;
    end

endmodule


module up_down_counter (
    input clk, reset_p,
    input up_down,
    output reg [3:0] count
);

    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;
        else if(up_down) count = count +1;
        else count = count -1;
    end


endmodule


module up_down_counter_BCD_p (
    input clk,
    input reset_p,
    input up_down,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;
        else begin
            if(up_down) begin
                if(count >= 9) count = 0;
                else count = count +1;
            end
            else begin
                if(count == 0) count = 9;
                else count = count -1;
            end
       end
    end        
        
endmodule



module ring_counter_fnd (
    input clk,
    output [3:0] com
);
    
    reg [3:0] temp;
    
    always @(posedge clk) begin
        if (temp != 4'b1110 && temp != 4'b1101 && temp != 4'b1011 && temp != 4'b0111) temp = 4'b1110;
        else if (temp == 4'b0111) temp = 4'b1110;
        else temp = {temp[2:0], 1'b1}; 
    end
    
    assign com = temp;
    
endmodule


module up_down_counter_Nbit_p #(parameter N = 4) (
    input clk,
    input reset_p,
    input up_down,
    output reg [N-1:0] count
);
    
   
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) count = 0;
        else begin
            if(up_down) count = count +1;
            else count = count -1;
       end
    end        
        
endmodule



module edge_detector_n (
    input clk,
    input cp_in,
    input reset_p,
    output p_edge,
    output n_edge
);

    reg cp_in_old, cp_in_cur;
    
    always @(negedge clk or posedge reset_p) begin
        if(reset_p) begin cp_in_old = 0; cp_in_cur = 0; end
        else begin 
            cp_in_cur <= cp_in;        
            cp_in_old <= cp_in_cur;
        end    
    end

    assign p_edge = ~cp_in_old & cp_in_cur;
    assign n_edge = cp_in_old & ~cp_in_cur;

endmodule


module edge_detector_p (
    input clk,
    input cp_in,
    input reset_p,
    output p_edge,
    output n_edge
);

    reg cp_in_old, cp_in_cur;
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) begin cp_in_old = 0; cp_in_cur = 0; end
        else begin 
            cp_in_cur <= cp_in;        
            cp_in_old <= cp_in_cur;
        end    
    end

    assign p_edge = ~cp_in_old & cp_in_cur;
    assign n_edge = cp_in_old & ~cp_in_cur;

endmodule


//module shift_register_SISO_s(
//    input d,
//    input clk, 
//    input reset_p,   
//    output q
//);
//    wire [2:0] w;
//    D_flip_flop_n dff3(.d(d), .clk(clk), .reset_p(reset_p), .q(w[2]));
//    D_flip_flop_n dff2(.d(w[2]), .clk(clk), .reset_p(reset_p), .q(w[1]));
//    D_flip_flop_n dff1(.d(w[1]), .clk(clk), .reset_p(reset_p), .q(w[0]));
//    D_flip_flop_n dff0(.d(w[0]), .clk(clk), .reset_p(reset_p), .q(q));
    
    
//endmodule

module shift_register_SISO_n(
    input d,
    input clk, 
    input reset_p,   
    output reg q
);
    
    reg [3:0] siso;
    
    always @(negedge clk or posedge reset_p) begin
        if(reset_p)  siso = 0;
        else begin
        siso[3] <= d;
        siso[2] <= siso[3];
        siso[1] <= siso[2];
        siso[0] <= siso[1];
        q <= siso[0];
        end 
    end

endmodule


module shift_register_PISO(
    input [3:0] d,
    input clk, reset_p, shift_load,
    output q
);

    reg [3:0] data;
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) data = 0;
        else if(shift_load) data = {1'b0, data[3:1]};
        else data = d;       
    end
    
    assign q = data[0];

endmodule
    

//module shift_register_SIPO(
//    input d,
//    input clk, reset_p, 
//    input rd_en,
//    output [3:0] q
//);
    
//    wire [3:0] shift_register;
//    D_flip_flop_n D3(.d(d), .clk(clk), .reset_p(reset_p), .q(shift_register[3]));
//    D_flip_flop_n D2(.d(shift_register[3]), .clk(clk), .reset_p(reset_p), .q(shift_register[2]));
//    D_flip_flop_n D1(.d(shift_register[2]), .clk(clk), .reset_p(reset_p), .q(shift_register[1]));
//    D_flip_flop_n D0(.d(shift_register[1]), .clk(clk), .reset_p(reset_p), .q(shift_register[0]));
    
//    bufif1 (q[0], shift_register[0], rd_en); // buffer when 0 -> print
//    bufif1 (q[1], shift_register[1], rd_en);
//    bufif1 (q[2], shift_register[2], rd_en);
//    bufif1 (q[3], shift_register[3], rd_en);
    
//endmodule


module shift_register_SIPO(
    input d,
    input clk, reset_p, 
    input rd_en,
    output [3:0] q
);
    
    reg [3:0] shift_register;
    always@(negedge clk or posedge reset_p) begin
        if(reset_p) shift_register <= 0;
        else shift_register <= {d,shift_register[3:1]};
    end
    
    assign q = (rd_en) ? shift_register : 4'bz;
           
endmodule



module shift_register(
    input clk, reset_p, shift, load, sin,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) data_out = 0;
        else if(shift) data_out = {sin, data_out[7:1]};
        else if(load) data_out = data_in;
        else data_out = data_out;        
    end   
    
endmodule


module register_Nbit_p #(parameter N=8)(
    input [N-1:0] d,
    input clk, reset_p, wr_en, rd_en,
    output q
);
    
    reg [N-1:0] register;
    
    always @(posedge clk or posedge reset_p) begin
        if(reset_p) register = 0;
        else if(wr_en) register = d;
        else register = register; 
    end
    
    assign q = rd_en ? register : 'bz;
    
endmodule


module sram_8bit_1024(
    input clk, wr_en, rd_en, 
    input [9:0] addr,
    inout [7:0] data
);
    
    reg [7:0] mem [0:1023];     //[0:1023] array
    
    always @(posedge clk)
        if(wr_en) mem[addr] <= data;
        
        assign data = rd_en ? mem[addr] : 8'bz;
    
endmodule





