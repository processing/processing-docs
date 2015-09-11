void draw() {
  background(204);
  // Shift the origin to the center
  translate(width/2, height/2);
  // Draw the origin
  line(-width/2, 0, width/2, 0);    // Draw x-axis
  line(0, -height/2, 0, height/2);  // Draw y-axis
  // Draw within the new coordinate system
  ellipse(0, 0, 45, 45);  // Draw at the origin
  ellipse(-width/2, height/2, 45, 45);
  ellipse(width/2, -height/2, 45, 45);
}
