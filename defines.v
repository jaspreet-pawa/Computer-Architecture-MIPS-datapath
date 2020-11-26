// Wire widths
`define WORD_LEN 32
`define REG_FILE_ADDR_LEN 5
`define EXE_CMD_LEN 4
`define FORW_SEL_LEN 2
`define OP_CODE_LEN 6

// Memory constants
`define DATA_MEM_SIZE 1024
`define INSTR_MEM_SIZE 1024
`define REG_FILE_SIZE 32
`define MEM_CELL_SIZE 8

// To be used inside controller.v
`define OP_NOP 6'b000000
`define OP_ADD 6'b000001
`define OP_SUB 6'b000011
`define OP_AND 6'b000101
`define OP_OR 6'b000110
`define OP_BEZ 6'b101000
`define OP_BNE 6'b101001
`define OP_JMP 6'b101010

// To be used in side ALU
`define EXE_ADD 4'b0000
`define EXE_SUB 4'b0010
`define EXE_AND 4'b0100
`define EXE_OR 4'b0101
`define EXE_NO_OPERATION 4'b1111 // for NOP, BEZ, BNQ, JMP

// To be used in conditionChecker
`define COND_JUMP 2'b10
`define COND_BEZ 2'b11
`define COND_BNE 2'b01
`define COND_NOTHING 2'b00
