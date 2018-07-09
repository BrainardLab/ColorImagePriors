%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;

nData = 1e5;
basisSize = 13 * 13;

%% TODO: sampling random image patches 

%% Caltech 101 Dataset, Reformatting Data

data = load('caltech101patches');
colImages = reshape(data.X', dx, dy, 3, nData);
bwImages  = zeros(dx, dy, nData);

for idx = 1:nData
    img   = colImages(:, :, :, idx);
    bwImg = rgb2gray(img);
    
    bwImages(:, :, idx) = bwImg;
end

bwImages = reshape(bwImages, dx * dy, nData)';

%% RICA
[basis, basisImg] = learnBasisBW(bwImages, imgDim, basisSize);

%% Visulization of basis 
figure;

transMatrix = res.TransformWeights;
imshow(visBasisBW(transMatrix, imgDim, basisSize), 'InitialMagnification', 600);

%% Reconstruction (simple linear reconstruction)
idxLow = 200; idxHigh = 300;

boatImg = im2double(imread('boat.png'));
% boatImg = boatImg(idxLow:idxHigh, idxLow:idxHigh);

reconLinear = boatImg;
reconSparse = boatImg;
reconSample = boatImg;

[reDim,  ~] = size(boatImg);

nSample = 81;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render = eye(dx * dy);
render = render(idx, :);

nPatch = floor(reDim / imgDim);
for i = 1:nPatch
    for j = 1:nPatch
        % Access to original image
        imgPatch = reshape(boatImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy), ...
        [dx * dy, 1]);
        
        % Linear projection and reconstruction
        reconPatch = transMatrix * transMatrix' * imgPatch;
        reconLinear( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy) = reshape(reconPatch, [dx, dy]);  
        
        % Nonlinear (sparse) reconstruction        
        reconPatch = sparseReconBW(imgPatch, transMatrix, eye(dx * dy), 0.01);        
        reconSparse( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy) = reshape(reconPatch, [dx, dy]);   
        
        % Reconstruction with subsample                
        reconPatch = sparseReconBW(render * imgPatch, transMatrix, render, 0.1);  
        reconSample( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy) = reshape(reconPatch, [dx, dy]);   
    end
end

figure;
subplot(2, 2, 1);
imshow(boatImg);

subplot(2, 2, 2);
imshow(reconLinear)

subplot(2, 2, 3);
imshow(reconSparse)

subplot(2, 2, 4);
imshow(reconSample);

