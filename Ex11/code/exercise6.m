function run_ex5()

% load image
img = imread('cow.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)
img = im2double(img);
scale = 0.5;
%img = imresize(img,scale);
figure, imshow(img), title('original image')


% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
imgSmoothed = smooth(img, 5, 5);
figure, imshow(imgSmoothed), title('smoothed image')

% convert to L*a*b* image (6.1b)
% (replace the folliwing line with your code to convert the image to lab
% space

imglab = rgb2lab(imgSmoothed);
figure, imshow(imglab), title('l*a*b* image')


% (6.2)
% r = 0.005;
% [mapMS, peak] = meanshiftSeg(imglab, r);
% visualizeSegmentationResults(mapMS,peak);


% (6.3)
K = 4;
[mapEM, mus] = EM(imglab, K);
visualizeSegmentationResults(mapEM,mus);

end