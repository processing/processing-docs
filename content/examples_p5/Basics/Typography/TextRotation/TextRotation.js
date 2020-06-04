/**
 * Text Rotation. 
 * 
 * Draws letters to the screen and rotates them at different angles.
 */

var f;
var angleRotate = 0.0;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(0);

  // Create the font from the .ttf file in the data folder
  textFont("Source Code Pro", 18);
} 

function draw() {
  background(0);


  push();
  var angle1 = radians(45);
  translate(100, 180);
  rotate(angle1);
  noStroke();
  fill(255);
  text("45 DEGREES", 0, 0);
  strokeWeight(1);
  stroke(153);
  line(0, 0, 150, 0);
  pop();

  push();
  var angle2 = radians(270);
  translate(200, 180);
  rotate(angle2);
  noStroke();
  fill(255);
  text("270 DEGREES", 0, 0);
  strokeWeight(1);
  stroke(153);
  line(0, 0, 150, 0);
  pop();
  
  push();
  translate(440, 180);
  rotate(radians(angleRotate));
  noStroke();
  fill(255);
  text(int(angleRotate) % 360 + " DEGREES", 0, 0);
  strokeWeight(1);
  stroke(153);
  line(0, 0, 150, 0);
  pop();
  
  angleRotate += 0.25;

  stroke(255, 0, 0);
  strokeWeight(4);
  point(100, 180);
  point(200, 180);
  point(440, 180);
}