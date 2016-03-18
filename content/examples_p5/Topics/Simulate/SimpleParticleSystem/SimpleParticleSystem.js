/**
 * Simple Particle System
 * by Daniel Shiffman.  
 * 
 * Particles are generated each cycle through draw(),
 * fall with gravity and fade out over time
 * A ParticleSystem object manages a variable size (ArrayList) 
 * list of particles. 
 */
 
var ps;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  ps = new ParticleSystem(createVector(width/2,50));
}

function draw() {
  background(0);
  ps.addParticle();
  ps.run();
}


