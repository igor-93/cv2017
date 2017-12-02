function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    descriptors = zeros(0,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(0,4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img); 
    angs = angles(grad_x, grad_y);
    
    angle_bins = linspace(0, 2*pi, nBins+1);
    angle_bins = angle_bins(1:end-1) + pi/nBins;
    
    for i = 1:size(vPoints,1) % for all local feature points
        p = vPoints(i,:);
        x = p(1);
        y = p(2);
        current_desc = [];
        for x_dir = [-2 -1 0 1]
            for y_dir = [-2 -1 0 1]
                small_patch = angs(x+x_dir*w+1:x+x_dir*w+w, y+y_dir*h+1:y+y_dir*h+h);
                assert(size(small_patch,1) == 4, 'Small patch size(1) is wrong')
                assert(size(small_patch,2) == 4, 'Small patch size(2) is wrong')
                c = hist(small_patch(:), angle_bins);
                assert(size(c,2) == nBins, 'Histogram size is wrong')
                %keyboard;
                current_desc = [current_desc c];
            end
        end
        
        assert(size(current_desc,2) == 128, 'Descriptor size is wrong')
        %keyboard;
        patch = img(x-2*w+1:x+2*w, y-2*h+1:y+2*h);
        assert(size(patch,1) == 16, 'Patch size(1) is wrong')
        assert(size(patch,2) == 16, 'Patch size(2) is wrong')
        patch = patch(:)';
        descriptors = [descriptors; current_desc];
        patches = [patches; patch];
    end % for all local feature points
    
end


function a = angles(x, y)
    a = atan2(y,x);
    negs = a<0;
    a(negs) = a(negs) + 2*pi;
end
