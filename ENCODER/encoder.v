module encoder(
input        CLK_125_P,                   // 125 MHz clock positive input
input        CLK_125_N,                   // 125 MHz clock negative input 
input        A, B, Z,
input        rst_n
);

wire clk;                                       // Clock signal
// IBUFDS: Differential Input Buffer
// 7 Series
// Xilinx HDL Language Template, version 2017.4
IBUFDS #(
.DIFF_TERM("FALSE"),                           // Differential Termination
.IBUF_LOW_PWR("TRUE"),                          // Low power="TRUE", Highest performance="FALSE"
.IOSTANDARD("DEFAULT")                          // Specify the input I/O standard
) IBUFDS_inst (
.O(clk),                                        // Buffer output    "clk" in your case
.I(CLK_125_P),                                  // Diff_p buffer input (connect directly to top-level port)   "clk_p" in your case
.IB(CLK_125_N)                                  // Diff_n buffer input (connect directly to top-level port)  "clk_n" in your case
);
// End of IBUFDS_inst instantiation

(* MARK_DEBUG = "TRUE" *)    reg direction;
(* MARK_DEBUG = "TRUE" *)    reg [20:0] counter;
    
reg [2:0] A_mem, B_mem;
    reg Z_OX;
(* MARK_DEBUG = "TRUE" *)  wire counter_en = A_mem[2] ^ A_mem[1] ^ B_mem[2] ^ B_mem[1];
wire dir = A_mem[1] ^ B_mem[2];

always @(posedge clk)
begin
A_mem <= {A_mem[1:0], A}; // shift left and save new value
B_mem <= {B_mem[1:0], B};
Z_OX <= Z;

if(counter_en) begin
counter <= dir ? (counter + 1) : (counter - 1); // if(direction == 1) +1 else -1
direction <= dir;
end
        else if(Z_OX) begin
            counter <= 0;
        end
end

endmodule