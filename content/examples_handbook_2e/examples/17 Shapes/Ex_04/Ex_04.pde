PShape land;

void setup() {
  size(100, 100);
  land = loadShape("antarctica.svg");
}

void draw() {
  background(204);
  float scalar = 0.36;
  shape(land, 8, 14, land.width*scalar, land.height*scalar); 
}
