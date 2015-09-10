// Requires the Check class

int numChecks = 25;
Check[] checks = new Check[numChecks];

void setup() {
  size(100, 100);
  int x = 14;
  int y = 14;
  for (int i = 0; i < checks.length; i++) {
    checks[i] = new Check(x, y, 12, color(0));
    x += 15;
    if (x > 80) {
      x = 14;
      y += 15;
    }
  }
}

void draw() {
  background(0);
  for (Check ch : checks) {
    ch.display();
  }
}

void mousePressed() {
  for (Check ch : checks) {
    ch.press(mouseX, mouseY);
  } 
}
