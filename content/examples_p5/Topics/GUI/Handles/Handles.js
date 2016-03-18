/**
 * Handles. 
 * 
 * Click and drag the white boxes to change their position. 
 */
 
var handles;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  var num = height/15;
  handles = [];
  var hsize = 10;
  for (var i = 0; i < num; i++) {
    handles[i] = new Handle(width/2, 10+i*15, 50-hsize/2, 10, handles);
  }
}

function draw() {
  background(153);
  
  for (var i = 0; i < handles.length; i++) {
    handles[i].update();
    handles[i].display();
  }
  
  fill(0);
  rect(0, 0, width/2, height);
}

function mouseReleased()  {
  for (var i = 0; i < handles.length; i++) {
    handles[i].releaseEvent();
  }
}

  
  
function Handle(ix, iy, il, is, o) {
  this.x = ix;
  this.y = iy;
  this.stretch = il;
  this.size = is;
  this.boxx = this.x+this.stretch - this.size/2;
  this.boxy = this.y - this.size/2;
  this.others = o;
  this.over = false;
  this.press = false;
  this.locked = false;
  this.otherslocked = false;

  this.update = function() {
    this.boxx = this.x+this.stretch;
    this.boxy = this.y - this.size/2;
    
    for (var i=0; i<this.others.length; i++) {
      if (this.others[i].locked == true) {
        this.otherslocked = true;
        break;
      } else {
        this.otherslocked = false;
      }  
    }
    
    if (this.otherslocked == false) {
      this.overEvent();
      this.pressEvent();
    }
    
    if (this.press) {
      this.stretch = lock(mouseX-width/2-this.size/2, 0, width/2-this.size-1);
    }
  }
  
  this.overEvent = function() {
    if (overRect(this.boxx, this.boxy, this.size, this.size)) {
      this.over = true;
    } else {
      this.over = false;
    }
  }
  
  this.pressEvent = function() {
    if (this.over && mouseIsPressed || this.locked) {
      this.press = true;
      this.locked = true;
    } else {
      this.press = false;
    }
  }
  
  this.releaseEvent = function() {
    this.locked = false;
  }
  
  this.display = function() {
    line(this.x, this.y, this.x+this.stretch, this.y);
    fill(255);
    stroke(0);
    rect(this.boxx, this.boxy, this.size, this.size);
    if (this.over || this.press) {
      line(this.boxx, this.boxy, this.boxx+this.size, this.boxy+this.size);
      line(this.boxx, this.boxy+this.size, this.boxx+this.size, this.boxy);
    }

  }
}


var overRect = function(x,y,width,height) {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

var lock = function(val, minv, maxv) { 
  return  min(max(val, minv), maxv); 
} 
