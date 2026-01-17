# Synchronous FIFO Verification Project

## Overview
This project focuses on the **Design and Verification of a Synchronous FIFO (First-In-First-Out)** memory system using SystemVerilog.
Unlike standard tutorials, this project implements a **robust Class-Based Verification Environment** featuring:
-   **Constrained Random Verification**
-   **Functional Coverage** (Cross-Coverage of Control Signals)
-   **SystemVerilog Assertions (SVA)** for protocol checking
-   **Scoreboard** with a dynamic reference model

## Design Specifications
-   **Depth:** 8-slot circular buffer
-   **Width:** 16-bit data width
-   **Features:** Simultaneous Read/Write support, Status Flags (Empty, Full, Almost Empty, Almost Full), and Error protections (Overflow/Underflow).

## Verification Environment
The testbench follows a layered architecture:
1.  **Interface (`fifo_intf`):** Connects DUT and TB, embedded with **SVA (Assertions)** for immediate protocol violation detection.
2.  **Generator (`fifo_item`):** randomized transaction packets with weighted distributions.
3.  **Driver/Monitor:** Drives stimuli and captures response for analysis.
4.  **Scoreboard (`fifo_checker`):** Implements a **Queue-based Reference Model** to verify data integrity bit-by-bit.
5.  **Coverage (`fifo_cov_group`):** Tracks simulation completeness, ensuring all flag combinations (e.g., *Write when Full*) are hit.

## How to Run

### Using Icarus Verilog (Open Source)
1.  **Install:** [Download Icarus Verilog](https://bleyer.org/icarus/) (Windows) or `sudo apt install iverilog` (Linux).
2.  **Compile & Run:**
    ```bash
    cd My_Original_FIFO
    iverilog -g2012 -o fifo_sim.vvp -I verification ./verification/fifo_common_pkg.sv ./verification/fifo_item.sv ./verification/fifo_intf.sv ./verification/fifo_cov_group.sv ./verification/fifo_checker.sv ./verification/fifo_monitor.sv ./verification/fifo_tester.sv ./verification/fifo_tb_top.sv ./rtl/sync_fifo_dut.v
    vvp fifo_sim.vvp
    ```
3.  **View Waveforms:**
    ```bash
    gtkwave fifo_wave.vcd
    ```

### Using ModelSim / QuestaSim
1.  **Create Project:** Open ModelSim -> File -> New -> Project -> Name it "FIFO_Verify".
2.  **Add Files:** Add all files from `My_Original_FIFO/rtl` and `My_Original_FIFO/verification`.
3.  **Compile:** Compile All.
4.  **Simulate:** `vsim -voptargs=+acc work.fifo_tb_top`.
5.  **Waveforms:** Add signals to wave window and run `-all`.

## Key Verification Scenarios
-   **Burst Write:** Filled FIFO to capacity to verify `full` and `overflow` flags.
-   **Burst Read:** Emptied FIFO to verify `empty` and `underflow` flags.
-   **Random Stress:** Randomized 2000+ transactions to hit corner cases (e.g., Simultaneous Read/Write at thresholds).

## Results
-   **Data Integrity:** 100% Data Matching between DUT and Reference Model.
-   **Protocol Safety:** 0 Assertion Failures.
-   **Coverage:** 100% Functional Coverage achieved on Control Signal transitions.
