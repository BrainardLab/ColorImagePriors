function pcaReconImg = pcaRecon(input, basis, render, ridgeCoff)
%PCARECON PCA baseline reconstruction method

% 'Alpha'   lasso/elastic net regression
% 'Lambda'  regularization cofficients 

alpha  = 1e-20;
lambda = ridgeCoff / (2 * length(input));

regressor = render * basis; 
[B, fitInfo] = lasso(regressor, input, 'Alpha', alpha, 'Lambda', lambda);

pcaReconImg = basis * B + fitInfo.Intercept;

end

