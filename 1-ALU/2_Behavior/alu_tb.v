//behavior tb
`timescale 1ns/10ps
`define CYCLE		10
`define HCYCLE	5

module alu_tb;
    reg  [3:0] ctrl;
    reg  [7:0] x;
    reg  [7:0] y;
    wire       carry;
    wire [7:0] out;
    
    alu alu2(
        ctrl     ,
        x        ,
        y        ,
        carry    ,
        out  
    );

//    initial begin
//        $fsdbDumpfile("alu.fsdb");
//        $fsdbDumpvars;
//    end

    initial begin
        ctrl = 4'b1101;
        x    = 8'b0001_1111;
        y    = 8'b0001_0001;
        
		#(`CYCLE);

        ctrl = 4'b0000;
        #(`HCYCLE);
        if( {carry,out} == 9'b0_0011_0000 ) $display( "PASS --- 0000 add" );
        else $display( "FAIL --- 0000 add" );

		#(`CYCLE);

        ctrl = 4'b0001;
        #(`HCYCLE);
        if( {carry,out} == 9'b0_000_1110 ) $display( "PASS --- 0001 sub" );
        else $display( "FAIL --- 0001 sub" );
		
		#(`CYCLE);

        ctrl = 4'b0010;
        #(`HCYCLE);
        if( out == 8'b0001_0001 ) $display( "PASS --- 0010 boolean and" );
        else $display( "FAIL --- 0010 boolean and" );
		
		#(`CYCLE);

        ctrl = 4'b0011;
        #(`HCYCLE);
        if( out == 8'b0001_1111 ) $display( "PASS --- 0011 boolean or" );
        else $display( "FAIL --- 0011 boolean or" );
		
		#(`CYCLE);

        ctrl = 4'b0100;
        #(`HCYCLE);
        if( out == 8'b1110_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );
		
		#(`CYCLE);

        ctrl = 4'b0101;
        #(`HCYCLE);
        if( out == 8'b0000_1110 ) $display( "PASS --- 0101 boolean xor" );
        else $display( "FAIL --- 0101 boolean xor" );
		
		#(`CYCLE);

        ctrl = 4'b0110;
        #(`HCYCLE);
        if( out == 8'b1111_0001 ) $display( "PASS --- 0110 boolean nor" );
        else $display( "FAIL --- 0110 boolean nor" );
		
		#(`CYCLE);

        ctrl = 4'b0111;
        #(`HCYCLE);
        if( out == 8'b1000_0000 ) $display( "PASS --- 0111 shift left logical variable" );
        else $display( "FAIL --- 0111 shift left logical variable" );
		
		#(`CYCLE);

        ctrl = 4'b1000;
        #(`HCYCLE);
        if( out == 8'b0 ) $display( "PASS --- 1000 shift right logical variable" );
        else $display( "FAIL --- 1000 shift right logical variable" );
		
		#(`CYCLE);

        ctrl = 4'b1001;
        #(`HCYCLE);
        if( out == 8'b0000_1111 ) $display( "PASS --- 1001 shift right arithmetic" );
        else $display( "FAIL --- 1001 shift right arithmetic" );
		
        #(`CYCLE);

        ctrl = 4'b1010;
        #(`HCYCLE);
        if( out == 8'b0011_1110 ) $display( "PASS --- 1010 rotate left" );
        else $display( "FAIL --- 1010 rotate left" );
		
		#(`CYCLE);

        ctrl = 4'b1011;
        #(`HCYCLE);
        if( out == 8'b1000_1111 ) $display( "PASS --- 1011 rotate right" );
        else $display( "FAIL --- 1011 rotate right" );
		
		#(`CYCLE);

        ctrl = 4'b1100;
        #(`HCYCLE);
        if( out == 8'b0 ) $display( "PASS --- 1100 equal" );
        else $display( "FAIL --- 1100 equal" );
		
		#(`CYCLE);
        // 0100 boolean not
        ctrl = 4'b1101;
        #(`HCYCLE);
        if( out == 8'b0 ) $display( "PASS --- 1101 No operation" );
        else $display( "FAIL --- 1101 No operation" );
		
		#(`CYCLE);
        // 0100 boolean not
        ctrl = 4'b1110;
        #(`HCYCLE);
        if( out == 8'b0 ) $display( "PASS --- 1110 No operation" );
        else $display( "FAIL --- 1110 No operation" );
		
		#(`CYCLE);
        // 0100 boolean not
        ctrl = 4'b1111;
        #(`HCYCLE);
        if( out == 8'b0 ) $display( "PASS --- 1111 No operation" );
        else $display( "FAIL --- 1111 No operation" );
        
        // finish tb
        #(`CYCLE) $finish;
    end
endmodule
