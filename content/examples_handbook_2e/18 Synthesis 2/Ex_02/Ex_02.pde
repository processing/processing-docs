// Master variables
int w = 40;  // Wall thickness
int tx = 620;  // Text x-coordinate
int ty = 420;  // Text y-coordinate
boolean gate = true;  // Is the gate closed or open?

// Room 1 variables
int gx = 260;  // Gate x-coordinate
int dx = 150;  // Dagger x-coordinate
int dy = 210;  // Dagger y-coordinate

void setup() {
  size(640, 480);
  ellipseMode(RADIUS);
  noCursor();
  textSize(14);
  textAlign(RIGHT);
}

void draw() {

  // Walls
  background(255);
  noStroke();
  fill(0);
  rect(0, 0, width, w);  // Top
  rect(0, 0, w, height);  // Left
  rect(0, height-w, width, w);  // Bottom

  // Gate
  fill(0);
  if (gate == true) {
    for (int y = w; y <= height-w; y += 20) {
      ellipse(gx, y, 5, 5);
    }
    text("Use the arrow keys to explore", tx, ty);
  }

  // Dagger
  fill(102);
  triangle(dx, dy, dx+5, dy-10, dx+10, dy);
  rect(dx, dy, 10, 70);
  rect(dx-10, dy+45, 30, 10);
}
