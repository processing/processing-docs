// Constructor
function Egg(xpos, ypos, t, s) {
  this.x = xpos;
  this.y = ypos;
  this.tilt = t;
  this.scalar = s / 100.0;
  this.angle = 0;

  this.wobble = function() {
    this.tilt = cos(this.angle) / 8;
    this.angle += 0.1;
  }

  this.display = function() {
    noStroke();
    fill(255);
    push();
    translate(this.x, this.y);
    rotate(this.tilt);
    scale(this.scalar);
    beginShape();
    vertex(0, -100);
    bezierVertex(25, -100, 40, -65, 40, -40);
    bezierVertex(40, -15, 25, 0, 0, 0);
    bezierVertex(-25, 0, -40, -15, -40, -40);
    bezierVertex(-40, -65, -25, -100, 0, -100);
    endShape();
    pop();
  }
}
