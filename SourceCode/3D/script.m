clc;
clear all;
A = zeros([3 437645]);
file = fopen('dragon.txt', 'r');
A = fscanf(file, '%f %f %f', size(A));

I = 1:200:437645;
y0 = A(:,I)' * 100;
fclose(file);

tri = delaunay(y0(:, 1), y0(:, 2));
V = triangulationVolume(tri, y0(:, 1), y0(:, 2), y0(:, 3));
trisurf(tri, y0(:, 1), y0(:, 2), y0(:, 3));

%%
y = Rotation3(y0, pi/2, pi/2, 0);
z = CreateEvaluationFunction(y0, y);
S0 = [0 0 0]';

[S, Z] = SimmulatedAnnealing(S0, z, 100, 0.95);
%translation can be found comparing center of gravity
yf = Rotation3(y, S(1), S(2), S(3));
yf = DataCorrection(yf, y0);

figure(),
hold on
scatter3(y0(:, 1), y0(:, 2), y0(:, 3), '.k')
scatter3(y(:, 1), y(:, 2), y(:, 3), '*g')
figure(),
hold on
scatter3(y0(:, 1), y0(:, 2), y0(:, 3), '.k')
%scatter3(y(:, 1), y(:, 2), y(:, 3), '*g')
scatter3(yf(:, 1), yf(:, 2), yf(:, 3), 'or')