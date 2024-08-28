module uart_tx
(
    CLK, tx_BPS_CLK, RSTn, TX_Data_Valid, TX_Data,TX_Done_Sig, TX_Pin_Out
);

    input CLK;             // 50M系统时钟
    input tx_BPS_CLK;         // 波特率时钟
    input RSTn;            // 复位信号
    input TX_Data_Valid;   // 数据有效信号
    input [7:0] TX_Data;   // 发送的8位数据

    output TX_Done_Sig;
    output TX_Pin_Out; // 串口发送数据线

    /********************************************************/

    reg [3:0] State;
    reg rTX;               // "r" means register            
    reg isDone;

    always @ (posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            State <= 4'd0;
            rTX <= 1'b1;
            isDone <= 1'b0;
        end else if (TX_Data_Valid) begin // While TX_Data_Valid = 1, Transmit is Allowed 
            case (State)
                4'd0 : // TX从高到低，发送起始位
                    if (tx_BPS_CLK) begin 
                        State <= State + 1'b1; 
                        rTX <= 1'b0;
                    end
                 
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8 : // TX由低位到高位发送TX_Data
                    if (tx_BPS_CLK) begin 
                        State <= State + 1'b1;
                        rTX <= TX_Data[State - 4'd1]; // Transmit TX_Data[0] - TX_Data[7]
                    end
                 
                4'd9 : // 发送停止位
                    if (tx_BPS_CLK) begin 
                        State <= State + 1'b1;
                        rTX <= 1'b1;
                    end
                             
                4'd10 : // 保持停止位
                    if (tx_BPS_CLK) begin 
                        State <= State + 1'b1; 
                        rTX <= 1'b1;
                    end
                 
                4'd11 : // 完成发送
                    if (tx_BPS_CLK) begin 
                        State <= State + 1'b1; 
                        isDone <= 1'b1; 
                    end
                 
                4'd12 : // 重置状态
                    begin 
                        State <= 4'd0; 
                        isDone <= 1'b0; 
                    end
            endcase
        end else begin
            rTX <= rTX;
        end
    end

    /********************************************************/
     
    assign TX_Pin_Out = rTX;
    assign TX_Done_Sig = isDone;
    /*********************************************************/

endmodule
