`include "defines.v"
`include "regFile.v"
`include "IFStage.v"
`include "IDStage.v"
`include "EXEStage.v"
`include "MEMStage.v"
`include "WBStage.v"
`include "IF2ID.v"
`include "ID2EXE.v"
`include "EXE2MEM.v"
`include "MEM2WB.v"

module forwarding_EXE (src1_EXE, src2_EXE, ST_src_EXE, dest_MEM, dest_WB, WB_EN_MEM, WB_EN_WB, val1_sel, val2_sel, ST_val_sel);
  input [`REG_FILE_ADDR_LEN-1:0] src1_EXE, src2_EXE, ST_src_EXE;
  input [`REG_FILE_ADDR_LEN-1:0] dest_MEM, dest_WB;
  input WB_EN_MEM, WB_EN_WB;
  output reg [`FORW_SEL_LEN-1:0] val1_sel, val2_sel, ST_val_sel;

  always @ ( * ) begin
    // initializing sel signals to 0
    // they will change to enable forwrding if needed.
    {val1_sel, val2_sel, ST_val_sel} <= 0;

    // determining forwarding control signal for store value (ST_val)
    if (WB_EN_MEM && ST_src_EXE == dest_MEM) ST_val_sel <= 2'd1;
    else if (WB_EN_WB && ST_src_EXE == dest_WB) ST_val_sel <= 2'd2;

    // determining forwarding control signal for ALU val1
    if (WB_EN_MEM && src1_EXE == dest_MEM) val1_sel <= 2'd1;
    else if (WB_EN_WB && src1_EXE == dest_WB) val1_sel <= 2'd2;

    // determining forwarding control signal for ALU val2
    if (WB_EN_MEM && src2_EXE == dest_MEM) val2_sel <= 2'd1;
    else if (WB_EN_WB && src2_EXE == dest_WB) val2_sel <= 2'd2;
  end
endmodule // forwarding


module hazard_detection(forward_EN, is_imm, ST_or_BNE, src1_ID, src2_ID, dest_EXE, WB_EN_EXE, dest_MEM, WB_EN_MEM, MEM_R_EN_EXE, branch_comm, hazard_detected);
  input [`REG_FILE_ADDR_LEN-1:0] src1_ID, src2_ID;
  input [`REG_FILE_ADDR_LEN-1:0] dest_EXE, dest_MEM;
  input [1:0] branch_comm;
  input forward_EN, WB_EN_EXE, WB_EN_MEM, is_imm, ST_or_BNE, MEM_R_EN_EXE;
  output hazard_detected;

  wire src2_is_valid, exe_has_hazard, mem_has_hazard, hazard, instr_is_branch;

  assign src2_is_valid =  (~is_imm) || ST_or_BNE;

  assign exe_has_hazard = WB_EN_EXE && (src1_ID == dest_EXE || (src2_is_valid && src2_ID == dest_EXE));
  assign mem_has_hazard = WB_EN_MEM && (src1_ID == dest_MEM || (src2_is_valid && src2_ID == dest_MEM));

  assign hazard = (exe_has_hazard || mem_has_hazard);
  assign instr_is_branch = (branch_comm == `COND_BEZ || branch_comm == `COND_BNE);

  assign hazard_detected = ~forward_EN ? hazard : (instr_is_branch && hazard) || (MEM_R_EN_EXE && mem_has_hazard);
endmodule // hazard_detection


