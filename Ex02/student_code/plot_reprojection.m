function plot_reprojection(filename, points, fig)
    img = imread(filename);
    figure(fig);
    imshow(img);
    hold on
    plot(points(1, :), points(2, :), 'r.', 'MarkerSize',32);
    hold off
end