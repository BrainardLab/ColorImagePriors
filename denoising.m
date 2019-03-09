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

%% Noisy image dataset
snr = zeros(1, 8);
for idx = 1:8
    testIdx = randi([1, 5000]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));
    
    subplot(4, 4, 2*idx-1);
    imshow(reshape(image, [32, 32, 3]), 'InitialMagnification', 500);
    
    subplot(4, 4, 2*idx);
    imshow(reshape(noisy, [32, 32, 3]), 'InitialMagnification', 500);
    
    snr(idx) = imStats(image, noisy);
end

%% Gaussian model
[regBasis, mu] = computeBasisPCA(imageTr, 32);
estimator      = RidgeGaussianEstimator(eye(3072), regBasis, mu');

%% Denoising
snr = zeros(2, 6);
imageSize = [32, 32, 3];
for idx = 1:6
    testIdx = randi([1, 5000]);
    image = imageTr(testIdx, :);
    noisy = image + normrnd(0, 0.1, size(image));    
    recon = estimator.estimate(noisy, 'regularization', 0.05);
    
    subplot(6, 3, 3 * idx - 2);
    imshow(reshape(image, imageSize), 'InitialMagnification', 500);
    
    subplot(6, 3, 3 * idx - 1);
    imshow(reshape(noisy, imageSize), 'InitialMagnification', 500);
    
    subplot(6, 3, 3 * idx);
    imshow(reshape(recon, imageSize), 'InitialMagnification', 500);
    
    snr(1, idx) = imStats(image, noisy);
    snr(2, idx) = imStats(image, recon);
end