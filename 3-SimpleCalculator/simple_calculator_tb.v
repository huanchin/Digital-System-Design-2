`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5

module simple_calculator_tb;
    // port declaration for design-under-test
    reg        Clk;
    reg        WEN;
    reg  [2:0] RW, RX, RY;
    reg  [7:0] DataIn;
    reg        Sel;
    reg  [3:0] Ctrl;
    wire [7:0] busY;
    wire       Carry;
	
	integer count;
	reg [7:0] A;
	reg [7:0] B;
    // instantiate the design-under-test
    simple_calculator u_calc(
        .Clk    (Clk),
        .WEN    (WEN),
        .RW     (RW),
        .RX     (RX),
        .RY     (RY),
        .DataIn (DataIn),
        .Sel    (Sel),
        .Ctrl   (Ctrl),
        .busY   (busY),
        .Carry  (Carry)
    );

    //waveform dump
    /*
	initial begin
		$fsdbDumpfile("simple_calc.fsdb");
		$fsdbDumpvars;
    end
	*/
	always #(`HCYCLE) begin
		Clk=~Clk;
	end
	
	initial begin
		Clk = 0;
		WEN = 1;
		RW = 0;
		RX = 0;
		RY = 0;
		DataIn = 0;
		Sel=0;
		Ctrl=4'b0000; //add
		A = 8'b0000_0011;
		B = 8'b0000_0101;
		
		#(`CYCLE*0.2)
		$display("===========================================");
		$display("1. Start to store value A: %b into REG#1", A);
		WEN = 1'b1; RW = 3'b1; RX = 0; RY = 0;
		Ctrl = 4'b0000; Sel=0; DataIn = A;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b1; RX = 0; RY = 3'b1;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		if(busY==A) $display("...Pass");
		else $display("...FAIL!!! design(%b) != expected(%b)", busY , A);
		#(`CYCLE*0.5)
		////////////////////B////////////////////////
		
		#(`CYCLE*0.2)
		$display("2. Start to store value B: %b into REG#2", B);
		WEN = 1'b1; RW = 3'b010; RX = 0; RY = 0;
		Ctrl = 4'b0000; Sel=0; DataIn = B;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b010; RX = 0; RY = 3'b010;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		if(busY==B) $display("...Pass");
		else $display("...FAIL!!! design(%b) != expected(%b)", busY , B);
		#(`CYCLE*0.5)
		
		////////////////////B MASK//////////////////////////
		$display("3. Making B mask");
		////////////////////B[0] MASK//////////////////////////
		#(`CYCLE*0.2)
		$display("3a. Making B[0] mask: (%b) into REG#3", B[0]);
		WEN = 1'b1; RW = 3'b011; RX = 3'b010; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b011;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		$display("now mask is %b", busY);
		#(`CYCLE*0.5)
		
		for (count=1;count<8;count=count+1) begin
			#(`CYCLE*0.2)
			$display("3a. shift arithmetic #%d in REG#3", count);
			WEN = 1'b1; RW = 3'b011; RX = 3'b011; RY = 0;
			Ctrl = 4'b1001;// shift arithmetic right
			Sel=1; DataIn = 0;
			#(`CYCLE*0.8) //one cycle pass, reg write at this moment
			
			#(`CYCLE*0.2)
			WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b011;
			Ctrl = 4'b0000; Sel=0; DataIn = 0;
			#(`CYCLE*0.3)
			$display("--- now mask is %b", busY);
			#(`CYCLE*0.5);
		end
		
		$display(" ");
		////////////////////B[1] MASK//////////////////////////
		#(`CYCLE*0.2)
		$display("3b. Making B[1] mask: (%b) into REG#4", B[1]);
		WEN = 1'b1; RW = 3'b100; RX = 3'b010; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b100; RX = 3'b100; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b100; RX = 0; RY = 3'b100;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		$display("now mask is %b", busY);
		#(`CYCLE*0.5)
		
		for (count=1;count<8;count=count+1) begin
			#(`CYCLE*0.2)
			$display("3b. shift arithmetic #%d in REG#4", count);
			WEN = 1'b1; RW = 3'b100; RX = 3'b100; RY = 0;
			Ctrl = 4'b1001;// shift arithmetic right
			Sel=1; DataIn = 0;
			#(`CYCLE*0.8) //one cycle pass, reg write at this moment
			
			#(`CYCLE*0.2)
			WEN = 1'b0; RW = 3'b100; RX = 0; RY = 3'b100;
			Ctrl = 4'b0000; Sel=0; DataIn = 0;
			#(`CYCLE*0.3)
			$display("--- now mask is %b", busY);
			#(`CYCLE*0.5);
		end
		
		$display(" ");
		////////////////////B[2] MASK//////////////////////////
		#(`CYCLE*0.2)
		$display("3c. Making B[2] mask: (%b) into REG#5", B[2]);
		WEN = 1'b1; RW = 3'b101; RX = 3'b010; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b101; RX = 3'b101; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b101; RX = 3'b101; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b101; RX = 0; RY = 3'b101;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		$display("now mask is %b", busY);
		#(`CYCLE*0.5)
		
		for (count=1;count<8;count=count+1) begin
			#(`CYCLE*0.2)
			$display("3c. shift arithmetic #%d in REG#5", count);
			WEN = 1'b1; RW = 3'b101; RX = 3'b101; RY = 0;
			Ctrl = 4'b1001;// shift arithmetic right
			Sel=1; DataIn = 0;
			#(`CYCLE*0.8) //one cycle pass, reg write at this moment
			
			#(`CYCLE*0.2)
			WEN = 1'b0; RW = 3'b101; RX = 0; RY = 3'b101;
			Ctrl = 4'b0000; Sel=0; DataIn = 0;
			#(`CYCLE*0.3)
			$display("--- now mask is %b", busY);
			#(`CYCLE*0.5);
		end
		
		$display(" ");
		////////////////////B[3] MASK//////////////////////////
		#(`CYCLE*0.2)
		$display("3d. Making B[3] mask: (%b) into REG#6", B[3]);
		WEN = 1'b1; RW = 3'b110; RX = 3'b010; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 0;
		Ctrl = 4'b1011;// rotate right
		Sel=1; DataIn = 0;
		#(`CYCLE*0.8) //one cycle pass, reg write at this moment
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b110; RX = 0; RY = 3'b110;
		Ctrl = 4'b0000; Sel=0; DataIn = 0;
		#(`CYCLE*0.3)
		$display("now mask is %b", busY);
		#(`CYCLE*0.5)
		
		for (count=1;count<8;count=count+1) begin
			#(`CYCLE*0.2)
			$display("3d. shift arithmetic #%d in REG#6", count);
			WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 0;
			Ctrl = 4'b1001;// shift arithmetic right
			Sel=1; DataIn = 0;
			#(`CYCLE*0.8) //one cycle pass, reg write at this moment
			
			#(`CYCLE*0.2)
			WEN = 1'b0; RW = 3'b110; RX = 0; RY = 3'b110;
			Ctrl = 4'b0000; Sel=0; DataIn = 0;
			#(`CYCLE*0.3)
			$display("--- now mask is %b", busY);
			#(`CYCLE*0.5);
		end
		
		//////////////////// AND //////////////////////////
		
		Sel=1; DataIn = 0;
		
		////////////////////B[0] AND A//////////////////////////
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b011; RX = 3'b001; RY = 3'b011;
		Ctrl = 4'b0010;// AND
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b010;
		#(`CYCLE*0.3)
		$display("--- now A AND B[0] is %b", busY);
		#(`CYCLE*0.5);
		
		////////////////////B[1] AND A//////////////////////////
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b100; RX = 3'b001; RY = 3'b100;
		Ctrl = 4'b0010;// AND
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b100; RX = 3'b100; RY = 3'b100;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b100; RX = 0; RY = 3'b100;
		#(`CYCLE*0.3)
		$display("--- now A AND B[1] is %b", busY);
		#(`CYCLE*0.5);
		
		////////////////////B[2] AND A//////////////////////////
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b101; RX = 3'b001; RY = 3'b101;
		Ctrl = 4'b0010;// AND
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b101; RX = 3'b101; RY = 3'b101;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b101; RX = 3'b101; RY = 3'b101;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b101; RX = 0; RY = 3'b101;
		#(`CYCLE*0.3)
		$display("--- now A AND B[2] is %b", busY);
		#(`CYCLE*0.5);
		
		////////////////////B[3] AND A//////////////////////////
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b001; RY = 3'b110;
		Ctrl = 4'b0010;// AND
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 3'b110;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 3'b110;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b110; RX = 3'b110; RY = 3'b110;
		Ctrl = 4'b1010;// SHIFT
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b110; RX = 0; RY = 3'b110;
		#(`CYCLE*0.3)
		$display("--- now A AND B[3] is %b", busY);
		#(`CYCLE*0.5);
		
		////////////////////ADD_UP//////////////////////////
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b011;
		#(`CYCLE*0.3)
		$display("add to now is %b", busY);
		#(`CYCLE*0.5);
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b011; RX = 3'b011; RY = 3'b100;
		Ctrl = 4'b0000;// ADD
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b011;
		#(`CYCLE*0.3)
		$display("add to now is %b", busY);
		#(`CYCLE*0.5);
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b011; RX = 3'b011; RY = 3'b101;
		Ctrl = 4'b0000;// ADD
		#(`CYCLE*0.8)
		
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b011; RX = 0; RY = 3'b011;
		#(`CYCLE*0.3)
		$display("add to now is %b", busY);
		#(`CYCLE*0.5);
		
		#(`CYCLE*0.2)
		WEN = 1'b1; RW = 3'b011; RX = 3'b011; RY = 3'b110;
		Ctrl = 4'b0000;// ADD
		#(`CYCLE*0.8)
		
		
		//CHECK ANSWER
		#(`CYCLE*0.2)
		WEN = 1'b0; RW = 3'b110; RX = 0; RY = 3'b011;
		#(`CYCLE*0.3)
		$display("A is %d, B is %d",A,B);
		$display("ANSWER is %d", busY);
		#(`CYCLE*0.5);
		$finish;
	end
    
    // write your test pattern here
	
	
endmodule
