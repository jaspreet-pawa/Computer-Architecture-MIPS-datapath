`timescale 1ns/1ns
`include "topLevelCircuit.v"

module testbench ();
  reg clk,rst, forwarding_EN;
  wire[`WORD_LEN-1:0]dataout; 
  wire[`REG_FILE_ADDR_LEN-1:0] dataoutregister;
  MIPS_Processor top_module (clk, rst, forwarding_EN, dataoutregister, dataout);
  initial 
   begin
    rst = 1'b1;
    forwarding_EN = 1'b1;
    clk=0;
    $dumpfile("Waveforms.vcd");
    $dumpvars(3, testbench);
   end
  
  always
	#150 rst = 1'b0;
  always 
   begin
		repeat(500)
			#50 clk = ~clk;
   	$finish;
   end
endmodule // test
