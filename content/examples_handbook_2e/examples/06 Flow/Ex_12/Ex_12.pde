float x = 0;

void setup() {
  size(100, 100); 
}

void draw() {
  background(204);
  if (x < 20) {               // If x is less than 40,
    ellipse(50, 50, 60, 60);  // draw the ellipse 
  }
  if (x > 80) {               // If x is greater than 60
    rect(20, 20, 60, 60);     // draw this rectangle
  }
  line(x, 0, x, 100);
  x += 0.25;
}
