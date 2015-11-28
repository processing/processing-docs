/**
 * Objects
 * by hbarragan. 
 * 
 * Move the cursor across the image to change the speed and positions
 * of the geometry. The class MRect defines a group of lines.
 */

var r1, r2, r3, r4;
 
function setup()
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  fill(255, 204);
  noStroke();
  r1 = new MRect(1, 134.0, 0.532, 0.1*height, 10.0, 60.0);
  r2 = new MRect(2, 44.0, 0.166, 0.3*height, 5.0, 50.0);
  r3 = new MRect(2, 58.0, 0.332, 0.4*height, 10.0, 35.0);
  r4 = new MRect(1, 120.0, 0.0498, 0.9*height, 15.0, 60.0);
}
 
function draw()
{
  background(0);
  
  r1.display();
  r2.display();
  r3.display();
  r4.display();
 
  r1.move(mouseX-(width/2), mouseY+(height*0.1), 30);
  r2.move((mouseX+(width*0.05))%width, mouseY+(height*0.025), 20);
  r3.move(mouseX/4, mouseY-(height*0.025), 40);
  r4.move(mouseX-(width/2), (height-mouseY), 50);
}
 

function MRect(iw, ixp, ih, iyp, id, it) {
  this.w = iw; // single bar width
  this.xpos = ixp; // rect xposition
  this.h = ih; // rect height
  this.ypos = iyp; // rect yposition
  this.d = id; // single bar distance
  this.t = it; // number of bars
 
 
  this.move = function(posX, posY, damping) {
    var dif = this.ypos - posY;
    if (abs(dif) > 1) {
      this.ypos -= dif/damping;
    }
    dif = this.xpos - posX;
    if (abs(dif) > 1) {
      this.xpos -= dif/damping;
    }
  }
 
  this.display = function() {
    for (var i=0; i<this.t; i++) {
      rect(this.xpos+(i*(this.d+this.w)), this.ypos, this.w, height*this.h);
    }
  }
}
