function I = ambientLight(ka,Ia)
    %convert to column vectors
    ka = ka(:);
    Ia = Ia(:);

    %element wise multiplication
    I = ka.*Ia;
end