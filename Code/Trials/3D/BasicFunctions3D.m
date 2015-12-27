%% Functions handler
function handler = BasicFunctions3D()
    handler.CreateEvaluationFunction = @CreateEvaluationFunction;
    handler.DataCorrection = @DataCorrection;
    handler.triangulationVolume = @triangulationVolume;
    handler.Rotation3 = @Rotation3;
    
    handler.SimmulatedAnnealing = @SimmulatedAnnealing;
    
    handler.RotationCostFunction = @RotationCostFunction;
    handler.TranslationCostFunction = @TranslationCostFunction;
    handler.Translation3 = @Translation3;
    handler.SimmulatedAnnealing_t = @SimmulatedAnnealing_t;
end


function r = RotationCostFunction(A, B)
    r = @(T) EvaluateR(A, B, T);
end

function cost = EvaluateR(A, B, T)
    Btrans = Rotation3(B, T(1), T(2), T(3));
    cost = DetermineVolume(A, Btrans);
end


function t = TranslationCostFunction(A, B)
    t = @(T) EvaluateT(A, B, T);
end

function cost = EvaluateT(A, B, T)
    Btrans = Translation3(B, T(1), T(2), T(3));
    cost = DetermineVolume(A, Btrans);
end



%% Evaluation of functions
function evf = CreateEvaluationFunction(A, B)
    evf = @(T) EvaluateCostFunction(A, B, T);
end

function cost = EvaluateCostFunction(A, B, T)
    Btrans = Rotation3(B, T(1), T(2), T(3));
    Btrans = DataCorrection(Btrans, A);
    cost = DetermineVolume(A, Btrans);
end

function C = DataCorrection(B, A)
    diff = mean(A) - mean(B);
    C = Translation3(B, diff(1), diff(2), diff(3));
end

function V = DetermineVolume(A, B)
    C = [A; B];
    tri = delaunay(C(:, 1), C(:, 2));
    V = triangulationVolume(tri, C(:, 1), C(:, 2), C(:, 3));
end

function [vol,area] = triangulationVolume(TRI,X,Y,Z)
    %[VOLUME,AREA] = triangulationVolume(TRI,X,Y,Z)
    %
    %  Computes the VOLUME and AREA of a closed surface defined
    %  by the triangulation in indices TRI and coordinates X, Y and Z,
    %  using the divergence theorem of Gauss (volume/surface integral).
    %  The unit of the volume equals to UNIT^3 and the unit of the area
    %  equals to UNIT^2, with UNIT the unit of the coordinates X,Y,Z.
    %  The surface needs to be closed, this is not checked.
    %
    %  Example:
    %  >> [vol,area]  = triangulationVolume(tri,x,y,z);
    %
    %  See also:
    %    testTriangulationVolume.m
    %
    %Copyright ? 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands

    %====================================================================================================
    % ? 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands
    %
    % History
    %
    % Who	When        What
    %
    % JPAV    29.01.2001  Creation (Jeroen P.A. Verbunt) (V0.0)
    % JPAV    30.01.2001  Finished (V1.0)
    % JPAV    06.06.2007  Published on Matlab File Exchnage
    %
    %====================================================================================================

    APPNAME = 'triangulationVolume';
    VERSION = '1.0';
    DATE    = '30 January 2001';
    AUTHOR  = 'Jeroen P.A. Verbunt';

    vol  = 0;
    area = 0;

    nTri = size(TRI,1);           % Number of triangles

    if (nTri > 3)                 % Need at least 4 triangles to form a closed surface
       for i=1:nTri
          U = [X(TRI(i,1)) Y(TRI(i,1)) Z(TRI(i,1))]; % First  point of triangle
          V = [X(TRI(i,2)) Y(TRI(i,2)) Z(TRI(i,2))]; % Second point of triangle
          W = [X(TRI(i,3)) Y(TRI(i,3)) Z(TRI(i,3))]; % Third  point of triangle

          A = V - U;              % One side of triangle (from U to V)
          B = W - U;              % Another side of triangle (from U to W)

          C = cross(A, B);        % Length of C equals to the area of the parallelogram [A,B]
          normC = norm(C);

          a = 0.5 * normC;        % Area of triangle [U,V,W]

          P = (U + V + W) / 3;    % Middle of triangle
          N = C / normC;          % Normal vector of triangle

          vol  = vol + abs(P(1) * N(1) * a);
          area = area + a;
       end
    end

    vol  = abs(vol);  % Not shure whether taking the absolute value is really necessary.
    area = abs(area); % If the normal vectors are oriented outwards, this should not be necessary.
                      % But can you guarantee that the normal vectors are oriented outwards...?


    %--------------------------------------------------------------------------------------------------------------
    % Divergence theorem of Gauss:
    % (see "Advanced engineering mathematics" by E. Kreyszig, 6th ed., p.551, eq.2):
    %
    %   ---    _         --_ _
    %  /// div F dV  =  // F.n dA
    % ---              --
    %  T                S
    %
    % volume integral   surface integral (closed surface)
    %
    % Divergence:
    % (see "Advanced engineering mathematics" by E. Kreyszig, 6th ed., p.492, eq.1):
    %     _     dV1    dV2   dV3
    % div V  =  ---  + --- + ---
    %            dx     dy    dz
    %
    %
    % To compute the volume V of a closed surface S:
    %        _                     _
    % Define F = [x,0,0], with div F = 1 + 0 + 0 = 1
    %
    %      ---          --_ _
    % V = /// 1 dV  =  // x.n dA
    %    ---          --
    %     T            S
    %
    % Jeroen P.A. Verbunt
    %
    %= triangulationVolume =======================================================================================
