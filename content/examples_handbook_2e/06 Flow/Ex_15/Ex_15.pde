float x = 0.0;

void setup() {
  size(100, 100); 
}

void draw() {
  background(204);
  if (x < 40) {
    // If x is less than 40, draw a small circle
    ellipse(50, 50, 20, 20);
  } else if (x < 80) { 
    // If the previous test was false and x is 
    // also less than 80, draw a large circle   
    ellipse(50, 50, 60, 60);
  } else {
    // If neither test was true, x is larger than 
    // or equal to 80, so draw a rectangle 
    rect(20, 20, 60, 60);
  }
  line(x, 0, x, 100);
  x += 0.25;
}
