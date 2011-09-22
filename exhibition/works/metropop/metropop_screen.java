import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class metropop_screen extends PApplet {
//
// Tom Carden, May 2004, revised May 2005.
// a simple particle system with naive gravitational attraction
//

int NUM_PARTICLES  = 10000;
int NUM_ATTRACTORS = 6;

Particle[] particle;
Attractor[] attractor;

public void setup() {
  
  size(708,400,P3D);

  attractor = new Attractor[NUM_ATTRACTORS];
  particle = new Particle[NUM_PARTICLES];
  
  scatter();
  
  // a favourite... (comment these out if you change NUM_ATTRACTORS)
  attractor[0] = new Attractor(199.51851f,109.791565f);
  attractor[1] = new Attractor(142.45416f,273.7996f);
  attractor[2] = new Attractor(81.76278f,28.523111f);
  attractor[3] = new Attractor(167.28207f,196.15504f);
  attractor[4] = new Attractor(517.4808f,312.41132f);
  attractor[5] = new Attractor(564.9883f,7.6203823f);

}

public void draw() {
    
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

public void scatter() {

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



// this is basically just a random point

class Attractor {
  float x,y;
  Attractor(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Attractor() {
    x = random(width);
    y = random(height);
  }
}


// a point in space with a velocity
// moves according to acceleration and damping parameters
// in this case, it moves very fast so the process is basically "scattering"

// changing these parameters can give very different results
float damp = 0.00002f; // remember a very small amount of the last direction
float accel = 4000.0f; // move very quickly

class Particle {

  // location and velocity
  float x,y,vx,vy;
  
  Particle() {
  
    // initialise with random velocity:
    x = random(width);
    y = random(height);
    
    // initialise with random velocity:
    vx = random(-accel/2,accel/2);
    vy = random(-accel/2,accel/2);
    
  }
  
  public void step() {
  
    // move towards every attractor 
    // at a speed inversely proportional to distance squared
    // (much slower when further away, very fast when close)
    
    for (int i = 0; i < attractor.length; i++) {
      
      // calculate the square of the distance 
      // from this particle to the current attractor
      float d2 = sq(attractor[i].x-x) + sq(attractor[i].y-y);

      if (d2 > 0.1f) { // make sure we don't divide by zero
        // accelerate towards each attractor
        vx += accel * (attractor[i].x-x) / d2;
        vy += accel * (attractor[i].y-y) / d2;
      }
      
    }
    
    // move by the velocity
    x += vx;
    y += vy;
    
    // scale the velocity back for the next frame
    vx *= damp;
    vy *= damp;
    
  }
   
}
}