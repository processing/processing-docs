PFont zigBlack;

void setup() {
  size(100, 100);
  zigBlack = loadFont("Ziggurat-Black-32.vlw");
  textFont(zigBlack);
  fill(0);
}

void draw() {
  background(204);
  text("LAX", 0, 40);
  text("LHR", 0, 70);
  text("TGL", 0, 100);
}
