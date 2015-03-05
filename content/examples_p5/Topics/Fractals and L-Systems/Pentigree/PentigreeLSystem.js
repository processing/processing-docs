// Child class constructor
function PentigreeLSystem() {
  LSystem.call(this);
  this.steps = 0;
  this.somestep = 0.1;
  this.xoff = 0.01;
  this.axiom = "F-F-F-F-F";
  this.rule = "F-F++F+F-F-F";
  this.startLength = 60.0;
  this.theta = radians(72);  
  this.reset();
};

// Inherit from the parent class
PentigreeLSystem.prototype = Object.create(LSystem.prototype);
this.constructor = PentigreeLSystem;

PentigreeLSystem.prototype.useRule = function(r_) {
  this.rule = r_;
}

PentigreeLSystem.prototype.useAxiom = function(a_) {
  this.axiom = a_;
}

PentigreeLSystem.prototype.useLength = function(l_) {
  this.startLength = l_;
}

PentigreeLSystem.prototype.useTheta = function(t_) {
  this.theta = radians(t_);
}

PentigreeLSystem.prototype.reset = function() {
  this.production = this.axiom;
  this.drawLength = this.startLength;
  this.generations = 0;
}

PentigreeLSystem.prototype.getAge = function() {
  return this.generations;
}

PentigreeLSystem.prototype.render = function() {
  translate(width/4, height/2);
  this.steps += 3;          
  if (this.steps > this.production.length) {
    this.steps = this.production.length;
  }

  for (var i = 0; i < this.steps; i++) {
    var step = this.production.charAt(i);
    if (step == 'F') {
      noFill();
      stroke(255);
      line(0, 0, 0, -this.drawLength);
      translate(0, -this.drawLength);
    } 
    else if (step == '+') {
      rotate(this.theta);
    } 
    else if (step == '-') {
      rotate(-this.theta);
    } 
    else if (step == '[') {
      push();
    } 
    else if (step == ']') {
      pop();
    }
  }
}


