/**
 * Random. 
 * 
 * Random numbers create the basis of this image. 
 * Each time the program is loaded the result is different. 
 */

function setup() {
  createCanvas(640, 360);
  background(0);
  strokeWeight(20);
  frameRate(2);
}

function draw() {
  for (var i = 0; i < width; i++) {
    var r = random(255);
    stroke(r);
    line(i, 0, i, height);
  }
}

