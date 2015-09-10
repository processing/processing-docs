Table xy;
int index = 0;

void setup() {
  size(100, 100);
  xy = loadTable("positions.txt", "tsv");
  noSmooth();
  frameRate(12);
}

void draw() {
  if (index < xy.getRowCount()) {
    int x = xy.getInt(index, 0);
    int y = xy.getInt(index, 1);
    point(x, y);
    // Go to the next line for the next run through draw()
    index++;
  }
}
