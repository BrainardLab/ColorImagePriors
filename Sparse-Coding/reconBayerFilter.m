%% Set up const
imgDim = 32; dx = imgDim; dy = imgDim;
render = bayerFilter(32, true);

nSample   = round(dx * dy * 3 / 3);
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

rmdRender = eye(dx * dy * 3);
rmdRender = rmdRender(renderIdx, :);

%% PCA

% load('pcaBasis.mat');
% scaleMatrix = diag(sqrt(pcaVar));
% regBasis    = pcaBasis * scaleMatrix;

load('./learned_basis/pca_basis.mat');
imageName = 'color-balls.jpg';

pcaError1 = sqrt(imgReconFun(imageName, @pcaRecon, regBasis, render, 0.2, true));
pcaError2 = sqrt(imgReconFun(imageName, @pcaRecon, regBasis, rmdRender, 0.2, true));

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
