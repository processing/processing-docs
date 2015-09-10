PFont font;
int opacity = 0;
int direction = 1;

void setup() {
  size(100, 100);
  font = createFont("SourceCodePro-Light.otf", 24);
  textFont(font);
}

void draw() {
  background(204);
  opacity += 2 * direction;
  if ((opacity < 0) || (opacity > 255)) {
    direction = -direction;
  }
  fill(0, opacity);
  text("FADE", 4, 60);
}
