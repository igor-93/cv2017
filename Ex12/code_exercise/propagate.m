function particles_new = propagate(particles,sizeFrame,params)
[n, d] = size(particles);

position_noise = normrnd(0,params.sigma_position,[n,2]);

if params.model==0
    w = position_noise;
else 
    velocity_noise = normrnd(0,params.sigma_velocity,[n,2]);
    w = [position_noise velocity_noise];
end

assert(size(w,2) == d);

particles_new = particles * params.A + w;

positions = particles_new(:, 1:2);

neg = positions < 1;
big1 = positions(:,1) > sizeFrame(2);
big2 = positions(:,2) > sizeFrame(1);

positions(neg) = 1;
particles_new(:, 1:2) = positions;
positions1 = particles_new(:, 1);
positions2 = particles_new(:, 2);
positions1(big1) = sizeFrame(2);
positions2(big2) = sizeFrame(1);
particles_new(:, 1) = positions1;
particles_new(:, 2) = positions2;

assert(all(particles_new(:)));
assert(all(particles_new(:, 1) <= sizeFrame(2)));
assert(all(particles_new(:, 2) <= sizeFrame(1)));