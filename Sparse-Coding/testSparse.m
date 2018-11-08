% Test sparse coding / Lasso regression reconstruction method

%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;
basisSize = 40 * 40;

% transMatrix = Mdl.TransformWeights;
load('Sparse Filtering/sparse1600reg.mat');
transMatrix = sparse1600;

%% Visulization of basis
visBasis(transMatrix, imgDim, basisSize);

%% Reconstruction (simple linear reconstruction)
nSample   = 120;
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

render = eye(dx * dy * 3);
render = render(renderIdx, :);

mse = sqrt(imgReconFun(@lassoRecon, transMatrix, render, 0.2, true));