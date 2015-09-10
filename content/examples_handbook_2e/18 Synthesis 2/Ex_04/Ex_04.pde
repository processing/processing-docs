// Master variables
int mode = 1;  // Current room
int w = 40;  // Wall thickness
int tx = 620;  // Text x-coordinate
int ty = 420;  // Text y-coordinate
boolean gate = true;  // Is the gate closed or open?

// Hero variables
int x = 400;  // Hero x-coordinate
int y = 240;  // Hero y-coordinate
int r = 40;  // Hero radius
float speed = 2.0;  // Hero speed

// Room 1 variables
int gx = 260;  // Gate x-coordinate
int dx = 150;  // Dagger x-coordinate
int dy = 210;  // Dagger y-coordinate

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

  if (mode == 1) {  // ROOM 1

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
    } else {
      text("Edit the code to grab the dagger", tx, ty);
    }

    // Dagger
    fill(102);
    triangle(dx, dy, dx+5, dy-10, dx+10, dy);
    rect(dx, dy, 10, 70);
    rect(dx-10, dy+45, 30, 10);

    // Stop the hero from walking through walls
    if (gate == true) {
      if (x < gx+r+5) {  // Check gate
        x = gx+r+5;
      }
    } 
    else {
      if (x < w+r) {  // Check left wall
        x = w+r;
      }
    }
    if (y > height-w-r) {  // Check bottom wall
      y = height-w-r;
    }
    if (y < w+r) {  // Check top wall
      y = w+r;
    }

    // Move to room 2
    if (x > width+r) {
      mode = 2; 
      x = r;
    }
    
  } else {  // ROOM 2

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
    if (gate == true) {
      text("Grab the key to open the gate", tx-w, ty);
    } 
    else {
      text("You have the key. The gate is open!", tx-w, ty);
    }

    // Check if hero is on top of the key
    if (x > kx && x < kx+80 && y > ky && y < ky+30) {
      gate = false;
    }

    // Stop the hero from walking through walls
    if (x < -r) {
      mode = 1;
      x = width-r;
    }
    if (x > width-w-r) {  // Check right wall
      x = width-w-r;
    }
    if (y > height-w-r) {  // Check bottom wall
      y = height-w-r;
    }
    if (y < w+r) {  // Check top wall
      y = w+r;
    }
    // Move to room 2
    if (x > width+r) {
      mode = 2; 
      x = r;
    }
  }

  // Draw hero
  fill(126);
  ellipse(x, y, r, r);

  // Move hero with arrow keys
  if (keyPressed && key == CODED) {
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
