

function Orb(x, y, r_) {
  // Orb has positio and velocity
  this.position = createVector(x, y);
  this.velocity = createVector(.5, 0);
  this.r = r_;
  // A damping of 80% slows it down when it hits the ground
  this.damping = 0.8;


  this.move = function() {
    // Move orb
    this.velocity.add(gravity);
    this.position.add(this.velocity);
  }

  this.display = function() {
    // Draw orb
    noStroke();
    fill(200);
    ellipse(this.position.x, this.position.y, this.r*2, this.r*2);
  }

  // Check boundaries of window
  this.checkWallCollision = function() {
    if (this.position.x > width-this.r) {
      this.position.x = width-this.r;
      this.velocity.x *= -this.damping;
    }
    else if (this.position.x < this.r) {
      this.position.x = this.r;
      this.velocity.x *= -this.damping;
    }
  }

  this.checkGroundCollision = function(groundSegment) {

    // Get difference between orb and ground
    var deltaX = this.position.x - groundSegment.x;
    var deltaY = this.position.y - groundSegment.y;

    // Precalculate trig values
    var cosine = cos(groundSegment.rot);
    var sine = sin(groundSegment.rot);

    /* Rotate ground and velocity to allow
     orthogonal collision calculations */
    var groundXTemp = cosine * deltaX + sine * deltaY;
    var groundYTemp = cosine * deltaY - sine * deltaX;
    var velocityXTemp = cosine * this.velocity.x + sine * this.velocity.y;
    var velocityYTemp = cosine * this.velocity.y - sine * this.velocity.x;

    /* Ground collision - check for surface
     collision and also that orb is within
     left/rights bounds of ground segment */
    if (groundYTemp > -this.r &&
      this.position.x > groundSegment.x1 &&
      this.position.x < groundSegment.x2 ) {
      // keep orb from going into ground
      groundYTemp = -this.r;
      // bounce and slow down orb
      velocityYTemp *= -1.0;
      velocityYTemp *= this.damping;
    }

    // Reset ground, velocity and orb
    deltaX = cosine * groundXTemp - sine * groundYTemp;
    deltaY = cosine * groundYTemp + sine * groundXTemp;
    this.velocity.x = cosine * velocityXTemp - sine * velocityYTemp;
    this.velocity.y = cosine * velocityYTemp + sine * velocityXTemp;
    this.position.x = groundSegment.x + deltaX;
    this.position.y = groundSegment.y + deltaY;
  }
}
