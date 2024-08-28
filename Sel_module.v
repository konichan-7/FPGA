module Sel_module
(
	RSTn, CLK, K1, K2, K3, K4, TimerL,Player_Number, Buzzer_Answer, Timer_Start
); 
	 input CLK;
	 input RSTn;
	 input K1, K2, K3, K4; 
     input TimerL;
     
	 output reg [3:0]Player_Number;
	 output reg Buzzer_Answer;
	 output reg Timer_Start;
	 	   
	 reg Block; 	
	 reg [24:0]Count='d0;
     reg en=1;
     reg [32:0]Remain_time='d0;
 
    //此时推动开关
	always @ ( posedge CLK or negedge RSTn ) 
		begin 	
			if( !RSTn ) 
				begin 
					Block <= 0;  
					Buzzer_Answer <= 0;				
					Count <= 'd0;	
					Player_Number <= 4'd0;
                    Timer_Start<=1;
                    en<=0;
                    Remain_time<='d0;
                                        						
				end
            else if(Block) 	//结束时响0.5s
						begin
							if( Count == 25'd24_999_999 )
								begin
									Buzzer_Answer <= 0;							
									Count <= Count;
								end
							else 
								begin
									Buzzer_Answer <= 1;	
									Count <= Count + 25'b1;
							end
						end
			else if(!en)  //9s之后锁住	
				begin 
					
                    if( Remain_time== 32'd449_999_999 )
						begin
							en<=1;							
							Remain_time <= Remain_time;
						end
					else 
						begin	
							Remain_time <= Remain_time + 32'b1;
						end
					if( K1 && !Block ) 	
						begin 	
							Block <= 1; 	
							Player_Number <= 4'd1; 
                            Timer_Start<=0;
                            en<=1;
						end 
					else if( K2 && !Block ) 
						begin 
							Block <= 1;
							Player_Number <= 4'd2;
                            Timer_Start<=0;	
                            en<=1;
						end 		
					else if( K3 && !Block ) 
						begin 
							Block <= 1;
							Player_Number <= 4'd3;
                            Timer_Start<=0;
                            en<=1;
						end 	 
					else if( K4 && !Block ) 
						begin 
							Block <= 1;
							Player_Number <= 4'd4;
                            Timer_Start<=0;	
                            en<=1;
						end 
				end
       
		end 

endmodule
