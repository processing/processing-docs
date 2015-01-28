
  // Contructor
function Module(xOffsetTemp, yOffsetTemp, xTemp, yTemp, speedTemp, tempUnit) {
  this.xOffset = xOffsetTemp;
  this.yOffset = yOffsetTemp;
  this.x = xTemp;
  this.y = yTemp;
  this.speed = speedTemp;
  this.unit = tempUnit;
  this.xDirection = 1;
  this.yDirection = 1;

  // Custom method for updating the variables
  this.update = function() {
    this.x = this.x + (this.speed * this.xDirection);
    if (this.x >= this.unit || this.x <= 0) {
      this.xDirection *= -1;
      this.x = this.x + (1 * this.xDirection);
      this.y = this.y + (1 * this.yDirection);
    }
    if (this.y >= this.unit || this.y <= 0) {
      this.yDirection *= -1;
      this.y = this.y + (1 * this.yDirection);
    }
  }
  
  // Custom method for drawing the object
  this.draw = function() {
    fill(255);
    ellipse(this.xOffset + this.x, this.yOffset + this.y, 6, 6);
  }
}
