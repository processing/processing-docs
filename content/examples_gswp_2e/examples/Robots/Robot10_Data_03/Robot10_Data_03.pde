int numRobotTypes = 3;
PShape[] shapes = new PShape[numRobotTypes];
float scalar = 0.3;

void setup() {
  size(720, 480);
  background(0, 153, 204);
  for (int i = 0; i < numRobotTypes; i++) {
    shapes[i] = loadShape("robot" + (i+1) + ".svg");
  }
  shapeMode(CENTER);
  Table botArmy = loadTable("botArmy.tsv", "header");
  for (TableRow row : botArmy.rows()) {
    int robotType = row.getInt("type");
    int x = row.getInt("x");
    int y = row.getInt("y");
    PShape bot = shapes[robotType - 1];
    shape(bot, x, y, bot.width*scalar, bot.height*scalar);
  }
}