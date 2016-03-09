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

% blender = vision.AlphaBlender('Operation', 'Binary mask', ...
%     'MaskSource', 'Input port');

xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

for i = 1:panoImages.Count

    I = read(panoImages, i);

    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);   
% blending: calculate the weight of each pixel based on their distance to
% the boundary
      [~,b]=find(rgb2gray(panorama)~=0);
      [~,y2]=find(rgb2gray(warpedImage)~=0);
      pan=panorama.*warpedImage;
      [m,n]=find(rgb2gray(pan)~=0);
      w=[];ww=[];
q=min(m);
s=max(m);
e=min(n);
r=max(n);
my=min(y2);
mb=max(b);
for k=q:s
     for l=e:r
        if panorama(k,l)~=0&&warpedImage(k,l)~=0

w(k,l)=abs(mb-l);
        ww(k,l)=abs(l-my);

         end
     end
       end
maxw=max(max(w));
maxww=max(max(ww));
  % blending: calculate each pixel's new value 
   for k=q:s
     for l=e:r
          if panorama(k,l)~=0&&warpedImage(k,l)~=0
               panorama(k,l,1)=panorama(k,l,1)*(w(k,l)/maxw);
           warpedImage(k,l,1)=warpedImage(k,l,1)*(ww(k,l)/maxww);
          panorama(k,l,2)=panorama(k,l,2)*(w(k,l)/maxw);
           warpedImage(k,l,2)=warpedImage(k,l,2)*(ww(k,l)/maxww);
          panorama(k,l,3)=panorama(k,l,3)*(w(k,l)/maxw);
           warpedImage(k,l,3)=warpedImage(k,l,3)*(ww(k,l)/maxww);
          end
     end
   end
   % Overlay the warpedImage onto the panorama.
    panorama =panorama+warpedImage;
    %panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end
end


