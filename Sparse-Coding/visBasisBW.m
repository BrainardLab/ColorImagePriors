function basisImg = visBasisBW(basisSet, imgDim, basisSize)
% visBasisBW Visualization of gray scale basis function

dx = imgDim;
dy = imgDim;

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

end

