module uart(
    input clk50,       // 50MHz 클럭 입력
    input reset_n,     // 리셋 신호, active-low
    
    input [17:0] ch1_dec,
    input [17:0] ch2_dec,
    input [17:0] ch3_dec,
    input [17:0] ch4_dec,
    input [17:0] ch5_dec,
    input [17:0] ch6_dec,
    input [17:0] ch7_dec,
    input [17:0] ch8_dec,    
    
    input [7:0] ch1_sig,
    input [7:0] ch2_sig,
    input [7:0] ch3_sig,
    input [7:0] ch4_sig,
    input [7:0] ch5_sig,
    input [7:0] ch6_sig,
    input [7:0] ch7_sig,
    input [7:0] ch8_sig,
    
    output tx           // UART 전송 출력
);

/********************************************/
// 상수 및 문자열 정의
/********************************************/
reg [7:0] uart_ad [113:0];  // ASCII 문자를 저장하는 배열
/********************************************/
// UART 전송을 위한 상태 머신
/********************************************/
reg [15:0] uart_cnt;  // UART 전송을 제어하기 위한 카운터
reg [2:0] uart_stat;  // UART 전송 상태

reg [7:0] txdata;      // 전송할 데이터
reg wrsig;             // UART 전송 신호

reg [8:0] k;           // 인덱스 카운터

reg [15:0] Time_wait;  // 대기 시간을 설정하는 카운터

always @(clk)
begin
    // 상태가 000일 때 ASCII 문자 설정
    if(uart_stat==3'b000) begin
        uart_ad[0]<=65;  // 'A'
        uart_ad[1]<=68;  // 'D'
        // ... (각 채널 및 문자 설정)
        uart_ad[113]<=13; // 캐리지 리턴 (CR)
    end
    // ... (다른 상태에 대한 설정)
end



always @(posedge clk)
begin
    // 리셋 시 초기화
    if(!reset_n) begin
        uart_cnt <= 0;
        uart_stat <= 3'b000;
        k <= 0;
    end
    else begin
        // 상태 머신
        case(uart_stat)
            // 상태 000: 대기 상태
            3'b000: begin
                // 대기 시간이 16비트 최댓값에 도달하면 상태 변경
                if (Time_wait == 16'hffff) begin
                    uart_stat <= 3'b001;
                    Time_wait <= 0;
                end
                else begin
                    uart_stat <= 3'b000;
                    Time_wait <= Time_wait + 1'b1;
                end
            end
            // ... (다른 상태에 대한 설정)
        endcase
    end
end

/********** 클럭 분주 모듈 ***********/
clkdiv u0 (
    .clk50 (clk50),
    .clkout (clk)
);

/************* UART 전송 모듈 ************/
uarttx u1 (
    .clk (clk),
    .datain (txdata),
    .wrsig (wrsig),
    .idle (idle),
    .tx (tx)
);

endmodule