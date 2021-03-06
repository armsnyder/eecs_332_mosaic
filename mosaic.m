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

%display the image after lens correction
%only works when there is no extremly bright part in the picture
img_out=lens(panorama);
