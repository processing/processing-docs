// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

var ParticleSystem = function(num, v, img_) {
  this.origin = v.copy();
  this.img = img_;
  this.particles = [];
  for (var i = 0; i < num; i++) {
    particles.add(new Particle(this.origin, this.img));         // Add "num" amount of particles to the arraylist
  }

  this.addParticle = function() {
    this.particles.push(new Particle(this.origin, this.img));
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

  // Method to add a force vector to all particles currently in the system
  this.applyForce = function(dir) {
    // Enhanced loop!!!
    for (var i = 0; i < this.particles.length; i++) {
      var p = this.particles[i];
      p.applyForce(dir);
    }
  
  }  
}
