int paddleX;
int paddleY;
int paddleHeight = 100;
int paddleWidth = 20;

void setup() {
  size(600, 600);
  paddleX = width-paddleWidth*2;
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
}
