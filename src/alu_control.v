module ALU_CONTROL(
    input [3:0] ALUOp,
    input [2:0] func3,
    input [6:0] func7,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            4'b0001: ALUControl = 4'b0010; // Load/Store/addi: ADD
            4'b0100: ALUControl = 4'b0011; // Branch: SUB
            4'b0010: begin // R-type and I-type ALU operations
                case (func3)
                    3'b000: begin
                        case (func7)
                            7'b0100000: ALUControl = 4'b0011; // SUB
                            default: ALUControl = 4'b0010; // ADD
                        endcase
                    end
                    3'b111: ALUControl = 4'b0000; // AND
                    3'b110: ALUControl = 4'b0001; // OR
                    3'b100: ALUControl = 4'b0100; // XOR
                    3'b010: ALUControl = 4'b0101; // SLT
                    3'b001: ALUControl = 4'b0110; // SLL
                    3'b101: begin
                        case (func7)
                            7'b0100000: ALUControl = 4'b1000; // SRA
                            default: ALUControl = 4'b0111; // SRL
                        endcase
                    end
                endcase
            end
            4'b0000: ALUControl = 4'b0000; // NOP - default to AND
            default: ALUControl = 4'b0010; // Load/Store/addi: ADD - SAFE DEFAULT
        endcase
    end
endmodule


module ALU_CONTROL(
    input [3:0] ALUOp,
    input [2:0] func3,
    input [6:0] func7,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            4'b0001: ALUControl = 4'b0010; // Load/Store/addi: ADD
            4'b0100: ALUControl = 4'b0011; // Branch: SUB

            4'b0010: begin // R-type & I-type (depends on func3/func7)
                case (func3)
                    3'b000: begin
                        case (func7)
                            7'b0100000: ALUControl = 4'b0011; // SUB
                            default:    ALUControl = 4'b0010; // ADD
                        endcase
                    end
                    3'b111: ALUControl = 4'b0000; // AND
                    3'b110: ALUControl = 4'b0001; // OR
                    3'b100: ALUControl = 4'b0100; // XOR
                    3'b010: ALUControl = 4'b0101; // SLT
                    3'b001: ALUControl = 4'b0110; // SLL
                    3'b101: begin
                        case (func7)
                            7'b0100000: ALUControl = 4'b1000; // SRA
                            default:    ALUControl = 4'b0111; // SRL
                        endcase
                    end
                endcase
            end

            4'b0000: ALUControl = 4'b0000; // NOP (default AND)
            default: ALUControl = 4'b0010; // Safe fallback: ADD
        endcase
    end
endmodule