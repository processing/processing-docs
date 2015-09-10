float x = 0;

void setup() {
  size(100, 100); 
}

void draw() {
  background(204);
  if (x < 20) {               // If x is less than 20,
    ellipse(50, 50, 60, 60);  // draw this ellipse, 
  } else {                    // else if x is not less,
    rect(20, 20, 60, 60);     // draw this rectangle
  }
  line(x, 0, x, 100);
  x += 0.25;
}
