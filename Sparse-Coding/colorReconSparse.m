% Script for image reconstruction (with subsamples) in color image domain

%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;
basisSize = 4e2;

load('ricaFull.mat');

% load('transformWeights.mat');
% transMatrix = res2k.transformWeights;

%% TODO: Visulization of basis 


%% Reconstruction (simple linear reconstruction)
testImg = im2double(imread('plane.jpg'));
testImg = testImg(48:158, 1:200, :);

reconLinear = testImg;
reconSparse = testImg;
reconSample = testImg;

[reDimX, reDimY, ~] = size(testImg);

nSample = 30 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render = eye(dx * dy * 3);
render = render(idx, :);

for i = 1 : floor(reDimX / imgDim)
    for j = 1 : floor(reDimY / imgDim)
        % Access to original image
        imgPatch = reshape(testImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :), ...
        [dx * dy * 3, 1]);  
        
        % Nonlinear (sparse) reconstruction        
        reconPatch = lassoRecon(imgPatch, transMatrix, eye(dx * dy * 3), 0.001);        
        reconSparse( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);   
        
        % Reconstruction with subsample                
        reconPatch = lassoRecon(render * imgPatch, transMatrix, render, 0.1);  
        reconSample( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);   
    end
end

%% Plot Reconstruction

figure;
subplot(3, 1, 1);
imshow(testImg);

subplot(3, 1, 2);
imshow(reconSparse)

subplot(3, 1, 3);
imshow(reconSample);