end

function y = Translation3(x, tx, ty, tz)
    y = zeros(size(x));
    T = [1 0 0 tx; 0 1 0 ty; 0 0 1 tz; 0 0 0 1];
    for i = 1:length(x)
        trans = T * [x(i, :)'; 1];
        y(i, :) = [trans(1); trans(2); trans(3)];
    end
end

function y = Rotation3(x, theta1, theta2, theta3)
    Rz = [cos(theta1) sin(theta1) 0 0; ...
        -sin(theta1) cos(theta1) 0 0; ...
        0 0 1 0; ...
        0 0 0 1];
    Rx = [1 0 0 0;
        0 cos(theta2) sin(theta2) 0; ...
        0 -sin(theta2) cos(theta2) 0; ...
        0 0 0 1];
    Ry = [cos(theta3) 0 -sin(theta3) 0; ...
        0 1 0 0; ...
        sin(theta3) 0 cos(theta3) 0; ...
        0 0 0 1];
    
    R = Rx * Ry * Rz;
    
    x = [x ones(length(x), 1)];
    
    y = zeros(size(x));
    for i = 1:length(x)
        y(i, :) = R * (x(i, :) - mean(x))' + mean(x)';
    end
    
    y = [y(:, 1), y(:, 2), y(:, 3)]; 
end

%% SA
function [Sbest, zSBest] = SimmulatedAnnealing(S0, z, T0, alpha , c)
    T = T0;
    Sbest = S0;
    S = Sbest;
    
    zS = z(S);
    zSBest = zS;

    iter = 0;
    while T > 2
        Stemp = GetRandomNeighbour(S , c);
        zStemp = z(Stemp);
        fprintf('T = %s, z = %s, vect = %s', int2str(T), z(Stemp), mat2str(Stemp'));
        if zStemp < zS
            S = Stemp;
            zS = zStemp;
            fprintf(' better');
            if zStemp < zSBest
                Sbest = Stemp;
                zSBest = zStemp;
                fprintf(' best');
            end
        else
            r = rand;
            fprintf(' r = %s, e = %s', r, exp(-(zStemp-zS) / T));
            if (r < exp(-(zStemp-zS) / T))
                fprintf(' accepted');
                S = Stemp;
                zS = zStemp;
            end
        end
        
        T = T * alpha;
        iter = iter + 1;
        fprintf('\n');
    end
end

function [Sbest, zSBest] = SimmulatedAnnealing_t(S0, z, T0, alpha , c)
    T = T0;
    Sbest = S0;
    S = Sbest;
    
    zS = z(S);
    zSBest = zS;

    iter = 0;
    while T > 2
        Stemp = GetRandomNeighbour_t(S, c);
        zStemp = z(Stemp);
        fprintf('T = %s, z = %s, vect = %s', int2str(T), z(Stemp), mat2str(Stemp'));
        if zStemp < zS
            S = Stemp;
            zS = zStemp;
            fprintf(' better');
            if zStemp < zSBest
                Sbest = Stemp;
                zSBest = zStemp;
                fprintf(' best');
            end
        else
            r = rand;
            fprintf(' r = %s, e = %s', r, exp(-(zStemp-zS) / T));
            if (r < exp(-(zStemp-zS) / T))
                fprintf(' accepted');
                S = Stemp;
                zS = zStemp;
            end
        end
        
        T = T * alpha;
        iter = iter + 1;
        fprintf('\n');
    end
end

function Sn = GetRandomNeighbour(S, c)
    Sn = S;
    idx = ceil(rand * length(S));
    Sn(idx) = Sn(idx)  + (rand * pi/(c) - pi/(2*c));
end

function Sn = GetRandomNeighbour_t(S , c)
    Sn = S;
    idx = ceil(rand * length(S));
    Sn(idx) = Sn(idx)  + (rand * 0.1/c - 0.05/c);
end
