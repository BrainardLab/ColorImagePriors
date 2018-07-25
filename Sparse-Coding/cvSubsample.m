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

% Render matrix with different subsampling
nSample = 110;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render1 = eye(dx * dy);
render1 = render1(idx, :);

nSample = 100;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render2 = eye(dx * dy);
render2 = render2(idx, :);

nSample = 90;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render3 = eye(dx * dy);
render3 = render3(idx, :);

nSample = 81;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render4 = eye(dx * dy);
render4 = render4(idx, :);

nSample = 70;
idx = sort(datasample(1 : dx * dy, nSample, 'Replace', false));
        
render5 = eye(dx * dy);
render5 = render5(idx, :);

nPatch = floor(reDim / imgDim);
imgDataset = zeros(dx * dy, nPatch * nPatch);

sparseCoff = [0 : 0.001 : 0.015, 0.02 : 0.02 : 0.3];
nCoff = length(sparseCoff);

% Mean squared error across all pixels 
mseSparse     = zeros(nCoff, 1);

mseSubsample1 = zeros(nCoff, 1);
mseSubsample2 = zeros(nCoff, 1);
mseSubsample3 = zeros(nCoff, 1);
mseSubsample4 = zeros(nCoff, 1);
mseSubsample5 = zeros(nCoff, 1);

for i = 1:nPatch
    for j = 1:nPatch
        % Extract individual image patches
        imgPatch = reshape(boatImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy), ...
        [dx * dy, 1]);                
        
        for idxCoff = 1 : nCoff            
            % Nonlinear (sparse) reconstruction        
            
%             reconPatch = sparseReconBW(imgPatch, transMatrix, eye(dx * dy), sparseCoff(idxCoff));        
            
%             mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);            
%             mseSparse(idxCoff) = mseSparse(idxCoff) + mse;
        
            % Reconstruction with subsample
            % R1
            reconPatch = sparseReconBW(render1 * imgPatch, transMatrix, render1, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample1(idxCoff) = mseSubsample1(idxCoff) + mse;
                       
            % R2
            reconPatch = sparseReconBW(render2 * imgPatch, transMatrix, render2, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample2(idxCoff) = mseSubsample2(idxCoff) + mse;
            
            % R3
            reconPatch = sparseReconBW(render3 * imgPatch, transMatrix, render3, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample3(idxCoff) = mseSubsample3(idxCoff) + mse;
            
            % R4
            reconPatch = sparseReconBW(render4 * imgPatch, transMatrix, render4, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample4(idxCoff) = mseSubsample4(idxCoff) + mse;
            
            % R5
            reconPatch = sparseReconBW(render5 * imgPatch, transMatrix, render5, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample5(idxCoff) = mseSubsample5(idxCoff) + mse;            
        end    
    end
end

mseSparse = mseSparse / (nPatch * nPatch);

mseSubsample1 = mseSubsample1 / (nPatch * nPatch); 
mseSubsample2 = mseSubsample2 / (nPatch * nPatch); 
mseSubsample3 = mseSubsample3 / (nPatch * nPatch); 
mseSubsample4 = mseSubsample4 / (nPatch * nPatch);
mseSubsample5 = mseSubsample5 / (nPatch * nPatch);

%% Plot Results
figure; hold on; grid on;
colors = get(gca,'colororder');
% plot(sparseCoff, mseSparse, '-o');

plot(sparseCoff, mseSubsample1, '-o', 'Color', colors(1, :));
[~, idx] = min(mseSubsample1);
plot(sparseCoff(idx), mseSubsample1(idx), '*', 'Color', colors(1, :));

plot(sparseCoff, mseSubsample2, '-o', 'Color', colors(2, :));
[~, idx] = min(mseSubsample2);
plot(sparseCoff(idx), mseSubsample2(idx), '*', 'Color', colors(2, :));

plot(sparseCoff, mseSubsample3, '-o', 'Color', colors(3, :));
[~, idx] = min(mseSubsample3);
plot(sparseCoff(idx), mseSubsample3(idx), '*', 'Color', colors(3, :));

plot(sparseCoff, mseSubsample4, '-o', 'Color', colors(4, :));
[~, idx] = min(mseSubsample4);
plot(sparseCoff(idx), mseSubsample4(idx), '*', 'Color', colors(4, :));

plot(sparseCoff, mseSubsample5, '-o', 'Color', colors(5, :));
[~, idx] = min(mseSubsample5);
plot(sparseCoff(idx), mseSubsample5(idx), '*', 'Color', colors(5, :));

% ylim([0, 0.05]);