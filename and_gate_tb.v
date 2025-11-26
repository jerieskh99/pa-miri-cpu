// and_gate_tb.v
`timescale 1ns/1ps

module and_gate_tb;
    reg a;
    reg b;
    wire y;

    // DUT
    and2 dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // VCD dump for waveform
        $dumpfile("and_gate.vcd");
        $dumpvars(0, and_gate_tb);

        // Stimulus
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        #10 $finish;
    end
endmodule
