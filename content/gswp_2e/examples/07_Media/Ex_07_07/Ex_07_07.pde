PFont font;

void setup() {
  size(480, 120);
  font = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(font);
}

void draw() {
  background(102);
  text("That’s one small step for man...", 26, 24, 240, 100);
}