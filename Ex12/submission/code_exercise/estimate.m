function meanState = estimate(particles,particles_w)


meanState = particles_w' * particles;