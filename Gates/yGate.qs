operation YGateExample() : Result {
    use q = Qubit();

    let initialMeasurement = M(q);
    Message($"Initial measurement = {initialMeasurement}");
    Y(q);

    let result = M(q);
    Message($"Final measurement = {result}");

    Reset(q);
    return result;
}