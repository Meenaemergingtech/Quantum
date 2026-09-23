operation ZGateExample() : Result {
    use q = Qubit();
 let initialMeasurement = M(q);
    Message($"Initial measurement = {initialMeasurement}");
    X(q);       // Put qubit into |1>
    let intermediateMeasurement = M(q);
    Message($"Intermediate measurement = {intermediateMeasurement}");   
    Z(q);       // Apply phase flip

    let result = M(q);
    Message($"Final measurement = {result}");

    Reset(q);
    return result;
}
