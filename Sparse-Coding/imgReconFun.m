function mse = imgReconFun(reconFun, transMatrix, render, priorCoff, showPlot)
%COLORRECON Reconstruction for color image

% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;

% Reconstruction (simple linear reconstruction)
testImg = im2double(imread('plane.jpg'));
testImg = testImg(48:158, 1:200, :);

reconSample = testImg;

[reDimX, reDimY, ~] = size(testImg);

% Patch-wise reconstruction
for i = 1 : floor(reDimX / imgDim)
    for j = 1 : floor(reDimY / imgDim)
        % Access to original image
        imgPatch = reshape(testImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :), ...
        [dx * dy * 3, 1]);  
                        
        % Reconstruction with subsample                
        reconPatch = reconFun(render * imgPatch, transMatrix, render, priorCoff);  
        reconSample( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(reconPatch, [dx, dy, 3]);   
    end
end

% Plot reconstruction
if showPlot
    figure;
    subplot(2, 1, 1);
    imshow(testImg);

    subplot(2, 1, 2);
    imshow(reconSample);
end

% Sum of squared error
nPatch = floor(reDimX / imgDim) * floor(reDimY / imgDim);
mse = sum((testImg(:) - reconSample(:)) .^ 2) / ...
    (nPatch * dx * dy);

end

