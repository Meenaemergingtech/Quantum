
namespace QuantumAsciiTransport {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    // Teleport a single qubit from Alice to Bob
    operation TeleportQubit(q : Qubit, target : Qubit) : Unit {
        use bellQubits = Qubit[2] {
            // Create entanglement between bellQubits[0] (Alice) and bellQubits[1] (Bob)
            H(bellQubits[0]);
            CNOT(bellQubits[0], bellQubits[1]);

            // Bell measurement between q and Alice's entangled qubit
            CNOT(q, bellQubits[0]);
            H(q);
            let m1 = M(q);
            let m2 = M(bellQubits[0]);

            // Send classical bits m1, m2 to Bob (simulated here)
            if (m2 == One) { X(bellQubits[1]); }
            if (m1 == One) { Z(bellQubits[1]); }

            // Copy teleported state into target qubit
            if (M(bellQubits[1]) == One) { X(target); }

            // Reset ancilla qubits
            ResetAll(bellQubits);
        }
    }

    // Encode ASCII value into qubits
    operation EncodeAscii(asciiValue : Int, qubits : Qubit[]) : Unit {
        for idx in 0 .. Length(qubits) - 1 {
            let bit = (asciiValue >>> idx) &&& 1;
            if (bit == 1) { X(qubits[idx]); }
        }
    }

    // Decode qubits back into ASCII integer
    operation DecodeAscii(qubits : Qubit[]) : Int {
        mutable value = 0;
        for idx in 0 .. Length(qubits) - 1 {
            let result = M(qubits[idx]);
            if (result == One) {
                set value += (1 <<< idx);
            }
        }
        return value;
    }

    @EntryPoint()
    operation Main() : Unit {
        let message = "hi";
        Message($"Original message: {message}");

        let asciiValues = [104, 105];
        for asciiValue in asciiValues {
            use receiverQubits = Qubit[8] {
                use senderQubits = Qubit[8] {
                    // Encode ASCII into sender qubits
                    EncodeAscii(asciiValue, senderQubits);

                    // Teleport each qubit to receiver
                    for i in 0 .. 7 {
                        TeleportQubit(senderQubits[i], receiverQubits[i]);
                    }

                    // Decode at receiver
                    let receivedValue = DecodeAscii(receiverQubits);

                    Message($"Sent ASCII {asciiValue} → Received ASCII {receivedValue}");

                    // Reset qubits
                    ResetAll(senderQubits);
                    ResetAll(receiverQubits);
                }
            }
        }
    }
}

