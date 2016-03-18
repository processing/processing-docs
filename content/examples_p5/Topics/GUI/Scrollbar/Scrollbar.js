/**
 * Scrollbar. 
 * 
 * Move the scrollbars left and right to change the positions of the images. 
 */


// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="seedTop.jpg,seedBottom.jpg"; */ 


var hs1, hs2;  // Two scrollbars
var img1, img2;  // Two images to load

function preload() {
  // Load images
  img1 = loadImage("seedTop.jpg");
  img2 = loadImage("seedBottom.jpg");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  
  hs1 = new HScrollbar(0, height/2-8, width, 16, 16);
  hs2 = new HScrollbar(0, height/2+8, width, 16, 16);
  
}

function draw() {
  background(255);
  
  // Get the position of the img1 scrollbar
  // and convert to a value to display the img1 image 
  var img1Pos = hs1.getPos()-width/2;
  fill(255);
  image(img1, width/2-img1.width/2 + img1Pos*1.5, 0);
  
  // Get the position of the img2 scrollbar
  // and convert to a value to display the img2 image
  var img2Pos = hs2.getPos()-width/2;
  fill(255);
  image(img2, width/2-img2.width/2 + img2Pos*1.5, height/2);
 
  hs1.update();
  hs2.update();
  hs1.display();
  hs2.display();
  
  stroke(0);
  line(0, height/2, width, height/2);
}


  function HScrollbar (xp, yp, sw, sh, l) {
    this.swidth = sw;// width and height of bar
    this.sheight = sh;
    var widthtoheight = sw - sh;
    this.ratio = sw / widthtoheight;
    this.xpos = xp;// x and y position of bar
    this.ypos = yp-this.sheight/2;
    this.spos = this.xpos + this.swidth/2 - this.sheight/2;// x position of slider
    this.newspos = this.spos;
    this.sposMin = this.xpos;// max and min values of slider
    this.sposMax = this.xpos + this.swidth - this.sheight;
    this.loose = l;// how loose/heavy
    this.over = false; // is the mouse over the slider?
    this.locked = false;
  

  this.update = function() {
    if (this.overEvent()) {
      this.over = true;
    } else {
      this.over = false;
    }
    if (mouseIsPressed && this.over) {
      this.locked = true;
    }
    if (!mouseIsPressed) {
      this.locked = false;
    }
    if (this.locked) {
      this.newspos = constrain(mouseX-this.sheight/2, this.sposMin, this.sposMax);
    }
    if (abs(this.newspos - this.spos) > 1) {
      this.spos = this.spos + (this.newspos-this.spos)/this.loose;
    }
  }

  this.constrain = function(val, minv, maxv) {
    return min(max(val, minv), maxv);
  }

  this.overEvent = function() {
    if (mouseX > this.xpos && mouseX < this.xpos+this.swidth &&
       mouseY > this.ypos && mouseY < this.ypos+this.sheight) {
      return true;
    } else {
      return false;
    }
  }

   this.display = function() {
    noStroke();
    fill(204);
    rect(this.xpos, this.ypos, this.swidth, this.sheight);
    if (this.over || this.locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(this.spos, this.ypos, this.sheight, this.sheight);
  }

  this.getPos = function() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return this.spos * this.ratio;
  }
}
