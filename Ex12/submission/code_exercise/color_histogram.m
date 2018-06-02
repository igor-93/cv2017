function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)

bbox = frame(yMin:yMax, xMin:xMax,:);
bboxR = bbox(:,:,1);
bboxG = bbox(:,:,2);
bboxB = bbox(:,:,3);
edges = linspace(0,255, hist_bin);

[countR,~] = histcounts(bboxR,edges);
[countG,~] = histcounts(bboxG,edges);
[countB,~] = histcounts(bboxB,edges);

hist = [countR countG countB];

hist = hist ./ sum(hist);

end
