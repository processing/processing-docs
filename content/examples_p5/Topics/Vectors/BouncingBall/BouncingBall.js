/**
 * Bouncing Ball with Vectors 
 * by Daniel Shiffman.  
 * 
 * Demonstration of using vectors to control motion of body
 * This example is not object-oriented
 * See AccelerationWithVectors for an example of how to simulate motion using vectors in an object
 */
 
var position;  // position of shape
var velocity;  // Velocity of shape
var gravity;   // Gravity acts at the shape's acceleration

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  position = createVector(100,100);
  velocity = createVector(1.5,2.1);
  gravity = createVector(0,0.2);

}

function draw() {
  background(0);
  
  // Add velocity to the position.
  position.add(velocity);
  // Add gravity to velocity
  velocity.add(gravity);
  
  // Bounce off edges
  if ((position.x > width) || (position.x < 0)) {
    velocity.x = velocity.x * -1;
  }
  if (position.y > height) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window
    velocity.y = velocity.y * -0.95; 
    position.y = height;
  }

  // Display circle at position vector
  stroke(255);
  strokeWeight(2);
  fill(127);
  ellipse(position.x,position.y,48,48);
}


