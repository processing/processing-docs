Table robots;
PShape bot1;
PShape bot2;
PShape bot3;

void setup() {
  size(720, 480);
  background(0, 153, 204);
  bot1 = loadShape("robot1.svg");
  bot2 = loadShape("robot2.svg");
  bot3 = loadShape("robot3.svg");
  shapeMode(CENTER);
  robots = loadTable("botArmy.tsv", "header");
  for (int i = 0; i < robots.getRowCount(); i++) {
    int bot = robots.getInt(i, "type");
    int x = robots.getInt(i, "x");
    int y = robots.getInt(i, "y");
    float sc = 0.3;
    if (bot == 1) {
      shape(bot1, x, y, bot1.width*sc, bot1.height*sc);
    } else if (bot == 2) {
      shape(bot2, x, y, bot2.width*sc, bot2.height*sc);
    } else {
      shape(bot3, x, y, bot3.width*sc, bot3.height*sc);
    }
  }
}