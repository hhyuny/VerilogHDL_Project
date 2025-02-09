`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/07 09:18:03
// Design Name: 
// Module Name: button_cntr
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


module button_cntr(
    input clk, reset_p,
    input btn,
    output btn_pe, btn_ne
    );
    
    reg [16:0] clk_div = 0;    
    always @(posedge clk) clk_div = clk_div + 1;
    
    wire debounced_btn;
    D_flip_flop_p DF(.d(btn), .clk(clk_div[16]), .reset_p(reset_p), .q(debounced_btn));
    edge_detector_n ED(.clk(clk), .cp_in(debounced_btn), .reset_p(reset_p), .p_edge(btn_pe), .n_edge(btn_ne));
    
endmodule
