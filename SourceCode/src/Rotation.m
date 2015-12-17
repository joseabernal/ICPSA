function y = Rotation(x, theta)
    y = zeros(size(x));
    T = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    for i = 1:length(x)
        y(i, :) = T * x(i, :)';
    end
end