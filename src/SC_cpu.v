module SC(
    input clk,
    input reset,
    output [31:0] next_pc,
    output [31:0] instruction_out,
    output [31:0] curr_pc,
    output [6:0] opcode_out,
    output RegWrite_out,
    output MemRead_out,
    output MemWrite_out,
    output memtoReg_out,
    output Branch_out,
    output ALUSrc_out,
    output jump_out,
    output [3:0] ALUOp_out
);
    wire [31:0] current_pc;

    wire [31:0] pc_plus4;
    assign pc_plus4 = current_pc + 4;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_plus4),
        .pc_out(current_pc)
    );

    wire [31:0] instruction;
    iMem IMEM(
        .pc(current_pc),
        .instruction(instruction)
    );

    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] func3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [6:0] func7;
    wire [31:0] imm_I;
    wire [31:0] imm_S;
    wire [31:0] imm_B;
    wire [31:0] imm_J;

    decoder DEC(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .func3(func3),
        .rs1(rs1),
        .rs2(rs2),
        .func7(func7),
        .imm_I(imm_I),
        .imm_S(imm_S),
        .imm_B(imm_B),
        .imm_J(imm_J)
    );

    wire _RegWrite; // write to rd
    wire _MemRead;
    wire _MemWrite;
    wire _memtoReg; // writeback come from memory or ALU?
    wire _Branch;
    wire _ALUSrc; // Second operand = rs2 (0) or immediate (1)?
    wire _jump;
    wire [3:0] _ALUOp; // ALU Operation

    decoder_controller d_controller(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .RegWrite(_RegWrite),
        .MemRead(_MemRead),
        .MemWrite(_MemWrite),
        .memtoReg(_memtoReg),
        .Branch(_Branch),
        .ALUSrc(_ALUSrc),
        .jump(_jump),
        .ALUOp(_ALUOp)
    );

    assign next_pc = pc_plus4;
    assign curr_pc = current_pc;
    assign instruction_out = instruction;
    assign opcode_out = opcode;
    assign RegWrite_out = _RegWrite;
    assign MemRead_out = _MemRead;
    assign MemWrite_out = _MemWrite;
    assign memtoReg_out = _memtoReg;
    assign Branch_out = _Branch;
    assign ALUSrc_out = _ALUSrc;
    assign jump_out = _jump;
    assign ALUOp_out = _ALUOp;

endmodule