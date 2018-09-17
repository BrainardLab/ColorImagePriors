function lassoReconImg = lassoRecon(input, basis, render, sparseCoff)
% Sparse coding prior based LASSO reconstruction of image patches
% 
% Syntax: 
%   lassoReconImg = lassoRecon(input, basis, render, sparseCoff)
% 
% Description:
%   Reconstruction of original image based on subsamples and a sparse based prior.
%   This version uses the lasso regression implementation with MATLAB function lasso
%
% Inputs:
%   input         - Input images/signals 
%   basis         - Basis functions of the sparse prior
%   render        - Render matrix describing the subsampling
%   sparseCoff    - Regularization cofficient based on sparseness
% 
% Outputs:
%   lassoReconImg - Reconstructed image
% 


% 'Alpha'   when alpha = 1 we have lasso regression
% 'Lambda'  regularization cofficients 
alpha  = 1; 
lambda = sparseCoff / (2 * length(input));

regressor = render * basis; 
[B, fitInfo] = lasso(regressor, input, 'Alpha', alpha, 'Lambda', lambda);

lassoReconImg = basis * B + fitInfo.Intercept;

end

