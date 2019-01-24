% Filter learning procedure for color images of 32 * 32 * 3 with RICA algorithm 

%% Define Constants  
imgDim = 16;
dx = imgDim;
dy = imgDim;

basisSize = 40 * 40;

%% Filter Basis Learning for Color Images
load('./cifar-all-mat/image_all_16.mat');
imgData = image_all;

res = rica(imgData, basisSize, 'IterationLimit', 2.5e4, 'VerbosityLevel', 1, ...
    'Standardize', true);

% res = rica(imgData, basisSize, 'IterationLimit', 1e3, 'VerbosityLevel', 1, ...
%     'InitialTransformWeights', res.TransformWeights, 'Lambda', 5);

%% Visulization of Learned Basis
% basisSet = res.TransformWeights;
basisSet = reshape(basisSet, [dx, dy, 3, basisSize]);

% N by N large "image"
allDim   = sqrt(basisSize); 
basisImg = zeros(allDim * imgDim, allDim * imgDim, 3);

for i = 1:allDim
    for j = 1:allDim
        % Select each Basis Image
        idx   = (i - 1) * allDim + j;
        basis = basisSet(:, :, :, idx);
        basis = basis(:);
        
        % Normalization
        basis = (basis - min(basis))/(max(basis) - min(basis));

        % Add to Display Image 
        basisImg((i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(basis, [dx, dy, 3]);
    end
end

figure;
imshow(basisImg, 'InitialMagnification', 300);