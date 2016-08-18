// Gravitational Attraction (3D) 
// Daniel Shiffman <http://www.shiffman.net>

// A class for an attractive body in our world

class Sun {
  float mass;         // Mass, tied to size
  PVector position;   // position
  float G;            // Universal gravitational constant (arbitrary value)

  Sun() {
    position = new PVector(0, 0);
    mass = 20;
    G = 0.4;
  }


  PVector attract(Planet m) {
    PVector force = PVector.sub(position, m.position);    // Calculate direction of force
    float d = force.mag();                               // Distance between objects
    d = constrain(d, 5.0, 25.0);                           // Limiting the distance to eliminate "extreme" results for very close or very far objects
    float strength = (G * mass * m.mass) / (d * d);      // Calculate gravitional force magnitude
    force.setMag(strength);                              // Get force vector --> magnitude * direction
    return force;
  }

  // Draw Sun
  void display() {
    stroke(255);
    noFill();
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(mass*2);
    popMatrix();
  }
}