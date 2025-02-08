`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ad706_test 
//////////////////////////////////////////////////////////////////////////////////
module ad7606_test(
    input        CLK_74_25_P,
    input        CLK_74_25_N,                  // 50MHz 클럭
input        rst_n,                // 리셋 신호

input [15:0] ad_data,              // ad7606 데이터 입력
input        ad_busy,              // ad7606 비지 바쁨 신호
    input        first_data,           // ad7606 첫 데이터 신호     
    output [2:0] ad_os,                // ad7606 오버샘플링 신호
    output       ad_cs,                // ad7606 CS 신호
    output       ad_rd,                // ad7606 데이터 읽기 신호
    output       ad_reset,             // ad7606 리셋 신호
    output       ad_convstab,          // ad7606 변환 시작 신호

input        rx,                   // UART 입력
output       tx                    // UART 출력
);

(* MARK_DEBUG = "TRUE" *) wire [4:0] state;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch1;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch2;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch3;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch4;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch5;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch6;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch7;
(* MARK_DEBUG = "TRUE" *) wire [17:0] ad_ch8;

wire [19:0] ch1_dec;
wire [19:0] ch2_dec;
wire [19:0] ch3_dec;
wire [19:0] ch4_dec;
wire [19:0] ch5_dec;
wire [19:0] ch6_dec;
wire [19:0] ch7_dec;
wire [19:0] ch8_dec;

wire [7:0] ch1_sig;
wire [7:0] ch2_sig;
wire [7:0] ch3_sig;
wire [7:0] ch4_sig;
wire [7:0] ch5_sig;
wire [7:0] ch6_sig;
wire [7:0] ch7_sig;
wire [7:0] ch8_sig;

wire clk;
// IBUFDS: Differential Input Buffer
// 7 Series
// Xilinx HDL Language Template, version 2017.4
IBUFDS #(
.DIFF_TERM("FALSE"), // Differential Termination
.IBUF_LOW_PWR("TRUE"), // Low power="TRUE", Highest performance="FALSE"
.IOSTANDARD("DEFAULT") // Specify the input I/O standard
) IBUFDS_inst (
.O(clk), // Buffer output    "clk" in your case
.I(CLK_74_25_P), // Diff_p buffer input (connect directly to top-level port)   "clk_p" in your case
.IB(CLK_74_25_N) // Diff_n buffer input (connect directly to top-level port)  "clk_n" in your case
);
// End of IBUFDS_inst instantiation

// ad7606 모듈 인스턴스화
ad7606c18 u1(
.clk              (clk),
.rst_n            (rst_n),
.ad_data          (ad_data),
.ad_busy          (ad_busy),
.first_data       (first_data),
.ad_os            (ad_os),
.ad_cs            (ad_cs),
.ad_rd            (ad_rd),
.ad_reset         (ad_reset),
.ad_convstab      (ad_convstab),
.ad_ch1           (ad_ch1),           // ch1 ad 데이터 16비트
.ad_ch2           (ad_ch2),           // ch2 ad 데이터 16비트
.ad_ch3           (ad_ch3),           // ch3 ad 데이터 16비트
.ad_ch4           (ad_ch4),           // ch4 ad 데이터 16비트
.ad_ch5           (ad_ch5),           // ch5 ad 데이터 16비트
.ad_ch6           (ad_ch6),           // ch6 ad 데이터 16비트
.ad_ch7           (ad_ch7),           // ch7 ad 데이터 16비트
.ad_ch8           (ad_ch8),            // ch8 ad 데이터 16비트
    .state            (state)
);

// AD 변환된 값을 전압으로 변환하는 모듈 인스턴스화
volt_cal u2(
.clk              (clk),
.ad_reset         (ad_reset),
.ad_ch1           (ad_ch1),           // ch1 ad 데이터 16비트 (입력)
.ad_ch2           (ad_ch2),           // ch2 ad 데이터 16비트 (입력)
.ad_ch3           (ad_ch3),           // ch3 ad 데이터 16비트 (입력)
.ad_ch4           (ad_ch4),           // ch4 ad 데이터 16비트 (입력)
.ad_ch5           (ad_ch5),           // ch5 ad 데이터 16비트 (입력)
.ad_ch6           (ad_ch6),           // ch6 ad 데이터 16비트 (입력)
.ad_ch7           (ad_ch7),           // ch7 ad 데이터 16비트 (입력)
.ad_ch8           (ad_ch8),           // ch8 ad 데이터 16비트 (입력)

.ch1_dec           (ch1_dec),         // ch1 ad 전압 (출력)
.ch2_dec           (ch2_dec),         // ch2 ad 전압 (출력)
.ch3_dec           (ch3_dec),         // ch3 ad 전압 (출력)
.ch4_dec           (ch4_dec),         // ch4 ad 전압 (출력)
.ch5_dec           (ch5_dec),         // ch5 ad 전압 (출력)
.ch6_dec           (ch6_dec),         // ch6 ad 전압 (출력)
.ch7_dec           (ch7_dec),         // ch7 ad 전압 (출력)
.ch8_dec           (ch8_dec),         // ch8 ad 전압 (출력)

.ch1_sig           (ch1_sig),         // ch1 ad 신호 (출력)
.ch2_sig           (ch2_sig),         // ch2 ad 신호 (출력)
.ch3_sig           (ch3_sig),         // ch3 ad 신호 (출력)
.ch4_sig           (ch4_sig),         // ch4 ad 신호 (출력)
.ch5_sig           (ch5_sig),         // ch5 ad 신호 (출력)
.ch6_sig           (ch6_sig),         // ch6 ad 신호 (출력)
.ch7_sig           (ch7_sig),         // ch7 ad 신호 (출력)
.ch8_sig           (ch8_sig)          // ch8 ad 신호 (출력)
);

// UART 통신 모듈 인스턴스화
uart u3(
.clk50                (clk),
.reset_n             (rst_n),

.ch1_dec                 (ch1_dec),         // ad1 BCD 전압
.ch2_dec                 (ch2_dec),         // ad2 BCD 전압
.ch3_dec                 (ch3_dec),         // ad3 BCD 전압
.ch4_dec                 (ch4_dec),         // ad4 BCD 전압
.ch5_dec                 (ch5_dec),         // ad5 BCD 전압
.ch6_dec                 (ch6_dec),         // ad6 BCD 전압
.ch7_dec                 (ch7_dec),         // ad7 BCD 전압
.ch8_dec                 (ch8_dec),         // ad8 BCD 전압

.ch1_sig                 (ch1_sig),          // ch1 ad 신호
.ch2_sig                 (ch2_sig),          // ch2 ad 신호
.ch3_sig                 (ch3_sig),          // ch3 ad 신호
.ch4_sig                 (ch4_sig),          // ch4 ad 신호
.ch5_sig                 (ch5_sig),          // ch5 ad 신호
.ch6_sig                 (ch6_sig),          // ch6 ad 신호
.ch7_sig                 (ch7_sig),          // ch7 ad 신호
.ch8_sig                 (ch8_sig),          // ch8 ad 신호

.tx                      (tx)
);

endmodule