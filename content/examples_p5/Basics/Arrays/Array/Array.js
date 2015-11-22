/**
 * Array. 
 * 
 * An array is a list of data. Each piece of data in an array 
 * is identified by an index number representing its position in 
 * the array. Arrays are zero based, which means that the first 
 * element in the array is [0], the second element is [1], and so on. 
 * In this example, an array named "coswav" is created and
 * filled with the cosine values. This data is displayed three 
 * separate ways on the screen. 
 */

var coswave; 

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  coswave = [];
  for (var i = 0; i < width; i++) {
    var amount = map(i, 0, width, 0, PI);
    coswave[i] = abs(cos(amount));
  }
  background(255);
  noLoop();
}

function draw() {

  var y1 = 0;
  var y2 = height/3;
  for (var i = 0; i < width; i+=2) {
    stroke(coswave[i]*255);
    line(i, y1, i, y2);
  }

  y1 = y2;
  y2 = y1 + y1;
  for (var i = 0; i < width; i+=2) {
    stroke(coswave[i]*255 / 4);
    line(i, y1, i, y2);
  }
  
  y1 = y2;
  y2 = height;
  for (var i = 0; i < width; i+=2) {
    stroke(255 - coswave[i]*255);
    line(i, y1, i, y2);
  }
  
}

