operation HGateExample() : Result {
    use q = Qubit();
    let initialMeasurement = M(q);
    Message($"Initial measurement = {initialMeasurement}");
    H(q);

    let result = M(q);
    Message($"Final measurement = {result}");

    Reset(q);
    return result;
}