`include "SNG.v"

module test();
	reg clk;
	wire outpu;
	reg[3:0] inp;
	
	SNG sto(.outp(outpu), .clk(clk), .inp(inp));
	initial
	begin
		inp = 4'b1010;
		clk = 1'b0;
		$dumpfile("fii.vcd");
		$dumpvars(2, test);
		i = 0;
	end
	integer i;
	
	always 
	begin
	repeat(30)
	begin 
		#5 clk = ~clk; inp = i+1;
		#10 i = i+1;
	end
	$finish;
	end
endmodule