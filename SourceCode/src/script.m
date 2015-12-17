clc;
close all;
a = 1;
b = 4;

y0 = GenerateElipse(a, b, 100);

y = GenerateNoiseElipse(a, b, 100, 50);
y = Rotation(y, pi/2);
%scatter(y(:, 1), y(:, 2), 'g')

z = CreateEvaluationFunction(y0, y);
S0 = [0]';
S = SimmulatedAnnealing(S0, z, 100, 0.95);
%translation can be found comparing center of gravity
yf = Rotation(y, S(1)); 
figure(),
hold on
scatter(y0(:, 1), y0(:, 2), 'ok')
scatter(y(:, 1), y(:, 2), '.k')
scatter(yf(:, 1), yf(:, 2), '*r')