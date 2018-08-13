function pcaReconImg = pcaRecon(input, basis, render, ~)
%PCARECON PCA baseline reconstruction method

reducedBasis = basis(:, 1 : length(input));
transMatrix  = render * reducedBasis;

basisCoff   = transMatrix \ input;
pcaReconImg = reducedBasis * basisCoff;

end

