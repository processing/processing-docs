// Child class constructor
function PenroseLSystem() {
  LSystem.call(this);
  this.axiom = "[X]++[X]++[X]++[X]++[X]";
  this.ruleW = "YF++ZF4-XF[-YF4-WF]++";
  this.ruleX = "+YF--ZF[3-WF--XF]+";
  this.ruleY = "-WF++XF[+++YF++ZF]-";
  this.ruleZ = "--YF++++WF[+ZF++++XF]--XF";
  this.startLength = 460.0;
  this.theta = radians(36);  
  this.reset();
};

// Inherit from the parent class
PenroseLSystem.prototype = Object.create(LSystem.prototype);
this.constructor = PenroseLSystem;


PenroseLSystem.prototype.useRule = function(r_) {
  this.rule = r_;
}

PenroseLSystem.prototype.useAxiom = function(a_) {
  this.axiom = a_;
}

PenroseLSystem.prototype.useLength = function(l_) {
  this.startLength = l_;
}

PenroseLSystem.prototype.useTheta = function(t_) {
  this.theta = radians(t_);
}

PenroseLSystem.prototype.reset = function() {
  this.production = this.axiom;
  this.drawLength = this.startLength;
  this.generations = 0;
}

PenroseLSystem.prototype.getAge = function() {
  return this.generations;
}

PenroseLSystem.prototype.render = function() {
  translate(width/2, height/2);
  var pushes = 0;
  var repeats = 1;
  this.steps += 12;          
  if (this.steps > this.production.length) {
    this.steps = this.production.length;
  }

  for (var i = 0; i < this.steps; i++) {
    var step = this.production.charAt(i);
    if (step == 'F') {
      stroke(255, 60);
      for (var j = 0; j < repeats; j++) {
        line(0, 0, 0, -this.drawLength);
        noFill();
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
      pushes++;            
      push();
    } 
    else if (step == ']') {
      pop();
      pushes--;
    } 
    else if ( (step.charCodeAt(0) >= 48) && (step.charCodeAt(0) <= 57) ) {
      repeats = step.charCodeAt(0) - 48;
    }
  }

  // Unpush if we need too
  while (pushes > 0) {
    pop();
    pushes--;
  }
}

PenroseLSystem.prototype.iterate = function(prod_, rule_) {
  var newProduction = "";
  for (var i = 0; i < prod_.length; i++) {
    var step = this.production.charAt(i);
    if (step == 'W') {
      newProduction = newProduction + this.ruleW;
    } 
    else if (step == 'X') {
      newProduction = newProduction + this.ruleX;
    }
    else if (step == 'Y') {
      newProduction = newProduction + this.ruleY;
    }  
    else if (step == 'Z') {
      newProduction = newProduction + this.ruleZ;
    } 
    else {
      if (step != 'F') {
        newProduction = newProduction + step;
      }
    }
  }

  this.drawLength = this.drawLength * 0.5;
  this.generations++;
  return newProduction;
}



