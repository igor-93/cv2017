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

%seed = 9;
%rng(seed);

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

%showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

x1 = fa(1:2, matches(1,:));
da = da(:,matches(1,:));
x2 = fb(1:2, matches(2,:));
[F, inliers] = ransacfitfundmatrix(x1, x2, 0.001);
%showFeatureMatches(img1, x1(1:2, inliers), img2, x2(1:2, inliers), 27);

x1 = vertcat(x1, ones(1, size(x1,2)));
x2 = vertcat(x2, ones(1, size(x2,2)));
x1 = x1(:, inliers);
da = da(:, inliers);
x2 = x2(:, inliers);

img_1 = im2double(imread(imgName1));
img_2 = im2double(imread(imgName2));

% draw epipolar lines
figure(1), clf,
imshow(img_1, []); hold on,
for k = 1:size(x2,2)
    drawEpipolarLines(F'*x2(:,k), img_1);
end
figure(2), clf,
imshow(img_2, []); hold on,
for k = 1:size(x1,2)
    drawEpipolarLines(F*x1(:,k), img_2);
end

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

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches, scores] = vl_ubcmatch(da, dc);
XS_3 = XS(:, matches(1,:));
x1_3 = x1(:,  matches(1,:));
x3 = fc(1:2, matches(2,:));
%[F, inliers3] = ransacfitfundmatrix(x1_3(1:2,:), x3, 0.0001);
%x1_3 = x1_3(:, inliers3);
%x3 = x3(:, inliers3);
%XS_3 = XS_3(:, inliers3);
showFeatureMatches(img1, x1_3, img3, x3, 30);

%run 6-point ransac
x3 = vertcat(x3, ones(1, size(x3,2)));
[P3, inliers3] = ransacfitprojmatrix(K_inv * x3, XS_3, 0.002);
x1_3 = x1_3(:, inliers3);
x3 = x3(:, inliers3);
showFeatureMatches(img1, x1_3, img3, x3(1:2,:), 31);
Ps{3} = P3;

%triangulate the inlier matches with the computed projection matrix
[XS3, err2] = linearTriangulation(Ps{1}, K_inv * x1_3, Ps{3}, K_inv * x3);

%% Add view 4

imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

[matches4, scores] = vl_ubcmatch(da, dd);
XS_4 = XS(:, matches4(1,:));
x1_4 = x1(:,  matches4(1,:));
x4 = fd(1:2, matches4(2,:));
%[F, inliers4] = ransacfitfundmatrix(x1_4(1:2,:), x4, 0.0005);
%x1_4 = x1_4(:, inliers4);
%x4 = x4(:, inliers4);
%XS_4 = XS_4(:, inliers4);
showFeatureMatches(img1, x1_4, img4, x4, 40);

%run 6-point ransac
x4 = vertcat(x4, ones(1, size(x4,2)));
[P4, inliers4] = ransacfitprojmatrix(K_inv * x4, XS_4, 0.002);
x1_4 = x1_4(:, inliers4);
x4 = x4(:, inliers4);
showFeatureMatches(img1, x1_4, img4, x4(1:2,:), 41);
Ps{4} = P4;
%triangulate the inlier matches with the computed projection matrix
[XS4, err4] = linearTriangulation(Ps{1}, K_inv * x1_4, Ps{4}, K_inv * x4);


%% Add view 5

imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

[matches5, scores] = vl_ubcmatch(da, de);
XS_5 = XS(:, matches5(1,:));
x1_5 = x1(:,  matches5(1,:));
x5 = fe(1:2, matches5(2,:));
%[F, inliers5] = ransacfitfundmatrix(x1_5(1:2,:), x5, 0.0005);
%x1_5 = x1_5(:, inliers5);
%x5 = x5(:, inliers5);
%XS_5 = XS_5(:, inliers5);
showFeatureMatches(img1, x1_5, img5, x5, 50);

%run 6-point ransac
x5 = vertcat(x5, ones(1, size(x5,2)));
[P5, inliers5] = ransacfitprojmatrix(K_inv * x5, XS_5, 0.002);
x1_5 = x1_5(:, inliers5);
x5 = x5(:, inliers5);
showFeatureMatches(img1, x1_5, img5, x5(1:2,:), 51);
Ps{5} = P5;
%triangulate the inlier matches with the computed projection matrix
[XS5, err5] = linearTriangulation(Ps{1}, K_inv * x1_5, Ps{5}, K_inv * x5);


%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points

%draw cameras
drawCameras(Ps, fig, XS);