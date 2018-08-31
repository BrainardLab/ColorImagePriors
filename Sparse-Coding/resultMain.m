%% Set up constants 
load('ricaFull.mat');
load('pcaBasis.mat');

imgDim = 11; dx = imgDim; dy = imgDim;

subSample = (120 : -5 : 5) * 3;

sparseCoff = 0.3;
ridgeCoff  = 0.1;

scaleMatrix = diag(sqrt(pcaVar));
regBasis    = pcaBasis * scaleMatrix;

%% Reconstruction Algorithm
mseSparse = zeros(length(subSample), 1);
msePCA    = zeros(length(subSample), 1);

for idx = 1 : length(subSample)
    nSample   = subSample(idx);
    renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
    render = eye(dx * dy * 3);
    render = render(renderIdx, :);
    
    mseSparse(idx) = imgReconFun(@lassoRecon, transMatrix, render, sparseCoff, false);
    msePCA(idx)    = imgReconFun(@pcaRecon, regBasis, render, ridgeCoff, false);
end

%% Plot Results
figure; 
grid on; hold on; xlabel('# of sample'); ylabel('mse pp');

plot(subSample, sqrt(mseSparse), '-o'); 
plot(subSample, sqrt(msePCA), '-o');

title('mse reconstruction');
set(gca, 'XDir','reverse');

legend({'Sparse', 'PCA'});
