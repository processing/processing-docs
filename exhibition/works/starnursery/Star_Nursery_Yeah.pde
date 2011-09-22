// Star Nursery
// by Ryan Alexander at Motion Theory
// 
// Press tilde (~) to show the bounding circles
// Press the mouse to hide the video
// 
// Make sure to have your camera turned on before you run me!
// 
// Deep currents
// Like the sky
// Use no pentameter
// Mike Stipe is just this guy

// This code will not work without the image "pfx_star.gif"
// in the sketch's data directory. The entire project is here:
// http://elfman.vendetta.com/ryan/p5/starnursery/Star_Nursery_Yeah.zip



int maxStars = 10000;
int nStars = 0;
Star stars[] = new Star[maxStars];

BImage basicStar, vidThumb;

boolean newFrame;
float brightest = 255;
float darkest = 0;

float brightX[][] = new float[8][6];
float brightY[][] = new float[8][6];
float brightVelX[][] = new float[8][6];
float brightVelY[][] = new float[8][6];

boolean firstFrame = true;

void setup()
{
  size(500, 375);
  background(0);

  basicStar = loadImage("pfx_star.gif");
  brightToAlpha(basicStar);

  beginVideo(width, height, 15);
  framerate(30);
  
  conceiveStars(300);
}

void loop()
{
  // Calibrate the video for next frame
  if(newFrame) {
    calibrateVideo();
    newFrame = false;
    firstFrame = false;
  }
  
  if(mousePressed) {
    background(0);
  } else {
    background(video);
  }

  noFill();
  stroke(255,0,0,40);
  for(int i=0; i < nStars; i++) {
    stars[i].update();
  }
  stroke(128,128,128,40);
  for(int i=0; i < nStars; i++) {
    stars[i].display();
  }
}

void mouseReleased()
{
  background(0);
}

void videoEvent()
{
  newFrame = true;
}

void conceiveStars(int n)
{
  n += nStars;
  for(int i=nStars; i < n; i++) {
    stars[i] = new Star(i, random(width), random(height), random(-5, 5), random(-5, 5));
  }
  nStars += n;
}

void calibrateVideo()
{
  vidThumb = video.copy(40, 30);
  float tempb = brightness(vidThumb.pixels[0]);
  brightest = tempb;
  darkest = tempb;

  for(int i=1; i < 1200; i++) {
    tempb = brightness(vidThumb.pixels[i]);
    if(tempb > brightest) {
      brightest = tempb;
    }
    if(tempb < darkest) {
      darkest = tempb;
    }
  }
  
  // Make sure that lightest is > darkest
  if(brightest <= darkest) brightest = darkest + 1;
  
  // Calculate the changes in general brightness
  float tempx, tempy, totalBright;
  int pxx, pxy;
  for(int j=0; j < 6; j++) {
    for(int i=0; i < 8; i++) {
      tempx = 0;
      tempy = 0;
      totalBright = 0;
      
      for(int jj=0; jj < 5; jj++) {
        for(int ii=0; ii < 5; ii++) {
          pxx = i*5 + ii;
          pxy = j*5 + jj;
          tempb = brightness(vidThumb.pixels[pxx + pxy * 40]);
          tempx += pxx * tempb;
          tempy += pxy * tempb;
          totalBright += tempb;
        }
      }
      
      // Adjust the general velocity of the brightness
      if(totalBright == 0) {  // Avoid divide by 0
        if(firstFrame) {
          brightX[i][j] = i * (width/8) + (width/16);
          brightY[i][j] = j * (height/6) + (height/12);
        }
      } else {
        tempx = (tempx / totalBright + .5) * (width / 40.0);
        tempy = (tempy / totalBright + .5) * (height / 30.0);
        if(firstFrame) {
          brightX[i][j] = tempx;
          brightY[i][j] = tempy;
        } else {
          brightX[i][j] += brightVelX[i][j];
          brightY[i][j] += brightVelY[i][j];
          brightVelX[i][j] = ((tempx - brightX[i][j]) - brightVelX[i][j]) * .2;
          brightVelY[i][j] = ((tempy - brightY[i][j]) - brightVelY[i][j]) * .2;
        }
      }
    }
  }
}


