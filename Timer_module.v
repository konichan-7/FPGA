module Timer_module
(	
	RSTn, CLK, Timer_Start, TimerH, TimerL, Buzzer_TimeOver
);
	 input RSTn;
	 input CLK; 
	 input Timer_Start;
	 output reg [3:0]TimerH;
	 output reg [3:0]TimerL;
	 output reg Buzzer_TimeOver;	 

	 reg count1=0;
	 reg CLK1; 
     reg CLK05;
	 reg [24:0]Count;
     reg [24:0]Count2;
	 parameter T1S = 25'd25_000_000;
     parameter T05S = 25'd12_500_000;		

	//产生1hz的时钟
	always @ ( posedge CLK or negedge Timer_Start )
		begin 
			if( !Timer_Start )
				Count <= 0;				
			else if( Count == T1S - 25'b1 )
				begin
					Count <= 0;
					CLK1 <= ~CLK1;		
				end
			else
				Count <= Count + 1;
		end
     
     //产生2hz的时钟   
     always @ ( posedge CLK or negedge Timer_Start )
		begin 
			if( !Timer_Start )
				Count2 <= 0;				
			else if( Count2 == T05S - 25'b1 )
				begin
					Count2 <= 0;
					CLK05 <= ~CLK05;		
				end
			else
				Count2 <= Count2 + 1;
		end

	//倒计时
	always @ ( posedge CLK1 or negedge RSTn )
		begin
			if( !RSTn )  		
				begin
					TimerH <= 4'd10;
					TimerL <= 4'd10;
				end
			else if( Timer_Start == 1 )		
				begin
						if (TimerL!=0)
                        begin
						TimerL <= TimerL - 1'b1;
                        end
				end
		end
	
    //倒计时结束时触发蜂鸣器
	always @ ( posedge CLK05 )
		begin
			if( TimerH == 'd10 && TimerL == 'd1 ) 	
				begin
					if( count1 == 1'b1 )
						begin
							Buzzer_TimeOver <= 0;
							count1 <= 0;
						end
					else 
						begin
							Buzzer_TimeOver <= 1;				
							count1 <= count1 + 1'b1;
						end
				end
			else
				begin
					Buzzer_TimeOver <= 0;
					count1 <= 0;			
				end
		end	

endmodule

	
	