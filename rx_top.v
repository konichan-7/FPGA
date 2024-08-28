module rx_top
(
    CLK, RSTn, RX_Pin_In, RX_En_Sig, TX_Pin_Out, LED_Out, Digitron_Out, DigitronCS_Out
);

    input CLK;
    input RSTn;              // SW0
    input RX_Pin_In;         // F12
    input RX_En_Sig;         // SW1
	 
    output TX_Pin_Out;
    output [7:0] LED_Out;    // LED7-LED0
    output [7:0] Digitron_Out; 
    output [3:0] DigitronCS_Out;

    wire TX_Done_Sig;
    wire neg_sig;            // synthesis keep
    wire BPS_CLK;            // synthesis keep
    wire tx_BPS_CLK;
    wire Count_Sig;          // synthesis keep
    wire RX_Done_Sig;        // synthesis keep
    wire [7:0] RX_Data;  
    wire [7:0] TX_Data;
    wire TX_Data_Valid;       // synthesis keep
	 
    reg CLK_500K;            // synthesis keep
    reg [9:0] cnt2;

    // 产生500K时钟
    always @ (posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            cnt2 <= 10'd0;
            CLK_500K <= 1'b0;
        end else if (cnt2 == 10'd49) begin
            cnt2 <= 10'd0;
            CLK_500K <= ~CLK_500K;
        end else begin
            cnt2 <= cnt2 + 1'b1;
        end
    end
	 
    /**********************************/
    detect_module U1
    (
        .CLK(CLK_500K),
        .RSTn(RSTn),
        .RX_Pin_In(RX_Pin_In),   // input - from top
        .neg_sig(neg_sig)        // output - to U3
    );
	
    /**********************************/
    rx_bps_module U2
    (
        .CLK(CLK_500K),
        .RSTn(RSTn),
        .Count_Sig(Count_Sig),   // input - from U3
        .BPS_CLK(BPS_CLK)        // output - to U3
    );	 
	
    /**********************************/
    rx_control_module U3
    (
        .CLK(CLK_500K),
        .RSTn(RSTn),
        .neg_sig(neg_sig),       // input - from U1
        .RX_En_Sig(RX_En_Sig),   // input - from top
        .RX_Pin_In(RX_Pin_In),   // input - from top
        .BPS_CLK(BPS_CLK),       // input - from U2
        .Count_Sig(Count_Sig),   // output - to U2
        .RX_Data(RX_Data),       // output - to U4
        .RX_Done_Sig(RX_Done_Sig)// output - to U4		  
    );
	 
    /************************************/
    LED_display_module U4
    (
        .CLK(CLK_500K),	
        .RSTn(RSTn),	
        .RX_Done_Sig(RX_Done_Sig), // input - from U3 
        .RX_Data(RX_Data),         // input - from U3
        .LED_Out(LED_Out)          // output - to top
    );
	  
    /************************************/
    Digitron_NumDisplay U5
    (
        .CLK(CLK),
        .RX_Data(RX_Data),            // input [3:0] - from U3
        .Digitron_Out(Digitron_Out),  // output - to top	
        .DigitronCS_Out(DigitronCS_Out) // output - to top	
    );
    
    calculate_rx U6
    (
        .CLK(CLK_500K),
        .RSTn(RSTn),
        .RX_Done_Sig(RX_Done_Sig),     // input - from U3
        .TX_Done_Sig(TX_Done_Sig),
        .RX_Data(RX_Data),             // input - from U3
        .TX_Data_Valid(TX_Data_Valid), // output - to U7
        .TX_Data(TX_Data)              // output - to U8
    );
    
    tx_bitrate U7
    (
      	.CLK(CLK_500K),
		.RSTn(RSTn),
		.Count_Sig(TX_Data_Valid),   // input - from U6
		.tx_BPS_CLK(tx_BPS_CLK) 
    );
    
    
    /************************************/
    uart_tx U8
    (
        .CLK(CLK_500K),
        .tx_BPS_CLK(tx_BPS_CLK),	
        .RSTn(RSTn),
        .TX_Data_Valid(TX_Data_Valid),
        .TX_Data(TX_Data),
        .TX_Pin_Out(TX_Pin_Out),     // output - to top 	
    	.TX_Done_Sig(TX_Done_Sig)
    );
   
endmodule
