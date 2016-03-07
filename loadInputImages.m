function [ images ] = loadInputImages( directory )
% LOADINPUTIMAGES Loads all image filenames in a given directory

% If we're going to auto-sort the images so that they are in order of
% how they should be stitched, that should go here. For now, they just
% load in default alphabetical order.

images = imageSet(directory);

end

