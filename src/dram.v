module DRAM(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);
    reg [7:0] memory [0:1023]; // 1KB Memory

    always @(*) begin
        if (MemRead) begin
            read_data = {memory[address],
                         memory[address+1],
                         memory[address+2],
                         memory[address+3]};
        end
        else begin
            read_data = 32'b0;
        end
    end

    always @(posedge clk) begin
        if (MemWrite) begin
            memory[address]   = write_data[31:24];
            memory[address+1]   = write_data[23:16];
            memory[address+2]   = write_data[15:8];
            memory[address+3]   = write_data[7:0];
        end
    end
endmodule