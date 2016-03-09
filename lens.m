function img_out=lens(img_in);
img_out=img_in;

r=img_in(:,:,1);
g=img_in(:,:,2);
b=img_in(:,:,3);
rm=mean(r(:));
gm=mean(g(:));
bm=mean(b(:));
Y = 0.299*rm + 0.587*gm + 0.114*bm;
if Y<100
 x=100/Y;
img_out(:,:,1)=img_in(:,:,1)*x;
img_out(:,:,2)=img_in(:,:,2)*x;
img_out(:,:,3)=img_in(:,:,3)*x;
figure,imshow(img_out);
title('after lens correction')

end
end