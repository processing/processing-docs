PImage img;

void setup() {
  size(100, 100);                
  img = loadImage("sample.png");
  stroke(255);
}

void draw() {
  image(img, 0, 0);
  color c = get(mouseX, mouseY);
  float r = red(c);      // Extract red
  float g = green(c);    // Extract green
  float b = blue(c);     // Extract blue
  fill(r, 0, 0);         
  rect(32, 20, 12, 60);  // Red component
  fill(0, g, 0);         
  rect(44, 20, 12, 60);  // Green component
  fill(0, 0, b);         
  rect(56, 20, 12, 60);  // Blue component
}

