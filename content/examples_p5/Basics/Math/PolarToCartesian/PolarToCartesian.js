/**
 * PolarToCartesian
 * by Daniel Shiffman.  
 * 
 * Convert a polar coordinate (r,theta) to cartesian (x,y):  
 * x = r * cos(theta)
 * y = r * sin(theta)
 */
 
var r;

// Angle and angular velocity, accleration
var theta;
var theta_vel;
var theta_acc;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  
  // Initialize all values
  r = height * 0.45;
  theta = 0;
  theta_vel = 0;
  theta_acc = 0.0001;
}

function draw() {
  
  background(0);
  
  // Translate the origin point to the center of the screen
  translate(width/2, height/2);
  
  // Convert polar to cartesian
  var x = r * cos(theta);
  var y = r * sin(theta);
  
  // Draw the ellipse at the cartesian coordinate
  ellipseMode(CENTER);
  noStroke();
  fill(200);
  ellipse(x, y, 32, 32);
  
  // Apply acceleration and velocity to angle (r remains static in this example)
  theta_vel += theta_acc;
  theta += theta_vel;

}




