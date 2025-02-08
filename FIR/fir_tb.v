`timescale 1ns/10ps

module fir_tb();

localparam CORDIC_CLK_PERIOD = 2;               // 500MHz CORDIC 샘플링 클럭을 생성하기 위한 값
localparam FIR_CLK_PERIOD = 10;                 // 100MHz FIR lowpass 필터 샘플링 클럭을 생성하기 위한 값
localparam signed [15:0] PI_POS = 16'h6488;     // 고정 소수점 1.2.13 형식의 +pi
localparam signed [15:0] PI_NEG = 16'h9B78;     // 고정 소수점 1.2.13 형식의 -pi
localparam PHASE_INC_2MHZ = 200;                // 2MHz 사인 파형 합성을 위한 위상 증가량
localparam PHASE_INC_30MHZ = 3000;              // 30MHz 사인 파형 합성을 위한 위상 증가량

reg cordic_clk = 1'b0;
reg fir_clk = 1'b0;
reg phase_tvalid = 1'b0;
reg signed [15:0] phase_2MHz = 0;
reg signed [15:0] phase_30MHz = 0;
wire sincos_2MHz_tvalid;
wire signed [15:0] sin_2MHz, cos_2MHz;
wire sincos_30MHz_tvalid;
wire signed [15:0] sin_30MHz, cos_30MHz;

reg signed [15:0] noisy_signal = 0;
wire signed [15:0] filtered_signal;

// 2MHz 사인 파형을 생성
cordic_0 cordic_inst_0(
    .aclk                   (cordic_clk),
    .s_axis_phase_tvalid    (phase_tvalid),
    .s_axis_phase_tdata     (phase_2MHz),
    .m_axis_dout_tvalid     (sincos_2MHz_tvalid),
    .m_axis_dout_tdata      ({sin_2MHz, cos_2MHz})
);

// 30MHz 사인 파형을 생성
cordic_0 cordic_inst_1(
    .aclk                   (cordic_clk),
    .s_axis_phase_tvalid    (phase_tvalid),
    .s_axis_phase_tdata     (phase_30MHz),
    .m_axis_dout_tvalid     (sincos_30MHz_tvalid),
    .m_axis_dout_tdata      ({sin_30MHz, cos_30MHz})
);

// 위상을 변경하여 2MHz와 30MHz를 합성
always@(posedge cordic_clk)
begin
    phase_tvalid <= 1'b1;
    
    // 2MHz 사인 파형을 합성하기 위한 위상 변경
    if(phase_2MHz + PHASE_INC_2MHZ < PI_POS) begin
        phase_2MHz <= phase_2MHz + PHASE_INC_2MHZ;
    end
    else begin
        phase_2MHz <= PI_NEG + (phase_2MHz + PHASE_INC_2MHZ - PI_POS);
    end
    
    // 30MHz 사인 파형을 합성하기 위한 위상 변경
    if(phase_30MHz + PHASE_INC_30MHZ <= PI_POS) begin
        phase_30MHz <= phase_30MHz + PHASE_INC_30MHZ;
    end
    else begin
        phase_30MHz <= PI_NEG + (phase_30MHz + PHASE_INC_30MHZ - PI_POS);
    end
end

// 500MHz Cordic 클럭 생성
always begin
    cordic_clk = #(CORDIC_CLK_PERIOD/2) ~cordic_clk;
end

// 100MHz FIR 클럭 생성
always begin
    fir_clk = #(FIR_CLK_PERIOD/2) ~fir_clk;
end

// 노이지 신호 = 2MHz 사인 + 30MHz 사인
// 노이지 신호는 100MHz FIR 샘플링 속도에서 다시 샘플링됨
always @(posedge fir_clk)
begin
    noisy_signal <= (sin_2MHz + sin_30MHz) / 2;
end

// FIR lowpass 필터에 노이지 신호 공급
fir fir_inst(
    .clk            (fir_clk),
    .noisy_signal   (noisy_signal),
    .filtered_signal(filtered_signal)
);

endmodule