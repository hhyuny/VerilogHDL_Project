module fir(
    input clk,                                  // 100MHz 샘플링 클럭
    input signed [15:0] noisy_signal,           // 필터링할 노이지 신호, 1.1.14
    output signed [15:0] filtered_signal        // 필터링된 출력 신호, 1.1.14
    );

    integer i, j;
// 9-tap FIR 필터에 대한 계수, 1.1.14
// 100MHz 샘플링 속도에서 약 10MHz의 컷오프 주파수
reg signed [15:0] coeff [0:8] = {16'h04F6,
                                 16'h0AE4,
                                 16'h1089,
                                 16'h1496,
                                 16'h160F,
                                 16'h1496,
                                 16'h1089,
                                 16'h0AE4,
                                 16'h04F6};
                                 
reg signed [15:0] delayed_signal [0:8];
reg signed [31:0] prod [0:8];                   // 1.3.28                  
reg signed [32:0] sum_0 [0:4];                  // 1.4.28
reg signed [33:0] sum_1 [0:2];                  // 1.5.28
reg signed [34:0] sum_2 [0:1];                  // 1.6.28
reg signed [35:0] sum_3;                        // 1.7.28

// 노이지 신호를 9개의 딜레이된 레지스터에 넣어 준비
always@(posedge clk)
begin
    delayed_signal[0] <= noisy_signal;
    for(i=1; i<=8; i=i+1) begin
        delayed_signal[i] <= delayed_signal[i-1];
    end
end

// 파이프라인화된 곱셈과 누적
always@(posedge clk)
begin
    for(j=0; j<=8; j=j+1) begin
        prod[j] <= delayed_signal[j] * coeff[j];
    end
end
    
always@(posedge clk)
begin
    sum_0[0] <= prod[0] + prod[1];
    sum_0[1] <= prod[2] + prod[3];
    sum_0[2] <= prod[4] + prod[5];
    sum_0[3] <= prod[6] + prod[7];
    sum_0[4] <= prod[8]; 
end

always@(posedge clk)
begin
    sum_1[0] <= sum_0[0] + sum_0[1];
    sum_1[1] <= sum_0[2] + sum_0[3];
    sum_1[2] <= sum_0[4];
end
    
always@(posedge clk)
begin
    sum_2[0] <= sum_1[0] + sum_1[1];
    sum_2[1] <= sum_1[2];    
end

always@(posedge clk)
begin
    sum_3 <= sum_2[0] + sum_2[1];
end

// 필터링된 출력 신호, 1.1.14
assign filtered_signal = $signed(sum_3[35:14]);

endmodule