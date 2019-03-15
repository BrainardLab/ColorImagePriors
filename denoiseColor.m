%% Load dataset
[imageTr, ~] = cifarLoader('extend', 0.8);
[~, imageTe] = cifarLoader('cifar', 0.95);

nTrainSet = size(imageTr, 1);
nTestSet  = size(imageTe, 1);

%% Gaussian model
[regBasis, mu] = computeBasisPCA(imageTr, 32);
estimatorRidge = RidgeGaussianEstimator(eye(3072), regBasis, mu');

%% Sparse (LASSO) model
% Load learned basis function
projectName = 'ISETImagePipeline';
dataBaseDir = getpref(projectName, 'dataDir');
basisInDir = fullfile(dataBaseDir, 'CIFAR_extend');
basisName  = 'ica_color_3600.mat';
load(fullfile(basisInDir, basisName));

% W = Mdl.TransformWeights;
% [~, U, SIG, MU] = whitening(imageTr, 'svd');
regBasis = U * diag(sqrt(SIG)) * W;
estimatorLasso = LassoGaussianEstimator(eye(3072), regBasis, MU');

%% Visualization
[~] = visualizeBasis(estimatorRidge.Basis, 32, size(estimatorRidge.Basis, 2), false);
[~] = visualizeBasis(estimatorLasso.Basis, 32, size(estimatorLasso.Basis, 2), false);

%% Denoising test
imageSize = [32, 32, 3];
figure();
for idx = 1:6
    testIdx = randi([1, nTestSet]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));
    
    reconGauss = estimatorRidge.estimate(noisy, 'regularization', 0.01);
    reconLasso = estimatorLasso.estimate(noisy, 'regularization', 0.01);
    
    subplot(6, 4, 4 * idx - 3);
    imshow(reshape(image, imageSize), 'InitialMagnification', 500);    
    subplot(6, 4, 4 * idx - 2);
    imshow(reshape(noisy, imageSize), 'InitialMagnification', 500);    
    subplot(6, 4, 4 * idx - 1);
    imshow(reshape(reconGauss, imageSize), 'InitialMagnification', 500);
    subplot(6, 4, 4 * idx);
    imshow(reshape(reconLasso, imageSize), 'InitialMagnification', 500);
    
    imStats(image, reconGauss, true);
    imStats(image, reconLasso, true);
end

%% Evaluation
regPara_ridge = 0 : 0.001 : 0.02;
regPara_lasso = 0 : 0.001 : 0.02;

nTest = 1e1; nReg = length(regPara_ridge);

SNR_ridge = zeros(nReg, nTest);
SNR_lasso = zeros(nReg, nTest);

rmse_ridge = zeros(nReg, nTest);
rmse_lasso = zeros(nReg, nTest);

for idx = 1:nTest
    fprintf('Cross Validation Iteration %d / %d \n', idx, nTest);
    image = imageTr(randi([1, nTestSet]), :);
    noisy = image + normrnd(0, 0.1, size(image));
    
    for regIdx = 1:nReg
        [rmse_ridge(regIdx, idx), SNR_ridge(regIdx, idx)] = ...
            imStats(image, estimatorRidge.estimate(noisy, 'regularization', regPara_ridge(regIdx)), false);
        
        [rmse_lasso(regIdx, idx), SNR_lasso(regIdx, idx)] = ...
            imStats(image, estimatorLasso.estimate(noisy, 'regularization', regPara_lasso(regIdx)), false);        
    end
end

%% Plot SNR
figure();
p1 = subplot(1, 2, 1);
plot(regPara_ridge, mean(SNR_ridge, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, Gaussian Prior');
ylm1 = ylim;

p2 = subplot(1, 2, 2);
plot(regPara_lasso, mean(SNR_lasso, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, Sparse Prior');
ylm2 = ylim;

ylim(p1, [min([ylm1, ylm2]), max([ylm1, ylm2])]);
ylim(p2, [min([ylm1, ylm2]), max([ylm1, ylm2])]);

suptitle('Color Denoising, CIFAR, Noise Var: 0.1');

%% Plot RMSE
figure;
p1 = subplot(1, 2, 1);
plot(regPara_ridge, mean(rmse_ridge, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('RMSE'); grid on;
title('RMSE, Gaussian Prior');
ylm1 = ylim;

p2 = subplot(1, 2, 2);
plot(regPara_lasso, mean(rmse_lasso, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('RMSE'); grid on;
title('RMSE, Sparse Prior');
ylm2 = ylim;

ylim(p1, [min([ylm1, ylm2]), max([ylm1, ylm2])]);
ylim(p2, [min([ylm1, ylm2]), max([ylm1, ylm2])]);