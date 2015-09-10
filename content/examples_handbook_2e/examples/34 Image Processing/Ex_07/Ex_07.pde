PImage trees;

void setup() {
  size(100, 100);
  trees = loadImage("topangaCrop.jpg");
}

void draw() {
  image(trees, 0, 0); 
  int y = constrain(mouseY, 0, 99);
  for (int x = 0; x < 50; x++) {
    color c = get(x, y);
    stroke(c);
    line(x+50, 0, x+50, 100);
  }
  stroke(255);
  line(0, y, 49, y);
}
