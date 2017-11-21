% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)
% run /home/igor/software/vlfeat/vlfeat-0.9.20/toolbox/vl_setup.m

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

x1 = fa(1:2, matches(1,:));
da = da(:,matches(1,:));
x2 = fb(1:2, matches(2,:));
[F, inliers] = ransacfitfundmatrix(x1, x2, 0.001);
showFeatureMatches(img1, x1(1:2, inliers), img2, x2(1:2, inliers), 22);

x1 = x1(:, inliers);
da = da(:, inliers);
x2 = x2(:, inliers);

x1 = vertcat(x1, ones(1, size(x1,2)));
x2 = vertcat(x2, ones(1, size(x2,2)));

K_inv = inv(K);
nx1 = K_inv * x1;
nx2 = K_inv * x2;
[Eh, E] = essentialMatrix(nx1, nx2);

P1 = eye(4);
P2 = decomposeE(Eh, nx1, nx2);
Ps{1} = P1;
Ps{2} = P2;

%triangulate the inlier matches with the computed projection matrix
[XS, err] = linearTriangulation(Ps{1}, nx1, Ps{2}, nx2);
%% Add an addtional view of the scene 

imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches, scores] = vl_ubcmatch(da, dc);
XS = XS(:, matches(1,:));
x1 = x1(:,  matches(1,:));
x3 = fc(1:2, matches(2,:));
showFeatureMatches(img1, x1, img3, x3, 23);

%run 6-point ransac
x3 = vertcat(x3, ones(1, size(x3,2)));
[P3_, inliers] = ransacfitprojmatrix(K_inv * x3, XS, 0.1);
XS = XS(:, inliers);
x1 = x1(:, inliers);
x3 = x3(:, inliers);
showFeatureMatches(img1, x1, img3, x3(1:2,:), 24);

nx1 = K_inv * x1;
nx3 = K_inv * x3;
[P3, ~] = dlt(x3, XS);
P3 = [P3; 0 0 0 1];
%triangulate the inlier matches with the computed projection matrix
Ps{3} = P3_;
[XS, err2] = linearTriangulation(Ps{1}, nx1, Ps{3}, nx3);

%% Add more views...

imgName4 = '../data/house.003.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

imgName5 = '../data/house.004.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points

%draw cameras
drawCameras(Ps, fig);