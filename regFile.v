`include "defines.v"

module regFile (clk, rst, src1, src2, dest, writeVal, writeEn, reg1, reg2);
  input clk, rst, writeEn;
  input [`REG_FILE_ADDR_LEN-1:0] src1, src2, dest;
  input [`WORD_LEN-1:0] writeVal;
  output [`WORD_LEN-1:0] reg1, reg2;

  reg [`WORD_LEN-1:0] regMem [0:`REG_FILE_SIZE-1];
  integer i;

  always @(posedge clk)
  begin
  	#50 regMem[1] <= 32'b10001000100010001000100010001000;regMem[3] <= 32'b11001010100110001100101010011000;regMem[5] <= 32'b11001010110111001100101010011100;regMem[6] <= 32'b11011010110111001110101010011100;
  end
	

  always @ (negedge clk) begin
    if (rst) begin
      for (i = 0; i < `WORD_LEN; i = i + 1)
        regMem[i] <= 0;
	    end

    else if (writeEn) regMem[dest] <= writeVal;
    regMem[0] <= 0;
  end

  assign reg1 = (regMem[src1]);
  assign reg2 = (regMem[src2]);
endmodule // regFile
