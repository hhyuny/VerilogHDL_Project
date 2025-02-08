`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    clkdiv 
//50MHz의 입력 클럭(clk50)을 받아서 분주된 클럭(clkout)을 만드는 Verilog 모듈입니다. 
//50MHz의 클럭을 이용하여 162 사이클 동안 클럭을 높은 상태로 유지한 후, 
//그 다음 163 사이클 동안 클럭을 낮은 상태로 유지하여 출력 클럭을 생성합니다. 
//이러한 동작을 반복하면서 50MHz 클럭을 분주하여 새로운 클럭을 만듭니다.
//////////////////////////////////////////////////////////////////////////////////
module clkdiv(clk50, clkout);
input clk50;            // 50MHz 클럭 입력
output clkout;          // 분주된 클럭 출력
reg clkout;             // 출력된 클럭 레지스터
reg [15:0] cnt;          // 16비트 카운터

always @(posedge clk50) // 50MHz 클럭의 상승 에지에서 동작
begin
  if(cnt == 16'd162)    // 카운터 값이 162인 경우
  begin
    clkout <= 1'b1;     // 출력 클럭을 높은 상태로 설정
    cnt <= cnt + 16'd1;  // 카운터를 1 증가
  end
  else if(cnt == 16'd325) // 카운터 값이 325인 경우
  begin
    clkout <= 1'b0;      // 출력 클럭을 낮은 상태로 설정
    cnt <= 16'd0;        // 카운터를 초기화
  end
  else
  begin
    cnt <= cnt + 16'd1;  // 그 외의 경우에는 카운터를 1 증가
  end
end
endmodule