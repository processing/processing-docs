PImage trees, treesCrop;

void setup() {
  trees = loadImage("topanga.jpg");
  stroke(255);
  strokeWeight(12);
}

void draw() {
  image(trees, 0, 0);
  line(0, 0, width, height); 
  line(0, height, width, 0);
  treesCrop = trees.get(20, 20, 60, 60); 
  image(treesCrop, 20, 20);
}
