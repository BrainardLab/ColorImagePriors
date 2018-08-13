%% Set up constants 
load('ricaFull.mat');
load('pcaBasis.mat');

imgDim = 11; dx = imgDim; dy = imgDim;

subSample = (110 : -5 : 20) * 3;
sparseCoff = 0.3;

%% Reconstruction Algorithm
mseSparse = zeros(length(subSample), 1);
msePCA    = zeros(length(subSample), 1);

for idx = 1 : length(subSample)
    nSample   = subSample(idx);
    renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
    render = eye(dx * dy * 3);
    render = render(renderIdx, :);
    
    mseSparse(idx) = imgReconFun(@lassoRecon, transMatrix, render, sparseCoff, false);
    msePCA(idx)    = imgReconFun(@pcaRecon, pcaBasis, render, sparseCoff, false);
end

%% Plot Results
figure; 

subplot(2, 1, 1); 
plot(subSample, sqrt(mseSparse), '-o'); 
grid on; xlabel('# of sample'); ylabel('rmse pp');
title('rmse sparse reconstruction');
set(gca, 'XDir','reverse');

subplot(2, 1, 2); 
plot(subSample, sqrt(msePCA), '-o');
grid on; xlabel('# of sample'); ylabel('rmse pp');
title('rmse pca reconstruction')
set(gca, 'XDir','reverse');
