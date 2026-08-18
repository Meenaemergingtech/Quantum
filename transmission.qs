
namespace Quantum.Concepts {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation Teleportation(sentMessage: Bool) : Bool {
        mutable messageReceived = false;

        // An array of three qubits allocated, representing the message qubit, Alice's qubit, and Bob's qubit.
        use register = Qubit[3];
        let message = register[0];

        // The first qubit is set to the state |1⟩ if sentMessage is true, otherwise it remains in the state |0⟩.
        if(sentMessage) {
            // Flip the qubit to |1> state
            X(message)
        }

        let alice = register[1];
        let bob = register[2];

        // An entangled pair is created where the two qubits become correlated such that 
        // their states are entangled. Any changes made to one qubit will instantaneously 
        // affect the other qubit, regardless of the distance between them.
        H(alice);
        // CNOT gate is applied with alice as the control and bob as the target, creating an entangled state between them.
        CNOT(alice, bob);

        // We want to teleport the message Qubit to Bob by entangling it with alice
        // The message qubit is entangled with Alice's qubit using a CNOT gate.
        CNOT(message, alice);
        H(message);
        
        // To teleport the qubit, Alice performs a special quantum measurement known 
        // as a Bell measurement on her qubit and the entangled qubit. This measurement 
        // is a joint measurement that extracts two classical bits of information.
        let messageState = M(message);
        let aliceState = M(alice);
        
        // Based on the outcome of the Bell measurement, Alice obtains two classical 
        // bits of information that she sends to Bob through classical communication channels. 
        // These bits contain information about the measurement result.

        // Upon receiving the two classical bits from Alice, Bob uses this information to 
        // perform a series of quantum operations on his qubit.

        // The classical bits received by Bob from Alice determine which of the four possible quantum 
        // operations Bob should apply to his qubit. These operations are:

        // 00 Outcome: If Alice's measurement result yields 00, Bob's qubit is already in the correct state, so no further action is needed.

        // 01 Outcome: If Alice's measurement result yields 01, Bob applies a Pauli-X gate (bit-flip gate) to his qubit. 
        // This gate flips the state of Bob's qubit, effectively changing |0⟩ to |1⟩ and |1⟩ to |0⟩.

        // 10 Outcome: If Alice's measurement result yields 10, Bob applies a Pauli-Z gate (phase-flip gate) to his qubit. 
        // This gate introduces a phase flip, leaving the basis states unchanged but introducing a phase of -1 to the |1⟩ state.

        // 11 Outcome: If Alice's measurement result yields 11, Bob applies both a Pauli-X gate (bit-flip gate) and a Pauli-Z gate (phase-flip gate) to his qubit. 
        // This combination of gates effectively performs both a bit-flip and a phase-flip operation.

        // Apply Pauli-Z gate (phase-flip gate) to Bob's Quibt
        if messageState == One {
            Z(bob);
        }

        // Apply Pauli-X gate (bit-flip gate) to Bob's qubit. 
        if aliceState == One {
            X(bob)
        }

        // After Bob applies the appropriate quantum operation, his qubit is now in 
        // the exact same state as the original qubit that Alice wanted to teleport.
        let bobState = M(bob);
        if bobState == One {
            set messageReceived = true;
        }

        // While the quantum state information is communicated instantaneously through 
        // the entangled qubits, the classical information obtained from the measurement 
        // result and the subsequent quantum operation by Bob are communicated classically, 
        // which is subject to the limitations of classical communication speed. 
        // As a result, the overall teleportation process does not occur instantaneously; 
        // it is limited by the speed of classical communication.

        // Reset all the qubits that we used
        ResetAll(register);

        return messageReceived;
    }

    @EntryPoint()
    operation Main() : Bool{
        // Get a random message to be sent
        let sentMessage = GetRandom();
        
        // Invoke the quantum teleportation operation
        let messageReceieved = Teleportation(sentMessage);

        return (messageReceieved);
    }

    operation GetRandom():Bool {
        use q = Qubit();

        H(q);
        let r = M(q);
        Reset(q);

        return {
            if r == One {
                true
            } else {
                false
            }
        };
    }

}