module keyboard_instance(clk_50M,RSTn,col,row,Digitron_Out,DigitronCS_Out,LED_Out);
    
    input clk_50M;
    input RSTn ;// SW0
    input [3:0] col;
    output [3:0] row;
    output [7:0] Digitron_Out;
    output [3:0] DigitronCS_Out;
     output [7:0]LED_Out;

    
    wire [15:0] key;
  
    keyboard_scan U1(
        .clk(clk_50M),
        .RSTn(RSTn),
        .col(col),
        .row(row),
        .key(key)
    );
    
    wire [15:0] key_deb;
    key_filter U2(
        .clk(clk_50M),
        .rstn(RSTn),
        .key_in(key),
        .key_deb(key_deb)
    );
     
    wire [3:0] data_disp;  
    onehot2binary U3(
        .clk(clk_50M),
        .onehot(key_deb),
        .binary(data_disp)
    );	    
    
    wire [11:0] display;
    wire [3:0]error_count;
    wire correct;
    register U4(
        .CLK(clk_50M),
        .RSTn(RSTn),
        .rdata(data_disp),
        .display(display),
        .error_count(error_count),
        .correct(correct)
    );
    
    led U5(
        .CLK(clk_50M),
        .start(correct),
        .LED_Out( LED_Out )
    );
    
    Digitron_TimeDisplay_module U6
    (
    	.CLK(clk_50M),
    	.display(display),
        .error_count(error_count),
    	.Digitron_Out(Digitron_Out),
    	.DigitronCS_Out(DigitronCS_Out)
    );
    
    
endmodule

