PrintWriter output;

void setup() {
  size(720, 480);
  // Create the new file
  output = createWriter("botArmy.tsv");
  // Write a header line with the column titles
  output.println("type\tx\ty");
  for (int y = 0; y <= height; y += 120) {
    for (int x = 0; x <= width; x += 60) {
      int robotType = int(random(1, 4));
      output.println(robotType + "\t" + x + "\t" + y);
      ellipse(x, y, 12, 12);
    }
  }
  output.flush(); // Write the remaining data to the file
  output.close(); // Finish the file
}