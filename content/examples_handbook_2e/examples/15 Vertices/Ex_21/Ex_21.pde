float angle = 0.0;

void setup() {
  size(100, 100);
  noStroke();
}

void draw() {
  background(0);
  fill(204);  // Light gray
  rect(0, 44, 100, 12);

  // Position in middle, scale 80%, and rotate
  translate(width/2, height/2);
  scale(0.75);
  rotate(angle);

  fill(102);
  beginShape();
  // Outer shape
  vertex(-25,-50);
  vertex( 25,-50);
  vertex( 25, 50);
  vertex(-25, 50);
  // Top hole
  beginContour();
  vertex(-15,-30);
  vertex(-15,-10);
  vertex( 15,-10);
  vertex( 15,-30);
  endContour();
  // Bottom Hole
  beginContour();
  vertex(-15, 10);
  vertex(-15, 30);
  vertex( 15, 30);
  vertex( 15, 10);
  endContour();
  endShape();
  
  angle += 0.01;
}
