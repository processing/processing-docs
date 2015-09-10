PShape land;

void setup() {
  size(100, 100);
  land = loadShape("antarctica.svg");
  noStroke();
}

void draw() {
  background(204);
  land.disableStyle();
  fill(255);
  shape(land, -20, 0); 
  fill(102);
  shape(land, 15, 0); 
  land.enableStyle();
  shape(land, 50, 0); 
}
