/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

var flock;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  flock = new Flock();
  // Add an initial set of boids into the system
  for (var i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

function draw() {
  background(50);
  flock.run();
}

// Add a new boid into the System
function mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

