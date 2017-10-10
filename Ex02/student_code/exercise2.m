% Exervice 2
%
close all;

IMG_NAME = 'images/image001.jpg';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
start_over = false
if start_over
    [xy, XYZ] = getpoints(IMG_NAME);
    save("xy.mat", "xy");
    save("XYZ.mat", "XYZ");
else
    xyFile = matfile('xy.mat');
    XYZFile = matfile('XYZ.mat');
    xy = xyFile.xy;
    XYZ = XYZFile.XYZ;
end

%plot_reprojection(IMG_NAME, xy, 7);

% === Task 2 DLT algorithm ===

[K, R, t, error] = runDLT(xy, XYZ, IMG_NAME);

% === Task 3 Gold Standard algorithm ===

[K, R, t, error] = runGoldStandard(xy, XYZ, IMG_NAME);

% === Bonus: Gold Standard algorithm with radial distortion estimation ===

%[K, R, t, error] = runGoldStandardRadial(xy, XYZ);

