
// A simple Particle class, renders the particle as an image
var Particle = function(l, img_) {
  this.acc = createVector(0, 0.05);
  var vx = randomGaussian()*0.3;
  var vy = randomGaussian()*0.3 - 1.0;
  this.vel = createVector(vx, vy);
  this.pos = l.copy();
  this.lifespan = 100.0;
  this.img = img_;

  this.run = function() {
    this.update();
    this.render();
  };

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  this.applyForce = function(f) {
    this.acc.add(f);
  }  

  // Method to update location
  this.update = function() {
    this.vel.add(this.acc);
    this.pos.add(this.vel);
    this.lifespan -= 2.5;
    this.acc.mult(0); // clear Acceleration
  }

  // Method to display
  this.render = function() {
    imageMode(CENTER);
    tint(255,this.lifespan);
    image(this.img,this.pos.x,this.pos.y);
    // Drawing a circle instead
    // fill(255,lifespan);
    // noStroke();
    // ellipse(loc.x,loc.y,img.width,img.height);
  }

  // Is the particle still useful?
  this.isDead = function() {
    if (this.lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
