`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5

module register_file_tb;
    // port declaration for design-under-test
    reg Clk, WEN;
    reg  [2:0] RW, RX, RY;
    reg  [7:0] busW;
    wire [7:0] busX, busY;
	
	integer count,err;
	reg [7:0] rnw;//random input
    reg [7:0] res;
    // instantiate the design-under-test
    register_file rf(
        Clk  ,
        WEN  ,
        RW   ,
        busW ,
        RX   ,
        RY   ,
        busX ,
        busY
    );
	always #(`HCYCLE) begin
		Clk=~Clk;
	end
	initial begin
		Clk = 0;
		WEN = 0;
		RW = 0;
		busW = 0;
		RX = 0 ;
		RY = 0 ;
		err = 0;
		for(count=0;count<8;count=count+1) begin
			
			rnw = $random;
			@(negedge Clk) 
			WEN= 1'b1;
			RW = count;
			busW = rnw;
			
			@(negedge Clk)
			WEN = 0;
			RX = count;
			
			//@(negedge Clk)
			#1
			if(count==0)begin
				if(busX!==0) begin 
					$display("ERROR at reg %d :output (%b)!=expect (00000000)", count, busX);
					err=err+1;
				end
				else $display("PASS... at reg %d :output (%b)==expect (00000000)", count, busX);
			end
			else begin
				if(busX!==rnw) begin 
					$display("ERROR at reg %d :output (%b)!=expect (%b)", count, busX, rnw);
					err=err+1;
				end
				else $display("PASS... at reg %d :output (%b)==expect (%b)", count, busX, rnw);
			end
		end
		$finish;
	end
        

    // write your test pattern here


endmodule
