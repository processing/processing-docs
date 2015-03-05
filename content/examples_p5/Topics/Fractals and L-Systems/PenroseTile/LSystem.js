function LSystem() {
  this.steps = 0;
  this.axiom = "F";
  this.rule = "F+F-F";
  this.startLength = 90.0;
  this.theta = radians(120.0);
  this.reset();
}

LSystem.prototype.reset = function() {
  this.production = this.axiom;
  this.drawLength = this.startLength;
  this.generations = 0;
}

LSystem.prototype.getAge = function() {
  return this.generations;
}

LSystem.prototype.render = function() {
  translate(width/2, height/2);
  this.steps += 5;          
  if (this.steps > this.production.length()) {
    this.steps = this.production.length();
  }
  for (var i = 0; i < steps; i++) {
    var step = this.production.charAt(i);
    if (step == 'F') {
      rect(0, 0, -this.drawLength, -this.drawLength);
      noFill();
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

LSystem.prototype.simulate = function(gen) {
  while (this.getAge() < gen) {
    this.production = this.iterate(this.production, this.rule);
  }

}

LSystem.prototype.iterate = function(prod_, rule_) {
  this.drawLength = this.drawLength * 0.6;
  this.generations++;
  var newProduction = prod_;          
  newProduction = newProduction.replaceAll("F", rule_);
  return newProduction;
}



