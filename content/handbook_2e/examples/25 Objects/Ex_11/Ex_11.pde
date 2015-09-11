Ring r;

void setup() {
  size(100, 100); 
  r = new Ring();
}

void draw() {
  background(0);
  r.grow();
  r.display();
}

void mousePressed() {
  r.start(mouseX, mouseY);
}


class Ring {
  float x, y;          // X-coordinate, y-coordinate
  float diameter;      // Diameter of the ring
  boolean on = false;  // Turns the display on and off

  void start(float xpos, float ypos) {
    x = xpos;
    y = ypos; 

    diameter = 1;
    on = true;
  }
  
  void grow() {
    if (on == true) {
      diameter += 0.5;
      if (diameter > 400) {
        on = false;
        diameter = 1;
      }
    }
  }

  void display() {
    if (on == true) {
      noFill();
      strokeWeight(4);
      stroke(204, 153);
      ellipse(x, y, diameter, diameter);
    }
  }
}
