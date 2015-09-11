PFont sourceLight, zigBlack;

void setup() {
  size(100, 100);
  zigBlack = createFont("Ziggurat-Black", 24);
  sourceLight = createFont("SourceCodePro-Light.otf", 34);
  fill(0);
}

void draw() {
  background(204);
  textFont(zigBlack);
  text("LAX", 0, 40);
  textFont(sourceLight);
  text("LHR", 0, 70);
  textFont(zigBlack);
  text("TXL", 0, 100);
}

