function evf = CreateEvaluationFunction(A, B)
    evf = @(T) EvaluateCostFunction(A, B, T);
end