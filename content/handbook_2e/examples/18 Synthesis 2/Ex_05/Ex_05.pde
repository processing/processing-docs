// Master variables
int mode = 1;  // Current room
int w = 40;  // Wall thickness
int tx = 620;  // Text x-coordinate
int ty = 420;  // Text y-coordinate
boolean gate = true;  // Is the gate closed or open?
PImage scribbles;  // Background image
PFont heroFont;  // Font for the project

// Hero variables
PImage hero;  // Hero image
int x = 440;  // Hero x-coordinate
int y = 240;  // Hero y-coordinate
int r = 110;  // Hero radius
float speed = 2;  // Hero speed

// Room 1 variables
int gx = 220;  // Gate x-coordinate
int dx = 75;  // Dagger x-coordinate
int dy = 120;  // Dagger y-coordinate
PImage dagger;  // Dagger image

// Room 2 variables
int kx = 390;  // Key x-coordinate
int ky = 180;  // Key y-coordinate
PImage gateKey; // Key image

void setup() {
  size(640, 480);
  noCursor();
  textAlign(RIGHT);
  hero = loadImage("figure.png");
  scribbles = loadImage("background.png");
  heroFont = createFont("SourceCodePro-Bold", 16);
  gateKey = loadImage("key.png");
  dagger = loadImage("dagger.png");
  textFont(heroFont);
}

void draw() {

  if (mode == 1) {  // ROOM 1

    // Walls
    imageMode(CORNER);
    image(scribbles, 0, 0);

    // Gate
    if (gate == true) {
      noStroke();
      fill(0);
      rect(gx, w, w, height-w*2);
      fill(0);
      text("Use the arrow keys to explore", tx, ty);
    } else {
      text("Edit the code to grab the dagger", tx, ty);
    }

    // Dagger
    image(dagger, dx, dy);

    // Stop the hero from walking through walls
    if (gate == true) {
      if (x < gx+r+5) {  // Check gate
        x = gx+r+5;
      }
    } else {
      if (x < w+r) {  // Check left wall
        x = w+r;
      }
    }
    if (y > height-w-r) {  // Check bottom wall
      y =  height-w-r;
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
    imageMode(CORNER);
    image(scribbles, -width, 0);

    // Key
    if (gate == true) {
      image(gateKey, kx, ky);
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
    if (x > kx && x < kx+gateKey.width && y > ky && y < ky+gateKey.height) {
      gate = false;
    }

    // Stop the hero from walking through walls
    if (x > width-w-r) {  // Check right wall
      x = width-w-r;
    }
    if (y > height-w-r) {  // Check bottom wall
      y =  height-w-r;
    }
    if (y < w+r) {  // Check top wall
      y = w+r;
    }

    // Move to room 1
    if (x < -r) {
      mode = 1;
      x = width-r;
    }
  }

  // Draw hero
  imageMode(CENTER);
  image(hero, x, y);

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
