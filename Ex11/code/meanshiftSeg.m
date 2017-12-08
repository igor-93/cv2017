function [map, peak] = meanshiftSeg(img, r)
% convert image to dataset X
[n,m] = size(img);
ch1 = img(:, :, 1);
ch2 = img(:, :, 2);
ch3 = img(:, :, 3);

ch1 = reshape(ch1, [n*m, 1]);
ch2 = reshape(ch2, [n*m, 1]);
ch3 = reshape(ch3, [n*m, 1]);

X = [ch1 ch2 ch3];


end