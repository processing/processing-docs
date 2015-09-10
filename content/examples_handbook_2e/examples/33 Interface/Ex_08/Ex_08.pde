class DragButton extends Button {
  int xoff, yoff;
  
  DragButton(int xp, int yp, int s, color b, color o, color p) {
    super(xp, yp, s, b, o, p); 
  }

  boolean press() {
    xoff = mouseX - x;  // Store x-offset from shape origin
    yoff = mouseY - y;  // Store y-offset from shape origin
    return super.press();
  }

  void drag() {
    if (pressed == true) {
      x = mouseX - xoff;  // Apply x-offset
      y = mouseY - yoff;  // Apply y-offset
    }
  }
}
