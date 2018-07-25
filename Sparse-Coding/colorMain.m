%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;
basisSize = 4e2;

load('colorTransMatrix.mat')
%% TODO: Visulization of basis 


%% Reconstruction (simple linear reconstruction)
testImg = im2double(imread('plane.jpg'));
testImg = testImg(48:158, 1:200, :);

reconLinear = testImg;
reconSparse = testImg;
reconSample = testImg;

[reDimX, reDimY, ~] = size(testImg);

nSample = 110 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render = eye(dx * dy * 3);
render = render(idx, :);

for i = 1 : floor(reDimX / imgDim)
    for j = 1 : floor(reDimY / imgDim)
        % Access to original image
        imgPatch = reshape(testImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :), ...
        [dx * dy * 3, 1]);
        
        % Linear projection and reconstruction
        reconPatch = transMatrix * transMatrix' * imgPatch;
        reconLinear( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);  
        
        % Nonlinear (sparse) reconstruction        
        reconPatch = sparseReconBW(imgPatch, transMatrix, eye(dx * dy * 3), 0.01);        
        reconSparse( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);   
        
        % Reconstruction with subsample                
        reconPatch = sparseReconBW(render * imgPatch, transMatrix, render, 0.1);  
        reconSample( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);   
    end
end

%% Plot Reconstruction

figure;
subplot(2, 2, 1);
imshow(testImg);

subplot(2, 2, 2);
imshow(reconLinear)

subplot(2, 2, 3);
imshow(reconSparse)

subplot(2, 2, 4);
imshow(reconSample);