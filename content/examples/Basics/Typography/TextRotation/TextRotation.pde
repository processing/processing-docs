/**
 * Text Rotation. 
 * 
 * Draws letters to the screen and rotates them at different angles.
 */

PFont f;
float angleRotate = 0.0;

void setup() {
  size(640, 360);
  background(0);

  // Create the font from the .ttf file in the data folder
  f = createFont("SourceCodePro-Regular.ttf", 18);
  textFont(f);
} 

void draw() {
  background(0);

  strokeWeight(1);
  stroke(153);

  pushMatrix();
  float angle1 = radians(45);
  translate(100, 180);
  rotate(angle1);
  text("45 DEGREES", 0, 0);
  line(0, 0, 150, 0);
  popMatrix();

  pushMatrix();
  float angle2 = radians(270);
  translate(200, 180);
  rotate(angle2);
  text("270 DEGREES", 0, 0);
  line(0, 0, 150, 0);
  popMatrix();
  
  pushMatrix();
  translate(440, 180);
  rotate(radians(angleRotate));
  text(int(angleRotate) % 360 + " DEGREES", 0, 0);
  line(0, 0, 150, 0);
  popMatrix();
  
  angleRotate += 0.25;

  stroke(255, 0, 0);
  strokeWeight(4);
  point(100, 180);
  point(200, 180);
  point(440, 180);
}
