s=((s-repmat(min(s(:)),size(s)))./(repmat(max(s(:)),size(s))-repmat(min(s(:)),size(s))));
I=s;

background = imopen(I,strel('disk',5));
I2 = I - background;
I3 = imadjust(I);
figure;imshow(I3)
level = graythresh(I3);
BW = im2bw(I3,level);
se = strel('disk', 5);
I3= imdilate(BW,se);
figure;imshow(BW)