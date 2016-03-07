function [ panorama ] = stitch( panoImages, tforms )
% STITCH Stitch together a set of images by applying a set of transforms

I = read(panoImages, 1);
imageSize = size(I);

% recalculate outer limits using recentered transforms
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)],...
        [1 imageSize(1)]);
end

% determine final mosaic size
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);
yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);
width  = round(xMax - xMin);
height = round(yMax - yMin);

% initialize empty mosaic
panorama = zeros([height width 3], 'like', I);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

for i = 1:panoImages.Count

    I = read(panoImages, i);

    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end

end

