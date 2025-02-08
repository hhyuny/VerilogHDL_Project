`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    uarttx 
//UART 통신에서 데이터를 전송하는 모듈을 구현한 Verilog 코드입니다. 
//cnt라는 8비트 카운터를 사용하여 데이터 비트와 스톱 비트를 제어하며, 
//paritymode에 따라 패리티 비트를 계산합니다.
//////////////////////////////////////////////////////////////////////////////////
module uarttx(clk, datain, wrsig, idle, tx);
input clk;                // UART 클럭 입력
input [7:0] datain;       // 전송할 8비트 데이터 입력
input wrsig;              // 전송 신호 (1 사이클 동안 유효)
output idle;              // 전송이 끝났을 때 high, 전송 중일 때 low
output tx;                // UART 전송 데이터 출력
reg idle, tx;              // 전송 상태 및 출력 데이터 레지스터
reg send;                  // 전송 중인지 여부를 나타내는 레지스터
reg wrsigbuf, wrsigrise;   // wrsig 신호와 그 변화 여부를 나타내는 레지스터
reg presult;               // 패리티 비트 계산 결과를 나타내는 레지스터
reg[7:0] cnt;              // 8비트 전송을 위한 카운터
parameter paritymode = 1'b0; // 패리티 모드 (0: 짝수 패리티, 1: 홀수 패리티)

// wrsig 신호와 그 변화 여부를 나타내는 레지스터 업데이트
always @(posedge clk)
begin
   wrsigbuf <= wrsig;
   wrsigrise <= (~wrsigbuf) & wrsig;
end

// 전송 동작을 수행하는 블록
always @(posedge clk)
begin
  if (wrsigrise && (~idle))  // wrsig가 상승 에지에서 변하고 현재 전송이 끝나지 않았을 때
  begin
     send <= 1'b1;           // 전송 시작
  end
  else if(cnt == 8'd168)     // 8비트 전송이 끝나면
  begin
     send <= 1'b0;           // 전송 종료
  end
end

// 전송 동작을 수행하는 블록
always @(posedge clk)
begin
  if(send == 1'b1)  begin
    case(cnt)               // 카운터 값에 따라 동작 수행
    8'd0: begin
         tx <= 1'b0;
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd16, 8'd32, 8'd48, 8'd64, 8'd80, 8'd96, 8'd112, 8'd128: begin
         tx <= datain[cnt/16];  // 데이터 비트 설정
         presult <= datain[cnt/16] ^ presult;  // 패리티 비트 계산
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd144: begin
         tx <= presult;        // 패리티 비트 설정
         presult <= datain[0] ^ paritymode;  // 다음 패리티 비트 계산을 위한 초기화
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd160: begin
         tx <= 1'b1;           // 스톱 비트 설정
         idle <= 1'b1;
         cnt <= cnt + 8'd1;
    end
    8'd168: begin
         tx <= 1'b1;           // 스톱 비트 설정
         idle <= 1'b0;         // 전송 종료 상태 설정
         cnt <= cnt + 8'd1;
    end
    default: begin
          cnt <= cnt + 8'd1;
    end
   endcase
  end
  else  begin
    tx <= 1'b1;
    cnt <= 8'd0;
    idle <= 1'b0;
  end
end
endmodule