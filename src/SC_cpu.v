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
    output [3:0] ALUOp_out,
    output [31:0] reg_out1,
    output [31:0] reg_out2,
    output [4:0] rs1_out,
    output [4:0] rs2_out,
    output [4:0] rd_out,
    output [31:0] write_back_out,
    output [31:0] alu_result_out,
    output alu_zero_out,
    output [3:0] alu_control_out
);
    wire [31:0] current_pc;

    wire [31:0] pc_plus4;
    assign pc_plus4 = current_pc + 4;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_in(next_pc),
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

    wire [31:0] REG_OUT1;
    wire [31:0] REG_OUT2;
    wire [31:0] WRITE_BACK;

    assign WRITE_BACK = _memtoReg ? MemRead_out : alu_result; // For now, write back ALU result. Memory access not implemented.

    regFile REGFILE(
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(WRITE_BACK),
        .RegWrite(_RegWrite),
        .clk(clk),
        .regout1(REG_OUT1),
        .regout2(REG_OUT2)
    );

    wire [3:0] alu_control;
    wire [31:0] alu_input2;
    wire [31:0] alu_result;
    wire alu_zero;

    ALU_CONTROL ALU_CTRL(
        .ALUOp(_ALUOp),
        .func3(func3),
        .func7(func7),
        .ALUControl(alu_control)
    );

    assign alu_input2 = (_ALUSrc) ? imm_I : REG_OUT2;

    ALU ALU_UNIT(
        .input1(REG_OUT1),
        .input2(alu_input2),
        .ALUControl(alu_control),
        .ALUResult(alu_result),
        .zero(alu_zero)
    );

    wire [31:0] branch_target;
    wire [31:0] jal_target;
    wire        pc_branch_eq;

    assign branch_target = current_pc + imm_B;
    assign jal_target = current_pc + imm_J;
    assign pc_branch_eq = _Branch & alu_zero;

    assign next_pc = _jump ? jal_target :
                (pc_branch_eq) ? branch_target :
                pc_plus4;

    wire [31:0] dmem_out;
    dmem DRAM(
        .clk(clk),
        .MemRead(_MemRead),
        .MemWrite(_MemWrite),
        .address(alu_result),
        .write_data(REG_OUT2),
        .read_data(dmem_out)
    );

    // assign next_pc = pc_plus4;
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

    assign reg_out1 = REG_OUT1;
    assign reg_out2 = REG_OUT2;
    assign rs1_out = rs1;
    assign rs2_out = rs2;
    assign rd_out = rd;
    assign write_back_out = WRITE_BACK;

    assign alu_result_out  = alu_result;
    assign alu_zero_out    = alu_zero;
    assign alu_control_out = alu_control;

endmodule