/**
 * Variable Scope. 
 * 
 * Variables have a global or local "scope". 
 * For example, variables declared within either the
 * setup() or draw() functions may be only used in these
 * functions. Global variables, variables declared outside
 * of setup() and draw(), may be used anywhere within the program.
 * If a local variable is declared with the same name as a
 * global variable, the program will use the local variable to make 
 * its calculations within the current scope. Variables are localized
 * within each block, the space between a { and }. 
 */
 
var a = 80;  // Create a global variable "a"

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(0);
  stroke(255);
  noLoop();
}

function draw() {
  // Draw a line using the global variable "a"
  line(a, 0, a, height);
  
  // Create a new variable "a" local to the for() statement 
  for (var a = 120; a < 200; a += 2) {
    line(a, 0, a, height);
  }
  
  // Create a new variable "a" local to the draw() function
  var a = 300;
  // Draw a line using the new local variable "a"
  line(a, 0, a, height);  
  
  // Make a call to the custom function drawAnotherLine()
  drawAnotherLine();
  
  // Make a call to the custom function setYetAnotherLine()
  drawYetAnotherLine();
}

function drawAnotherLine() {
  // Create a new variable "a" local to this method
  var a = 320;
  // Draw a line using the local variable "a"
  line(a, 0, a, height);
}

function drawYetAnotherLine() {
  // Because no new local variable "a" is set, 
  // this line draws using the original global
  // variable "a", which is set to the value 80.
  line(a+2, 0, a+2, height);
}
