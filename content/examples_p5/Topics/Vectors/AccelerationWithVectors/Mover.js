/**
 * Acceleration with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of the basics of motion with vector.
 * A "Mover" object stores location, velocity, and acceleration as vectors
 * The motion is controlled by affecting the acceleration (in this case towards the mouse)
 */



function Mover() {
  // Start in the center
  // The Mover tracks location, velocity, and acceleration 
  this.location = createVector(width/2,height/2);
  this.velocity = createVector(0,0);
  // The Mover's maximum speed
  this.topspeed = 5;
  

  this.update = function() {
    
    // Compute a vector that points from location to mouse
    var mouse = createVector(mouseX,mouseY);
    var acceleration = p5.Vector.sub(mouse,this.location);
    // Set magnitude of acceleration
    acceleration.setMag(0.2);
    
    // Velocity changes according to acceleration
    this.velocity.add(acceleration);
    // Limit the velocity by topspeed
    this.velocity.limit(this.topspeed);
    // Location changes by velocity
    this.location.add(this.velocity);
  }

  this.display = function() {
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(this.location.x,this.location.y,48,48);
  }

}



