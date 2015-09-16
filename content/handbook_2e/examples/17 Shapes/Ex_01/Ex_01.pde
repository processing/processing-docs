
PShape land;

void setup() {
  size(100, 100);
  land = loadShape("antarctica.svg");
}

void draw() {
  background(204);
  shape(land, 10, 10); 
}
