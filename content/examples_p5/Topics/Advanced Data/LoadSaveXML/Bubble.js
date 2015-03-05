// A Bubble class
  
  
// Create  the Bubble
function Bubble(x_, y_, diameter_, s) {
  this.over = false;
  this.x = x_;
  this.y = y_;
  this.diameter = diameter_;
  this.name = s;

  
  // CHecking if mouse is over the Bubble
  this.rollover = function(px, py) {
    var d = dist(px,py,this.x,this.y);
    if (d < this.diameter/2) {
      this.over = true; 
    } else {
      this.over = false;
    }
  }
  
  // Display the Bubble
  this.display = function() {
    stroke(0);
    strokeWeight(2);
    noFill();
    ellipse(this.x,this.y,this.diameter,this.diameter);
    if (this.over) {
      fill(0);
      noStroke();
      textAlign(CENTER);
      text(this.name,this.x,this.y+this.diameter/2+20);
    }
  }
}
