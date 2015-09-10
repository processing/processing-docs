int mode = 1;
int lastMode = 3;

void setup() {
  size(600, 600);
}

void draw() {
  background(204);
  if (mode == 1) {
    // Based on code TC
    fill(0);
    noStroke();
    ellipse(210, 0, 720, 720);
    ellipse(228, 377, 36, 36);
    ellipse(240, 605, 420, 420); 
  } else if (mode == 2) {
    // Based on code TC
    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(60, 60, 300, 300);
    noFill();
    rect(120, 120, 360, 360);
    rect(180, 180, 360, 360);
  } else {
    // Based on code TC
    stroke(0);
    strokeWeight(10);
    for (int y = 120; y < 480; y += 30) {
      line(120, y, 480, y + 90); 
    }
  }
}

void mousePressed() {
  mode++;
  if (mode > lastMode) {
    mode = 1; 
  }
}
