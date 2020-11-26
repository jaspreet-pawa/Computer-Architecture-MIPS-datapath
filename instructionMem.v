`include "defines.v"

module instructionMem (rst, addr, instruction);
  input rst;
  input [`WORD_LEN-1:0] addr;
  output [`WORD_LEN-1:0] instruction;

  wire [$clog2(`INSTR_MEM_SIZE)-1:0] address = addr[$clog2(`INSTR_MEM_SIZE)-1:0];
  reg [`MEM_CELL_SIZE-1:0] instMem [0:`INSTR_MEM_SIZE-1];

  always @ (*) begin
  	if (rst) begin
        // No nop added in between instructions since there is a hazard detection unit

        instMem[0] <= 8'b00001100; //-- SUB	$2,$1,$3
        instMem[1] <= 8'b01000001;
        instMem[2] <= 8'b00011000;
        instMem[3] <= 8'b00000000;

        instMem[4] <= 8'b00010101; //-- AND 	$8,$2,$5
        instMem[5] <= 8'b00000010;
        instMem[6] <= 8'b00101000;
        instMem[7] <= 8'b00000000;

        instMem[8] <= 8'b00011001; //-- OR	$9,$6,$2
        instMem[9] <= 8'b00100110;
        instMem[10] <= 8'b00010000;
        instMem[11] <= 8'b00000000;

        instMem[12] <= 8'b00010100; //-- ADD	$5,$5,$6
        instMem[13] <= 8'b10100101;
        instMem[14] <= 8'b00110000;
        instMem[15] <= 8'b00000000;

        instMem[16] <= 8'b00001100; //-- SUB	$4,$3,$6
        instMem[17] <= 8'b10000011;
        instMem[18] <= 8'b00110000;
        instMem[19] <= 8'b00000000;

        instMem[20] <= 8'b10100000; //-- BEQ	$r5,$6
        instMem[21] <= 8'b10100110;
        instMem[22] <= 8'b00000000;
        instMem[23] <= 8'b00000000;

        instMem[24] <= 8'b00000000; //-- NOP
        instMem[25] <= 8'b00000000;
        instMem[26] <= 8'b00000000;
        instMem[27] <= 8'b00000000;

        instMem[28] <= 8'b00000000; //-- NOP
        instMem[29] <= 8'b00000000;
        instMem[30] <= 8'b00000000;
        instMem[31] <= 8'b00000000;

        instMem[32] <= 8'b00000000; //-- NOP
        instMem[33] <= 8'b00000000;
        instMem[34] <= 8'b00000000;
        instMem[35] <= 8'b00000000;

        instMem[36] <= 8'b00000000; //-- NOP
        instMem[37] <= 8'b00000000;
        instMem[38] <= 8'b00000000;
        instMem[39] <= 8'b00000000;

        instMem[40] <= 8'b00000000; //-- NOP
        instMem[41] <= 8'b00000000;
        instMem[42] <= 8'b00000000;
        instMem[43] <= 8'b00000000;

        instMem[44] <= 8'b00000000; //-- NOP
        instMem[45] <= 8'b00000000;
        instMem[46] <= 8'b00000000;
        instMem[47] <= 8'b00000000;

        instMem[48] <= 8'b00000000; //-- NOP
        instMem[49] <= 8'b00000000;
        instMem[50] <= 8'b00000000;
        instMem[51] <= 8'b00000000;

        instMem[52] <= 8'b00000000; //-- NOP
        instMem[53] <= 8'b00000000;
        instMem[54] <= 8'b00000000;
        instMem[55] <= 8'b00000000;

        instMem[56] <= 8'b00000000; //-- NOP
        instMem[57] <= 8'b00000000;
        instMem[58] <= 8'b00000000;
        instMem[59] <= 8'b00000000;

        instMem[60] <= 8'b00000000; //-- NOP
        instMem[61] <= 8'b00000000;
        instMem[62] <= 8'b00000000;
        instMem[63] <= 8'b00000000;

        instMem[64] <= 8'b00000000; //-- NOP
        instMem[65] <= 8'b00000000;
        instMem[66] <= 8'b00000000;
        instMem[67] <= 8'b00000000;

        instMem[68] <= 8'b00000000; //-- NOP
        instMem[69] <= 8'b00000000;
        instMem[70] <= 8'b00000000;
        instMem[71] <= 8'b00000000;

        instMem[72] <= 8'b00000000; //-- NOP
        instMem[73] <= 8'b00000000;
        instMem[74] <= 8'b00000000;
        instMem[75] <= 8'b00000000;

        instMem[76] <= 8'b00000000; //-- NOP
        instMem[77] <= 8'b00000000;
        instMem[78] <= 8'b00000000;
        instMem[79] <= 8'b00000000;

        instMem[80] <= 8'b00000000; //-- NOP
        instMem[81] <= 8'b00000000;
        instMem[82] <= 8'b00000000;
        instMem[83] <= 8'b00000000;

        instMem[84] <= 8'b00000000; //-- NOP
        instMem[85] <= 8'b00000000;
        instMem[86] <= 8'b00000000;
        instMem[87] <= 8'b00000000;

        instMem[88] <= 8'b00000000; //-- NOP
        instMem[89] <= 8'b00000000;
        instMem[90] <= 8'b00000000;
        instMem[91] <= 8'b00000000;

        instMem[92] <= 8'b00000000; //-- NOP
        instMem[93] <= 8'b00000000;
        instMem[94] <= 8'b00000000;
        instMem[95] <= 8'b00000000;

        instMem[96] <= 8'b00000000; //-- NOP
        instMem[97] <= 8'b00000000;
        instMem[98] <= 8'b00000000;
        instMem[99] <= 8'b00000000;

        instMem[100] <= 8'b00000000; //-- NOP
        instMem[101] <= 8'b00000000;
        instMem[102] <= 8'b00000000;
        instMem[103] <= 8'b00000000;

        instMem[104] <= 8'b00000000; //-- NOP
        instMem[105] <= 8'b00000000;
        instMem[106] <= 8'b00000000;
        instMem[107] <= 8'b00000000;

        instMem[108] <= 8'b00000000; //-- NOP
        instMem[109] <= 8'b00000000;
        instMem[110] <= 8'b00000000;
        instMem[111] <= 8'b00000000;

        instMem[112] <= 8'b00000000; //-- NOP
        instMem[113] <= 8'b00000000;
        instMem[114] <= 8'b00000000;
        instMem[115] <= 8'b00000000;

        instMem[116] <= 8'b00000000; //-- NOP
        instMem[117] <= 8'b00000000;
        instMem[118] <= 8'b00000000;
        instMem[119] <= 8'b00000000;

        instMem[120] <= 8'b00000000; //-- NOP
        instMem[121] <= 8'b00000000;
        instMem[122] <= 8'b00000000;
        instMem[123] <= 8'b00000000;

        instMem[124] <= 8'b00000000; //-- NOP
        instMem[125] <= 8'b00000000;
        instMem[126] <= 8'b00000000;
        instMem[127] <= 8'b00000000;

        instMem[128] <= 8'b00000000; //-- NOP
        instMem[129] <= 8'b00000000;
        instMem[130] <= 8'b00000000;
        instMem[131] <= 8'b00000000;

        instMem[132] <= 8'b00000000; //-- NOP
        instMem[133] <= 8'b00000000;
        instMem[134] <= 8'b00000000;
        instMem[135] <= 8'b00000000;

        instMem[136] <= 8'b00000000; //-- NOP
        instMem[137] <= 8'b00000000;
        instMem[138] <= 8'b00000000;
        instMem[139] <= 8'b00000000;

        instMem[140] <= 8'b00000000; //-- NOP
        instMem[141] <= 8'b00000000;
        instMem[142] <= 8'b00000000;
        instMem[143] <= 8'b00000000;

        instMem[144] <= 8'b00000000; //-- NOP
        instMem[145] <= 8'b00000000;
        instMem[146] <= 8'b00000000;
        instMem[147] <= 8'b00000000;

        instMem[148] <= 8'b00000000; //-- NOP
        instMem[149] <= 8'b00000000;
        instMem[150] <= 8'b00000000;
        instMem[151] <= 8'b00000000;

        instMem[152] <= 8'b00000000; //-- NOP
        instMem[153] <= 8'b00000000;
        instMem[154] <= 8'b00000000;
        instMem[155] <= 8'b00000000;

        instMem[156] <= 8'b00000000; //-- NOP
        instMem[157] <= 8'b00000000;
        instMem[158] <= 8'b00000000;
        instMem[159] <= 8'b00000000;

        instMem[160] <= 8'b00000000; //-- NOP
        instMem[161] <= 8'b00000000;
        instMem[162] <= 8'b00000000;
        instMem[163] <= 8'b00000000;

        instMem[164] <= 8'b00000000; //-- NOP
        instMem[165] <= 8'b00000000;
        instMem[166] <= 8'b00000000;
        instMem[167] <= 8'b00000000;

        instMem[168] <= 8'b00000000; //-- NOP
        instMem[169] <= 8'b00000000;
        instMem[170] <= 8'b00000000;
        instMem[171] <= 8'b00000000;

        instMem[172] <= 8'b00000000; //-- NOP
        instMem[173] <= 8'b00000000;
        instMem[174] <= 8'b00000000;
        instMem[175] <= 8'b00000000;

        instMem[176] <= 8'b00000000; //-- NOP
        instMem[177] <= 8'b00000000;
        instMem[178] <= 8'b00000000;
        instMem[179] <= 8'b00000000;

        instMem[180] <= 8'b00000000; //-- NOP
        instMem[181] <= 8'b00000000;
        instMem[182] <= 8'b00000000;
        instMem[183] <= 8'b00000000;

        instMem[184] <= 8'b00000000; //-- NOP
        instMem[185] <= 8'b00000000;
        instMem[186] <= 8'b00000000;
        instMem[187] <= 8'b00000000;

        instMem[188] <= 8'b00000000; //-- NOP
        instMem[189] <= 8'b00000000;
        instMem[190] <= 8'b00000000;
        instMem[191] <= 8'b00000000;

        instMem[192] <= 8'b00000000; //-- NOP
        instMem[193] <= 8'b00000000;
        instMem[194] <= 8'b00000000;
        instMem[195] <= 8'b00000000;

        instMem[196] <= 8'b00000000; //-- NOP
        instMem[197] <= 8'b00000000;
        instMem[198] <= 8'b00000000;
        instMem[199] <= 8'b00000000;

        instMem[200] <= 8'b00000000; //-- NOP
        instMem[201] <= 8'b00000000;
        instMem[202] <= 8'b00000000;
        instMem[203] <= 8'b00000000;

        instMem[204] <= 8'b00000000; //-- NOP
        instMem[205] <= 8'b00000000;
        instMem[206] <= 8'b00000000;
        instMem[207] <= 8'b00000000;

        instMem[208] <= 8'b00000000; //-- NOP
        instMem[209] <= 8'b00000000;
        instMem[210] <= 8'b00000000;
        instMem[211] <= 8'b00000000;

        instMem[212] <= 8'b00000000; //-- NOP
        instMem[213] <= 8'b00000000;
        instMem[214] <= 8'b00000000;
        instMem[215] <= 8'b00000000;

        instMem[216] <= 8'b00000000; //-- NOP
        instMem[217] <= 8'b00000000;
        instMem[218] <= 8'b00000000;
        instMem[219] <= 8'b00000000;

        instMem[220] <= 8'b00000000; //-- NOP
        instMem[221] <= 8'b00000000;
        instMem[222] <= 8'b00000000;
        instMem[223] <= 8'b00000000;

        instMem[224] <= 8'b00000000; //-- NOP
        instMem[225] <= 8'b00000000;
        instMem[226] <= 8'b00000000;
        instMem[227] <= 8'b00000000;

        instMem[228] <= 8'b00000000; //-- NOP
        instMem[229] <= 8'b00000000;
        instMem[230] <= 8'b00000000;
        instMem[231] <= 8'b00000000;

        instMem[232] <= 8'b00000000; //-- NOP
        instMem[233] <= 8'b00000000;
        instMem[234] <= 8'b00000000;
        instMem[235] <= 8'b00000000;
      end
    end

  assign instruction = {instMem[address], instMem[address + 1], instMem[address + 2], instMem[address + 3]};
endmodule // insttructionMem
