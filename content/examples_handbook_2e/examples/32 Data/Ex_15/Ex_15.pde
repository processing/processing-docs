XML cambridge;  // Data for Cambridge, MA

int[] lows = new int[0];
int[] highs = new int[0];

void setup() {
  size(700, 100);
  cambridge = loadXML("cambridge.xml");
  lows = getData(cambridge, "minimum");
  highs = getData(cambridge, "maximum");
}

void draw() {
  background(204);
  // Shape defined by daily highs and lows
  noStroke();
  fill(0);
  beginShape(QUAD_STRIP);
  for (int i = 0; i < lows.length; i++) {
    float x = map(i, 0, lows.length-1, 0, width);
    vertex(x, height-lows[i]);
    vertex(x, height-highs[i]*2);
  }
  endShape();
  // Lines for temperatures, 0 (bottom) to 50 (top)
  stroke(255, 153);
  for (int y = height-1; y > 0; y -= 10) {
    line(0, y, width, y);
  } 
}

int[] getData(XML city, String minOrMax) {
  int[] values = new int[0];
  for (XML temps : city.getChildren("temperature")) {
    String type = temps.getString("type");
    if (type.equals(minOrMax)) {
      for (XML val : temps.getChildren("value")) {
        int t = int(val.getContent());
        values = append(values, t);
      }
    }
  } 
  return values;
}
