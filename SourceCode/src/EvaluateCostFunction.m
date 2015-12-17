function cost = EvaluateCostFunction(A, B, T)
    Btrans = zeros(size(B));
    for i = 1:length(B)
        Btrans(i, :) = [cos(T(1)) -sin(T(1)); sin(T(1)) cos(T(1))] * B(i, :)';
    end
    
    cost = DetermineVolume(A, Btrans);
end