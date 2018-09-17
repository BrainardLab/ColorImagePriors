% Filter learning procedure for color images of 11 * 11 * 3 with RICA algorithm 

%% Define Constants  
imgDim = 11;
dx = imgDim;
dy = imgDim;

basisSize = 40 * 40;

%% Filter Basis Learning for Color Images
data = load('caltech101patches');
images = data.X;

res = rica(images, basisSize, 'IterationLimit', 2e4, 'VerbosityLevel', 1);

% res = rica(images, basisSize, 'IterationLimit', 1e3, 'VerbosityLevel', 1, ...
%     'InitialTransformWeights', transMatrix, 'Lambda', 10);

%% Visulization of Learned Basis
% basisSet = transMatrix;
basisSet = res.TransformWeights;
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
        basisImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(basis, dx, dy, 3);
    end
end

figure;
imshow(basisImg, 'InitialMagnification', 300);