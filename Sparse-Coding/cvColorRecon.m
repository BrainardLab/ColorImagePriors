%% Set up constants
imgDim = 11; dx = imgDim; dy = imgDim;
basisSize = 4e2;

load('ricaFull.mat'); 

%% Reconstruction (simple linear reconstruction)
testImg = im2double(imread('plane.jpg'));
testImg = testImg(48:158, 1:200, :);

[reDimX, reDimY, ~] = size(testImg);

% Render matrix with different subsampling
nSample = 110 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render1 = eye(dx * dy * 3);
render1 = render1(idx, :);

nSample = 100 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render2 = eye(dx * dy * 3);
render2 = render2(idx, :);

nSample = 90 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render3 = eye(dx * dy * 3);
render3 = render3(idx, :);

nSample = 81 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render4 = eye(dx * dy * 3);
render4 = render4(idx, :);

nSample = 64 * 3;
idx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
render5 = eye(dx * dy * 3);
render5 = render5(idx, :);

nPatch = floor(reDimX / imgDim) * floor(reDimY / imgDim);

sparseCoff = [0 : 0.005 : 0.015, 0.02 : 0.02 : 0.3, 0.32 : 0.1 : 1];
nCoff = length(sparseCoff);
    
mseSubsample1 = zeros(nCoff, 1);
mseSubsample2 = zeros(nCoff, 1);
mseSubsample3 = zeros(nCoff, 1);
mseSubsample4 = zeros(nCoff, 1);
mseSubsample5 = zeros(nCoff, 1);

for i = 1 : floor(reDimX / imgDim)   
    for j = 1 : floor(reDimY / imgDim)
        
        % Access to original image
        imgPatch = reshape(testImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :), ...
        [dx * dy * 3, 1]);              
        
        for idxCoff = 1 : nCoff                                
            % R1
            % Reconstruction with subsample                
                                    
            reconPatch = lassoRecon(render1 * imgPatch, transMatrix, render1, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample1(idxCoff) = mseSubsample1(idxCoff) + mse;
                       
            % R2
            reconPatch = lassoRecon(render2 * imgPatch, transMatrix, render2, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample2(idxCoff) = mseSubsample2(idxCoff) + mse;
            
            % R3
            reconPatch = lassoRecon(render3 * imgPatch, transMatrix, render3, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample3(idxCoff) = mseSubsample3(idxCoff) + mse;
            
            % R4
            reconPatch = lassoRecon(render4 * imgPatch, transMatrix, render4, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample4(idxCoff) = mseSubsample4(idxCoff) + mse;
            
            % R5
            reconPatch = lassoRecon(render5 * imgPatch, transMatrix, render5, sparseCoff(idxCoff));  
            
            mse = sum((imgPatch - reconPatch) .^ 2) / length(imgPatch);
            mseSubsample5(idxCoff) = mseSubsample5(idxCoff) + mse;            
        end    
    end
end

%% Plot Results
mseSubsample1 = mseSubsample1 / nPatch;
mseSubsample2 = mseSubsample2 / nPatch;
mseSubsample3 = mseSubsample3 / nPatch;
mseSubsample4 = mseSubsample4 / nPatch;
mseSubsample5 = mseSubsample5 / nPatch;

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