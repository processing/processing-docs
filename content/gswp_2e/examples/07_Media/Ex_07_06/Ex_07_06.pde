PFont font;

void setup() {
  size(480, 120);
  font = createFont("SourceCodePro-Regular.ttf", 32);
  textFont(font);
}

void draw() {
  background(102);
  textSize(32);
  text("That’s one small step for man...", 25, 60);
  textSize(16);
  text("That’s one small step for man...", 27, 90);
}