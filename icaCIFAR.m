%% Load dataset
[imageTr, ~] = cifarLoader('extend', 1);

%% Whitening, SVD
[Z, U, SIG, MU] = whitening(imageTr, 'svd');

%% RICA analysis
nBasis = 60 * 60;
Mdl    = rica(Z, nBasis, 'IterationLimit', 5e3, 'VerbosityLevel', 1, 'GradientTolerance', 1e-4, 'StepTolerance', 1e-4);

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
