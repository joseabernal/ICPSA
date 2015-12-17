function y = Translation(x, tx, ty)
    y = zeros(size(x));
    T = [1 0 tx; 0 1 ty; 0 0 1];
    for i = 1:length(x)
        trans = T * [x(i, :)'; 1];
        y(i, :) = [trans(1); trans(2)];
    end
end