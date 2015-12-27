% Clear workspace
clc;
close all;

% Elipse parameters
a = 1;
b = 4;

% Include basic functions
handler = BasicFunctions2D;

% Data cloud 1 generation
y0 = handler.GenerateElipse(a, b, 100);

% Data cloud 2 generation
y = handler.GenerateNoiseElipse(a, b, 100, 20);
y = handler.Rotation(y, pi/3);
y = handler.Translation(y, 2, 3);

% Data fitting
z = handler.CreateEvaluationFunction(y0, y);
S0 = [0]';
S = handler.SimmulatedAnnealing(S0, z, 100, 0.95);
%translation can be found comparing center of gravity
yf = handler.Rotation(y, S(1));
yf = handler.DataCorrection(yf, y0);

% Plot results
figure(),
hold on
scatter(y0(:, 1), y0(:, 2), 'ok')   % Cloud of points 1
scatter(y(:, 1), y(:, 2), '.k')     % Cloud of points 2
scatter(yf(:, 1), yf(:, 2), '*r')   % Adjusted cloud 2 on cloud 1