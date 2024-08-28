module Digitron_NumDisplay
(
    CLK, RX_Data, Digitron_Out, DigitronCS_Out
);
    input CLK;
    input [7:0] RX_Data;          // 8位数据输入
    output [7:0] Digitron_Out;    // 数码管段选信号
    output [3:0] DigitronCS_Out;  // 数码管片选信号

    parameter T1MS = 16'd50000;   // 定义1ms的时间
    reg [15:0] Count;
    reg [1:0] cnt;


    // 定时器，用于生成扫描计数
    always @ (posedge CLK)
    begin    
        if(Count == T1MS)
        begin
            Count <= 16'd0;
            if(cnt == 2'b10) // 修改为2'b10以适应3个数码管的需求
                cnt <= 2'b00;
            else 
                cnt <= cnt + 1'b1;                    
        end
        else
            Count <= Count + 1'b1;                   
    end

    reg [3:0] W_DigitronCS_Out;
             
    always @(cnt)
    begin
        case (cnt)
            2'b00: W_DigitronCS_Out = 4'b1110; // 选择第一个数码管
            2'b01: W_DigitronCS_Out = 4'b1101; // 选择第二个数码管
            2'b10: W_DigitronCS_Out = 4'b1011; // 选择第三个数码管
        endcase
    end

    // 提取RX_Data的百位、十位、个位
    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] units;
    
    assign hundreds = (RX_Data >= 100) ? RX_Data / 100 : 4'h0;
    assign tens = (RX_Data >= 10) ? (RX_Data % 100) / 10 : 4'h0;
    assign units = RX_Data % 10;

    reg [3:0] SingleNum;
    reg [7:0] W_Digitron_Out;
    
    parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
              _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
              _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
              _9 = 8'b0110_1111, _10 = 8'b0000_0000; // 空白
    
    // 根据当前选择的数码管片选信号，决定显示哪个数字
    always @(cnt)
    begin
        case (cnt)
            2'b00: SingleNum = units;    // 第一个数码管显示个位数
            2'b01: SingleNum = tens;     // 第二个数码管显示十位数
            2'b10: SingleNum = hundreds; // 第三个数码管显示百位数
        endcase
        
        case (SingleNum)
            4'h0: W_Digitron_Out = _0;
            4'h1: W_Digitron_Out = _1;
            4'h2: W_Digitron_Out = _2;
            4'h3: W_Digitron_Out = _3;
            4'h4: W_Digitron_Out = _4;
            4'h5: W_Digitron_Out = _5;
            4'h6: W_Digitron_Out = _6;
            4'h7: W_Digitron_Out = _7;
            4'h8: W_Digitron_Out = _8;
            4'h9: W_Digitron_Out = _9;
            default: W_Digitron_Out = _10; // 显示空白
        endcase
    end
    
    assign Digitron_Out = W_Digitron_Out;
    assign DigitronCS_Out = W_DigitronCS_Out;
        
endmodule
