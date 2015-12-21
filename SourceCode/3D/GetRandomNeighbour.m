function Sn = GetRandomNeighbour(S)
    Sn = S;
    idx = ceil(rand * length(S));
    Sn(idx) = Sn(idx)  + (rand * pi - pi/2);
end