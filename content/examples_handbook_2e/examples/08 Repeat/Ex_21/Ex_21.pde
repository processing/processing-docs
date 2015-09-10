background(255);
rectMode(CENTER);
for (int y = 9; y < height; y += 20) {
  for (int x = 9; x < width; x += 20) {
    for (int d = 18; d > 0; d -= 4) {
      rect(x, y, d, d);
    }
  }
}
