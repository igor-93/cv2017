function vPoints = grid_points(img,nPointsX,nPointsY,border)

% remove border

[n, m] = size(img);

gridX = linspace(border,n-border,nPointsX);
gridY = linspace(border,m-border,nPointsY);
gridX = round(gridX);
gridY = round(gridY);

[x1g, x2g] = meshgrid(gridX, gridY);
vPoints = zeros(nPointsX*nPointsY, 2);
iter = 1;
for i = 1:nPointsX
    for j=1:nPointsY
        vPoints(iter, :) = [x1g(i,j) x2g(i,j)];
        iter = iter + 1;
    end
end

end
