module calculate_rx
(
    CLK, RSTn, RX_Done_Sig, TX_Done_Sig, RX_Data, TX_Data, TX_Data_Valid
);
    input CLK;
    input RSTn;
    input RX_Done_Sig;
    input TX_Done_Sig;
    input [7:0] RX_Data;       // 8位数据输入
    
    output [7:0] TX_Data;      // 8位数据输出
    output TX_Data_Valid;      // 有效信号输出

    reg [15:0] sum;            // 用于累加的寄存器
    reg [1:0] sample_count;    // 计数器，记录输入次数
    reg [7:0] rTX_Data;
    reg rTX_Data_Valid;

    // 在复位信号时进行初始化
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            sum <= 16'd0;
            sample_count <= 2'b00;
            rTX_Data_Valid <= 1'b0;
        end else if (RX_Done_Sig) begin
            if (sample_count == 2'b11) begin
                rTX_Data <= sum / 3;      // 计算平均值
                rTX_Data_Valid <= 1'b1;   // 输出有效信号
                sum <= 16'd0;             // 重置累加器
                sample_count <= 2'b00;    // 重置计数器
            end else begin
                sum <= sum + RX_Data;     // 累加RX_Data
                sample_count <= sample_count + 1'b1;
                rTX_Data_Valid <= 1'b0;   // 在未完成计算前保持无效
            end
        end else if (TX_Done_Sig) begin
            rTX_Data_Valid <= 1'b0;       // 发送完成后无效
        end
    end
    
    assign TX_Data = rTX_Data;
    assign TX_Data_Valid = rTX_Data_Valid;
    
endmodule
