var ParticleSystem = function(num, position) {
  this.origin = position.copy();
  this.particles = [];
  for (var i = 0; i < num; i++) {
    this.particles.push(new Particle(this.origin));    // Add "num" amount of particles to the arraylist
  }

  this.addParticle = function() {
    var p;
    // Add either a Particle or CrazyParticle to the system
    if (int(random(0, 2)) == 0) {
      p = new Particle(this.origin);
    } 
    else {
      p = new CrazyParticle(this.origin);
    }
    this.particles.push(p);
  };

  this.run = function() {
    for (var i = this.particles.length-1; i >= 0; i--) {
      var p = this.particles[i];
      p.run();
      if (p.isDead()) {
        this.particles.splice(i, 1);
      }
    }
  };

  // A method to test if the particle system still has particles
  this.dead = function() {
    return particles.length === 0;
  }
}
