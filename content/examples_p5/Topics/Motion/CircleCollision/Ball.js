

function Ball(x, y, r_) {
  this.position = new p5.Vector(x, y);
  this.velocity = p5.Vector.random2D();
  this.velocity.mult(3);
  this.r = r_;
  this.m = this.r*.1;
  

  this.update = function() {
    this.position.add(this.velocity);
  }

  this.checkBoundaryCollision = function() {
    if (this.position.x > width-this.r) {
      this.position.x = width-this.r;
      this.velocity.x *= -1;
    } 
    else if (this.position.x < this.r) {
      this.position.x = this.r;
      this.velocity.x *= -1;
    } 
    else if (this.position.y > height-this.r) {
      this.position.y = height-this.r;
      this.velocity.y *= -1;
    } 
    else if (this.position.y < this.r) {
      this.position.y = this.r;
      this.velocity.y *= -1;
    }
  }

  this.checkCollision = function(other) {

    // get distances between the balls components
    var bVect = p5.Vector.sub(other.position, this.position);

    // calculate magnitude of the vector separating the balls
    var bVectMag = bVect.mag();

    if (bVectMag < this.r + other.r) {
      // get angle of bVect
      var theta  = bVect.heading();
      // precalculate trig values
      var sine = sin(theta);
      var cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      var bTemp = [
        new p5.Vector(), new p5.Vector()
        ];

        /* this ball's position is relative to the other
         so you can use the vector between them (bVect) as the 
         reference point in the rotation expressions.
         bTemp[0].position.x and bTemp[0].position.y will initialize
         automatically to 0.0, which is what you want
         since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
      bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

      // rotate Temporary velocities
      var vTemp = [
        new p5.Vector(), new p5.Vector()
        ];

        vTemp[0].x  = cosine * this.velocity.x + sine * this.velocity.y;
      vTemp[0].y  = cosine * this.velocity.y - sine * this.velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
     var vFinal = [ 
        new p5.Vector(), new p5.Vector()
        ];

      // final rotated velocity for b[0]
      vFinal[0].x = ((this.m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (this.m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - this.m) * vTemp[1].x + 2 * this.m * vTemp[0].x) / (this.m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
     var bFinal = [
        new p5.Vector(), new p5.Vector()
        ];

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = this.position.x + bFinal[1].x;
      other.position.y = this.position.y + bFinal[1].y;

      this.position.add(bFinal[0]);

      // update velocities
      this.velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      this.velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }


  this.display = function() {
    noStroke();
    fill(204);
    ellipse(this.position.x, this.position.y, this.r*2, this.r*2);
  }
}

