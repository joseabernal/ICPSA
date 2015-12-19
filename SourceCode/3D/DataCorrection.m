function C = DataCorrection(B, A)
    diff = mean(A) - mean(B);
    C = Translation3(B, diff(1), diff(2), diff(3));
end