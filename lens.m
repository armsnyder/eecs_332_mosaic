function img_out=lens(img_in);
img_out=img_in;
HSV=rgb2hsv(img_in);
v=HSV(:,:,3);
vm=mean(v(:));
if vm<0.4
    x=0.4/vm;
HSV(:,:,3)=HSV(:,:,3)*x;
HSV(:,:,3)=histeq(HSV(:,:,3));

img_out=hsv2rgb(HSV);
figure,imshow(img_out);
title('after lens correction')

end
end