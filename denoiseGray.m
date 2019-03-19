%% Load dataset
projectName = 'ColorImagePriors';
thisImageSet = 'CIFAR_all';
dataBaseDir = getpref(projectName, 'dataDir');

testData = 'image_cifar_all_gray.mat';
dataInDir = fullfile(dataBaseDir, thisImageSet, testData);
load(dataInDir);

imageTr = image_all_gray(1:9.5e4, :);
imageTe = image_all_gray(9.5e4+1:end, :);
nTestSet = 5e3;
clear image_all;

%% Gaussian model
[regBasis, mu] = computeBasisPCA(imageTr, 32);
estimatorRidge = RidgeGaussianEstimator(eye(1024), regBasis, mu');

%% LASSO model
[Z, U, SIG, MU] = whitening(imageTr, 'svd');

basisInDir = fullfile(dataBaseDir, thisImageSet, 'sparse_basis');
basisName  = 'ica_gray_1600.mat';
load(fullfile(basisInDir, basisName));

W = Mdl.TransformWeights; nBasis = 1600;
[~] = visualizeBasis(U * diag(sqrt(SIG)) * W, 32, nBasis, true);

regBasis = U * diag(sqrt(SIG)) * W;
estimatorLasso = LassoGaussianEstimator(eye(1024), regBasis, MU');

%% Baseline model (lowpass filter)
lo_filt = binomialFilter(3) * binomialFilter(3)';
filterRecon = @(image) rconv2(image,lo_filt);

%% Denoising test
imageSize = [32, 32];
figure(); 
for idx = 1:6
    testIdx = randi([1, nTestSet]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));
    
    reconGauss = estimatorRidge.estimate(noisy, 'regularization', 0.01);
    reconLasso = estimatorLasso.estimate(noisy, 'regularization', 0.01);
    reconFilt  = filterRecon(reshape(image, imageSize));
    
    subplot(6, 5, 5 * idx - 4);
    imshow(reshape(image, imageSize), 'InitialMagnification', 500);    
    subplot(6, 5, 5 * idx - 3);
    imshow(reshape(noisy, imageSize), 'InitialMagnification', 500);    
    subplot(6, 5, 5 * idx - 2);
    imshow(reconFilt, 'InitialMagnification', 500);
    subplot(6, 5, 5 * idx - 1);
    imshow(reshape(reconGauss, imageSize), 'InitialMagnification', 500);
    subplot(6, 5, 5 * idx);
    imshow(reshape(reconLasso, imageSize), 'InitialMagnification', 500);
    
    imStats(reshape(image, imageSize), reconFilt, true);
    imStats(image, reconGauss, true);
    imStats(image, reconLasso, true);
end

%% Evaluation
regPara_ridge = 0 : 0.001 : 0.01;
regPara_lasso = 0 : 0.001 : 0.01;

nTest = 5e1; 
nReg  = length(regPara_ridge);

SNR_ridge = zeros(nReg, nTest);
SNR_lasso = zeros(nReg, nTest);

rmse_ridge = zeros(nReg, nTest);
rmse_lasso = zeros(nReg, nTest);

for idx = 1:nTest
    image = imageTr(randi([1, nTestSet]), :);
    noisy = image + normrnd(0, 0.1, size(image));
    
    parfor regIdx = 1:nReg
        [rmse_ridge(regIdx, idx), SNR_ridge(regIdx, idx)] = ...
            imStats(image, estimatorRidge.estimate(noisy, 'regularization', regPara_ridge(regIdx)), false);
        
        [rmse_lasso(regIdx, idx), SNR_lasso(regIdx, idx)] = ...
            imStats(image, estimatorLasso.estimate(noisy, 'regularization', regPara_lasso(regIdx)), false);        
    end
end

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

