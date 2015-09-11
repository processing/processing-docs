PImage trees;

void setup() {
  size(100, 100);
  trees = loadImage("topangaCrop.jpg");
}

void draw() {
  background(0);
  color white = color(255);
  trees.set(0, 50, white);
  trees.set(1, 50, white);
  trees.set(2, 50, white);
  trees.set(3, 50, white);
  image(trees, 20, 0);
}
