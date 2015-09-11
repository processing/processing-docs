import processing.pdf.*;
PShape bot;

void setup() {
  size(600, 800, PDF, "Ex-13-5.pdf");
  bot = loadShape("robot1.svg");
}

void draw() {
  background(0, 153, 204);
  for (int i = 0; i < 100; i++) {
    float rx = random(-bot.width, width);
    float ry = random(-bot.height, height);
    shape(bot, rx, ry);
  }
  exit();
}