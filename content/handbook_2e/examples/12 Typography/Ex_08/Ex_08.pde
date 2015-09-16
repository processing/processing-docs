PFont zigBlack;

void setup() {
  size(100, 100);
  zigBlack = createFont("Ziggurat-Black", 32);
  textFont(zigBlack);
  fill(0);
}

void draw() {
  background(204);
  text("LAX", 0, 40);
  text("LHR", 0, 70);
  text("TXL", 0, 100);
}

