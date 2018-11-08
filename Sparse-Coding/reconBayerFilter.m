%% Set up const
imgDim = 11; dx = imgDim; dy = imgDim;
render = bayerFilter(11, true);

nSample = 121;
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

rmdRender = eye(dx * dy * 3);
rmdRender = rmdRender(renderIdx, :);

%% PCA
load('pcaBasis.mat');
scaleMatrix = diag(sqrt(pcaVar));
regBasis    = pcaBasis * scaleMatrix;

pcaError1 = sqrt(imgReconFun(@pcaRecon, regBasis, render, 0.1, true));
pcaError2 = sqrt(imgReconFun(@pcaRecon, regBasis, rmdRender, 0.1, true));

%% RICA
load('ricaFull.mat');
sparseCoff = 0.2;
ricaError1 = sqrt(imgReconFun(@lassoRecon, transMatrix, render, sparseCoff, true));
ricaError2 = sqrt(imgReconFun(@lassoRecon, transMatrix, rmdRender, sparseCoff, true));

%% Sparse Filtering
load('Sparse Filtering/sparse1600reg.mat');
basisSize = 40 * 40;

sparseError1 = sqrt(imgReconFun(@lassoRecon, sparse1600, render, 0.1, true));
sparseError2 = sqrt(imgReconFun(@lassoRecon, sparse1600, rmdRender, 0.1, true));