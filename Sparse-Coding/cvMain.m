%% Set up constants 
imgDim = 11; dx = imgDim; dy = imgDim;

nData = 1e5;
basisSize = 13 * 13;

transMatrix = res.TransformWeights;

%% Reconstruction (simple linear reconstruction)
idxLow = 200; idxHigh = 300;
boatImg = im2double(imread('boat.png'));
boatImg = boatImg(idxLow:idxHigh, idxLow:idxHigh);

[reDim,  ~] = size(boatImg);

nSample = 100;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render = eye(dx * dy);
render = render(idx, :);

% Extract individual image patches
nPatch = floor(reDim / imgDim);
imgDataset = zeros(dx * dy, nPatch * nPatch);


sparseCoff = 0.005 : 0.005 : 0.12;
nCoff = length(sparseCoff);

mseSparse    = zeros(nCoff, 1);
mseSubsample = zeros(nCoff, 1);

for i = 1:nPatch
    for j = 1:nPatch
        % Access to original image
        imgPatch = reshape(boatImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy), ...
        [dx * dy, 1]);                
        
        for idxCoff = 1 : nCoff
            % Nonlinear (sparse) reconstruction        
            reconPatch = sparseReconBW(imgPatch, transMatrix, eye(dx * dy), sparseCoff(idxCoff));        
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);            
            mseSparse(idxCoff) = mseSparse(idxCoff) + mse;
        
            % Reconstruction with subsample                
            reconPatch = sparseReconBW(render * imgPatch, transMatrix, render, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample(idxCoff) = mseSubsample(idxCoff) + mse;
        end    
    end
end

mseSparse    = mseSparse / (nPatch * nPatch);  
mseSubsample = mseSubsample / (nPatch * nPatch); 

figure; hold on; grid on;
plot(sparseCoff, mseSparse, '-o');
plot(sparseCoff, mseSubsample, '-o');
