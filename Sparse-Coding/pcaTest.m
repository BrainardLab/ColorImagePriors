%% PCA Basis Learning
data    = load('caltech101patches');
imgData = data.X;

for idx = 1 : 1e5
    img = imgData(idx, :);
    
    img = img - min(img);
    img = img / max(img);
    
    imgData(idx, :) = img;
end

pcaBasis = pca(imgData);

%% Test PCA Reconstruction
dx = 11; dy = 11;

nSample   = 363;
renderIdx = sort(datasample(1 : dx * dy * 3, nSample, 'Replace', false));

render = eye(dx * dy * 3);
render = render(renderIdx, :);

