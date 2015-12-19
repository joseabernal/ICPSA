function [Sbest, zSBest] = SimmulatedAnnealing(S0, z, T0, alpha)
    T = T0;
    Sbest = S0;
    S = Sbest;
    
    zS = z(S);
    zSBest = zS;

    iter = 0;
    while T > 2
        Stemp = GetRandomNeighbour(S);
        zStemp = z(Stemp);
        fprintf('z = %s, vect = %s', z(Stemp), mat2str(S'));
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