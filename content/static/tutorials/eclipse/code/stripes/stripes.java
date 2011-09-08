import processing.core.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; public class stripes extends PApplet {// Daniel Shiffman
// Book 2006
// Simple while loop with interactivity

public void setup() {
  size(255,255);
  background(0);
}

public void draw() {
  background(0);
  // start with i as 0
  int i = 0;
  // while i is less than the width of the window
  while (i < width) {
    noStroke();
    // calculate the absolute value of the 
    // distance between i and the mouse
    float distance = abs(mouseX - i);  
    // use the distance for the fill color
    fill(distance);
    // display a rectangle at x location i
    rect(i,0,10,height);
    // increase i by 10
    i += 10;
  }
}
static public void main(String args[]) {   PApplet.main(new String[] { "stripes" });}}