imgDim = 11;
dx = imgDim;
dy = imgDim;

data   = load('caltech101patches');
images = data.X;

% Number of Basis 
basisSize = 4e2;

%% Learning Basis Set
res = sparsefilt(images, basisSize, 'IterationLimit', 2e5, 'VerbosityLevel', 1);
basisSet = res.TransformWeights;

%% Visulization of Learned Basis
basisSet = reshape(basisSet, [dx, dy, 3, basisSize]);

% 10 by 10 large "image"
allDim   = sqrt(basisSize); 
basisImg = zeros(allDim * imgDim, allDim * imgDim, 3);

for i = 1:allDim
    for j = 1:allDim
        idx   = (i - 1) * allDim + j;
        basis = basisSet(:, :, :, idx);
        basis = basis(:);
        
        % Normalization
        basis = (basis - min(basis))/(max(basis) - min(basis));
        
        basisImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy, :) = reshape(basis, dx, dy, 3);
    end
end

imshow(basisImg,'InitialMagnification',300);
