# Quantum Word Transmission POC

This repository contains a small proof-of-concept (POC) for quantum word transmission, gate demonstrations, and noisy teleportation experiments implemented in Q#.

## Repository contents

- `main.qs` — Minimal Q# entry point and Bell-pair demonstration.
- `transmission.qs` — Basic quantum transmission example using entanglement and measurement.
- `word_transmission.qs` — ASCII word encoding/decoding and bit-by-bit teleportation workflow.
- `NoisyQuantumTransportation.qs` — Teleportation with an added bit-flip noise model and a configurable noise probability.

### Gate samples

The `Gates/` folder contains single-gate and basic quantum logic examples:

- `Gates/xGate.qs` — Pauli-X gate example.
- `Gates/yGate.qs` — Pauli-Y gate example.
- `Gates/zGate.qs` — Pauli-Z gate example.
- `Gates/sGate.qs` — S-gate (phase gate) example using `R1(PI()/2.0, target)`.
- `Gates/hGate.qs` — Hadamard gate example.

## Recent additions

The most recent additions to the POC include:

- `NoisyQuantumTransportation.qs` — Demonstrates teleportation with noise on the transmitted qubit and prints the Alice/Bob measurement results.
- `Gates/sGate.qs` — Adds a focused S-gate example for learning phase operations and their effect on qubit states.

## Prerequisites

- Microsoft QDK (Q#) installed. See https://learn.microsoft.com/azure/quantum/ for installation and setup.

## Quick start

1. Open the folder in Visual Studio Code with the Q# extension installed.
2. Build or run the Q# files using the QDK tooling or the VS Code run/debug UI.

Example using the QDK CLI:

```bash
# From the project directory
qsharp build
qsharp run main.qs
```

If you are using a .NET-based project setup instead:

```bash
dotnet build
dotnet run
```

## Notes

- This project is a learning and experimentation POC, so several files are intentionally focused on individual concepts rather than a single production-ready application.
- The README will be updated as more gate experiments, simulations, or documentation examples are added.

## License

- Copyright (c) Your Name. All rights reserved.
