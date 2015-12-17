function V = DetermineVolume(A, B)
    [~, V] = convhulln([A; B]);
end