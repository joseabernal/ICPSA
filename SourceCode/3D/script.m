clc;
clear all;
y0 = zeros([3 437645]);
y0 = zeros([3 2000]);
file = fopen('dragon.txt', 'r');
y0 = fscanf(file, '%f %f %f', size(y0));
y0 = y0';
fclose(file);

tri = convhull(y0, 'simplify', false);
trisurf(tri, y0(:, 1), y0(:, 2), y0(:, 3));

%%
y = Rotation3(y0, pi/2, 0, 0);
z = CreateEvaluationFunction(y0, y);
S0 = [0 0 0]';
S = SimmulatedAnnealing(S0, z, 100, 0.95);
%translation can be found comparing center of gravity
yf = Rotation3(y, S(1), S(2), S(3)); 
figure(),
hold on
scatter3(y0(:, 1), y0(:, 2), y0(:, 3), '.k')
scatter3(y(:, 1), y(:, 2), y(:, 3), 'og')
scatter3(yf(:, 1), yf(:, 2), yf(:, 3), '*r')