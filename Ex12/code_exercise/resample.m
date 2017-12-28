function [p, p_w] = resample(particles,particles_w)

n = size(particles, 1);
y = randsample(n,n,true,particles_w);

p = particles(y,:);
p_w = particles_w(y);
