PGraphics tile;

void setup() {
  size(600, 100);
  tile = createGraphics(50, 50);
  background(0);
}

void draw() {
  runTile();
  for (int y = 0; y < height; y += tile.height) {
    for (int x = 0; x < width; x += tile.width) {
      image(tile, x, y);
    }
  }
}

void runTile() {
  float x = random(20, tile.width-20);
  float y = random(20, tile.height-20);
  tile.beginDraw();
  tile.noStroke();
  tile.fill(0, 20);
  tile.rect(0, 0, tile.width, tile.height);
  tile.fill(255);
  tile.ellipse(x, y, 10, 10);
  tile.endDraw();
}
