PFont zigBlack;

void setup() {
  size(100, 100);
  zigBlack = loadFont("Ziggurat-Black-12.vlw");
  textFont(zigBlack);
  fill(0);
}

void draw() {
  background(204);
  textSize(12);
  text("A", 20, 20);
  textSize(96);
  text("A", 20, 90);
}

