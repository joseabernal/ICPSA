% Clear workspace
clc;
close all;
clear all;
warning ('off','all');

% Include basic functions
handler = basic3DFunctions;

%% INPUT DATA - SET y0 AS THE GOAL CLOUD AND y AS THE ONE TO FIT
%% SEASHELL
% Read data cloud 1
%y0 = load('../../Database/Seashell/original.mat');
%y0 = y0.original;

% Read data cloud 2
%y = load('../../Database/Seashell/spike_reduction.mat');
%y = y.spike;
%y = load('../../Database/Seashell/top_reduction.mat');
%y = y.top;

%% DRAGON
% Read data cloud 1
y0 = load('../../Database/Dragon/original.mat');
y0 = y0.original;

% Read data cloud 2
y = load('../../Database/Dragon/head_reduction.mat');
y = y.head;
%y = load('../../Database/Dragon/tail_reduction.mat');
%y = y.tail;

%% ALGORITHM ICPSA
% Move the second data cloud
tri = concavehull(y, 3);
%trisurf(tri, y(:, 1), y(:, 2), y(:, 3))
y = handler.Rotation3(y, pi/2, pi/2, 0);
y = handler.Translation3(y, 2, 1, 3);
x=y;

% Update visual progress
figure;
plot3(y0(:, 3), y0(:, 1), y0(:, 2), '.k'); hold on;
plot3(x(:, 3), x(:, 1), x(:, 2), 'ob'); hold off;

% Modifiable parameters of the double ICP loop
o_iterations = 5;
j_iterations = 15;

% ICP x 2 + SA loop
S0 = [0 0 0]';
S = [1 1 1]';
while( sum(abs(S)) > 0.1 )
    for o = 1:1:o_iterations
        % Translation
        [TR,TT]=icp(transpose(x),transpose(y0), 10, 'Minimize', 'lmaPoint');
        T = [1 0 0 -TT(1); 0 1 0 -TT(2); 0 0 1 -TT(3); 0 0 0 1];
        for i = 1:length(x)
            trans = T * [x(i, :)'; 1];
            x(i, :) = [trans(1); trans(2); trans(3)];
        end

        % Rotation
        for j = 1:1:j_iterations
            j
     
            [TR,TT]=icp(transpose(x),transpose(y0));
            new_TR=[TR(1,:),0;TR(2,:),0;TR(3,:),0;0 0 0 1];
            if( sum(sum(floor(abs(new_TR))==eye(4)))==16 )
                display('Rotation "converged"')
                break;
            end
            b = [x ones(length(x), 1)];
            a = zeros(size(b));
            for i = 1:length(b)
                a(i, :) = new_TR \ (b(i, :) - mean(b))' + mean(b)';
            end
            x = [a(:, 1), a(:, 2), a(:, 3)]; 
        end
        
        % Update visual progress
        figure;
        plot3(y0(:, 3), y0(:, 1), y0(:, 2), '.k'); hold on;
        plot3(x(:, 3), x(:, 1), x(:, 2), 'om'); hold off;
    end

    % Update visual progress
    figure;
    plot3(y0(:, 3), y0(:, 1), y0(:, 2), '.k'); hold on;
    plot3(x(:, 3), x(:, 1), x(:, 2), 'or'); hold off;
    pause(2);

    % Check if the ICP x 2 strategy got stuck in a local minimum
    r = handler.RotationCostFunction(y0,x);
    [S, Z] = handler.SimmulatedAnnealing(S0, r, 100, 0.95 , 1);
    S(1) = wrapToPi(S(1));
    S(2) = wrapToPi(S(2));
    S(3) = wrapToPi(S(3));
    x = handler.Rotation3(x, S(1), S(2), S(3));

    % Update visual progress
    figure;
    plot3(y0(:, 3), y0(:, 1), y0(:, 2), '.k'); hold on;
    plot3(x(:, 3), x(:, 1), x(:, 2), 'og'); hold off;
end