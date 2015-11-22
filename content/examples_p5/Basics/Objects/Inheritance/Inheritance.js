/**
 * Inheritance
 * 
 * A class can be defined using another class as a foundation. In object-oriented
 * programming terminology, one class can inherit fi elds and methods from another. 
 * An object that inherits from another is called a subclass, and the object it 
 * inherits from is called a superclass. A subclass extends the superclass.
 */

var spots;
var arm;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  arm = new SpinArm(width/2, height/2, 0.01);
  spots = new SpinSpots(width/2, height/2, -0.02, 90.0);
}

function draw() {
  background(204);
  arm.update();
  arm.display();
  spots.update();
  spots.display();
}


function Spin(xpos, ypos, s) {
  this.x = xpos;
  this.y = ypos;
  this.speed = s;
  this.angle = 0;
  
  this.update = function() {
    this.angle += this.speed;
  }
}

// Child class constructor
function SpinArm(x, y, s) {
  Spin.call(this, x, y, s);

  // Override the display method
  this.display = function(){
    strokeWeight(1);
    stroke(0);
    push();
    translate(this.x, this.y);
    this.angle += this.speed;
    rotate(this.angle);
    line(0, 0, 165, 0);
    pop();
  };
};

// Inherit from the parent class
SpinArm.prototype = Object.create(Spin.prototype);
this.constructor = SpinArm;

// Child class constructor
function SpinSpots(x, y, s, d) {
  this.dim = d;
  Spin.call(this, x, y, s);

  // Override the display method
  this.display = function(){
    noStroke();
    push();
    translate(this.x, this.y);
    this.angle += this.speed;
    rotate(this.angle);
    ellipse(-this.dim/2, 0, this.dim, this.dim);
    ellipse(this.dim/2, 0, this.dim, this.dim);
    pop();
  };
};

// Inherit from the parent class
SpinSpots.prototype = Object.create(Spin.prototype);
this.constructor = SpinSpots;
