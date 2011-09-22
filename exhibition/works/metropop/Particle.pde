
// a point in space with a velocity
// moves according to acceleration and damping parameters
// in this case, it moves very fast so the process is basically "scattering"

// changing these parameters can give very different results
float damp = 0.00002; // remember a very small amount of the last direction
float accel = 4000.0; // move very quickly

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
  
  void step() {
  
    // move towards every attractor 
    // at a speed inversely proportional to distance squared
    // (much slower when further away, very fast when close)
    
    for (int i = 0; i < attractor.length; i++) {
      
      // calculate the square of the distance 
      // from this particle to the current attractor
      float d2 = sq(attractor[i].x-x) + sq(attractor[i].y-y);

      if (d2 > 0.1) { // make sure we don't divide by zero
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
