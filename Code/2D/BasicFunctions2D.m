%% Functions handler
function handler = BasicFunctions2D()
    handler.GenerateNoiseElipse = @GenerateNoiseElipse;
    handler.GenerateElipse = @GenerateElipse;
    handler.CreateEvaluationFunction = @CreateEvaluationFunction;
    handler.DataCorrection = @DataCorrection;
    handler.Translation = @Translation;
    handler.Rotation = @Rotation;
    
    handler.SimmulatedAnnealing = @SimmulatedAnnealing;
end

%% Generation and evaluation functions
function [yNoisy] = GenerateNoiseElipse(a, b, samples, snr)
    y = GenerateElipse(a, b, samples);
    yNoisy = awgn(y, snr, 'measured');
end

function [y] = GenerateElipse(a, b, samples)
    theta = rand(samples)*2*pi;
    y = zeros(length(theta), 2);
    f = @(t) [a*cos(t); b*sin(t)];
    for i = 1 : length(y)
        y(i, :) = f(theta(i));
    end
end

function evf = CreateEvaluationFunction(A, B)
    B = DataCorrection(B, A);
    evf = @(T) EvaluateCostFunction(A, B, T);
end

function C = DataCorrection(B, A)
    diff = mean(A) - mean(B);
    C = Translation(B, diff(1), diff(2));
end

function cost = EvaluateCostFunction(A, B, T)
    Btrans = zeros(size(B));
    for i = 1:length(B)
        Btrans(i, :) = [cos(T(1)) -sin(T(1)); sin(T(1)) cos(T(1))] * B(i, :)';
    end
    
    cost = DetermineVolume(A, Btrans);
end

function V = DetermineVolume(A, B)
    [~, V] = convhulln([A; B]);
end

function y = Translation(x, tx, ty)
    y = zeros(size(x));
    T = [1 0 tx; 0 1 ty; 0 0 1];
    for i = 1:length(x)
        trans = T * [x(i, :)'; 1];
        y(i, :) = [trans(1); trans(2)];
    end
end

function y = Rotation(x, theta)
    y = zeros(size(x));
    
    T = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    for i = 1:length(x)
        y(i, :) = T * (x(i, :) - mean(x))' + mean(x)';
    end
end

%% SA
function Sbest = SimmulatedAnnealing(S0, z, T0, alpha)
    T = T0;
    Sbest = S0;
    S = Sbest;
    iter = 0;
    while T > 2
        Stemp = GetRandomNeighbour(S);
        fprintf('z = %s, vect = %s\n', z(Stemp), mat2str(S'));
        if z(Stemp) < z(S)
            S = Stemp;
            if z(Stemp) < z(Sbest)
                Sbest = Stemp;
            end
        else
            r = rand;
            if (r < exp(-(z(Stemp)-z(S)) / T))
                S = Stemp;
            end
        end
        
        T = T * alpha;
        iter = iter + 1;
    end
end

function Sn = GetRandomNeighbour(S)
    Sn = S;
    idx = ceil(rand * length(S));
    Sn(idx) = mod(Sn(idx) + (rand * 2 - 1), 2*pi);
end