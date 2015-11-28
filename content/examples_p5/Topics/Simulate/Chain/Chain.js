/**
 * Chain. 
 * 
 * One mass is attached to the mouse position and the other 
 * is attached the position of the other mass. The gravity
 * in the environment pulls down on both. 
 */


var s1, s2;

var gravity = 9.0;
var mass = 2.0;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  fill(255, 126);
  // Inputs: x, y, mass, gravity
  s1 = new Spring2D(0.0, width/2, mass, gravity);
  s2 = new Spring2D(0.0, width/2, mass, gravity);
}

function draw() {
  background(0);
  s1.update(mouseX, mouseY);
  s1.display(mouseX, mouseY);
  s2.update(s1.x, s1.y);
  s2.display(s1.x, s1.y);
}

  
function Spring2D(xpos, ypos, m, g) {
  this.x = xpos;// The x- and y-coordinates
  this.y = ypos;
  this.vx = 0; // The x- and y-axis velocities
  this.vy = 0;
  this.mass = m;
  this.gravity = g;
  this.radius = 30;
  this.stiffness = 0.2;
  this.damping = 0.7;
  
  this.update = function(targetX, targetY) {
    var forceX = (targetX - this.x) * this.stiffness;
    var ax = forceX / this.mass;
    this.vx = this.damping * (this.vx + ax);
    this.x += this.vx;
    var forceY = (targetY - this.y) * this.stiffness;
    forceY += this.gravity;
    var ay = forceY / this.mass;
    this.vy = this.damping * (this.vy + ay);
    this.y += this.vy;
  }
  
   this.display = function(nx, ny) {
    noStroke();
    ellipse(this.x, this.y, this.radius*2, this.radius*2);
    stroke(255);
    line(this.x, this.y, nx, ny);
  }
}
