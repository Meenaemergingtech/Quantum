// Helper: measure the Pauli Y observable by rotating the Y-eigenbasis to Z,
// then measuring in the computational basis. (Apply Adjoint S, then H, then M.)
operation MeasurePauliY(q : Qubit) : Result {
    Adjoint S(q);
    H(q);
    let r = M(q);
    // Optional: leave qubit measured in |0> by undoing H and S (not strictly needed here)
    // Undo the basis-change only if you plan to reuse the qubit's state.
    return r;
}

@EntryPoint()
operation RunSGateDemo() : Unit {
    use q = Qubit();

    // Trial A: prepare |+> (X eigenstate) and measure Y (without applying S)
    H(q);                                // prepare |+>
    let rA = MeasurePauliY(q);           // measure Y on |+> -> expected ~50/50
    Message($"Trial A - measure Y on |+>: {rA}");

    // Reset q to |0> for reuse (flip if result was One)
    if (rA == One) { X(q); }

    // Trial B: prepare |+>, apply S, then measure Y
    H(q);                                // prepare |+>
    S(q);                                // apply S -> transforms |+> into Y+ eigenstate
    let rB = MeasurePauliY(q);           // measure Y on S|+> -> expected deterministic Zero (Y+)
    Message($"Trial B - apply S then measure Y: {rB}");

    if (rB == One) { X(q); }
    Reset(q);
}