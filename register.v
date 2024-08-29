module register (
    input CLK,
    input RSTn,
    input [3:0] rdata,
    output [11:0] display,
    output [3:0] error_count,
    output correct
);
    reg [11:0] rdisplay;
    reg [3:0] rdata_reg; // 用于寄存上一个rdata值
    reg rdata_updated; // 用于检测rdata是否更新
    reg [3:0] error;
    reg rcorrect;

    parameter password = 12'b000000010010; // 正确密码

    // 在每个时钟上升沿或复位时进行操作
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            rdisplay <= 12'b0;
            rdata_reg <= 4'b0;
            error <= 4'b0;
            rdata_updated <= 1'b0;
            rcorrect <= 1'b0;
        end else begin
            if (rdata != rdata_reg) begin
                rdata_updated <= 1'b1; // 如果rdata更新，则设置更新标志
                rdata_reg <= rdata;    // 更新寄存的rdata值
            end else begin
                rdata_updated <= 1'b0; // 否则，清除更新标志
            end

            if (rdata_updated) begin
                if (rdata == 4'b1111) begin
                    // 检测到按键15按下，进行密码比较
                    if (rdisplay == password) begin
                        rdisplay <= 12'b0; // 密码正确，清零display
                        error <= 4'b0; // 清零错误次数
                        rcorrect <= 1'b1;
                    end else begin
                        error <= error + 1; // 密码错误，次数加1
                        rcorrect <= 1'b0;
                    end
                end else begin
                    // 否则，将输入的rdata移位到rdisplay中
                    rdisplay <= {rdisplay[7:0], rdata};
                end
            end
        end
    end

    assign display = rdisplay; // display输出当前的rdisplay内容
    assign error_count = error;
    assign correct = rcorrect;

endmodule
