float ballX;
float ballY;
float ballSpeedX = random(3, 5);
float ballSpeedY = random(-2, 2);
float ballDiameter = 20.0;
float ballRadius = ballDiameter/2;

int paddleX;
int paddleY;
int paddleHeight = 100;
int paddleWidth = 20;

void setup() {
  size(600, 600);
  paddleX = width-paddleWidth*2;
  ballX = -ballRadius;
  ballY = height/2;
  noCursor();
}

void draw() {
  background(0);

  // Update paddle
  paddleY = mouseY - paddleHeight/2;
  paddleY = constrain(paddleY, 0, height-paddleHeight);   

  // Draw paddle
  fill(102);
  noStroke();
  rect(paddleX, paddleY, paddleWidth, paddleHeight);

  // Draw ball
  fill(255);
  noStroke();
  ellipse(ballX, ballY, ballDiameter, ballDiameter);

  // Update ball location
  ballX = ballX + ballSpeedX;
  ballY = ballY + ballSpeedY;

  // Reset position if ball leaves the screen
  if (ballX > width + ballRadius) {
    ballX = -ballRadius;
    ballY = random(height*0.25, height*0.75);
    ballSpeedX = random(3, 5);
    ballSpeedY = random(-6, 6);
  }
  
  // If ball hits the left edge, change directino of X
  if (ballX < ballRadius) {
    ballX = ballRadius;
    ballSpeedX = ballSpeedX * -1;
  } 

  // If ball hits top or bottom, change direction of Y  
  if (ballY > height - ballRadius) {
    ballY = height - ballRadius;
    ballSpeedY = ballSpeedY * -1;
  } else if (ballY < ballRadius) {
    ballY = ballRadius;
    ballSpeedY = ballSpeedY * -1;
  }

  // Set variable to true if shapes are overlapping, false if not
  boolean collision = hitPaddle(paddleX, paddleY, paddleWidth, paddleHeight, 
                                ballX, ballY, ballDiameter/2);
  
  // Change ball direction when paddle is hit
  // and bump it back to the edge of the paddle                          
  if (collision == true) {
    ballSpeedX = ballSpeedX * -1;
    ballX += ballSpeedX;
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
