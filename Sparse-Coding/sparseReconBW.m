function reconImg = sparseReconBW(input, basis, render, alpha)
% Sparse coding prior based reconstruction of image patches
% 
% Syntax: 
%   reconImg = sparseReconBW(input, basis, render, alpha)
% 
% Description:
%   Reconstruction of original image based on subsamples and a sparse coding based prior.
%   This version uses the vanilla fmincon implementation. See lassoRecon.m for faster implementation. 
%
% Inputs:
%   input    - Input images/signals 
%   basis    - Basis functions of the sparse prior
%   render   - Render matrix describing the subsampling
%   alpha    - Regularization cofficient based on sparseness
% 
% Outputs:
%   reconImg - Reconstructed image
% 

[~, nDim] = size(basis);
lossImg    = @(coff) sum((render * (basis * coff) - input) .^ 2);
lossSparse = @(coff) sum(abs(coff));

loss = @(coff) lossImg(coff) + alpha * lossSparse(coff);
init = zeros(nDim, 1);

options = optimoptions('fmincon');
options.MaxFunctionEvaluations = 2e5;

coff = fmincon(loss, init, [],[],[],[],[],[],[], options);

reconImg = basis * coff;
end

