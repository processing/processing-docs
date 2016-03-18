/**
 * Springs. 
 * 
 * Move the mouse over one of the circles and click to re-position. 
 * When you release the mouse, it will snap back into position. 
 * Each circle has a slightly different behavior.  
 */


var num = 3; 
var springs = [];

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke(); 
  springs[0] = new Spring(240, 260, 40, 0.98, 8.0, 0.1, springs, 0); 
  springs[1] = new Spring(320, 210, 120, 0.95, 9.0, 0.1, springs, 1); 
  springs[2] = new Spring(180, 170, 200, 0.90, 9.9, 0.1, springs, 2);
}

function draw() {
  background(51); 

  for (var i = 0; i < springs.length; i++) {
    var spring = springs[i]; 
    spring.update(); 
    spring.display();
  }
}

function mousePressed() {
  for (var i = 0; i < springs.length; i++) {
    var spring = springs[i]; 
    spring.pressed();
  }
}

function mouseReleased() {
  for (var i = 0; i < springs.length; i++) {
    var spring = springs[i]; 
    spring.released();
  }
}



  // Constructor
function Spring(x, y, s, d, m, k_in, others, id) { 
  // Screen values 
  this.xpos = this.tempxpos = x; 
  this.ypos = this.tempypos = y;
  this.size = 20;
  this.over = false;
  this.move = false;
  // Spring simulation constants 
  this.rest_posx = x;
  this.rest_posy = y;
  this.size = s;
  this.damp = d; 
  this.mass = m; 
  this.k = k_in;
  this.friends = others;
  this.me = id;
  // Spring simulation variables 
  //var pos = 20.0; // Position 
  this.velx = 0.0;   // X Velocity 
  this.vely = 0.0;   // Y Velocity 
  this.accel = 0;    // Acceleration 
  this.force = 0;    // Force 

  this.update = function() { 
    if (this.move) { 
      this.rest_posy = mouseY; 
      this.rest_posx = mouseX;
    } 

    this.force = -this.k * (this.tempypos - this.rest_posy);  // f=-ky 
    this.accel = this.force / this.mass;                 // Set the acceleration, f=ma == a=f/m 
    this.vely = this.damp * (this.vely + this.accel);         // Set the velocity 
    this.tempypos = this.tempypos + this.vely;           // Updated position 

    this.force = -this.k * (this.tempxpos - this.rest_posx);  // f=-ky 
    this.accel = this.force / this.mass;                 // Set the acceleration, f=ma == a=f/m 
    this.velx = this.damp * (this.velx + this.accel);         // Set the velocity 
    this.tempxpos = this.tempxpos + this.velx;           // Updated position 


    if ((this.overEvent() || this.move) && !this.otherOver() ) { 
      this.over = true;
    } else { 
      this.over = false;
    }
  } 

  // Test to see if mouse is over this spring
  this.overEvent = function() {
    var disX = this.tempxpos - mouseX;
    var disY = this.tempypos - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < this.size/2 ) {
      return true;
    } else {
      return false;
    }
  }

  // Make sure no other springs are active
  this.otherOver = function() {
    for (var i=0; i<num; i++) {
      if (i != this.me) {
        if (this.friends[i].over == true) {
          return true;
        }
      }
    }
    return false;
  }

  this.display = function() { 
    if (this.over) { 
      fill(153);
    } else { 
      fill(255);
    } 
    ellipse(this.tempxpos, this.tempypos, this.size, this.size);
  } 

  this.pressed = function() { 
    if (this.over) { 
      this.move = true;
    } else { 
      this.move = false;
    }
  } 

  this.released = function() { 
    this.move = false; 
    this.rest_posx = this.xpos;
    this.rest_posy = this.ypos;
  }
} 
