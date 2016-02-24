// TOO SLOW!

/**
 * Spore 1 
 * by Mike Davis. 
 * 
 * A short program for alife experiments. Click in the window to restart.
 * Each cell is represented by a pixel on the display as well as an entry in
 * the array 'cells'. Each cell has a run() method, which performs actions
 * based on the cell's surroundings.  Cells run one at a time (to avoid conflicts
 * like wanting to move to the same space) and in random order.
 */
/*
var w;
var numcells = 0;
var maxcells = 10;
var cells = [];
var spore_color;
// set lower for smoother animation, higher for faster simulation
var runs_per_loop = 100;
  
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  pixelDensity(1);
  frameRate(24);
  reset();
}

function reset() {
  clearScreen();  
  w = new World();
  spore_color = color(172, 255, 128);
  seed();
}

function seed() {
  // Add cells at random places
  for (var i = 0; i < maxcells; i++)
  {
    var cX = int(random(width));
    var cY = int(random(height));
    //if (w.getpix(cX, cY) === black) {
      w.setpix(cX, cY, spore_color);
      cells[numcells] = new Cell(cX, cY);
      numcells++;
    //}
  }
}

function draw() {
  // Run cells in random order
  loadPixels();
  for (var i = 0; i < runs_per_loop; i++) {
    var selected = min(int(random(numcells)), numcells - 1);
    cells[selected].run();
  }
  updatePixels();
}

function clearScreen() {
  background(0);
}

function Cell(xin, yin) {
  this.x = xin;
  this.y = yin;
  
  // Perform action based on surroundings
  this.run = function() {
    // Fix cell coordinates
    while(this.x < 0) {
      this.x+=width;
    }
    while(this.x > width - 1) {
      this.x-=width;
    }
    while(this.y < 0) {
      this.y+=height;
    }
    while(this.y > height - 1) {
      this.y-=height;
    }
    
    // Cell instructions
    if (isBlack(w.getpix(this.x + 1, this.y))) {
      this.move(0, 1);
    } else if (!isBlack(w.getpix(this.x, this.y - 1)) && !isBlack(w.getpix(this.x, this.y + 1))) {
      this.move(int(random(9)) - 4, int(random(9)) - 4);
    }
  }
  
  // Will move the cell (dx, dy) units if that space is empty
  this.move = function(dx, dy) {
    if (isBlack(w.getpix(this.x + dx, this.y + dy))) {
      w.setpix(this.x + dx, this.y + dy, w.getpix(this.x, this.y));
      w.setpix(this.x, this.y, color(0));
      this.x += dx;
      this.y += dy;
    }
  }
}

function isBlack(col) {
  return (col[0] === 0 && col[1] === 0 && col[2] === 0);
}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
function World() {
  
  this.setpix = function(x, y, c) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    set(x, y, c);
  }
  
  this.getpix = function(x, y) {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    var c = get(x,y);
    //console.log(c);
    return c;
  }
}

function mousePressed() {
  numcells = 0;
  reset();
}
*/
