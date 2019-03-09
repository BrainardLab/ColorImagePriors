%% Load dataset
projectName = 'ISETImagePipeline';
thisImageSet = 'CIFAR_all';
dataBaseDir = getpref(projectName, 'dataDir');

testData = 'image_cifar_all.mat';
dataInDir = fullfile(dataBaseDir, thisImageSet, testData);
load(dataInDir);

imageTr = image_all(1:9.5e4, :);
imageTe = image_all(9.5e4+1:end, :);
clear image_all;

%% Whitening, SVD
[Z, U, SIG, MU] = whitening(imageTr, 'svd');
X = (U * diag(sqrt(SIG)) * Z' + MU')';

%% RICA analysis
nBasis = 58 * 58;
Mdl    = rica(Z, nBasis, 'IterationLimit', 2e3, 'VerbosityLevel', 1, 'GradientTolerance', 1e-4, 'StepTolerance', 1e-4);

%% Visualization
W   = Mdl.TransformWeights;
[~] = visualizeBasis(U * diag(sqrt(SIG)) * W, 32, nBasis, false);

%% Sparsity check
coff = transform(Mdl, Z);

figure;
nPlot = 8;
for idx = 1:(nPlot * nPlot)
    subplot(nPlot, nPlot, idx);
    coffIdx = randi([1, nBasis]);
    histogram(coff(:, coffIdx), 'Normalization', 'probability');    
end

figure;
kurtStat = kurtosis(coff);
histogram(kurtStat(kurtStat < 2e2) - 3);

%% Sort basis by sparsity
[~, sortIdx] = sort(kurtStat, 'ascend');
sortedBasis = zeros(size(W));
for idx = 1:nBasis
    sortedBasis(:, idx) = W(:, sortIdx(idx));
end
[~] = visualizeBasis(U * diag(sqrt(SIG)) * sortedBasis, 32, nBasis, false);