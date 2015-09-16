int mode = 0;
int nextTime = 0;
int timer = 1000;

void setup() {
  size(100, 100); 
  nextTime = millis() + timer;
  noFill();
  stroke(255);
}

void draw() {
  background(0);
  if (mode == 0) {
    line(10, 10, 90, 90);
  } else if (mode == 1) {
    ellipse(50, 50, 80, 80);
  } else if (mode == 2) {
    rect(10, 10, 80, 80);
  }
  
  if (millis() > nextTime) {
    mode++;
    if (mode > 2) {
      mode = 0;
    } 
    nextTime = millis() + timer;
  }
}
