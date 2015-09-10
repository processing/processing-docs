Ball ball;
Paddle paddle;

void setup() {
  size(600, 600);
  paddle = new Paddle();
  ball = new Ball();
  noCursor();
}

void draw() {
  background(0);

  paddle.update();  // Update paddle
  paddle.display();  // Draw paddle

  ball.update();  // Update ball
  ball.display();  // Draw ball

  // Set variable to true if shapes are overlapping, false if not
  boolean collision = hitPaddle(paddle, ball);
                                
  if (collision == true) {
    ball.hit(paddle);
  }
}

boolean hitPaddle(Paddle p, Ball b) {
 
  float circleDistanceX = abs(b.x - p.x - p.w/2);
  float circleDistanceY = abs(b.y - p.y - p.h/2);
 
  if (circleDistanceX > (p.w/2 + b.radius)) { return false; }
  if (circleDistanceY > (p.h/2 + b.radius)) { return false; }
  if (circleDistanceX <= p.w/2) { return true; }
  if (circleDistanceY <= p.h/2) { return true; }
 
  float cornerDistance = pow(circleDistanceX - p.w/2, 2) + pow(circleDistanceY - p.h/2, 2);
  if (cornerDistance <= pow(b.radius, 2)) {
    return true; 
  } else {
    return false;
  }
}

