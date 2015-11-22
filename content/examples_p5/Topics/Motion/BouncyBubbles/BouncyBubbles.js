/**
 * Bouncy Bubbles  
 * based on code from Keith Peters. 
 * 
 * Multiple-object collision.
 */
 
 
var numBalls = 12;
var spring = 0.05;
var gravity = 0.03;
var friction = -0.9;
var balls = [];

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  for (var i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
  noStroke();
  fill(255, 204);
}

function draw() {
  background(0);
  for (var i = 0; i < balls.length; i++) {
    var ball = balls[i];
    ball.collide();
    ball.move();
    ball.display();  
  }
}

 
function Ball(xin, yin, din, idin, oin) {
  this.x = xin;
  this.y = yin;
  this.diameter = din;
  this.id = idin;
  this.others = oin;
  this.vx = 0;
  this.vy = 0;

  this.collide = function() {
    for (var i = this.id + 1; i < numBalls; i++) {
      var dx = this.others[i].x - this.x;
      var dy = this.others[i].y - this.y;
      var distance = sqrt(dx*dx + dy*dy);
      var minDist = this.others[i].diameter/2 + this.diameter/2;
      if (distance < minDist) { 
        var angle = atan2(dy, dx);
        var targetX = this.x + cos(angle) * minDist;
        var targetY = this.y + sin(angle) * minDist;
        var ax = (targetX - this.others[i].x) * spring;
        var ay = (targetY - this.others[i].y) * spring;
        this.vx -= ax;
        this.vy -= ay;
        this.others[i].vx += ax;
        this.others[i].vy += ay;
      }
    }   
  }
  
  this.move = function() {
    this.vy += gravity;
    this.x += this.vx;
    this.y += this.vy;
    if (this.x + this.diameter/2 > width) {
      this.x = width - this.diameter/2;
      this.vx *= friction; 
    }
    else if (this.x - this.diameter/2 < 0) {
      this.x = this.diameter/2;
      this.vx *= friction;
    }
    if (this.y + this.diameter/2 > height) {
      this.y = height - this.diameter/2;
      this.vy *= friction; 
    } 
    else if (this.y - this.diameter/2 < 0) {
      this.y = this.diameter/2;
      this.vy *= friction;
    }
  }
   
  this.display = function() {
    ellipse(this.x, this.y, this.diameter, this.diameter);
  }
}
