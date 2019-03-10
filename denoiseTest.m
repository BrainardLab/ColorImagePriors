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
estimator      = RidgeGaussianEstimator(eye(3072), regBasis, mu');

%% Denoising test
imageSize = [32, 32, 3];
figure();
for idx = 1:6
    testIdx = randi([1, nTestSet]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));    
    recon = estimator.estimate(noisy, 'regularization', 0.01);
    
    subplot(6, 3, 3 * idx - 2);
    imshow(reshape(image, imageSize), 'InitialMagnification', 500);    
    subplot(6, 3, 3 * idx - 1);
    imshow(reshape(noisy, imageSize), 'InitialMagnification', 500);    
    subplot(6, 3, 3 * idx);
    imshow(reshape(recon, imageSize), 'InitialMagnification', 500);
    
    imStats(image, noisy, true);
    imStats(image, recon, true);
end

%% Evaluation
regPara = [0 : 0.002 : 0.02, 0.1];
nTest = 1e2;
SNR   = zeros(length(regPara), nTest);
for idx = 1:nTest
    image = imageTr(idx, :);
    noisy = image + normrnd(0, 0.1, size(image));
    parfor regIdx = 1:length(regPara)
        [~, SNR(regIdx, idx)] = imStats(image, estimator.estimate(noisy, 'regularization', regPara(regIdx)), false);
    end
end

figure();
plot(regPara, mean(SNR, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, Gaussian Prior');

%% Sparse (LASSO)
basisInDir = fullfile(dataBaseDir, thisImageSet, 'sparse_coding');
basisName  = 'rica_color_3072.mat';
load(fullfile(basisInDir, basisName));

W = Mdl.TransformWeights;
[~, U, SIG, MU] = whitening(imageTr, 'svd');

regBasis  = U * diag(sqrt(SIG)) * W;
estimator = LassoDenoiseEstimator(eye(3072), regBasis, MU');

%% Denoising test
imageSize = [32, 32, 3];
figure();
for idx = 1:6
    testIdx = randi([1, nTestSet]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));    
    recon = estimator.estimate(noisy, 'regularization', 8);
    
    subplot(6, 3, 3 * idx - 2);
    imshow(reshape(image, imageSize), 'InitialMagnification', 500);
    subplot(6, 3, 3 * idx - 1);
    imshow(reshape(noisy, imageSize), 'InitialMagnification', 500);
    subplot(6, 3, 3 * idx);
    imshow(reshape(recon, imageSize), 'InitialMagnification', 500);
    
    imStats(image, noisy, true);
    imStats(image, recon, true);
end

%% Evaluation
regPara = 0 : 1 : 15;
nTest = 1e2;
SNR   = zeros(length(regPara), nTest);
for idx = 1:nTest
    image = imageTr(idx, :);
    noisy = image + normrnd(0, 0.1, size(image));
    parfor regIdx = 1:length(regPara)
        [~, SNR(regIdx, idx)] = imStats(image, estimator.estimate(noisy, 'regularization', regPara(regIdx)), false);
    end
end

figure();
plot(regPara, mean(SNR, 2), '-o', 'LineWidth', 2);
xlabel('regularization'); ylabel('SNR'); grid on;
title('SNR, LASSO Prior');
