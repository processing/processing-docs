PFont font;
String quote = "That’s one small step for man...";

void setup() {
  size(480, 120);
  font = createFont("SourceCodePro-Regular.ttf", 24);
  textFont(font);
}

void draw() {
  background(102);
  text(quote, 26, 24, 240, 100);
}
