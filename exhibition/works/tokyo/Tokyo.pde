// Tokyo by David Crawford <http://www.stopmotionstudies.net>
// Framerate is stepped up and down
// Created 22 April 2005

boolean stepUp = true;
int numFrames = 3;
int frame = 0;

int framerateMax = 30;
int framerateMin = framerateMax/10;
float newFramerate = framerateMin;
float framerateStep = 0.3;

PImage[] images = new PImage[numFrames];
    
void setup()
{
  size(640, 480);
  
  images[0] = loadImage("roof_00.jpg");
  images[1] = loadImage("roof_01.jpg");
  images[2] = loadImage("roof_02.jpg");
} 

void draw() 
{ 
  if (newFramerate <= framerateMax && stepUp == true) {
    newFramerate = newFramerate + framerateStep;
  } else {
    stepUp = false;
    framerateMax = int(random(29)+1);
      if (newFramerate >= framerateMin) {
        newFramerate = newFramerate - framerateStep;
      } else {
        stepUp = true;
        framerateMin = int(random(2)+1);
      }
  }
  frame = (frame+1) % numFrames;  // Use % to cycle through frames
  image(images[frame],0,0);
  framerate(newFramerate);
}
