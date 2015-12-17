function [y] = GenerateElipse(a, b, samples)
    theta = rand(samples)*2*pi;
    y = zeros(length(theta), 2);
    f = Elipse(a, b);
    for i = 1 : length(y)
        y(i, :) = f(theta(i));
    end
end