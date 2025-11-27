module decoder(
    input [31:0] instruction,
    output wire [6:0] opcode,
    output wire [4:0] rd,
    output wire [2:0] func3,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [6:0] func7,
    output wire [31:0] imm_I,
    output wire [31:0] imm_S,
    output wire [31:0] imm_B,
    output wire [31:0] imm_J
);
    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign func3  = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign func7  = instruction[31:25];

    // Immediate generation
    // I-type immediate
    assign imm_I = {{20{instruction[31]}}, instruction[31:20]};

    // S-type immediate
    assign imm_S = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

    // B-type immediate
    assign imm_B = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // J-type immediate
    assign imm_J = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

endmodule

