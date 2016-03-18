/**
 * Multiple Particle Systems
 * by Daniel Shiffman.
 *
 * Click the mouse to generate a burst of particles
 * at mouse location.
 *
 * Each burst is one instance of a particle system
 * with Particles and CrazyParticles (a subclass of Particle)
 * Note use of Inheritance and Polymorphism here.
 */

var systems = [];

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() {
  background(51);
  for(var i = 0; i < systems.length; i++){
    systems[i].addParticle();
    systems[i].run();
  }
  if (systems.length === 0) {
    fill(255);
    noStroke();
    textAlign(CENTER);
    text("click mouse to add particle systems", width/2, height/2);
  }
}

function mousePressed() {
  systems.push(new ParticleSystem(1, createVector(mouseX, mouseY)));
}
