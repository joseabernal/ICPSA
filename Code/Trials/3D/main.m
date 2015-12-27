% Clear workspace
clc;
clear all;

% Include basic functions
handler = BasicFunctions3D;

% Read basic data cloud
A = zeros([3 437645]);
file = fopen('../../Database/dragon.txt', 'r');
A = fscanf(file, '%f %f %f', size(A));
I = 1:200:437645;
y0 = A(:,I)' * 100;
fclose(file);

% Modify one data cloud
tri = delaunay(y0(:, 1), y0(:, 2));
V = handler.triangulationVolume(tri, y0(:, 1), y0(:, 2), y0(:, 3));
trisurf(tri, y0(:, 1), y0(:, 2), y0(:, 3));
y = handler.Rotation3(y0, pi/2, pi/2, 0);
z = handler.CreateEvaluationFunction(y0, y);

% Data fitting
S0 = [0 0 0]';
[S, Z] = handler.SimmulatedAnnealing(S0, z, 100, 0.95);
%translation can be found comparing center of gravity
yf = handler.Rotation3(y, S(1), S(2), S(3));
yf = handler.DataCorrection(yf, y0);

% Plot results
figure(),
hold on
scatter3(y0(:, 1), y0(:, 2), y0(:, 3), '.k')
scatter3(y(:, 1), y(:, 2), y(:, 3), '*g')
figure(),
hold on
scatter3(y0(:, 1), y0(:, 2), y0(:, 3), '.k')
%scatter3(y(:, 1), y(:, 2), y(:, 3), '*g')
scatter3(yf(:, 1), yf(:, 2), yf(:, 3), 'or')