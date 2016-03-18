
var Particle = function(position) {
  this.acceleration = createVector(0, 0.05);
  this.velocity = createVector(random(-1, 1), random(-2, 0));
  this.position = position.copy();
  this.lifespan = 255.0;

  this.run = function() {
    this.update();
    this.display();
  };

  // Method to update position
  this.update = function(){
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.lifespan -= 1;
  };

  // Method to display
  this.display = function() {
    stroke(255,this.lifespan);
    fill(255,this.lifespan);
    ellipse(this.position.x,this.position.y,8,8);
  };

  // Is the particle still useful?
  this.isDead = function(){
    if (this.lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  };
}