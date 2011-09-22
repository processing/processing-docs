// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

// Articulate
// by REAS <http://www.groupc.net>

// Click mouse button to restart
// Press space bar to switch representations

// Created 3 June 2003


int numCells = 200;
StemCell[] stemcells = new StemCell[numCells];

BImage instructions;

float max_distance;
int count, mode;

boolean accumulate;
boolean clearBuffer;

int red, green, blue;

void setup()
{
  size(600, 600);
  noBackground();
  
  ellipseMode(CENTER_DIAMETER);
  
  for(int i=0; i<numCells; i++) {
    float temprand = random(TWO_PI);
    float hoff = cos(temprand) * width/5;
    float voff = sin(temprand) * width/5;
    stemcells[i] = new StemCell(width/2+hoff, height/2+voff, 10+i/15, i, stemcells);
  }
  max_distance = sqrt(sq(width) + sq(height));
  accumulate = true;
  mode = count = 0;
}

void loop()
{ 
  count++;
  
  for(int i=0; i<numCells; i++) {
    stemcells[i].check();
    stemcells[i].display();
  }
  
  if(count > 1800) {
    clearBuffer = true;
    beginAgain();
    count = 0;
  }
  
  if(clearBuffer) {
    clearMe();
    count = 0;
  }
 
}

void keyPressed() 
{
  if(key == ' ') {
    clearBuffer = true;
    accumulate = !accumulate;
  }
  count = 0;
}

void beginAgain()
{
  mode++;
  if(mode == 0) {
    for(int i=0; i<numCells; i++) {
      float temprand = random(TWO_PI);
      float hoff = cos(temprand) * width/5;
      float yoff = sin(temprand) * width/5;
      stemcells[i].newx = stemcells[i].x = width/2+hoff;
      stemcells[i].newy = stemcells[i].y = height/2+yoff;
    }
  } else if(mode == 1) {
    for(int i=0; i<numCells; i++) {
      stemcells[i].newx = stemcells[i].x = width/2;
      stemcells[i].newy = stemcells[i].y = 75 + random(height-150);
    }
  } else if(mode == 2) {
    for(int i=0; i<numCells; i++) {
      stemcells[i].newx = stemcells[i].x = random(0, width);
      int ytest;
      if(i%2 == 0) {
        ytest = 0;
      } else {
        ytest = height;
      }
      stemcells[i].newy = stemcells[i].y = ytest;
    }
  } else if(mode == 3) {
    for(int i=0; i<numCells; i++) {
      stemcells[i].newx = stemcells[i].x = random(width);
      stemcells[i].newy = stemcells[i].y = random(height);
    }
    mode = -1;
  }
}

void mousePressed()
{
  beginAgain();
  clearBuffer = true;
  count = 0;
}


// Cleans the entire screen to white

void clearMe()
{
  if(clearBuffer) {
    for(int i=0; i<width*height; i++) {
      pixels[i] = 0xFFFFFF;
    }
    clearBuffer = false;
  }
}

// Original StemCell class by William Ngan
// Modified by REAS

class StemCell
{
  // Data
  float x, y, newx, newy;  //Position of each cell
  float cellwidth, cellheight;
  float r;  // Radius of the cell
  float inc = 1.0; // Increment distance to move
  int id;  // Unique identifier for each stemcell
  float angle = 0;  // Angle of each inner circle
  float moveangle = 0;
  int over;  // Number of circles touching

  boolean hasOverlap; // Another cell is overlapping
  int selCell = -1; // The cell currently being dragged
  int off;
  int speed;
  int ds = 6;
  StemCell[] others;

  // Contructor
  StemCell(float xin, float yin, float rin, int num, StemCell[] cells) {
    x = newx = xin;
    y = newy = yin;
    r = rin;
    id = num;
    setRadius();
    setAngle();
    others = cells;
  }
  
  void setAngle() 
  {
    moveangle = (TWO_PI/(float)numCells * id) - PI;
  }
  
  void setRadius() {
    cellwidth = r*2;
    cellheight = r*2;
  }

  float getCenterX() {
    return newx;
  }

  float getCenterY() {
    return newy;
  }
  
  void move(float a, float r) {
    newx = newx + cos(a)*r;
    newy = newy + sin(a)*r;
    hasOverlap = true;
  }
  
