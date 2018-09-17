function pcaReconImg = pcaRecon(input, basis, render, ridgeCoff)
% PCA Gaussian prior based Ridge reconstruction of image patches
% 
% Syntax: 
%   pcaReconImg = pcaRecon(input, basis, render, ridgeCoff)
% 
% Description:
%   Reconstruction of original image based on subsamples and a PCA Gaussian based prior.
%   This version uses the ridge regression implementation with MATLAB function lasso
%
% Inputs:
%   input         - Input images/signals 
%   basis         - Basis functions of the sparse prior
%   render        - Render matrix describing the subsampling
%   ridgeCoff     - Regularization cofficient based on variance of zero-mean Gaussian
% 
% Outputs:
%   pcaReconImg   - Reconstructed image
% 


% 'Alpha'   when alpha -> 0 we have ridge regression
% 'Lambda'  regularization cofficients 
alpha  = 1e-20;
lambda = ridgeCoff / (2 * length(input));

regressor = render * basis; 
[B, fitInfo] = lasso(regressor, input, 'Alpha', alpha, 'Lambda', lambda);

pcaReconImg = basis * B + fitInfo.Intercept;

end

