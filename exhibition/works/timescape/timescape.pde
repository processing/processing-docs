/*
timescape
by e.j.gone
20050124
*/

int xpos = 0;
int ypos = 0;
int w = 1280; // window width
//capturing video at 180x120 pixels
int vw = 180; // video width
int vh = 120; // video height
boolean newFrame = false;

void setup()
{
  size(w, vw*2);
  beginVideo(vw, vh, 30);
}

void videoEvent()
{
  newFrame = true;
}

void loop()
{
  if(newFrame) {
    if(xpos > w) {
      xpos = 0;
      ypos += vw;
    }
    for (int y = 0; y < vw; y ++){
      set(xpos, y+ypos, video.pixels[y+vw*(vh/2)]);
    }
    xpos += 1;

    if (xpos>w && ypos>1){ // save image
      String var = "shot_"+month()+"."+day()+"_"+hour()+"."+minute()+"."+second()+".tif";
      save(var);
    }
    newFrame = false;
  }
}

void keyPressed(){
  if (key == SHIFT){ // press SHIFT to restart recording
    xpos = 0;
    ypos = 0;
  }
}

