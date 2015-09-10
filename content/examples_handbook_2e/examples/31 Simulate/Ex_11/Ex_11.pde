class ArrowParticle extends Particle {  
  float angle = 0.0;  
  float shaftLength = 20.0;
  
  ArrowParticle(int xpos, int ypos, float velx, float vely, float r) {
    super(xpos, ypos, velx, vely, r);
  }
  
  void update() {
    super.update();
    angle = atan2(vy, vx);
  }

  void display() {
    stroke(255);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    scale(shaftLength);           
    strokeWeight(1.0 / shaftLength);
    line(0, 0, 1, 0);
    line(1, 0, 0.7, -0.3);
    line(1, 0, 0.7, 0.3);
    popMatrix();
  }
}
