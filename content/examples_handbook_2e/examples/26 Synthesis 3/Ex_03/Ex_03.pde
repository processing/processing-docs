float ballX = 300.0;
float ballY = 300.0;
float ballDiameter = 200.0;

int paddleX;
int paddleY;
int paddleHeight = 150;
int paddleWidth = 50;

void setup() {
  size(600, 600);
  noCursor();
}

void draw() {
  background(0);

  // Update paddle
  paddleX = mouseX;
  paddleY = mouseY;  

  // Draw paddle
  fill(102);
  noStroke();
  rect(paddleX, paddleY, paddleWidth, paddleHeight);

  // Draw ball
  fill(255);
  noStroke();
  ellipse(ballX, ballY, ballDiameter, ballDiameter);

  // Set variable to true if shapes are overlapping, false if not
  boolean collision = hitPaddle(paddleX, paddleY, paddleWidth, paddleHeight, 
                                ballX, ballY, ballDiameter/2);
                                
  if (collision == true) {
    stroke(204);
    strokeWeight(10);
    line(0, 0, width, height);
    line(0, width, height, 0);
  }
}

boolean hitPaddle(int rx, int ry, int rw, int rh, float cx, float cy, float cr) {
 
  float circleDistanceX = abs(cx - rx - rw/2);
  float circleDistanceY = abs(cy - ry - rh/2);
 
  if (circleDistanceX > (rw/2 + cr)) { return false; }
  if (circleDistanceY > (rh/2 + cr)) { return false; }
  if (circleDistanceX <= rw/2) { return true; }
  if (circleDistanceY <= rh/2) { return true; }
 
  float cornerDistance = pow(circleDistanceX - rw/2, 2) + pow(circleDistanceY - rh/2, 2);
  if (cornerDistance <= pow(cr, 2)) {
    return true; 
  } else {
    return false;
  }
}
