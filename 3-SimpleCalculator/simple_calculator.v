module simple_calculator(
    Clk,
    WEN,
    RW,
    RX,
    RY,
    DataIn,
    Sel,
    Ctrl,
    busY,
    Carry
);

    input        Clk;
    input        WEN;
    input  [2:0] RW, RX, RY;
    input  [7:0] DataIn;
    input        Sel;
    input  [3:0] Ctrl;
    output [7:0] busY;
    output       Carry;

// declaration of wire/reg
	wire [7:0] Rin;
	wire [7:0] busX;
	reg [7:0] aluX;
// submodule instantiation
	register_file rf(Clk, WEN, RW, Rin, RX, RY, busX, busY);
	alu alu2(Ctrl, aluX, busY, Carry, Rin);
// combinational part
	always@(*) #1 begin
		if(Sel)
			aluX<=busX;
		else aluX<=DataIn;
	end
	// sequential part


endmodule
