class Scrollbar {
  int x, y;              // The x- and y-coordinates
  float sw, sh;          // Width and height of scrollbar
  float pos;             // Position of thumb
  float posMin, posMax;  // Min and max values of thumb
  boolean rollover;      // True when the mouse is over 
  boolean locked;        // True when its the active scrollbar 
  float minVal, maxVal;  // Min and max values for the thumb

  Scrollbar (int xp, int yp, int w, int h, float miv, float mav) {
    x = xp;
    y = yp;
    sw = w;
    sh = h;
    minVal = miv;
    maxVal = mav;
    pos = x + sw/2 - sh/2;  // Move thumb to middle
    posMin = x;
    posMax = x + sw - sh;
  }

  // Update the boolean value over and the position of the thumb
  void update(int mx, int my) {
    if (over(mx, my) == true) {
      rollover = true;
    } else {
      rollover = false;
    }
    if (locked == true) {
      pos = constrain(mx-sh/2, posMin, posMax);
    }
  }
  
  // Lock the thumb so the mouse can move off and still update
  void press(int mx, int my) {
    if (rollover == true) {
      locked = true;
    } else {
      locked = false;
    }
  }
 
  // Reset the scrollbar to neutral
  void release() {
    locked = false;
  }

  // Return true if the cursor is over the scrollbar 
  boolean over(int mx, int my) {
    if ((mx > x) && (mx < x+sw) && (my > y) && (my < y+sh)) {
      return true;
    } else {
      return false;
    }
  }

  // Draw the scrollbar to the screen
  void display() {
    fill(255);
    rect(x, y, sw, sh);  // Draw bar
    if ((rollover == true) || (locked == true)) {
      fill(0);
    } else {
      fill(102);
    }
    rect(pos, y, sh, sh);  // Draw thumb
  }

  // Return the current value of the thumb
  float getPos() {
    float scalar = sw/(sw-sh);
    float ratio = ((pos - x) * scalar) / sw;
    float thumbPos = minVal + (ratio * (maxVal-minVal));
    return thumbPos;
  }
}
