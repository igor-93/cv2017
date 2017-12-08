function res = smooth(img, filter_size, sigma)

filter = fspecial('gaussian',filter_size,sigma);

res = imfilter(img,filter);

