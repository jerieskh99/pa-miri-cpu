`timescale 1ns / 1ps

module tb_Imem();
    reg clk = 0;
    reg reset;
    wire [31:0] next_pc;
    wire [31:0] instruction_out;
    wire [31:0] curr_pc;
    wire [6:0] opcode_out;
    wire RegWrite_out;
    wire MemRead_out;
    wire MemWrite_out;
    wire memtoReg_out;
    wire Branch_out;
    wire ALUSrc_out;
    wire jump_out;
    wire [3:0] ALUOp_out;



    SC sc_cpu(
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .instruction_out(instruction_out),
        .curr_pc(curr_pc),
        .opcode_out(opcode_out),
        .RegWrite_out(RegWrite_out),
        .MemRead_out(MemRead_out),
        .MemWrite_out(MemWrite_out),
        .memtoReg_out(memtoReg_out),
        .Branch_out(Branch_out),
        .ALUSrc_out(ALUSrc_out),
        .jump_out(jump_out),
        .ALUOp_out(ALUOp_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sc.vcd");
        $dumpvars(0, tb_Imem);
        reset = 1;
        #10;
        reset = 0;
        #200;
        

        $finish;
    end



endmodule