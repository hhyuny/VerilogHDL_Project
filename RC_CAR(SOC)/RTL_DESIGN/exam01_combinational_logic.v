`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/19 14:24:34
// Design Name: 
// Module Name: and_gate
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

module half_adder_structural(       //structural modeling
    input A,
    input B,
    output sum,
    output carry
    );
    
    xor (sum, A, B);
    and (carry, A, B);
    
endmodule


module half_adder(     //dataflow modeling
    input A,
    input B,
    output sum,
    output carry
    );
    
    assign sum = A ^ B;
    assign carry = A & B;
    
endmodule


module half_adder_behavioral(       //behavioral modeling
    input A,
    input B,
    output reg sum,
    output reg carry
    );
    
    always @(A, B)begin
        case({A, B})
            2'b00: begin sum = 0; carry = 0; end    //2'b : 2bit binary 
            2'b01: begin sum = 1; carry = 0; end    //case's begin end : C's brace{}
            2'b10: begin sum = 1; carry = 0; end
            2'b11: begin sum = 0; carry = 1; end
        endcase
    end
       
endmodule


module full_adder_structural(
    input A, B, cin,
    output sum, carry
    );
    
    wire sum_0, carry_0, carry_1;
    
    half_adder ha0 (.A(A), .B(B), .sum(sum_0), .carry(carry_0));    //instance
    half_adder ha1 (.A(sum_0), .B(cin), .sum(sum), .carry(carry_1));
    or (carry, carry_0, carry_1);
        
endmodule


module full_adder(
    input A, B, cin,
    output sum, carry
    );
    
   assign sum = A ^ B ^ cin;
   assign carry = (cin & (A ^ B)) | (A & B);
    
    
endmodule



module full_adder_4bit_s(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output carry        //MSB first - 4bit
    );
    
    wire [2:0] carry_in;
    
    full_adder fa0 (.A(a[0]), .B(b[0]), .cin(cin), .sum(sum[0]), .carry(carry_in[0]));
    full_adder fa1 (.A(a[1]), .B(b[1]), .cin(carry_in[0]), .sum(sum[1]), .carry(carry_in[1]));
    full_adder fa2 (.A(a[2]), .B(b[2]), .cin(carry_in[1]), .sum(sum[2]), .carry(carry_in[2]));
    full_adder fa3 (.A(a[3]), .B(b[3]), .cin(carry_in[2]), .sum(sum[3]), .carry(carry));
        
endmodule


module full_adder_4bit( //data flow
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output carry     //MSB first - 4bit
    );
    
   wire [4:0] temp; //output = 5 bit
   
   assign temp = a + b + cin;
   assign sum = temp[3:0];
   assign carry = temp[4];
              
endmodule



module full_add_sub_4bit_s(
    input [3:0] a, b,
    input s,                //add: s = 0, sub: s = 1
    output [3:0] sum,
    output carry        
    );
    
    wire [2:0] carry_in;
    
    full_adder fa0 (.A(a[0]), .B(b[0] ^ s), .cin(s), .sum(sum[0]), .carry(carry_in[0]));
    full_adder fa1 (.A(a[1]), .B(b[1] ^ s), .cin(carry_in[0]), .sum(sum[1]), .carry(carry_in[1]));
    full_adder fa2 (.A(a[2]), .B(b[2] ^ s), .cin(carry_in[1]), .sum(sum[2]), .carry(carry_in[2]));
    full_adder fa3 (.A(a[3]), .B(b[3] ^ s), .cin(carry_in[2]), .sum(sum[3]), .carry(carry));
        
endmodule




module fadd_sub_4bit(
    input [3:0] a, b,
    input s,                //add: s = 0, sub: s = 1
    output [3:0] sum,
    output carry        
    );
    
   wire [4:0] temp;
            
   assign temp = s? a - b: a + b; 
   assign sum = temp[3:0];
   assign carry = temp[4];   
   //ex, case temp1, temp2(s = 1, s = 0)
           
endmodule


module comparator #(parameter N = 4)(
    input [N-1:0] A, B,   //data flow advantage
    output equal, greater, less    
);
     
   assign equal = (A == B) ? 1'b1 : 1'b0;
   assign greater = (A > B) ? 1'b1 : 1'b0;
   assign less = (A < B) ? 1'b1 : 1'b0;
   
   /*structual modeling
   assign equal = A ~^ B;  //exclusive-nor
   assign greater = A & ~B;
   assign less = ~A & B;*/
    
           
endmodule


module decoder_2_4 (
    input [1:0] A,
    output [3:0] Y //always reg
    );
    
    /*always @(A) begin  //@(A) sensitivity list
        case(A)
            2'b00: Y = 4'b0001;
            2'b01: Y = 4'b0010;
            2'b10: Y = 4'b0100;
            2'b11: Y = 4'b1000;         
        endcase
    end
   
    
     always @(A) begin  
        if (A == 2'b00) Y = 4'b0001;
        else if(A == 2'b01) Y = 4'b0010;
        else if(A == 2'b10) Y = 4'b0100;
        else Y = 4'b1000;               
    end*/
    
    assign Y = (A == 2'b00) ? 4'b0001 : (A == 2'b01) ? 4'b0010 : (A == 2'b10) ? 4'b0100 : 4'b1000;
    
    
endmodule



module decoder_2_4_en (
    input [1:0] A,
    input en,
    output reg [3:0] Y //always reg
    );
        
    //assign Y = !en ? 4'b0000: (A == 2'b00) ? 4'b0001 : (A == 2'b01) ? 4'b0010 : (A == 2'b10) ? 4'b0100 : 4'b1000;
        
    /*always @(A) begin  //@(A) sensitivity list
        if (en) begin
        case(A)
            2'b00: Y = 4'b0001;
            2'b01: Y = 4'b0010;
            2'b10: Y = 4'b0100;
            2'b11: Y = 4'b1000;         
        endcase
        end
            else Y = 0;
        end*/
       
     always @(A) begin  
        if(!en) Y = 4'b0000;
        else if(A == 2'b00) Y = 4'b0001;
        else if(A == 2'b01) Y = 4'b0010;
        else if(A == 2'b10) Y = 4'b0100;
        else Y = 4'b1000;               
    end
        
endmodule


module decoder_3_4 (
    input [2:0] A,
    output [7:0] Y
);
    decoder_2_4_en DE1(A[1:0], !A[2], Y[3:0]);
    decoder_2_4_en DE2(A[1:0], A[2], Y[7:4]);
    
endmodule



module decoder_7seg(
    input [3:0] hex_value,
    output reg [7:0] seg_7
    );
    
    always @(hex_value) begin
        case(hex_value)
            4'b0000 : seg_7 = 8'b11000000; 
            4'b0001 : seg_7 = 8'b11111001;           
            4'b0010 : seg_7 = 8'b10100100;           
            4'b0011 : seg_7 = 8'b10110000;           
            4'b0100 : seg_7 = 8'b10011001;           
            4'b0101 : seg_7 = 8'b10010010;           
            4'b0110 : seg_7 = 8'b10000010;           
            4'b0111 : seg_7 = 8'b11111000;           
            4'b1000 : seg_7 = 8'b10000000;           
            4'b1001 : seg_7 = 8'b10010000;
            4'b1010 : seg_7 = 8'b10001000;
            4'b1011 : seg_7 = 8'b10000011;
            4'b1100 : seg_7 = 8'b11000110;
            4'b1101 : seg_7 = 8'b10100001;
            4'b1110 : seg_7 = 8'b10000110;
            4'b1111 : seg_7 = 8'b10001110;            
        endcase    
    end
    
endmodule


module fnd_test_top(
    input clk,
    output [7:0] seg_7,
    output [3:0] com
    );
    
    assign com = 4'b0001;
    
    reg [25:0] clk_div;
    
    always @(posedge clk) clk_div = clk_div + 1;
    
    reg [3:0] count;
    always @(negedge clk_div[25]) begin
        count = count + 1;
    end
    
//    wire [7:0] seg_7_font;
    
    decoder_7seg seg7(.hex_value(count), .seg_7(seg_7));
    
//    assign seg_7 = ~seg_7_font;
    
    
endmodule


module encoder_4_2(
    input [3:0] D,
    output [1:0] B   
);
     
    assign B = (D == 4'b0001) ? 2'b00 : (D == 4'b0010) ? 2'b01 : (D == 4'b0100) ? 2'b10 : 2'b11;

endmodule


module mux_2_1(
    input [1:0] d,
    input s,
    output f
);

    assign f = s ? d[1] : d[0];

//    wire s_, in0, in1;
    
//    not (s_, s);
//    and (in0, d[0], s_);
//    and (in1, d[1], s);
//    or (f, in0, in1);
    
endmodule


module mux_4_1(
    input [3:0] d,
    input [1:0] s,
    output f
);
    
    assign f = d[s];

endmodule


module mux_8_1(
    input [7:0] d, //input variable
    input [2:0] s, //select
    output f       
);
    
    assign f = d[s];

endmodule


module demux_1_4(
    input d,
    input [1:0] s,
    output [3:0] f
);

//    always @* begin
//        f = 0;
//        f[s] = d;
//    end
    
    assign f = (s == 2'b00) ? {3'b000, d} : (s == 2'b01) ? {2'b00, d, 1'b0} : (s == 2'b10) ? {1'b0, d, 2'b00} : {d, 3'b000};
    
endmodule


module mux_test_top(
    input [7:0] d, 
    input [2:0] s_mux,
    input [1:0] s_demux,
    output [3:0] f
);
    wire w;
    
    mux_8_1 mux(d, s_mux, w);
    demux_1_4 demux(w, s_demux, f);
  
endmodule



module bin_to_dec(
    input [11:0] bin,
    output reg [15:0] bcd
);
    
    reg [3:0] i;
    
    always @(bin) begin
        bcd = 0;
        for(i = 0; i < 12; i = i + 1) begin
            bcd = {bcd[14:0], bin[11-i]};                               //shift : bin << 1, >>     
            if(i < 11 && bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3;
            if(i < 11 && bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;
            if(i < 11 && bcd[11:8] > 4) bcd[11:8] = bcd[11:8] + 3;
            if(i < 11 && bcd[15:12] > 4) bcd[15:12] = bcd[15:12] + 3;
        end    
    end

endmodule
