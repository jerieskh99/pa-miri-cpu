
module decoder_controller(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output wire RegWrite, // write to rd
    output wire MemRead,
    output wire MemWrite,
    output wire memtoReg, // writeback come from memory or ALU?
    output wire Branch,
    output wire ALUSrc, // Second operand = rs2 (0) or immediate (1)?
    output wire jump,
    output wire [3:0] ALUOp // ALU Operation
);
    // Control signal generation based on opcode
    reg _RegWrite;
    reg _MemRead;
    reg _MemWrite;
    reg _memtoReg;
    reg _ALUSrc;
    reg _jump;
    reg _Branch;
    reg [3:0] _ALUOp;

    always @(*) begin
        _RegWrite=0;
        _MemRead=0;
        _MemWrite=0;
        _memtoReg=0;
        _Branch=0;
        _ALUSrc=0;
        _jump=0;
        _ALUOp=4'b0000; // NOP 
        case (opcode)
            7'b0110011: begin // R-type
            _RegWrite=1;
            _MemRead=0;
            _MemWrite=0;
            _memtoReg=0;
            _Branch=0;
            _ALUSrc=0;
            _jump=0;
            _ALUOp=4'b0010; // ALU does operation based on func3 and func7
            end

            7'b0010011: begin // I-type (ALU immediate)
            _RegWrite=1;
            _MemRead=0;
            _MemWrite=0;
            _memtoReg=0;
            _Branch=0;
            _ALUSrc=1;
            _jump=0;
            _ALUOp=4'b0010; // ALU does operation based on func3
            end

            7'b0000011: begin // Load
            _RegWrite=1;
            _MemRead=1;
            _MemWrite=0;
            _memtoReg=1;
            _Branch=0;
            _ALUSrc=1;
            _jump=0;
            _ALUOp=4'b0001; // ALU does addition for address calculation
            end
        
            7'b0100011: begin // Store
            _RegWrite=0;
            _MemRead=0;
            _MemWrite=1;
            _memtoReg=0;
            _Branch=0;
            _ALUSrc=1;
            _jump=0;
            _ALUOp=4'b0001; // ALU does addition for address calculation
            end

            7'b1100011: begin // Branch
            _RegWrite=0;
            _MemRead=0;
            _MemWrite=0;
            _memtoReg=0;
            _Branch=1;
            _ALUSrc=0;
            _jump=0;
            _ALUOp=4'b0100; // ALU does subtraction for comparison
            end

            7'b1101111: begin // JAL
            _RegWrite=1; // Write return address to rd
            _MemRead=0;
            _MemWrite=0;
            _memtoReg=0;
            _Branch=0;
            _ALUSrc=0;
            _jump=1;
            _ALUOp=4'b0000; // NOP
            end
    endcase 
    end

    assign RegWrite = _RegWrite;
    assign MemRead = _MemRead;
    assign MemWrite = _MemWrite;
    assign memtoReg = _memtoReg;
    assign Branch = _Branch;
    assign ALUSrc = _ALUSrc;
    assign jump = _jump;
    assign ALUOp = _ALUOp;


endmodule