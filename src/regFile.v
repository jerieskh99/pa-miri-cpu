module regFile(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input RegWrite,
    input clk,
    output [31:0] regout1,
    output [31:0] regout2
);
    reg [31:0] regs[0:31];

    assign regout1 = (rs1 == 0) ? 0 : regs[rs1];
    assign regout2 = (rs2 == 0) ? 0 : regs[rs2];

    always @(posedge clk) begin
        regs[rd] <= ((RegWrite == 1) && (rd != 0)) ? write_data : regs[rd];
    end

endmodule