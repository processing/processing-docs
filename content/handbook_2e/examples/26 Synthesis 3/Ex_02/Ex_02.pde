float ballX;
float ballY;
float ballSpeedX = random(3, 5);
float ballSpeedY = random(-2, 2);
float ballDiameter = 20.0;
float ballRadius = ballDiameter/2;

void setup() {
  size(600, 600);
  ballX = -ballRadius;
  ballY = height/2;
}

void draw() {
  background(0);

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

  // If ball hits top or bottom, change direction of Y  
  if (ballY > height - ballRadius) {
    ballY = height - ballRadius;
    ballSpeedY = ballSpeedY * -1;
  } else if (ballY < ballRadius) {
    ballY = ballRadius;
    ballSpeedY = ballSpeedY * -1;
  }
}
