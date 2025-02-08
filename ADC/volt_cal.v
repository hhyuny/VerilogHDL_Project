`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    
//volt_cal AD 변환된 값을 전압으로 변환하는 volt_cal 모듈
//ad_ch1부터 ad_ch8까지의 AD 데이터를 받아 각 채널의 전압값 및 부호를 계산합니다.
//16비트 AD 값을 20비트 BCD로 변환하고 전압 값을 계산합니다.
//bcd 모듈을 사용하여 16진수를 BCD로 변환합니다.
//전체 모듈의 기능은 AD 변환된 데이터를 받아 각 채널의 전압값을 20비트 BCD로 표현하고 부호를 맞추어 출력하는 것입니다.
//////////////////////////////////////////////////////////////////////////////////
module volt_cal(
    input           clk,                  // 50MHz 클럭
input           ad_reset,             // AD 리셋 신호

input [17:0] ad_ch1,                  // AD 채널 1 데이터
input [17:0] ad_ch2,                  // AD 채널 2 데이터
input [17:0] ad_ch3,                  // AD 채널 3 데이터
input [17:0] ad_ch4,                  // AD 채널 4 데이터
input [17:0] ad_ch5,                  // AD 채널 5 데이터
input [17:0] ad_ch6,                  // AD 채널 6 데이터
input [17:0] ad_ch7,                  // AD 채널 7 데이터
input [17:0] ad_ch8,                  // AD 채널 8 데이터

output [17:0] ch1_dec,                // AD 채널 1 전압 20비트 BCD 표현
output [17:0] ch2_dec,                // AD 채널 2 전압 20비트 BCD 표현
output [17:0] ch3_dec,                // AD 채널 3 전압 20비트 BCD 표현
output [17:0] ch4_dec,                // AD 채널 4 전압 20비트 BCD 표현
output [17:0] ch5_dec,                // AD 채널 5 전압 20비트 BCD 표현
output [17:0] ch6_dec,                // AD 채널 6 전압 20비트 BCD 표현
output [17:0] ch7_dec,                // AD 채널 7 전압 20비트 BCD 표현
output [17:0] ch8_dec,                // AD 채널 8 전압 20비트 BCD 표현

output reg [7:0] ch1_sig,             // AD 채널 1 전압 부호 및 맏 표현
output reg [7:0] ch2_sig,             // AD 채널 2 전압 부호 및 맏 표현
output reg [7:0] ch3_sig,             // AD 채널 3 전압 부호 및 맏 표현
output reg [7:0] ch4_sig,             // AD 채널 4 전압 부호 및 맏 표현
output reg [7:0] ch5_sig,             // AD 채널 5 전압 부호 및 맏 표현
output reg [7:0] ch6_sig,             // AD 채널 6 전압 부호 및 맏 표현
output reg [7:0] ch7_sig,             // AD 채널 7 전압 부호 및 맏 표현
output reg [7:0] ch8_sig              // AD 채널 8 전압 부호 및 맏 표현
);

reg [17:0] ch1_reg;
reg [17:0] ch2_reg;
reg [17:0] ch3_reg;
reg [17:0] ch4_reg;
reg [17:0] ch5_reg;
reg [17:0] ch6_reg;
reg [17:0] ch7_reg;
reg [17:0] ch8_reg;

reg [31:0] ch1_data_reg;
reg [31:0] ch2_data_reg;
reg [31:0] ch3_data_reg;
reg [31:0] ch4_data_reg;
reg [31:0] ch5_data_reg;
reg [31:0] ch6_data_reg;
reg [31:0] ch7_data_reg;
reg [31:0] ch8_data_reg;

reg [31:0] ch1_vol;
reg [31:0] ch2_vol;
reg [31:0] ch3_vol;
reg [31:0] ch4_vol;
reg [31:0] ch5_vol;
reg [31:0] ch6_vol;
reg [31:0] ch7_vol;
reg [31:0] ch8_vol;

// AD 변환값을 18비트로 맞춤
always @(posedge clk) begin
if(ad_reset == 1'b1) begin   
ch1_reg <= 0;
ch2_reg <= 0;
ch3_reg <= 0;
ch4_reg <= 0;
ch5_reg <= 0;
ch6_reg <= 0;
ch7_reg <= 0;
ch8_reg <= 0;
end
else begin
// CH1 전압 및 부호 표현
if(ad_ch1[17] == 1'b1) begin
ch1_reg <= 18'h7ffff - ad_ch1;
ch1_sig <= 45; // '-' ASCII 코드
end
else begin
ch1_reg <= ad_ch1;
ch1_sig <= 43; // '+' ASCII 코드
end

// CH2 전압 및 부호 표현
if(ad_ch2[17] == 1'b1) begin
ch2_reg <= 18'h7ffff - ad_ch2;
ch2_sig <= 45;
end
else begin
ch2_reg <= ad_ch2;
ch2_sig <= 43;
end

// CH3 전압 및 부호 표현
if(ad_ch3[17] == 1'b1) begin
ch3_reg <= 18'h7ffff - ad_ch3;
ch3_sig <= 45;
end
else begin
ch3_reg <= ad_ch3;
ch3_sig <= 43;
end

// CH4 전압 및 부호 표현
if(ad_ch4[17] == 1'b1) begin
ch4_reg <= 18'h7ffff - ad_ch4;
ch4_sig <= 45;
end
else begin
ch4_reg <= ad_ch4;
ch4_sig <= 43;
end

// CH5 전압 및 부호 표현
if(ad_ch5[17] == 1'b1) begin
ch5_reg <= 18'h7ffff - ad_ch5;
ch5_sig <= 45;
end
else begin
ch5_reg <= ad_ch5;
ch5_sig <= 43;
end

// CH6 전압 및 부호 표현
if(ad_ch6[17] == 1'b1) begin
ch6_reg <= 18'h7ffff - ad_ch6;
ch6_sig <= 45;
end
else begin
ch6_reg <= ad_ch6;
ch6_sig <= 43;
end

// CH7 전압 및 부호 표현
if(ad_ch7[17] == 1'b1) begin
ch7_reg <= 18'h7ffff - ad_ch7;
ch7_sig <= 45;
end
else begin
ch7_reg <= ad_ch7;
ch7_sig <= 43;
end

// CH8 전압 및 부호 표현
if(ad_ch8[17] == 1'b1) begin
ch8_reg <= 18'h7ffff - ad_ch8;
ch8_sig <= 45;
end
else begin
ch8_reg <= ad_ch8;
ch8_sig <= 43;
end
end
end

// AD 값을 전압으로 변환 (1 LSB = 5V / 32758 = 0.15mV)
always @(posedge clk) begin
if(ad_reset == 1'b1) begin   
ch1_data_reg <= 0;
ch2_data_reg <= 0;
ch3_data_reg <= 0;
ch4_data_reg <= 0;
ch5_data_reg <= 0;
ch6_data_reg <= 0;
ch7_data_reg <= 0;
ch8_data_reg <= 0;
ch1_vol <= 0;
ch2_vol <= 0;
ch3_vol <= 0;
ch4_vol <= 0;
ch5_vol <= 0;
ch6_vol <= 0;
ch7_vol <= 0;
ch8_vol <= 0;
end
else begin  
ch1_data_reg <= ch1_reg * 50000;
ch2_data_reg <= ch2_reg * 50000;
ch3_data_reg <= ch3_reg * 50000;
ch4_data_reg <= ch4_reg * 50000;
ch5_data_reg <= ch5_reg * 50000;
ch6_data_reg <= ch6_reg * 50000;
ch7_data_reg <= ch7_reg * 50000;
ch8_data_reg <= ch8_reg * 50000;

ch1_vol <= ch1_data_reg >> 15;
ch2_vol <= ch2_data_reg >> 15;
ch3_vol <= ch3_data_reg >> 15;
ch4_vol <= ch4_data_reg >> 15;
ch5_vol <= ch5_data_reg >> 15;
ch6_vol <= ch6_data_reg >> 15;
ch7_vol <= ch7_data_reg >> 15;
ch8_vol <= ch8_data_reg >> 15;
end
end

// 16진수를 BCD로 변환하는 모듈 인스턴스화
bcd bcd1_ist(         
.hex           (ch1_vol[17:0]),
.dec           (ch1_dec),
.clk           (clk)
); 

bcd bcd2_ist(         
.hex           (ch2_vol[17:0]),
.dec           (ch2_dec),
.clk           (clk)
); 

bcd bcd3_ist(         
.hex           (ch3_vol[17:0]),
.dec           (ch3_dec),
.clk           (clk)
); 

bcd bcd4_ist(         
.hex           (ch4_vol[17:0]),
.dec           (ch4_dec),
.clk           (clk)
); 

bcd bcd5_ist(         
.hex           (ch5_vol[17:0]),
.dec           (ch5_dec),
.clk           (clk)
); 

bcd bcd6_ist(         
.hex           (ch6_vol[17:0]),
.dec           (ch6_dec),
.clk           (clk)
); 

bcd bcd7_ist(         
.hex           (ch7_vol[17:0]),
.dec           (ch7_dec),
.clk           (clk)
); 

bcd bcd8_ist(         
.hex           (ch8_vol[17:0]),
.dec           (ch8_dec),
.clk           (clk)
);   
endmodule

 

module bcd(
    input clk,             // 클럭 입력
    input [17:0] hex,      // 16비트의 입력 BCD 값
    output [19:0] dec      // 20비트의 10진수 출력
);

wire [17:0] rrhex;         // 16비트의 임시 BCD 값
reg [3:0] rhex[3:0];       // 4비트씩 나눈 BCD 값

reg [18:0] rhexd;          // 19비트 10진수 값
reg [13:0] rhexc;          // 14비트 10진수 값
reg [9:0] rhexb;           // 10비트 10진수 값
reg [3:0] rhexa;           // 4비트 10진수 값

reg [5:0] resa, resb, resc, resd;  // 각 자릿수의 합 결과 레지스터
reg [3:0] rese;                    // 맨 앞 자릿수의 합 결과 레지스터

assign rrhex = hex[17:0];          // 현재 BCD 값을 복사

// BCD 값을 4비트씩 나누어 저장
always @(posedge clk)
begin
    rhex[3] <= rrhex[17:14];
    rhex[2] <= rrhex[13:10];
    rhex[1] <= rrhex[9:6];
    rhex[0] <= rrhex[5:1];
end

// 4비트씩 나눈 BCD 값에 따라 19비트 10진수 값을 결정
always @(posedge clk)
begin
    case(rhex[3])
        4'h0: rhexd <= 19'h00000;
        4'h1: rhexd <= 19'h04096;  // 0x1000 -> 4096
        4'h2: rhexd <= 19'h08192;  // 0x2000 -> 8192
        // ... 중략 ...
        4'hf: rhexd <= 19'h61440;  // 0xf000 -> 61440
        default: rhexd <= 19'h00000;
    endcase
end

// 4비트씩 나눈 BCD 값에 따라 14비트 10진수 값을 결정
always @(posedge clk)
begin
    case(rhex[2])
        // ... 중략 ...
        default: rhexc <= 14'h0000;
    endcase
end 

// 4비트씩 나눈 BCD 값에 따라 10비트 10진수 값을 결정
always @(posedge clk)
begin
    case(rhex[1])
        // ... 중략 ...
        default: rhexb <= 10'h000;
    endcase
end 

// 4비트 10진수 값을 결정
always @(posedge clk)
begin
    rhexa <= rhex[0];
end

// BCD를 10진수로 변환하는 논리 함수 정의
function [5:0] addbcd4; 
    input [3:0] add1, add2, add3, add4;
begin
    addbcd4 = add1 + add2 + add3 + add4;
    // 10보다 큰 경우에는 각 자릿수에 맞게 10진수를 증가
    if (addbcd4 > 6'h1d)
        addbcd4 = addbcd4 + 5'h12;
    else if (addbcd4 > 5'h13)
        addbcd4 = addbcd4 + 4'hc;
    else if (addbcd4 > 4'h9)
        addbcd4 = addbcd4 + 4'h6;
end
endfunction

// BCD 값을 10진수로 변환하여 결과를 출력
always @(posedge clk)
begin   
    resa = addbcd4(rhexa[3:0], rhexb[3:0], rhexc[3:0], rhexd[3:0]);
    resb = addbcd4(resa[5:4], rhexb[7:4], rhexc[7:4], rhexd[7:4]);
    resc = addbcd4(resb[5:4], rhexb[9:8], rhexc[11:8], rhexd[11:8]);
    resd = addbcd4(resc[5:4], 4'h0, rhexc[13:12], rhexd[15:12]);
    rese = resd[5:4] + rhexd[18:16];
end

endmodule