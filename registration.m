function [ tforms ] = registration( panoImages )
% REGISTRATION The "registration" step of image stitching: calculating
% the transforms for each image in an image set
%
%    panoImages: A list of image filenames, in order of how they will be
%                stitched.


% detect and extract SURF features from first image as a strating point
I = rgb2gray(read(panoImages, 1));
points = detectSURFFeatures(I);
[features, points] = extractFeatures(I, points);

% initialize transforms for images
tforms(panoImages.Count) = projective2d(eye(3));

for i = 2:panoImages.Count
    lastPoints = points;
    lastFeatures = features;
    
    % detect and extract SURF features for next image
    I = rgb2gray(read(panoImages, i));
    points = detectSURFFeatures(I);
    [features, points] = extractFeatures(I, points);
    
    % find common features between this image and last image
    indexPairs = matchFeatures(features, lastFeatures, 'Unique', true);
    matched = points(indexPairs(:,1),:);
    lastMatched = lastPoints(indexPairs(:,2),:);
    
    % uncomment to show the transform:
    
%     figure; showMatchedFeatures(read(panoImages, i-1),...
%         read(panoImages, i), lastMatched, matched);
    
    % calculate the transform between the two images
    tforms(i) = estimateGeometricTransform(matched, lastMatched,... 
    'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

    % accumulate previous transforms
    tforms(i).T = tforms(i-1).T * tforms(i).T;
end

% use output limits to find center image
imageSize = size(I);
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)],...
        [1 imageSize(1)]);
end

% find center image
meanXLim = mean(xlim, 2);
[~, idx] = sort(meanXLim);
centerIdx = floor((numel(tforms)+1)/2);
centerImageIdx = idx(centerIdx);

% apply center image inverse transform to all other images
Tinv = invert(tforms(centerImageIdx));
for i = 1:numel(tforms)
    tforms(i).T = Tinv.T * tforms(i).T;
end

end

