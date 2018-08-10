function lassoReconImg = lassoRecon(input, basis, render, sparseCoff)

% 'Alpha'   lasso/elastic net regression
% 'Lambda'  regularization cofficients 

alpha  = 1;
lambda = sparseCoff / (2 * length(input));

regressor = render * basis; 
[B, fitInfo] = lasso(regressor, input, 'Alpha', alpha, 'Lambda', lambda);

lassoReconImg = basis * B + fitInfo.Intercept;

end

