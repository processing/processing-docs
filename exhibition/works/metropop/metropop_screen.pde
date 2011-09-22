
//
// Tom Carden, May 2004, revised May 2005.
// a simple particle system with naive gravitational attraction
//

int NUM_PARTICLES  = 10000;
int NUM_ATTRACTORS = 6;

Particle[] particle;
Attractor[] attractor;

void setup() {
  
  size(708,400,P3D);

  attractor = new Attractor[NUM_ATTRACTORS];
  particle = new Particle[NUM_PARTICLES];
  
  scatter();
  
  // a favourite... (comment these out if you change NUM_ATTRACTORS)
  attractor[0] = new Attractor(199.51851,109.791565);
  attractor[1] = new Attractor(142.45416,273.7996);
  attractor[2] = new Attractor(81.76278,28.523111);
  attractor[3] = new Attractor(167.28207,196.15504);
  attractor[4] = new Attractor(517.4808,312.41132);
  attractor[5] = new Attractor(564.9883,7.6203823);

}

void draw() {
    
  // move and draw particles
  stroke(0,4); // use lower alpha for finer detail
  
  beginShape(POINTS);
  for (int i = 0; i < particle.length; i++) {
    particle[i].step();
    vertex(particle[i].x,particle[i].y);
  }
  endShape();
  
  // reset on mouse click
  if (mousePressed) {
    scatter();
  }

}

void scatter() {

  // clear the preview
  background(255);

  // randomise attractors
  for (int i = 0; i < attractor.length; i++) {
    attractor[i] = new Attractor();
    println("attractor["+i+"] = new Attractor("+attractor[i].x+","+attractor[i].y+");"); // so you *can* get your favourite one back, if you want!
  }
  println();
  
  // randomise particles
  for (int i = 0; i < particle.length; i++) {
    particle[i] = new Particle();
  }
  
}

