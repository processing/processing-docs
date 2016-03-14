function CrazyParticle(position) {
  this.theta = 0;

  Particle.call(this, position);
  
  // Method to update position
  this.update = function(){
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.lifespan -= 2;
    var theta_vel = (this.velocity.x * this.velocity.mag()) / 10;
    this.theta += theta_vel;
  };

  // Override the display method
  this.display = function(){
    stroke(255,this.lifespan);
    fill(255,this.lifespan);
    ellipse(this.position.x,this.position.y,8,8);
    // Then add a rotating line
    push();
    translate(this.position.x,this.position.y);
    rotate(this.theta);
    stroke(255,this.lifespan);
    line(0,0,25,0);
    pop();
  }
}

// Inherit from the parent class
CrazyParticle.prototype = Object.create(Particle.prototype);
this.constructor = CrazyParticle;
