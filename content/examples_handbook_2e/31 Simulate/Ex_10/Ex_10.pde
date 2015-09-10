// Requires Particle and LimitedParticle classes

int num = 80;
LimitedParticle[] p = new LimitedParticle[num];
float radius = 1.2;

void setup() {
  size(100, 100);
  noStroke();
  for (int i = 0; i < p.length; i++) {
    float velX = random(-2, 2);
    float velY = -i;
    // Inputs: x, y, x-velocity, y-velocity, radius
    p[i] = new LimitedParticle(width/2, height/2, 
                               velX, velY, 2.2);
  }
}

void draw() {
  fill(0, 24);
  rect(0, 0, width, height);
  fill(255);
  for (LimitedParticle part : p) {
    part.update();
    part.display(); 
  }
}


