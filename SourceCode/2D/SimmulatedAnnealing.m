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