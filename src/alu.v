module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg zero
);
    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = input1 & input2; //AND
            4'b0001: ALUResult = input1 | input2; //OR
            4'b0010: ALUResult = input1 + input2; //ADD
            4'b0011: ALUResult = input1 - input2; //SUB
            4'b0100: ALUResult = input1 ^ input2; //XOR
            4'b0101: ALUResult = input1 < input2 ? {{31{1'b0}}, 1'b1} : 32'b0; //SLT
            4'b0110: ALUResult = input1 << input2[4:0]; //SLL
            4'b0111: ALUResult = input1 >> input2[4:0]; //SRL
            4'b1000: ALUResult = $signed(input1) >>> input2[4:0]; //SRA
            default: ALUResult = 0;
        endcase
        zero = (ALUResult == 0);
    end
endmodule


