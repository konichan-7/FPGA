module led
(
    CLK, start, LED_Out
);

    input CLK;
    input start;
    output [7:0] LED_Out;
    
    parameter T100MS = 23'd2_500_000; // 延时
    parameter T2S = 32'd100_000_000;   // 延时
    reg [31:0] Count;                // 100ms延时计数器
    reg [31:0] Timer2s;              // 2秒计时器
    reg [7:0] rLED_Out;
    
    always @ (posedge CLK or negedge start)
    begin
        if (!start)
        begin
            Count <= 32'd0;
            Timer2s <= 32'd0;
            rLED_Out <= 8'b0000_0000;
        end
        else if (Count == T100MS - 1'b1)
        begin
            Count <= 32'd0;
            if (rLED_Out == 8'b0000_0000)
                rLED_Out <= 8'b0000_1111;
            else
                rLED_Out <= {rLED_Out[0], rLED_Out[7:1]};
        end
        else
        begin
            Count <= Count + 1'b1;
            // 增加2秒计时器逻辑
            if (Timer2s < T2S - 1'b1)
                Timer2s <= Timer2s + 1'b1;
            else
            begin
                // 2秒计时结束，停止流水灯
                Count <= 32'd0;
                rLED_Out <= 8'b0000_0000;
            end
        end
    end
    
    assign LED_Out = rLED_Out;
    
endmodule