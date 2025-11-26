# CPU Project — Single-Cycle → Pipelined → Cached → Virtual Memory

(UPC – PA-MIRI 2025/2026)

This repository contains the source code and testbenches for implementing a full processor architecture as required by the PA-MIRI project specification.

The processor will be developed in **four milestones**:

1. **Single-Cycle CPU**

   * Basic ISA implementation
   * ADD/SUB/MUL, loads/stores, BEQ, JUMP
   * No pipeline, no hazards
   * Simple instruction/data memory
   * Clean combinational datapath

2. **5-Stage Pipelined CPU**

   * IF / ID / EX / MEM / WB
   * Full bypassing
   * Hazard detection, stall logic
   * Correct branch behavior

3. **Instruction + Data Cache**

   * 4 lines × 128-bit
   * Configurable associativity and replacement policy
   * 5-cycle memory latency simulation
   * Instruction fetch and data access integration

4. **Virtual Memory + TLB + Exceptions**

   * iTLB + dTLB
   * Virtual→Physical translation
   * Exception handling
   * Mini-OS flow with rm0/rm1/rm4 registers
   * TLBWRITE + IRET support

---

## 📦 Project Structure

```
src/
    alu.v                # ADD/SUB/MUL logic
    regfile.v            # 32×32 register file with 2R1W
    pc.v                 # Program counter logic
    imem.v               # Instruction memory (simple ROM or hex)
    dmem.v               # Data memory (RAM)
    cpu_single_cycle.v   # Top module (single-cycle)
    ... (future: pipeline regs, caches, tlbs...)
tb/
    tb_cpu.v             # Single-cycle testbench
README.md
.gitignore
```

---

## 🛠 Development Environment (macOS)

Install the simulator:

```bash
brew update
brew install icarus-verilog
```

Run tests:

```bash
iverilog -o cpu.out src/*.v tb/tb_cpu.v
vvp cpu.out
```

Open GTKWave (optional but recommended):

```bash
brew install gtkwave
```

---

## 🔧 VSCode Extensions

Recommended extensions:

* **Verilog-HDL/SystemVerilog** (syntax + lint)
* **Better Comments**
* **Code Runner** (optional)

---

## 🚀 Getting Started

1. Clone the repo:

```bash
git clone <repo_url>
cd <repo>
```

2. Implement the modules in `src/`
3. Run the testbench with Icarus:

```bash
iverilog -o cpu.out src/*.v tb/tb_cpu.v
vvp cpu.out
```

4. Inspect waveforms:

```bash
gtkwave dump.vcd
```

---

## 🧩 Milestone 1 — Single Cycle CPU

Requirements:

* Implement the minimum ISA:

  * ADD, SUB, MUL
  * LDB, LDW
  * STB, STW
  * BEQ, JUMP
* One cycle per instruction
* No pipeline registers
* Simple combinational datapath
* Memory interface without latency

Once this works, you will extend it into the full 5-stage design.

---

## 📝 License

For academic use under the PA-MIRI program.
