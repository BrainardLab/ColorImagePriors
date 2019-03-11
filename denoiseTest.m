%% Load dataset
projectName = 'ColorImagePriors';
thisImageSet = 'CIFAR_all';
dataBaseDir = getpref(projectName, 'dataDir');

testData = 'image_cifar_all.mat';
dataInDir = fullfile(dataBaseDir, thisImageSet, testData);
load(dataInDir);

imageTr = image_all(1:9.5e4, :);
imageTe = image_all(9.5e4+1:end, :);
nTestSet = 5e3;
clear image_all;

%% Gaussian model
[regBasis, mu] = computeBasisPCA(imageTr, 32);
estimatorRidge = RidgeGaussianEstimator(eye(3072), regBasis, mu');

%% Sparse (LASSO) model
basisInDir = fullfile(dataBaseDir, thisImageSet, 'sparse_coding');
basisName  = 'rica_color_3072.mat';
load(fullfile(basisInDir, basisName));

W = Mdl.TransformWeights;
[~, U, SIG, MU] = whitening(imageTr, 'svd');

regBasis = U * diag(sqrt(SIG)) * W;
estimatorLasso = LassoDenoiseEstimator(eye(3072), regBasis, MU');

%% Denoising test
imageSize = [32, 32, 3];
figure();
for idx = 1:6
    testIdx = randi([1, nTestSet]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.05, size(image));
    
    reconGauss = estimatorRidge.estimate(noisy, 'regularization', 0.003);
    reconLasso = estimatorLasso.estimate(noisy, 'regularization', 2.1);
    
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
regPara_ridge = 0 : 0.0004 : 0.0048;
regPara_lasso = 0 : 0.3 : 3.6;

nTest = 1e1; nReg = length(regPara_ridge);

SNR_ridge = zeros(nReg, nTest);
SNR_lasso = zeros(nReg, nTest);

for idx = 1:nTest
    image = imageTr(randi([1, nTestSet]), :);
    noisy = image + normrnd(0, 0.05, size(image));
    
    parfor regIdx = 1:nReg
        [~, SNR_ridge(regIdx, idx)] = imStats(image, estimatorRidge.estimate(noisy, 'regularization', regPara_ridge(regIdx)), false);
        [~, SNR_lasso(regIdx, idx)] = imStats(image, estimatorLasso.estimate(noisy, 'regularization', regPara_lasso(regIdx)), false);        
    end
end

figure();
subplot(1, 2, 1);
plot(regPara_ridge, mean(SNR_ridge, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, Gaussian Prior');

subplot(1, 2, 2);
plot(regPara_lasso, mean(SNR_lasso, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, Sparse Prior');
