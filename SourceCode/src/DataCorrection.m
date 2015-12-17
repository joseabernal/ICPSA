function C = DataCorrection(B, A)
    diff = mean(A) - mean(B);
    C = Translation(B, diff(1), diff(2));
end