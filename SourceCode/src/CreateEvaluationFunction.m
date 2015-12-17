function evf = CreateEvaluationFunction(A, B)
    B = DataCorrection(B, A);
    evf = @(T) EvaluateCostFunction(A, B, T);
end