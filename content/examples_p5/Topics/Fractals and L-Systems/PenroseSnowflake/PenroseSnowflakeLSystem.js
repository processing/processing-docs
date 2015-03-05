// Child class constructor
function PenroseSnowflakeLSystem() {
  LSystem.call(this);
  this.steps = 0;
  this.axiom = "F3-F3-F3-F3-F";
  this.ruleF = "F3-F3-F45-F++F3-F";
  this.startLength = 450.0;
  this.theta = radians(18); 
  this.reset();
};

// Inherit from the parent class
PenroseSnowflakeLSystem.prototype = Object.create(LSystem.prototype);
this.constructor = PenroseSnowflakeLSystem;



PenroseSnowflakeLSystem.prototype.useRule = function(r_) {
  this.rule = r_;
}

PenroseSnowflakeLSystem.prototype.useAxiom = function(a_) {
  this.axiom = a_;
}

PenroseSnowflakeLSystem.prototype.useLength = function(l_) {
  this.startLength = l_;
}

PenroseSnowflakeLSystem.prototype.useTheta = function(t_) {
  this.theta = radians(t_);
}

PenroseSnowflakeLSystem.prototype.reset = function() {
  this.production = this.axiom;
  this.drawLength = this.startLength;
  this.generations = 0;
}

PenroseSnowflakeLSystem.prototype.getAge = function() {
  return this.generations;
}

PenroseSnowflakeLSystem.prototype.render = function() {
  translate(width, height);
  var repeats = 1;

  this.steps += 3;          
  if (this.steps > this.production.length) {
    this.steps = this.production.length;
  }

  for (var i = 0; i < this.steps; i++) {
    var step = this.production.charAt(i);
    if (step == 'F') {
      for (var j = 0; j < repeats; j++) {
        line(0,0,0, -this.drawLength);
        translate(0, -this.drawLength);
      }
      repeats = 1;
    } 
    else if (step == '+') {
      for (var j = 0; j < repeats; j++) {
        rotate(this.theta);
      }
      repeats = 1;
    } 
    else if (step == '-') {
      for (var j =0; j < repeats; j++) {
        rotate(-this.theta);
      }
      repeats = 1;
    } 
    else if (step == '[') {
      push();
    } 
    else if (step == ']') {
      pop();
    } 
    else if ( (step.charCodeAt(0) >= 48) && (step.charCodeAt(0) <= 57) ) {
      repeats += step.charCodeAt(0) - 48;
    }
  }
}


PenroseSnowflakeLSystem.prototype.iterate = function(prod_, rule_) {
  var newProduction = "";
  for (var i = 0; i < prod_.length; i++) {
    var step = this.production.charAt(i);
    if (step == 'F') {
      newProduction = newProduction + this.ruleF;
    } 
    else {
      if (step != 'F') {
        newProduction = newProduction + step;
      }
    }
  }
  this.drawLength = this.drawLength * 0.4;
  this.generations++;
  return newProduction;
}


