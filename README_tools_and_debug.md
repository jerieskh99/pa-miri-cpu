**File name suggestion:** `README_tools_and_debug.md`

````markdown
# PA-MIRI CPU – Tools & Debugging Guide

This README explains how to run simulations, view waveforms, and inspect RTL for this project on macOS using VSCode.

The flow is:

1. Edit RTL + testbenches in VSCode  
2. Simulate with **Icarus Verilog**  
3. View waveforms with the **Surfer** VSCode extension  
4. Optionally view RTL schematics with **Yosys**

---

## 1. Tools you need (macOS)

Install CLI tools with Homebrew:

```bash
brew install icarus-verilog yosys
````

Recommended VSCode extensions:

* **Verilog/SystemVerilog support** (any syntax-highlighting / language support extension you like)
* **Surfer – HDL Visual Debugger** (waveform viewer)

After installing Surfer, you should see a **Surfer** icon in the VSCode activity bar (left side).

---

## 2. Directory layout (example)

For small modules:

```text
pa-miri-cpu/
  ├── rtl/
  │   └── and_gate.v
  ├── tb/
  │   └── and_gate_tb.v
  └── waves/
      └── (VCD files will go here)
```

You can change the layout, but the examples below assume something similar.

---

## 3. Minimal example: AND gate

### 3.1 RTL (`rtl/and_gate.v`)

```verilog
// and_gate.v
module and2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

### 3.2 Testbench (`tb/and_gate_tb.v`)

```verilog
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
        $dumpfile("waves/and_gate.vcd");
        $dumpvars(0, and_gate_tb);

        // Stimulus
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        #10 $finish;
    end
endmodule
```

> Note: make sure the `waves/` directory exists, or change the path in `$dumpfile`.

---

## 4. Running the simulation (Icarus Verilog)

From the project root:

```bash
# 1) Compile
iverilog -g2012 -o build/and_gate_tb.vvp tb/and_gate_tb.v rtl/and_gate.v

# 2) Run
vvp build/and_gate_tb.vvp
```

After `vvp` finishes, you should have:

```text
waves/and_gate.vcd
```

You can quickly check that the VCD is non-empty by opening it in a text editor – you should see `$var` lines and `#<time>` entries.

---

## 5. Viewing waveforms with Surfer

1. In VSCode, click the **Surfer** icon in the left activity bar.
2. Click **“Open VCD file…”** (wording may vary slightly) and select `waves/and_gate.vcd`.
3. Surfer will parse the VCD and show:

   * A list of signals (hierarchy starting at `and_gate_tb`).
   * A waveform area.

If you don’t see signals:

* Confirm the testbench actually produced `waves/and_gate.vcd` (rerun `vvp` if needed).
* Make sure `$dumpvars(0, and_gate_tb);` is present in the testbench.
* Try closing and reopening the Surfer panel and re-selecting the VCD.

---

## 6. Viewing RTL schematics with Yosys

You can use **Yosys** to generate a simple schematic of a module.

### 6.1 Simple example for `and2`

From the project root:

```bash
yosys -p 'read_verilog rtl/and_gate.v; prep -top and2; show -format svg -prefix and2'
```

This will create a file:

```text
and2.svg
```

Open `and2.svg` in your browser or in VSCode’s built-in SVG viewer to see the gate-level schematic.

> **Note on `xdot` errors:**
> If you run `show` without `-format svg`, Yosys tries to call `xdot`, which may not be installed (`sh: xdot: command not found`).
> Using `-format svg` avoids this dependency and is usually more convenient.

### 6.2 For larger designs

Once you have a top-level CPU module, you can do something like:

```bash
yosys -p 'read_verilog rtl/*.v; hierarchy -top cpu_top; proc; opt; show -format svg -prefix cpu_top'
```

Replace `cpu_top` with the name of your actual top module.

---

## 7. If you get stuck

Common issues & fixes:

* **No waveforms in Surfer**

  * Check that `vvp` actually ran and produced the VCD.
  * Ensure `$dumpfile` path matches where you’re looking.
  * Ensure `$dumpvars(0, top_module_name);` uses the correct top module name.
* **Yosys says `xdot: command not found`**

  * Use `show -format svg` instead of plain `show`.
* **Simulator can’t find modules**

  * Verify the `iverilog` command includes *all* needed RTL files.
  * Check module names (`module and2` vs instance name `and2 dut`).

Once this basic flow works for the AND gate, you can grow it into your single-cycle CPU:
replace `and2` with your top CPU module, expand the testbench, and reuse the same simulation + Surfer + Yosys pattern.
