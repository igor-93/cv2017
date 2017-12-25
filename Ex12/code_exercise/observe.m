function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
[n, d] = size(particles);

[f1, f2, ~] = size(frame);

particles_w = zeros(n,1);

for p = 1:n
    xMin = max(round(particles(p, 1) - 0.5 * W),1);
    xMax = min(round(particles(p, 1) + 0.5 * W),f2);
    yMin = max(round(particles(p, 2) - 0.5 * H),1);
    yMax = min(round(particles(p, 2) + 0.5 * H), f1);

    hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
    dist = chi2_cost(hist, hist_target)^2;
    
    weight = exp(-dist / (2*sigma_observe^2));
    particles_w(p) = weight;
end

w_sum = sum(particles_w);
particles_w = particles_w ./ w_sum;