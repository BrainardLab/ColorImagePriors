function reconImg = sparseReconBW(input, basis, render, alpha)
%SPARSERECONBW Sparse coding based reconstruction of image patches

[~, nDim] = size(basis);
lossImg    = @(coff) sum((render * (basis * coff) - input) .^ 2);
lossSparse = @(coff) sum(abs(coff));

loss = @(coff) lossImg(coff) + alpha * lossSparse(coff);
init = zeros(nDim, 1);

coff =fmincon(loss, init, [], []);

reconImg = basis * coff;
end

