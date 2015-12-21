function V = DetermineVolume(A, B)
    C = [A; B];
    tri = delaunay(C(:, 1), C(:, 2));
    V = triangulationVolume(tri, C(:, 1), C(:, 2), C(:, 3));
end