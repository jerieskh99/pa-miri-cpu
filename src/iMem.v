module iMem(
    input [31:0] pc,
    output [31:0] instruction
);
    reg [31:0] mem [0:1024];

    initial begin
        $readmemh("code.txt", mem);
    end

    assign instruction = mem[pc[31:2]]; // word aligned to 4 bytes - apply *4 to PC index.

endmodule