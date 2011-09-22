// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// Webcam Tracking (light) by flight404 (robert@flight404.com)
//
// created with processing (www.processing.org)
//
// source code is provided as a gesture of good faith. Do with it what you will,
// but remember this...
//
// 1) code is unsupported. please don't send emails regarding its functionality.
// 2) code is sloppy and may contain bugs. i claim no responsibility.
// 3) if code is repurposed and reposted, i would prefer a link, or at least a heads up.
// 4) if code is improved, i would love a copy.
// 5) if the mood strikes you, send me a postcard...
//
//    flight404 c/o theBarbarianGroup
//    332 newbury street 2nd floor
//    boston massachusetts 02115
//
// works best with bright light sources in a darkened room.
// light tracking in this manner has its limitations.  Currently, a dim vertically
// oriented light might appear as brighter than a highly focused bright light.  Light
// focus is registered in rows and columns but should be dealt with in the same way as
// it is in this Director Xtra (http://webcamxtra.jtnimoy.com/) by Josh Nimoy.  If
// tracking improvements are made, i would love to see the modified code. 



int res = 2;             // video resolution (width and height of each'pixel')

int totalPixels;         // total for array setup
int[][] vPixels;         // video pixel array
int xPix, yPix;          // pixel to be modified

int r,g,b;               // red, green, blue
int bb;                  // hue, saturation, brightness

float[] brightXArray;    // array for total brightness in each column of pixels             
float[] brightYArray;    // array for total brightness in each row of pixels 
  
float brightXMost;       // largest total of brightness values in a column
float brightYMost;       // largest total of brightness values in a row
float bbx1;              // column number of brightXMost
float bby1;              // column number of brightYMost

float totalLight;

float xLight, yLight;    // x and y position of the lightCursor
float pxLight, pyLight;  // previous xLight and yLight values

float xVel, yVel;
boolean newFrame;

LightCursor lightCursor =  new LightCursor();


void setup() { 
  size(320, 240); 
  noBackground();
  ellipseMode(CENTER_DIAMETER);
  noStroke();
  
  vPixels   = new int[height][width];
  beginVideo(320, 240,15);
  
  brightXArray = new float[(int)(video.width/res)];
  brightYArray = new float[(int)(video.height/res)];
  
  lightCursor = new LightCursor(); 
}


void loop() {
  if (newFrame){
    analyzeVideo();
  }
  lightCursor.move();
}


// Check for new frame of video before continuing.
// Make sure not currently in middle of render.
void videoEvent(){
  if (!newFrame){
    newFrame = true;
  }
}


// checks each pixel of the video for bright pixels.
// change 'if' statement conditions for less or more accurate tracking.
void analyzeVideo(){
  for(int j=0; j<(int)(video.height/res); j++){
    for(int i=0; i<(int)(video.width/res); i++){
      xPix = (i * res);
      yPix = (j * res);
      
      vPixels[j][i] = video.pixels[(yPix * video.width) + xPix];

      r = (int)(red(vPixels[j][i]));
      g = (int)(green(vPixels[j][i]));
      b = (int)(blue(vPixels[j][i]));
      bb = (int)(brightness(vPixels[j][i]));
      
      if (bb > 245){
        brightXArray[i] += (bb/255.0f);
        brightYArray[j] += (bb/255.0f);
      }

      fill(r,g,b);
      rect(xPix, yPix, res, res);
    }
  }
  findAverage();
}


// check each row and column for largest concentration of bright pixels
void findAverage(){
  for(int i=0; i<(int)(video.width/res); i++){
    if (brightXMost < brightXArray[i]){
      brightXMost = brightXArray[i];
      bbx1 = i - ((video.width/res)/2.0f);
    }
  }
  
  for(int j=0; j<(int)(video.height/res); j++){
    if (brightYMost < brightYArray[j]){
      brightYMost = brightYArray[j];
      bby1 = j - (int)((video.height/res)/2.0f);
    }
  }

  pxLight = xLight;
  pyLight = yLight;
    
  xLight -= (xLight - ((bbx1 + (int)((video.width/res)/2)) * res)) * .7f;
  yLight -= (yLight - ((bby1 + (int)((video.height/res)/2)) * res)) * .7f;
  
  resetVars();
  newFrame = false;
}


// reset the variables when done
void resetVars(){
  brightXMost = 0.0f;
  brightYMost = 0.0f;
  
  for(int i=0; i<(int)(video.width/res); i++){
    brightXArray[i] = 0.0f;
  }
  for(int j=0; j<(int)(video.height/res); j++){
    brightYArray[j] = 0.0f;
  }
}



// here is where the goodies go
// any project which uses a cursor for input can be modified
// so that the brightness hot-spot becomes the cursor and 
// input can be directed by webcam and flashlight. This version
// simply places a red crosshair at the hot-spot.
class LightCursor {
  LightCursor (){}
  void move (){
    stroke(255,0,0);
    line(xLight - 3, yLight, xLight + 3, yLight);
    line(xLight, yLight - 3, xLight, yLight + 3);
    noStroke();
  }
}