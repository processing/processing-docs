PShape land;

void setup() {
  size(100, 100);
  land = loadShape("antarctica.svg");
  shapeMode(CENTER);
}

void draw() {
  background(204);
  translate(width/2, height/2);
  float scalar = map(mouseX, 0, width, 0.1, 2.5);
  scale(scalar);
  shape(land, 0, 0); 
}
