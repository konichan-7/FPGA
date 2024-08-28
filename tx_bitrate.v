module tx_bitrate
(
    CLK, RSTn, Count_Sig , tx_BPS_CLK
);

     input CLK;
	 input RSTn;
	 input Count_Sig;
	 output tx_BPS_CLK; //synthesis keep;
	 
	 /***************************/
	 
	 reg [12:0]Count_BPS;
	 parameter BPS_T = 13'd52;					// 500KHZ/9600 = 13'd52
	 
	 always @ ( posedge CLK or negedge RSTn)
	   if( !RSTn )
		    Count_BPS <= 13'd0;
		else if( Count_BPS == BPS_T - 1 ) 
		    Count_BPS <= 13'd0;
		else if( Count_Sig )	// 在顶层文件中，Count_Sig直连TX_EN_Sig
		    Count_BPS <= Count_BPS + 1'b1;
		else
		    Count_BPS <= 13'd0;
			  
	 /********************************/
    
    assign tx_BPS_CLK = ( Count_BPS == 12'd26 ) ? 1'b1 : 1'b0;

    /*********************************/


endmodule
