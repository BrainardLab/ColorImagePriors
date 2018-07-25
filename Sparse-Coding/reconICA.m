%% Const 
imgDim = 11;
dx = imgDim;
dy = imgDim;

%% Filter Basis Learning for Color Images
data = load('caltech101patches');
images = data.X;
basisSize = 4e2;

res = rica(images, basisSize, 'IterationLimit', 2e5, 'VerbosityLevel', 1, ...
    'InitialTransformWeights', transMatrix);

% res = rica(images, basisSize, 'IterationLimit', 2e5, 'VerbosityLevel', 1);

%% Visulization of Learned Basis
basisSet = res.TransformWeights;
basisSet = reshape(basisSet, [dx, dy, 3, basisSize]);

% 10 by 10 large "image"
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

imshow(basisImg, 'InitialMagnification', 500);