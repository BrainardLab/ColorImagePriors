%% Const 
imgDim = 11;
dx = imgDim;
dy = imgDim;

nData = 1e5;
basisSize = 13 * 13;

%% Reformatting Data
data = load('caltech101patches');
colImages = reshape(data.X', dx, dy, 3, nData);
bwImages  = zeros(dx, dy, nData);

for idx = 1:nData
    img   = colImages(:, :, :, idx);
    bwImg = rgb2gray(img);
    
    bwImages(:, :, idx) = bwImg;
end

bwImages = reshape(bwImages, dx * dy, nData)';

%% Filtering Learning
res = rica(bwImages, basisSize, 'IterationLimit', 2e4, 'VerbosityLevel', 1);

%% Visulization
basisSet = res.TransformWeights;
basisSet = reshape(basisSet, [dx, dy, basisSize]);

% M by M large "image"
allDim   = sqrt(basisSize); 
basisImg = zeros(allDim * imgDim, allDim * imgDim);

for i = 1:allDim
    for j = 1:allDim
        % Select each Basis Image
        idx   = (i - 1) * allDim + j;
        basis = basisSet(:, :, idx);
        basis = basis(:);
        
        % Normalization
        basis = (basis - min(basis))/(max(basis) - min(basis));

        % Add to Display Image 
        basisImg( (i-1) * dx + 1:i * dx, (j-1) * dy + 1:j * dy) = reshape(basis, dx, dy);
    end
end

imshow(basisImg, 'InitialMagnification', 600);
