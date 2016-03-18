/**
 * Integers Floats. 
 * 
 * Integers and floats are two different kinds of numerical data. 
 * An integer (more commonly called an int) is a number without 
 * a decimal point. A var is a floating-point number, which means 
 * it is a number that has a decimal place. Floats are used when
 * more precision is needed. 
 */
 
var a = 0;      // Create a variable "a" of the datatype "int"
var b = 0.0;  // Create a variable "b" of the datatype "float"

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  stroke(255);
  frameRate(30);
}

function draw() {
  background(0);
  
  a = a + 1;
  b = b + 0.2; 
  line(a, 0, a, height/2);
  line(b, height/2, b, height);
  
  if(a > width) {
    a = 0;
  }
  if(b > width) {
    b = 0;
  }
}
