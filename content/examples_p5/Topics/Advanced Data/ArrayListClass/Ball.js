// Simple bouncing ball class

  
function Ball(tempX, tempY, tempW) {
  this.x = tempX;
  this.y = tempY;
  this.w = tempW;
  this.speed = 0;
  this.gravity = 0.1;
  this.life = 255;
  
  
  this.move = function() {
    // Add gravity to speed
    this.speed = this.speed + this.gravity;
    // Add speed to y location
    this.y = this.y + this.speed;
    // If square reaches the bottom
    // Reverse speed
    if (this.y > height) {
      // Dampening
      this.speed = this.speed * -0.8;
      this.y = height;
    }
  }
  
  this.finished = function() {
    // Balls fade out
    this.life--;
    if (this.life < 0) {
      return true;
    } else {
      return false;
    }
  }
  
  this.display = function() {
    // Display the circle
    fill(0,this.life);
    //stroke(0,life);
    ellipse(this.x,this.y,this.w,this.w);
  }
}  
