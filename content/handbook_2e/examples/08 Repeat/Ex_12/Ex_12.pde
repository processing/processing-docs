void setup() {
  size(100, 100);
}

void draw() {
  int x = 0; 
  while (x < width) {
    line(x, 20, x, 80);
    x += 2;
  } 
}
