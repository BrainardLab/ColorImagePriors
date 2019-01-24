function [mse, reconSample] = imgReconFun(imgName, reconFun, transMatrix, render, priorCoff, showPlot)
% Patch-by-patch reconstruction of color image
% 
% Syntax:
%   mse = imgReconFun(reconFun, transMatrix, render, priorCoff, showPlot)
%   [mse, reconImg] = imgReconFun(reconFun, transMatrix, render, priorCoff, showPlot)
% 
% Description:
%   Patch-by-patch reconstruction of color images use method specified in reconFun.
%   Compute the mean square error (per pixel). When showPlot = true, also show 
%   the result of reconstructed image. 
% 
% Inputs:
%   reconFun     - Function handler of the chosen reconstruction method
%   transMatrix  - Set of basis function (required by reconFun)
%   render       - Render matrix describing the subsampling
%   priorCoff    - Regularization cofficient based on some prior 
%   showPlot     - If set to true, show the reconsturcted image at the end 
% 
% Outputs:
%   mse          - Mean squared error per pixel
%   reconSample  - Reconsturcted image
%

% Set up constants 
imgDim = 32; dx = imgDim; dy = imgDim;

% Reconstruction (simple linear reconstruction)

% testImg = im2double(imread('plane.jpg'));
% testImg = testImg(48:158, 1:200, :);
%  
% testImg = im2double(imread('nature.jpg'));
% testImg = imresize(testImg, 0.05);

testImg = im2double(imread(imgName));
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
    fprintf('Reconstruct Complete: %.2f\n', i / floor(reDimX / imgDim));
end

% Plot reconstruction
fprintf('Reconstruct Complete!\n');
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