  void check() 
  { 
    // Increase the angle when touching another circle
    // Increment position with numbers between -1 and 1
    // Modulate the speed based on size of circle
    newx += cos(angle); // * r;
    newy += sin(angle); // * r;
    
    // Constrain to screen
    if(newx < -r) { newx = -r; }
    if(newx > width+r) { newx = width+r; }
    if(newy < -r) { newy = -r; }
    if(newy > height+r) { newy = height+r; }

    // Interpolate
    float tempx = newx - x;
    if(abs(tempx) > 0.1) {
      x += tempx/4.0;
    }
    float tempy = newy - y;
    if(abs(tempy) > 0.1) {
      y += tempy/4.0;
    }

    over = 0;

    for(int i=0; i<numCells; i++) {
      if (i != id) { // if not the same
        float dx = others[i].getCenterX() - getCenterX();
        float dy = others[i].getCenterY() - getCenterY();
        float rerr = others[i].cellwidth/2 + cellwidth/2 + 1.0;
        float rr = others[i].cellwidth/2 + cellwidth/2;
        float diff = dx*dx + dy*dy;
        
        // If overlap
        if(diff < (rr*rr)) {
          float rA = atan2( dy, dx );
          if(rA == 0) {
            rA = random(1);
          }
          others[i].move( rA, inc );
          move( rA + PI, inc );
          
          if(accumulate) {
            float tempd = distance(x, y, others[i].x, others[i].y);
            if(tempd > 35) {
              // Pink
              red = 255;
              green = 102;
              blue = 204;
            } else if (tempd > 20) {
              // Orange
              red = 204;
              green = 102;
              blue = 0;  
            } else {
              // Blue
              red = 10;
              green = 91;
              blue = 124;
            }

            noStroke();
            drawLine((int)x, (int)y, (int)others[i].x, (int)others[i].y);

          }
          
          noStroke();
        } else {
          hasOverlap = false;
        }
        if(diff < rerr*rerr) {
          over++; // Count the number of cells touching
        }
        
      }
    }

    // Spin if touching another cell
    if(over > 0) { 
      angle += over*((29-r)/100); 
      //if(angle > TWO_PI) { angle = 0.0; }
      //if(angle < 0.0) { angle = TWO_PI; }
    }
  }

  void display() {
    noFill();
    if(!accumulate) {

      flat_circle((int)x, (int)y, (int)cellwidth/2, color(255, 255, 255));
      //flat_circle((int)x, (int)y, (int)cellwidth/2, color(255, 0, 0));
      stroke(153);
      point(x, y);
      
      noStroke();
      fill(255, 204, 0);
      crosscross(x+cos(angle)*(r-ds/2), y+sin(angle)*(r-ds/2));

    }
  }
}

void crosscross(float x, float y) {
    stroke(49, 11, 16);
    beginShape(POINTS);
    vertex(x-1, y);
    vertex(x+1, y);
    vertex(x, y-1);
    vertex(x, y+1);
    endShape();
}

float distance(float x1, float y1, float x2, float y2) {
  return sqrt(sq(x1-x2) + sq(y1-y2));
}

void flat_circle(int xC, int yC, int r, color c) 
{
    int x = 0, y = r, u = 1, v = 2 * r - 1, E = 0;
    while (x < y) {
      thin_point(xC + x, yC + y, c); // NNE
      thin_point(xC + y, yC - x, c); // ESE
      thin_point(xC - x, yC - y, c); // SSW
      thin_point(xC - y, yC + x, c); // WNW

      x++; E += u; u += 2;
      if (v < 2 * E){
	y--; E -= v; v -= 2;
      }
      if (x > y) break;

      thin_point(xC + y, yC + x, c); // ENE
      thin_point(xC + x, yC - y, c); // SSE
      thin_point(xC - y, yC - x, c); // WSW
      thin_point(xC - x, yC + y, c); // NNW
    }
}

void thin_point(int x, int y, color thiscolor)
{
  //if (xwidth1 || yheight1) { return; }
  int index = y*width + x;
  if(index < 0 || index > width*height-1) return;
  pixels[index] = thiscolor; //strokei;
}

void putPixel(int x, int y)
{
  fill(red, green, blue, 26);
  rect(x, y, 1, 1);
}

void drawLine(int xP, int yP, int xQ, int yQ)
{
  int x = xP, y = yP, D = 0, HX = xQ - xP, HY = yQ - yP, c, M, xInc = 1, yInc = 1;
  if (HX < 0){
    xInc = -1; HX = -HX;
  }
  if (HY < 0){
    yInc = -1; HY = -HY;
  }
  if (HY <= HX)
  {  c = 2 * HX; M = 2 * HY;
    for (;;)
    {
      putPixel(x, y);
      if (x == xQ) break;
      x += xInc;
      D += M;
      if (D > HX){
        y += yInc; D -= c;
      }
    }
  }
  else
  {
    c = 2 * HY;
    M = 2 * HX;
    for (;;)
    {
      putPixel(x, y);
      if (y == yQ) break;
      y += yInc;
      D += M;
      if (D > HY){
        x += xInc; D -= c;
      }
    }
  }
}



