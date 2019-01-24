% Find PCA basis with stardard PCA method
% Test PCA / Ridge regression reconstruction method

%% PCA Basis
load('./cifar-all-mat/image_all.mat');
imgData = image_all;
[pcaBasis, ~, pcaVar] = pca(imgData);

%% Visulization
basisSize = 3072; 
dx = 32; dy = 32; imgDim = 32;

basisSet = pcaBasis;
basisSet = reshape(basisSet, [dx, dy, 3, basisSize]);

% 10 by 10 large "image"
allDim   = 55; 
basisImg = zeros(allDim * imgDim, allDim * imgDim, 3);

for i = 1:allDim
    for j = 1:allDim
        % Select each Basis Image
        idx   = (i - 1) * allDim + j;
        basis = basisSet(:, :, :, idx);
        basis = basis(:);
        
        % Normalization
        basis = (basis - min(basis))/(max(basis) - min(basis));

        % Add to Display Image 
        basisImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(basis, dx, dy, 3);
    end
end

figure;
imshow(basisImg, 'InitialMagnification', 50);

%% Construct regression basis (euqal variance)
scaleMatrix = diag(sqrt(pcaVar));
regBasis    = pcaBasis * scaleMatrix;

%% Test PCA Reconstruction with Full Image
dx = 32; dy = 32; 

nSample   = round(dx * dy * 3 * 0.3);
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

render = eye(dx * dy * 3);
render = render(renderIdx, :);

imgReconFun('plane.jpg', @pcaRecon, regBasis, render, 0.2, true);
