namespace NoisyQuantumTeleportation {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Random;

    // Apply bit-flip noise with probability p.
    operation ApplyBitFlipNoise(
        qubit : Qubit,
        probability : Double
    ) : Unit {

        let randomValue = DrawRandomDouble(0.0, 1.0);

        if randomValue < probability {
            X(qubit);
        }
    }

    // Prepare the state to be teleported.
    // Here we use |+> = H|0>.
    operation PrepareState(qubit : Qubit) : Unit {
        H(qubit);
    }

    // Quantum teleportation with a noisy channel.
    operation TeleportWithNoise(
        source : Qubit,
        alice : Qubit,
        bob : Qubit,
        noiseProbability : Double
    ) : (Result, Result) {

        // ------------------------------------------------
        // Step 1: Prepare the source qubit
        // ------------------------------------------------
        PrepareState(source);

        // ------------------------------------------------
        // Step 2: Create Bell pair between Alice and Bob
        // ------------------------------------------------
        H(alice);
        CNOT(alice, bob);

        // ------------------------------------------------
        // Step 3: Alice entangles source with her Bell qubit
        // ------------------------------------------------
        CNOT(source, alice);
        H(source);

        // ------------------------------------------------
        // Step 4: Measurements by Alice
        // ------------------------------------------------
        let m1 = M(source);
        let m2 = M(alice);

        // ------------------------------------------------
        // Step 5: Classical communication
        // ------------------------------------------------
        // Apply corrections to Bob
        if m2 == One {
            X(bob);
        }

        if m1 == One {
            Z(bob);
        }

        // ------------------------------------------------
        // Step 6: Introduce noise in the quantum channel
        // ------------------------------------------------
        ApplyBitFlipNoise(bob, noiseProbability);

        // ------------------------------------------------
        // Step 7: Measure Bob's final state
        // ------------------------------------------------
        let result = M(bob);

        return (m1, result);
    }

    @EntryPoint()
    operation Main() : Unit {

        use (source, alice, bob) = (Qubit(), Qubit(), Qubit()); {

            let noiseProbability = 0.10;

            let (aliceMeasurement, bobMeasurement) =
                TeleportWithNoise(
                    source,
                    alice,
                    bob,
                    noiseProbability
                );

            Message("Quantum Teleportation with Noise");
            Message($"Noise probability = {noiseProbability}");

            Message($"Alice measurement = {aliceMeasurement}");
            Message($"Bob measurement = {bobMeasurement}");

            Reset(source);
            Reset(alice);
            Reset(bob);
        }
    }
}