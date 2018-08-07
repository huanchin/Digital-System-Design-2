module register_file(
    Clk  ,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY
);
    input        Clk, WEN;
    input  [2:0] RW, RX, RY;
    input  [7:0] busW;
    output [7:0] busX, busY;
	reg [7:0] r[7:0]; //8x8 reg
	
	assign busX = (RX==0)?0 :r[RX];
	assign busY = (RY==0)?0 :r[RY];
	always @(posedge Clk)
	begin
		
		if(WEN)
			r[RW] <= (RW == 3'b000)?0 :busW;
		r[0]<=8'b0;
	end
    
    // write your design here
    
endmodule
