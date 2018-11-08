function [render] = bayerFilter(imgDim, showRender)
% Generate Bayer filter sampling matrix for 11 * 11 * 3 RGB image
dx = imgDim; dy = imgDim;

fullZero = zeros(1, 11);
redVec = [repmat([0, 1], 1, 5), 0];

redRender = [fullZero; repmat([redVec; fullZero], 5, 1)];

greVec1 = [repmat([0, 1], 1, 5), 0];
greVec2 = [repmat([1, 0], 1, 5), 1];

greenRender = [repmat([greVec1; greVec2], 5, 1); greVec1];

blueVec = [repmat([1, 0], 1, 5), 1];
blueRender = [repmat([blueVec; fullZero], 5, 1); blueVec];

bayerFlt = zeros(11, 11, 3);

bayerFlt(:, :, 1) = redRender; 
bayerFlt(:, :, 2) = greenRender; 
bayerFlt(:, :, 3) = blueRender;

if showRender
    imshow(bayerFlt, 'InitialMagnification', 2000);
end

renderIdx = 1 : 11 * 11 * 3;
renderIdx = renderIdx(bayerFlt(:) == 1);

render = eye(dx * dy * 3);
render = render(renderIdx, :);

end