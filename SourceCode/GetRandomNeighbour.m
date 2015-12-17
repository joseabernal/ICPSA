function Sn = GetRandomNeighbour(S)
    Sn = S;
    idx = ceil(rand * length(S));
    Sn(idx) = mod(Sn(idx) + (rand * 2 - 1), 2*pi);
end