void draw() {
  background(204);
  // Shift the origin, scale the system
  translate(0, height);
  scale(1.0, -1.0);
  // Draw the origin
  line(0, 1, width, 1);    // Draw x-axis
  line(0, 1, 0, height);   // Draw y-axis
  // Draw within new coordinate system
  ellipse(0, 0, 45, 45);   // Draw at the origin
  ellipse(width/2, height/2, 45, 45);
  ellipse(width, height, 45, 45);
}
