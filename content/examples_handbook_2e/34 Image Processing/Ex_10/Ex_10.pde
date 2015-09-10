for (int x = 0; x < 55; x++) {
  for (int y = 0; y < 55; y++) {
    color c = color((x+y) * 1.8);
    set(30+x, 20+y, c);
  }
}