//      //
// Star //
//      //
class Star
{
  float x, y, xv, yv;
  float diameter, inside, minD, maxD;
  int id, age;

  boolean connected[] = new boolean[maxStars];

  float red, green, blue;

  Star(int iid, float ix, float iy, float ixv, float iyv)
  {
    x = ix; y = iy;
    xv = ixv; yv = iyv;
    id = iid;
    age = (int)random(500);

    minD = 20;
    maxD = 60;
  }

  void update()
  {
    // Decay the inside diameter
    if(inside > 0) inside -= 1;

    // React to video input
    if(x >= 0 && x < width && y >= 0 && y < height) {
      color tempPixel = video.pixels[(int)x + (int)y*width];

      // Diameter grows with brightness
      float multiplier = 255.0 / (brightest - darkest);
      float bright = constrain(((brightness(tempPixel) - darkest) * multiplier) / 255, 0, 1);
      float sizeMult = sin(age * .05) * .4 + .6;
      diameter += ( (((1 - bright) * (maxD - minD) + minD) * sizeMult) - diameter ) * .2;
      
      // Influence by movement of general brightness
      xv += brightVelX[(int)floor(x / (width/8.0))][(int)floor(y / (height/6.0))] * 1;
      yv += brightVelY[(int)floor(x / (width/8.0))][(int)floor(y / (height/6.0))] * 1;
    }

    // Check for new connections
    for(int i=0; i < nStars; i++) {
      if(i != id) {// && touching < 1 && stars[i].touching < 1) {  // If it's not me
         float xd = stars[i].x - x;
         float yd = stars[i].y - y;
         float diff = xd*xd + yd*yd;
         float radii = stars[i].diameter/2 + diameter/2;

         // If touching
         if(diff < radii*radii) {
           springAdd(stars[i].x, stars[i].y, radii);

           // Assimilate Velocity
           xv += (stars[i].xv - xv) * .01;
           yv += (stars[i].yv - yv) * .01;

           // Color changes with distance
           float dist = sqrt(diff);

           if(dist < 30) {
             stroke(255, ((30 - dist) * 6) * (min(inside, stars[i].inside) / 60));
             line(x, y, stars[i].x, stars[i].y);
           }

           if(!connected[i]) {
             inside += diameter / (maxD / 5);
             connected[i] = true;
           }
         } else {
           connected[i] = false;
         }
       }
     }

     inside = constrain(inside, 0, 60);
   }

   void display()
   {
     ellipseMode(CENTER_DIAMETER);
     if(keyPressed && key == '`') {
       ellipse(x, y, diameter, diameter);
     }
     if(inside > 1) {
       imageMode(CENTER_DIAMETER);
       tint(255, (inside-4)*64);

       push();
       translate(0,0,-1);
       image(basicStar, x, y, inside, inside);
       pop();
     }
     //line(x, y, x+xv, y+yv);

     x += xv;
     y += yv;

     // Constrain to screen
     float d2 = diameter/2;
     if(x < d2) { x = d2; }
     if(x > width - d2) { x = width - d2; }
     if(y < d2) { y = d2; }
     if(y > height - d2) { y = height - d2; }

     xv *= .8;
     yv *= .8;

     age++;
   }

   float dx, dy, mag, ext;
   void springAdd(float sx, float sy, float rest)
   {
     dx = sx - x;
     dy = sy - y;
     if(dx != 0 || dy != 0) {  // Prevent / by zero
       mag = sqrt(dx*dx + dy*dy);
       ext = mag - rest;
       xv += (dx / mag * ext) * .1;
       yv += (dy / mag * ext) * .1;
     }
   }
 }

 void brightToAlpha(BImage b)
 {
   b.format = RGBA;
   for(int i=0; i < b.pixels.length; i++) {
     b.pixels[i] = color(255,255,255,brightness(b.pixels[i]));
   }
 }
