module Digitron_TimeDisplay_module
(
	CLK, display,error_count, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input [11:0]display;	
     input [3:0]error_count;
	 output [7:0]Digitron_Out; 
	 output [3:0]DigitronCS_Out;

     parameter T1MS = 16'd50000;
	 reg [15:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [3:0]W_DigitronCS_Out;
	 reg [1:0]cnt ;
     parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111, _Ri= 8'b0111_1111;
				 	
	
   // 定时器，用于生成扫描计数
    always @ (posedge CLK)
    begin    
        if(Count == T1MS)
        begin
            Count <= 16'd0;
            if(cnt == 2'b11) // 修改为2'b10以适应3个数码管的需求
                cnt <= 2'b00;
            else 
                cnt <= cnt + 1'b1;                    
        end
        else
            Count <= Count + 1'b1;                   
    end
			
    always @(cnt)
    begin
        case (cnt)
            2'b00: W_DigitronCS_Out = 4'b1110; // 选择第一个数码管
            2'b01: W_DigitronCS_Out = 4'b1101; // 选择第二个数码管
            2'b10: W_DigitronCS_Out = 4'b1011; // 选择第三个数码管
            2'b11: W_DigitronCS_Out = 4'b0111;
        endcase
    end
	 
	 always@(cnt)
	 begin

			case(cnt)
				2'b00: SingleNum = display[3:0];    
                2'b01: SingleNum = display[7:4];   
                2'b10: SingleNum = display[11:8];
                2'b11: SingleNum = error_count;
			endcase		
            		
			case(SingleNum)
            	4'h0 : W_Digitron_Out = 8'h3f;
            	4'h1 : W_Digitron_Out = 8'h06;
            	4'h2 : W_Digitron_Out = 8'h5b;
            	4'h3 : W_Digitron_Out = 8'h4f;
            	4'h4 : W_Digitron_Out = 8'h66;
            	4'h5 : W_Digitron_Out = 8'h6d;
            	4'h6 : W_Digitron_Out = 8'h7d;
            	4'h7 : W_Digitron_Out = 8'h07;
            	4'h8 : W_Digitron_Out = 8'h7f;
            	4'h9 : W_Digitron_Out = 8'h6f;
            	4'ha : W_Digitron_Out = 8'h77;
            	4'hb : W_Digitron_Out = 8'h7c;
            	4'hc : W_Digitron_Out = 8'h39;
            	4'hd : W_Digitron_Out = 8'h5e;
            	4'he : W_Digitron_Out = 8'h79;
            	4'hf : W_Digitron_Out = 8'h71;
            	default :W_Digitron_Out = 8'h00;
			endcase
	 end
	 
	 assign Digitron_Out = W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	 
endmodule