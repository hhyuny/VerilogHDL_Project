module ad7606c18(
   input          clk,              // 50MHz 클럭
   input          rst_n,            // 리셋 신호 (Active Low)

   input [15:0]   ad_data,          // AD7606에서 변환된 아날로그 데이터
   input          ad_busy,          // AD 변환이 완료되었는지 여부를 나타내는 신호
   input          first_data,       // AD 변환 시작 시 초기화를 나타내는 신호

   output [2:0]   ad_os,            // AD7606의 오버샘플링 모드 설정 (항상 000)
   output reg     ad_cs,            // AD7606 Chip Select
   output reg     ad_rd,            // AD7606 AD 데이터 읽기
   output reg     ad_reset,         // AD7606 AD 리셋
   output reg     ad_convstab,      // AD7606 AD 변환 시작
   output reg     [4:0] state,

   output reg [17:0] ad_ch1,         // AD 채널 1 데이터 (18비트로 수정)
   output reg [17:0] ad_ch2,         // AD 채널 2 데이터 (18비트로 수정)
   output reg [17:0] ad_ch3,         // AD 채널 3 데이터 (18비트로 수정)
   output reg [17:0] ad_ch4,         // AD 채널 4 데이터 (18비트로 수정)
   output reg [17:0] ad_ch5,         // AD 채널 5 데이터 (18비트로 수정)
   output reg [17:0] ad_ch6,         // AD 채널 6 데이터 (18비트로 수정)
   output reg [17:0] ad_ch7,         // AD 채널 7 데이터 (18비트로 수정)
   output reg [17:0] ad_ch8          // AD 채널 8 데이터 (18비트로 수정)
);

reg [16:0] cnt;   // 카운터 레지스터
reg [5:0] i;       // 인덱스 레지스터


parameter IDLE=      0;
parameter AD_CONV=   1;
parameter Wait_1=    2;
parameter Wait_busy= 3;
parameter READ_CH1_1=4;
parameter READ_CH1_2=5;
parameter READ_CH2_1=6;
parameter READ_CH2_2=7;
parameter READ_CH3_1=8;
parameter READ_CH3_2=9;
parameter READ_CH4_1=10;
parameter READ_CH4_2=11;
parameter READ_CH5_1=12;
parameter READ_CH5_2=13;
parameter READ_CH6_1=14;
parameter READ_CH6_2=15;
parameter READ_CH7_1=16;
parameter READ_CH7_2=17;
parameter READ_CH8_1=18;
parameter READ_CH8_2=19;
parameter READ_DONE= 20;

assign ad_os=3'b000;  // AD7606의 오버샘플링 모드 항상 000으로 설정

// AD 레지스터 초기화
always @(posedge clk)
begin
   if(cnt < 16'hffff) begin
      cnt <= cnt + 1;
      ad_reset <= 1'b1;
   end
   else
      ad_reset <= 1'b0;
end

// AD7606 동작 상태 머신
always @(posedge clk)
begin
   if(ad_reset == 1'b1) begin
      // 리셋 시 초기화
      state <= IDLE;
      ad_ch1 <= 0;
      ad_ch2 <= 0;
      ad_ch3 <= 0;
      ad_ch4 <= 0;
      ad_ch5 <= 0;
      ad_ch6 <= 0;
      ad_ch7 <= 0;
      ad_ch8 <= 0;
      ad_cs <= 1'b1;
      ad_rd <= 1'b1;
      ad_convstab <= 1'b1;
      i <= 0;
   end
   else begin
      // 상태 머신 동작
      case(state)
         IDLE: begin
            // IDLE 상태에서 초기화를 위해 20 클럭 동안 대기
            ad_cs <= 1'b1;
            ad_rd <= 1'b1;
            ad_convstab <= 1'b0;
            if(i == 20) begin
               i <= 0;
               state <= AD_CONV;
            end
            else
               i <= i + 1'b1;
         end
         AD_CONV: begin
            // AD 변환 시작 후 2 클럭 동안 대기
            if(i == 2) begin
               i <= 0;
               state <= Wait_1;
               ad_convstab <= 1'b1;
            end
            else begin
               i <= i + 1'b1;
               ad_convstab <= 1'b0;
            end
         end
         Wait_1: begin
            // 5 클럭 대기 후 AD 변환이 완료되면 다음 단계로
            if(i == 5) begin
               i <= 0;
               state <= Wait_busy;
            end
            else
               i <= i + 1'b1;
         end
         Wait_busy: begin
            // AD 변환이 완료되면 다음 단계로
            if(ad_busy == 1'b0) begin
               i <= 0;
               state <= READ_CH1_1;
            end
         end
         READ_CH1_1: begin
            // 각 채널별로 데이터 읽기, 6 클럭 동안 대기
            if(i == 3) begin
               ad_rd <= 1'b1;
               i <= 0;
               ad_ch1[17:2] <= {ad_data[15:00]}; 
               ad_cs <= 1'b1;
               state <= READ_CH1_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH1_2: begin
            // 채널 2 데이터 읽기
            if(i == 3) begin
               ad_ch1[1:0] <= {ad_data[0], ad_data[1]};
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               state <= READ_CH2_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH2_1: begin
            // 채널 3 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch2[17:2] <= {ad_data[15:00]}; 
               state <= READ_CH2_2;
            end
            else begin
               ad_rd <= 1'b0;
               ad_cs <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH2_2: begin
            // 채널 4 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch2[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_CH3_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH3_1: begin
            // 채널 5 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch3[17:2] <= {ad_data[15:00]}; 
               state <= READ_CH3_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH3_2: begin
            // 채널 6 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch3[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_CH4_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH4_1: begin
            // 채널 7 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch4[17:2] <= {ad_data[15:00]}; 
               state <= READ_CH4_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH4_2: begin
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch4[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_CH5_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH5_1: begin
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch5[17:2] <= {ad_data[15:00]}; 
               state <= READ_CH5_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH5_2: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               i <= 0;
               ad_ch5[1:0] <= {ad_data[0], ad_data[1]};
               ad_cs <= 1'b1;
               state <= READ_CH6_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH6_1: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch6[17:2] <= {ad_data[15:00]}; 
               state <= READ_CH6_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH6_2: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch6[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_CH7_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH7_1: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch7[17:2] <= {ad_data[15:00]};  
               state <= READ_CH7_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH7_2: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch7[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_CH8_1;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH8_1: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch8[17:2] <= {ad_data[15:00]};  
               state <= READ_CH8_2;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_CH8_2: begin
            // 채널 8 데이터 읽기
            if(i == 3) begin
               ad_rd <= 1'b1;
               ad_cs <= 1'b1;
               i <= 0;
               ad_ch8[1:0] <= {ad_data[0], ad_data[1]};
               state <= READ_DONE;
            end
            else begin
               ad_cs <= 1'b0;
               ad_rd <= 1'b0;
               i <= i + 1'b1;
            end
         end
         READ_DONE: begin
            // 데이터 읽기 완료 후 IDLE 상태로
            ad_cs <= 1'b1;
            ad_rd <= 1'b1;
            ad_convstab <= 1'b1;
            state <= IDLE;
         end
      endcase
   end
end

endmodule