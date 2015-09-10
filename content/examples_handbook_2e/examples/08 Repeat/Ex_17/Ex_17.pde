fill(0);
noStroke();
for (int y = -10; y <= 100; y += 10) {
  for (int x = -40; x <= 100; x += 10) {
    ellipse(x + y/3.0, y + x/8.0, 4, 7);
  }
}
