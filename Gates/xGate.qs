operation XGate() : Result {
    use q = Qubit();

    
    let initialMeasurement = M(q);
    Message($"Initial measurement = {initialMeasurement}");
    X(q);
    let result = M(q);

    Reset(q);
    return result;
}