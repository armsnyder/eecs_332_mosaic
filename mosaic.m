input_folder = 'test';

% read all images in a folder
panoImages = loadInputImages(input_folder);

% estimate transforms for each image
tforms = registration(panoImages);

% stitch images together into one larger image
panorama = stitch(panoImages, tforms);

% display the image
figure
imshow(panorama)