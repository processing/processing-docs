class LimitedParticle extends Particle {
  float friction = 0.99;
  
  LimitedParticle(int xpos, int ypos, float velx, float vely, float r) {
    super(xpos, ypos, velx, vely, r);
  }
  
  void update() {
    vx *= friction;
    vy *= friction;
    super.update();
    limit();
  }
  
  void limit() {
    if ((x < radius) || (x > width-radius)) {
      vx = -vx;
      x = constrain(x, radius, width-radius);
    }
    if (y > height-radius) {
      vy = -vy;
      y = height-radius; 
    }
  } 
}
