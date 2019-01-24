function [render] = bayerFilter(imgDim, showRender)
% Generate Bayer filter sampling matrix for 32 * 32 * 3 RGB image
dx = imgDim; dy = imgDim;

fullZero = zeros(1, 32);
redVec = repmat([0, 1], 1, 16);

redRender = repmat([fullZero; redVec], 16, 1);

greVec1 = repmat([0, 1], 1, 16);
greVec2 = repmat([1, 0], 1, 16);

greenRender = repmat([greVec1; greVec2], 16, 1);

blueVec = repmat([1, 0], 1, 16);
blueRender = repmat([blueVec; fullZero], 16, 1);

bayerFlt = zeros(32, 32, 3);

bayerFlt(:, :, 1) = redRender; 
bayerFlt(:, :, 2) = greenRender; 
bayerFlt(:, :, 3) = blueRender;

if showRender
    imshow(bayerFlt, 'InitialMagnification', 2000);
end

renderIdx = 1 : dx * dy * 3;
renderIdx = renderIdx(bayerFlt(:) == 1);

render = eye(dx * dy * 3);
render = render(renderIdx, :);

end