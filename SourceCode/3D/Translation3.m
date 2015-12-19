function y = Translation3(x, tx, ty, tz)
    y = zeros(size(x));
    T = [1 0 0 tx; 0 1 0 ty; 0 0 1 tz; 0 0 0 1];
    for i = 1:length(x)
        trans = T * [x(i, :)'; 1];
        y(i, :) = [trans(1); trans(2); trans(3)];
    end
end