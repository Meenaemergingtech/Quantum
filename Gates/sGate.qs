operation SGateExample() : Result {
    use q = Qubit();

    let initialMeasurement = M(q);
    Message($"Initial measurement = {initialMeasurement}");

    H(q);
    let intermediateMeasurement = M(q);
    Message($"Intermediate measurement = {intermediateMeasurement}");
    S(q);

    let result = M(q);
    Message($"Final measurement = {result}");

    Reset(q);
    return result;
}