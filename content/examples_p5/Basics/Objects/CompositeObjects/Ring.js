function Ring() {

  this.x = 0;
  this.y = 0;
  this.on = false;
  this.diameter = 0;

  this.start = function(xpos,  ypos) {
    this.x = xpos;
    this.y = ypos;
    this.on = true;
    this.diameter = 1;
  }
  
  this.grow = function() {
    if (this.on == true) {
      this.diameter += 0.5;
      if (this.diameter > width*2) {
        this.diameter = 0.0;
      }
    }
  }
  
  this.display = function() {
    if (this.on == true) {
      noFill();
      strokeWeight(4);
      stroke(155, 153);
      ellipse(this.x, this.y, this.diameter, this.diameter);
    }
  }
}
