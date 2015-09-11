XML cambridge;  // Data for Cambridge, MA

int[] lows = new int[0];
int[] highs = new int[0];

void setup() {
  cambridge = loadXML("cambridge.xml");
  for (XML temps : cambridge.getChildren("temperature")) {
    String type = temps.getString("type");
    if (type.equals("maximum")) {
      for (XML val : temps.getChildren("value")) {
        int t = int(val.getContent());
        highs = append(highs, t);
      }
    } 
    else {
      for (XML val : temps.getChildren("value")) {
        int t = int(val.getContent());
        lows = append(lows, t);
      }
    }
  }
  printArray(lows);
  printArray(highs);
}

