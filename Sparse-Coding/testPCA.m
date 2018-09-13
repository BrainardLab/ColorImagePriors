%% PCA Basis Learning
data    = load('caltech101patches');
imgData = data.X;

for idx = 1 : 1e5
    img = imgData(idx, :);
    
    img = img - min(img);
    img = img / max(img);
    
    imgData(idx, :) = img;
end

[pcaBasis, ~, pcaVar] = pca(imgData);

%% Visulization
basisSize = 363; dx = 11; dy = 11; imgDim = 11;

basisSet = pcaBasis;
basisSet = reshape(basisSet, [dx, dy, 3, basisSize]);

% 10 by 10 large "image"
allDim   = 19; 
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
imshow(basisImg, 'InitialMagnification', 300);

%% Construct regression basis (euqal variance)
scaleMatrix = diag(sqrt(pcaVar));
regBasis    = pcaBasis * scaleMatrix;

%% Test PCA Reconstruction with Full Image
dx = 11; dy = 11; 

nSample   = 300;
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

render = eye(dx * dy * 3);
render = render(renderIdx, :);

imgReconFun(@pcaRecon, regBasis, render, 0.1, true);
