function [imageTr, imageTe] = cifarLoader(dataset, split)
%CIFARLOADER
projectName = 'ISETImagePipeline';
dataBaseDir = getpref(projectName, 'dataDir');

if(strcmp(dataset, 'extend'))
    thisImageSet = 'CIFAR_extend';
    testData = 'cifarExtend_240k.mat';
    dataInDir = fullfile(dataBaseDir, thisImageSet, testData);
    data = load(dataInDir);
elseif(strcmp(dataset, 'cifar'))
    thisImageSet = 'CIFAR_all';
    testData = 'image_cifar_all.mat';
    dataInDir = fullfile(dataBaseDir, thisImageSet, testData);
    data = load(dataInDir);
else
    error('Invalid Dataset Name.');
end

nData = size(data.image_all, 1);
imageTr = data.image_all(1 : floor(nData * split), :);
imageTe = data.image_all((ceil(nData * split) + 1) : end, :);

end

