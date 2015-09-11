PFont font;

void setup() {
  size(100, 100);
  font = createFont("mono", 16);
  textFont(font);
  textAlign(CENTER);
}

void draw() {
  background(0);
  int s = second();
  int m = minute();
  int h = hour();
  // The nf() function spaces the numbers nicely
  String t = nf(h,2) + ":" + nf(m,2) + ":" + nf(s,2);
  text(t, 50, 55);
}
