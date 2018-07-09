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
boatImg = im2double(imread('boat.png'));
ornImg  = boatImg;

[reDim,  ~] = size(boatImg);

nPatch = floor(reDim / imgDim);
for i = 1:nPatch
    for j = 1:nPatch
        % Access to original image
        imgPatch = reshape(boatImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy), ...
        [dx * dy, 1]);
        
        % Linear projection and reconstruction
        reconPatch = transMatrix * transMatrix' * imgPatch;
        boatImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy) = reshape(reconPatch, [dx, dy]);        
    end
end

figure;
subplot(1, 2, 1);
imshow(ornImg);

subplot(1, 2, 2);
imshow(boatImg)