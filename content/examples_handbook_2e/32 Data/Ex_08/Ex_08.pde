String[] lines;
int index = 0;

void setup() {
  size(100, 100);
  lines = loadStrings("positions.txt");
  noSmooth();
  frameRate(12);
}

void draw() {
  if (index < lines.length) {
    String[] pieces = split(lines[index], '\t');
    if (pieces.length == 2) {
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      point(x, y);
    }
    // Go to the next line for the next run through draw()
    index++;
  }
}
