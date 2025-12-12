# FPGA_Stream_Cipher

![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Platform](https://img.shields.io/badge/FPGA-Intel%20Cyclone%20V-red)
![Throughput](https://img.shields.io/badge/Throughput-1.21%20Gbps-green)
<a href="https://buymeacoffee.com/leonardo.corsini"><img alt="Make a donation" src="https://img.shields.io/badge/Make a donation-red.svg"></a>


A high-throughput, pipelined stream cipher implementation targeting **Operational Technology (OT)** and real-time embedded systems. Designed in **SystemVerilog** and synthesized on **Intel Cyclone V**.

## Project Overview
This project implements a custom stream cipher based on the **Galois Multiplication function of the AES algorithm**. It is designed to encrypt/decrypt data byte-by-byte, making it ideal for continuous data flows where low latency and high throughput are critical requirements.

The architecture features a **4-stage pipeline** capable of sustaining a throughput of **1 byte per clock cycle** once filled.

## Algorithm & Architecture
The cipher generates a keystream based on a 32-bit key and a counter block operation:
$$C[i] = P[i] \oplus S(CB[i])$$
Where:
* **$S()$**: Galois multiplication function derived from AES.
* **$CB[i]$**: Counter Block value ($Key + i \pmod{2^{32}}$).

### Key Features
* **Pipeline:** 4-stage architecture to maximize $f_{MAX}$ and throughput.
* **Interface:** Supports valid/encrypt bit propagation for metadata continuity.
* **Flexibility:** Instant re-keying support without hardware reset.
* **Efficiency:** extremely low resource usage (Logic ALMs < 0.1%).

## Performance Results
Synthesized on **Intel Cyclone V (5CGXFC9D6F27C7)** using Quartus Prime Lite 24.1.

| Metric | Result |
| :--- | :--- |
| **Max Frequency ($f_{MAX}$)** | **151.88 MHz** |
| **Throughput** | **~1.21 Gbps** |
| **Latency** | 4 Clock Cycles |
| **Logic Utilization** | 58 ALMs (Logic) |
| **Registers** | 95 Total Registers |

## Verification
The design was verified using **ModelSim** against a **Python Gold Model**.
1.  **Unit Testing:** Verified $S()$ function and Counter Block integrity.
2.  **System Testing:** Validated encryption/decryption against randomly generated test vectors.
3.  **Stress Testing:** Validated mixed workloads (simultaneous Encrypt/Decrypt requests) and sparse data arrival.

## Tools Used
* **Intel Quartus Prime Lite** (Synthesis & Timing Analysis)
* **ModelSim** (Simulation)
* **Python** (Golden Model & Test Vector Generation)

## Support

If you find this project useful, and you want to support my work, consider giving it a ⭐ on GitHub, sharing it with others.
You could donate on https://buymeacoffee.com/leonardo.corsini to support the development. I will be grateful for any donation you want to make.

Contributions and feedback are welcome!
