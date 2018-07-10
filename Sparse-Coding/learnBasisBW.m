function [basis, basisImg] = learnBasisBW(X, imgDim, basisSize, maxIter)
% ICA basis learning for gray scale images. 
%
% Syntax: 
%   [basis, basisImg] = learnBasisBW(imageData, imgDim, basisDim)
%
% Description: 
%   This funciton use Reconstruction Indepedent Component Analysis (RICA)
%   algorithm to find a basis set that minimizes reconstruction error and a
%   sparsity regularizer.  
%
% Inputs: 
%   X          - Input data set of dimension [n, (imgDim * imgDim)]
%   imgDim     - Height and width of the inptu image patches (assumed to be square)
%   basisSize  - Number of basis vector we want 
%   maxIter    - Max number of iteration allowed
%
% Outputs:
%   basis     - Set of learned basis of dimension [(imgDim * imgDim), basisSize]
%

res = rica(X, basisSize, 'IterationLimit', maxIter, 'VerbosityLevel', 1);
basis = res.TransformWeights;

basisImg = visBasisBW(basis, imgDim, basisSize);

end

