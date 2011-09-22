// Cinema Redux by Brendan Dawes
// www.brendandawes.com
// Cinema Redux  is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// This code was created with Processing V.67
// It may not run on other versions of the software

int xpos = 0;
int ypos = 0;
int VWIDTH = 8; // width of capture
int VHEIGHT = 6; // height of capture
int MOVIEWIDTH = VWIDTH * 60; // width is equivalent to 1 minute of film time
int MOVIEHEIGHT = VHEIGHT * 130; // 130 minutes
int MAXWIDTH = MOVIEWIDTH - VWIDTH;
int MAXHEIGHT = MOVIEHEIGHT - VHEIGHT;
boolean capture = false;
boolean newFrame = false;

void setup()
{
  size(MOVIEWIDTH, MOVIEHEIGHT);
  background(0);
  beginVideo(VWIDTH, VHEIGHT, 1);
}

void mousePressed() {
  // click screen to start capture
  // click again to take screengrab if required
  if (capture == false) {
    capture = true;
  } 
  else {
    saveFrame();
  }

}

void videoEvent()
{
  newFrame = true;
}

void loop()
{
  if(newFrame && capture==true) {

    image(video,xpos, ypos);
    xpos += VWIDTH;
    if (xpos > MAXWIDTH) {
      xpos = 0;
      ypos += VHEIGHT;
    }
    if (ypos > MAXHEIGHT) {
      saveFrame();
      ypos = 0;
      background(0);
    }
    newFrame = false;
  }
}
