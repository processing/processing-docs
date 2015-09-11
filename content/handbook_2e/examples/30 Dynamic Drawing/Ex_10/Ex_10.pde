PShape map;

void setup() {
  size(100, 100);
  map = loadShape("antarctica.svg");
  map.disableStyle();
  stroke(255, 10);
  noFill();
  background(0);
  shapeMode(CENTER);
} 

void draw() { 
  shape(map, mouseX, mouseY);
} 
