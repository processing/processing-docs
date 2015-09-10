int x = 320;  // Hero x-coordinate
int y = 240;  // Hero y-coordinate
int r = 40;  // Hero radius
float speed = 2.0;  // Hero speed

void setup() {
  size(640, 480);
  ellipseMode(RADIUS);
  noCursor();
}

void draw() {
  background(204);
  
  // Draw hero
  noStroke();
  fill(126);
  ellipse(x, y, r, r);
  
  // Move hero with arrow keys
  if ((keyPressed == true) && (key == CODED)) {
    if (keyCode == UP) { 
      y -= speed;
    } else if (keyCode == DOWN) { 
      y += speed;
    } else if (keyCode == LEFT) { 
      x -= speed;
    } else if (keyCode == RIGHT) {
      x += speed;
    }
  }
}
