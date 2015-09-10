// Requires the Radio class 

int numButtons = 7;
Radio[] buttons = new Radio[numButtons];

void setup() {
  size(100, 100);
  for (int i = 0; i < buttons.length; i++) {
    int x = 14 + i*12;
    buttons[i] = new Radio(x, 50, 10, color(255), color(0), i, buttons);
  }
}

void draw() {
  background(204);
  for (Radio r : buttons) {
    r.display();
  }
}

void mousePressed() {
  for (Radio r : buttons) {
    r.press(mouseX, mouseY);
  }
}
