% Script for image reconstruction (with subsamples) in color image domain

%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;
basisSize = 4e2;

load('ricaFull.mat');

%% TODO: Visulization of basis 
visBasis(transMatrix, imgDim, basisSize);

%% Reconstruction (simple linear reconstruction)
nSample   = 300;
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

render = eye(dx * dy * 3);
render = render(renderIdx, :);

imgReconFun(@lassoRecon, transMatrix, render, 0.3, true);