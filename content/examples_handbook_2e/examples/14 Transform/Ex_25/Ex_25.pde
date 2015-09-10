void draw() {
  background(204);
  // Shift the origin, scale the system
  scale(width/2, height/2);
  translate(1.0, 1.0);
  strokeWeight(1.0/width);
  // Draw the origin
  line(-1, 0, 1, 0);  // Draw x-axis
  line(0, -1, 0, 1);  // Draw y-axis
  // Draw within new coordinate system
  ellipse(0, 0, 0.9, 0.9);  // Draw at the origin
  ellipse(-1, 1, 0.9, 0.9);
  ellipse(1, -1, 0.9, 0.9);
}