module MIPS_Processor (input CLOCK_50, input rst, input forward_EN, output reg[`REG_FILE_ADDR_LEN-1:0] fortestbenchWBdest, output reg[`WORD_LEN-1:0] fortestbenchWBres);
	wire clock = CLOCK_50;
	wire [`WORD_LEN-1:0] PC_IF, PC_ID, PC_EXE, PC_MEM;
	wire [`WORD_LEN-1:0] inst_IF, inst_ID;
	wire [`WORD_LEN-1:0] reg1_ID, reg2_ID, ST_value_EXE, ST_value_EXE2MEM, ST_value_MEM;
	wire [`WORD_LEN-1:0] val1_ID, val1_EXE;
	wire [`WORD_LEN-1:0] val2_ID, val2_EXE;
	wire [`WORD_LEN-1:0] ALURes_EXE, ALURes_MEM, ALURes_WB;
	wire [`WORD_LEN-1:0] dataMem_out_MEM, dataMem_out_WB;
	wire [`WORD_LEN-1:0] WB_result;
	wire [`REG_FILE_ADDR_LEN-1:0] dest_EXE, dest_MEM, dest_WB; 
	wire [`REG_FILE_ADDR_LEN-1:0] src1_ID, src2_regFile_ID, src2_forw_ID, src2_forw_EXE, src1_forw_EXE;
	wire [`EXE_CMD_LEN-1:0] EXE_CMD_ID, EXE_CMD_EXE;
	wire [`FORW_SEL_LEN-1:0] val1_sel, val2_sel, ST_val_sel;
	wire [1:0] branch_comm;
	wire Br_Taken_ID, IF_Flush, Br_Taken_EXE;
	wire MEM_R_EN_ID, MEM_R_EN_EXE, MEM_R_EN_MEM, MEM_R_EN_WB;
	wire MEM_W_EN_ID, MEM_W_EN_EXE, MEM_W_EN_MEM;
	wire WB_EN_ID, WB_EN_EXE, WB_EN_MEM, WB_EN_WB;
	wire hazard_detected, is_imm, ST_or_BNE;

	always @(posedge CLOCK_50)
	begin
		fortestbenchWBdest <= dest_WB;
		fortestbenchWBres <= WB_result;
	end
	regFile regFile(
		// INPUTS
		.clk(clock),
		.rst(rst),
		.src1(src1_ID),
		.src2(src2_regFile_ID),
		.dest(dest_WB),
		.writeVal(WB_result),
		.writeEn(WB_EN_WB),
		// OUTPUTS
		.reg1(reg1_ID),
		.reg2(reg2_ID)
	);

	hazard_detection hazard (
		// INPUTS
		.forward_EN(forward_EN),
		.is_imm(is_imm),
		.ST_or_BNE(ST_or_BNE),
		.src1_ID(src1_ID),
		.src2_ID(src2_regFile_ID),
		.dest_EXE(dest_EXE),
		.dest_MEM(dest_MEM),
		.WB_EN_EXE(WB_EN_EXE),
		.WB_EN_MEM(WB_EN_MEM),
		.MEM_R_EN_EXE(MEM_R_EN_EXE),
		// OUTPUTS
		.branch_comm(branch_comm),
		.hazard_detected(hazard_detected)
	);

	forwarding_EXE forwrding1 (
		.src1_EXE(src1_forw_EXE),
		.src2_EXE(src2_forw_EXE),
		.ST_src_EXE(dest_EXE),
		.dest_MEM(dest_MEM),
		.dest_WB(dest_WB),
		.WB_EN_MEM(WB_EN_MEM),
		.WB_EN_WB(WB_EN_WB),
		.val1_sel(val1_sel),
		.val2_sel(val2_sel),
		.ST_val_sel(ST_val_sel)
	);

	//###########################
	//##### PIPLINE STAGES ######
	//###########################
	IFStage IFStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.freeze(hazard_detected),
		.brTaken(Br_Taken_ID),
		.brOffset(val2_ID),
		// OUTPUTS
		.instruction(inst_IF),
		.PC(PC_IF)
	);

	IDStage IDStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.hazard_detected_in(hazard_detected),
		.instruction(inst_ID),
		.reg1(reg1_ID),
		.reg2(reg2_ID),
		// OUTPUTS
		.src1(src1_ID),
		.src2_reg_file(src2_regFile_ID),
		.src2_forw(src2_forw_ID),
		.val1(val1_ID),
		.val2(val2_ID),
		.brTaken(Br_Taken_ID),
		.EXE_CMD(EXE_CMD_ID),
		.MEM_R_EN(MEM_R_EN_ID),
		.MEM_W_EN(MEM_W_EN_ID),
		.WB_EN(WB_EN_ID),
		.is_imm_out(is_imm),
		.ST_or_BNE_out(ST_or_BNE),
		.branch_comm(branch_comm)
	);

	EXEStage EXEStage (
		// INPUTS
		.clk(clock),
		.EXE_CMD(EXE_CMD_EXE),
		.val1_sel(val1_sel),
		.val2_sel(val2_sel),
		.ST_val_sel(ST_val_sel),
		.val1(val1_EXE),
		.val2(val2_EXE),
		.ALU_res_MEM(ALURes_MEM),
		.result_WB(WB_result),
		.ST_value_in(ST_value_EXE),
		// OUTPUTS
		.ALUResult(ALURes_EXE),
		.ST_value_out(ST_value_EXE2MEM)
	);

	MEMStage MEMStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.MEM_R_EN(MEM_R_EN_MEM),
		.MEM_W_EN(MEM_W_EN_MEM),
		.ALU_res(ALURes_MEM),
		.ST_value(ST_value_MEM),
		// OUTPUTS
		.dataMem_out(dataMem_out_MEM)
	);

	WBStage WBStage (
		// INPUTS
		.MEM_R_EN(MEM_R_EN_WB),
		.memData(dataMem_out_WB),
		.aluRes(ALURes_WB),
		// OUTPUTS
		.WB_res(WB_result)
	);

	//############################
	//#### PIPLINE REGISTERS #####
	//############################
	IF2ID IF2IDReg (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.flush(IF_Flush),
		.freeze(hazard_detected),
		.PCIn(PC_IF),
		.instructionIn(inst_IF),
		// OUTPUTS
		.PC(PC_ID),
		.instruction(inst_ID)
	);

	ID2EXE ID2EXEReg (
		.clk(clock),
		.rst(rst),
		// INPUTS
		.destIn(inst_ID[25:21]),
		.src1_in(src1_ID),
		.src2_in(src2_forw_ID),
		.reg2In(reg2_ID),
		.val1In(val1_ID),
		.val2In(val2_ID),
		.PCIn(PC_ID),
		.EXE_CMD_IN(EXE_CMD_ID),
		.MEM_R_EN_IN(MEM_R_EN_ID),
		.MEM_W_EN_IN(MEM_W_EN_ID),
		.WB_EN_IN(WB_EN_ID),
		.brTaken_in(Br_Taken_ID),
		// OUTPUTS
		.src1_out(src1_forw_EXE),
		.src2_out(src2_forw_EXE),
		.dest(dest_EXE),
		.ST_value(ST_value_EXE),
		.val1(val1_EXE),
		.val2(val2_EXE),
		.PC(PC_EXE),
		.EXE_CMD(EXE_CMD_EXE),
		.MEM_R_EN(MEM_R_EN_EXE),
		.MEM_W_EN(MEM_W_EN_EXE),
		.WB_EN(WB_EN_EXE),
		.brTaken_out(Br_Taken_EXE)
	);

	EXE2MEM EXE2MEMReg (
		.clk(clock),
		.rst(rst),
		// INPUTS
		.WB_EN_IN(WB_EN_EXE),
		.MEM_R_EN_IN(MEM_R_EN_EXE),
		.MEM_W_EN_IN(MEM_W_EN_EXE),
		.PCIn(PC_EXE),
		.ALUResIn(ALURes_EXE),
		.STValIn(ST_value_EXE2MEM),
		.destIn(dest_EXE),
		// OUTPUTS
		.WB_EN(WB_EN_MEM),
		.MEM_R_EN(MEM_R_EN_MEM),
		.MEM_W_EN(MEM_W_EN_MEM),
		.PC(PC_MEM),
		.ALURes(ALURes_MEM),
		.STVal(ST_value_MEM),
		.dest(dest_MEM)
	);

	MEM2WB MEM2WB(
		.clk(clock),
		.rst(rst),
		// INPUTS
		.WB_EN_IN(WB_EN_MEM),
		.MEM_R_EN_IN(MEM_R_EN_MEM),
		.ALUResIn(ALURes_MEM),
		.memReadValIn(dataMem_out_MEM),
		.destIn(dest_MEM),
		// OUTPUTS
		.WB_EN(WB_EN_WB),
		.MEM_R_EN(MEM_R_EN_WB),
		.ALURes(ALURes_WB),
		.memReadVal(dataMem_out_WB),
		.dest(dest_WB)
	);

	assign IF_Flush = Br_Taken_ID;
endmodule
