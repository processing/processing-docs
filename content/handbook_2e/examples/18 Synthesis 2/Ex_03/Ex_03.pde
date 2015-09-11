// Master variables
int w = 40;  // Wall thickness
int tx = 620;  // Text x-coordinate
int ty = 420;  // Text y-coordinate
boolean gate = true;  // Is the gate closed or open?

// Room 2 variables
int kx = 440;  // Key x-coordinate
int ky = 230;  // Key y-coordinate

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
  rect(width-w, 0, w, height);  // Right
  rect(0, height-w, width, w);  // Bottom

  // Key
  if (gate == true) {
    fill(102);
    pushMatrix();
    translate(kx, ky);
    beginShape();
    vertex(0, 10);
    vertex(50, 10);
    vertex(50, 0);
    vertex(80, 0);
    vertex(80, 30);
    vertex(50, 30);
    vertex(50, 20);
    vertex(30, 20);
    vertex(30, 30);
    vertex(20, 30);
    vertex(20, 20);
    vertex(10, 20);
    vertex(10, 30);
    vertex(0, 30);
    endShape();
    popMatrix();
  }

  // Text
  fill(0);
  if (gate) {
    text("Grab the key to open the gate", tx-w, ty);
  } 
  else {
    text("You have the key. The gate is open!", tx-w, ty);
  }
  
}
