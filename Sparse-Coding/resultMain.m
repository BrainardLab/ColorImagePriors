% Plot mse of reconstruction as a function of # subsample for both PCA and Sparse Coding method

%% Sparse filtering basis
load('Sparse Filtering/sparse361reg2.mat');
sparse361 = Mdl.TransformWeights;

load('Sparse Filtering/sparse400reg2.mat');
sparse400 = Mdl.TransformWeights;

load('Sparse Filtering/sparse900reg.mat');
sparse900 = Mdl.TransformWeights;

load('Sparse Filtering/sparse1024reg.mat');
sparse1024 = Mdl.TransformWeights;

%% Set up constants
load('ricaFull.mat');
transMatrix400 = transMatrix;

load('rica576.mat');
transMatrix576 = basisSet;

imgDim = 11; dx = imgDim; dy = imgDim;

subSample = (110 : -5 : 5) * 3;

sparseCoff = 0.2;
sparseFltCoff = 0.1;
ridgeCoff  = 0.1;

load('pcaBasis.mat');
scaleMatrix = diag(sqrt(pcaVar));
regBasis    = pcaBasis * scaleMatrix;

%% Reconstruction Algorithm
mseSparse400 = zeros(length(subSample), 1);
mseSparse576 = zeros(length(subSample), 1);
msePCA    = zeros(length(subSample), 1);

mseSparseFlt361 = zeros(length(subSample), 1);
mseSparseFlt400 = zeros(length(subSample), 1);
mseSparseFlt900 = zeros(length(subSample), 1);
mseSparseFlt1024 = zeros(length(subSample), 1);

for idx = 1 : length(subSample)
    nSample   = subSample(idx);
    renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));
        
    render = eye(dx * dy * 3);
    render = render(renderIdx, :);
    
    mseSparse400(idx) = imgReconFun(@lassoRecon, transMatrix400, render, sparseCoff, false);
    mseSparse576(idx) = imgReconFun(@lassoRecon, transMatrix576, render, sparseCoff, false);
    msePCA(idx)       = imgReconFun(@pcaRecon, regBasis, render, ridgeCoff, false);
      
    mseSparseFlt361(idx)  = imgReconFun(@lassoRecon, sparse361, render, sparseFltCoff, false);
    mseSparseFlt400(idx)  = imgReconFun(@lassoRecon, sparse400, render, sparseFltCoff, false);
    mseSparseFlt900(idx)  = imgReconFun(@lassoRecon, sparse900, render, sparseFltCoff, false);
    mseSparseFlt1024(idx) = imgReconFun(@lassoRecon, sparse1024, render, sparseFltCoff, false);
end

%% Plot Results
figure; 
grid on; hold on; xlabel('# of sample'); ylabel('mse pp');

plot(subSample, sqrt(mseSparse400), '-o'); 
plot(subSample, sqrt(mseSparse576), '-o'); 
plot(subSample, sqrt(msePCA), '-o');

plot(subSample, sqrt(mseSparseFlt361), '-o'); 
plot(subSample, sqrt(mseSparseFlt400), '-o'); 
plot(subSample, sqrt(mseSparseFlt900), '-o');
plot(subSample, sqrt(mseSparseFlt1024), '-o');

title('mse reconstruction');
set(gca, 'XDir','reverse');

legend({'Sparse400', 'Sparse576', 'PCA', 'SparseFlt 361', ...
    'SparseFlt 400', 'SparseFlt 900', 'SparseFlt 1024'});
