PFont sourceLight;

void setup() {
  size(100, 100);
  sourceLight = createFont("SourceCodePro-Light.otf", 34);
  textFont(sourceLight);
  fill(0);
}

void draw() {
  background(204);
  text("LAX", 0, 40);
  text("LHR", 0, 70);
  text("TXL", 0, 100);
}

