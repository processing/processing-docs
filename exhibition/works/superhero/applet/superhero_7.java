import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import netscape.javascript.*; import javax.comm.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class superhero_7 extends BApplet {//  ooooooo oo    oo ooooooo  oooooooo ooooooo  oo    oo oooooooo ooooooo   oooooo
// oo       oo    oo oo    oo oo       oo    oo oo    oo oo       oo    oo oo    oo
// oo       oo    oo oo    oo oo       oo    oo oo    oo oo       oo    oo oo    oo
// ooooooo  oo    oo ooooooo  oooooo   ooooooo  oooooooo oooooo   ooooooo  oo    oo
//       oo oo    oo oo       oo       oo    oo oo    oo oo       oo    oo oo    oo
//       oo oo    oo oo       oo       oo    oo oo    oo oo       oo    oo oo    oo
//       oo oo    oo oo       oo       oo    oo oo    oo oo       oo    oo oo    oo
// ooooooo   oooooo  oo       oooooooo oo    oo oo    oo oooooooo oo    oo  oooooo
// 
//
// mikkel crone koser
// www.beyondthree.com
//
// november 10th 2003 [v. 1.0]
// febuary 1st 2004 [v. 1.1]
// garment_hanger_project sketch [nov. 2003]
// also used for the 1000 tshirts project [dec. 2003]
// slightly reCoded for SUPERHERO*PROCE55ING :) [jan 2004]
// reCompiled with 0068 (no keyboard focus since it kills applets if only java 1.1)
//
// appologies for the messy/uncommented code ;)
//

Content allContent[];
Content activeContent;
Point tracker = new Point(0, 0);
BImage activeImage;
Follower trail;
Color bg;
boolean showTexture = true;
boolean showHelpers = false;
boolean sizeActive = false;
float WIDTH = 70f;
int memLength = 100;
float ang;
Point R = new Point(0, 0);
Point L = new Point(0, 0);
Point memL[] = new Point[memLength];
Point memR[] = new Point[memLength];

void setup(){
  size(540, 400);
  background(0);
  noStroke();
      
  framerate(40);

  allContent = new Content[5];
  allContent[0] = new Content(new Color(255, 255, 255), "cpt_america.jpg", 25, false);
  allContent[1] = new Content(new Color(255, 255, 255), "batman.jpg", 25, false);  
  allContent[2] = new Content(new Color(255, 255, 255), "wonderwoman.jpg", 25, false); 
  allContent[3] = new Content(new Color(255, 255, 255), "superman.jpg", 25, false); 
  allContent[4] = new Content(new Color(255, 255, 255), "superhero_name.gif", 25, true);
  activeContent = allContent[Integer.parseInt(getParameter("hero"))];
  //activeContent = allContent[0];
  updateContent();

  trail = new Follower(0, 0, 4);

  for(int i=0; i<memLength; i++){
    memL[i] = new Point(0, 0);
    memR[i] = new Point(0, 0);
  }
}

void updateContent(){
  activeImage = activeContent.img;
  bg = activeContent.bg;
  memLength = activeContent.memLength;
  if(activeContent.isSizeActive == true){
    sizeActive = true;
  }else{
    sizeActive = false;
  }
}

void loop(){
  updateGarment();

  drawShape();          // 't' to turn on/off
  drawHelpers();        // 'h' to turn on/off

  tracker = new Point(mouseX, mouseY);
  trail.update(tracker.x, tracker.y);
}

void keyPressed(){
  if(key == 't' || key == 'T'){
    showTexture = !showTexture;
  }else if(key == 'h' || key == 'H'){
    showHelpers = !showHelpers;
  }else if(key == 's' || key == 'S'){
    sizeActive = !sizeActive;
  }else if(key == '1'){
    activeContent = allContent[0];
  }else if(key == '2'){
    activeContent = allContent[1];
  }else if(key == '3'){
    activeContent = allContent[2];
  }else if(key == '4'){
    activeContent = allContent[3];
  }else if(key == '5'){
    activeContent = allContent[4];
  }

  updateContent();
}


void drawHelpers(){
  if(showHelpers){
    cross(tracker.x, tracker.y, 4, 255, 0, 0);
    cross(L.x, L.y, 4, 0, 255, 0);
    cross(R.x, R.y, 4, 0, 0, 255);
  }
}

void drawShape(){
  if(showTexture){
    fill(255);
    if(!mousePressed){
      background(bg.getRed(), bg.getGreen(), bg.getBlue());
    }
    noStroke();
    for(int i=0; i<memLength-1; i++){
      beginShape(QUADS);
      texture(activeImage);
      int ii = (i+1)*(activeImage.height/(memLength-1));
      int jj = i*(activeImage.height/(memLength-1));
      vertex(memL[i].x, memL[i].y, 0,           activeImage.width, jj);
      vertex(memL[i+1].x, memL[i+1].y,0,         activeImage.width, ii);
      vertex(memR[i+1].x, memR[i+1].y,0,        0, ii);
      vertex(memR[i].x, memR[i].y,0,           0, jj);
      endShape();
    }
  }else{
    fill(255, 20);
    rect(0, 0, width, height);
    noFill();
    stroke(0, 250);
    for(int i=0; i<memLength-1; i++){
      beginShape(QUADS);
      vertex(memL[i].x, memL[i].y, 0);
      vertex(memL[i+1].x, memL[i+1].y,0);
      vertex(memR[i+1].x, memR[i+1].y,0);
      vertex(memR[i].x, memR[i].y,0);
      endShape();
    }
  }
}

void cross(int xx, int yy, int dim, int rr, int gg, int bb){
  stroke(rr, gg, bb, 250);
  line(-dim+xx, yy, dim+xx, yy);
  line(xx, dim+yy, xx, -dim+yy);
}

void updateGarment(){
  for(int i=memLength-1; i>0; i--){
    memL[i] = memL[i-1];
    memR[i] = memR[i-1];
  }
  memL[0] = new Point(L.x, L.y);
  memR[0] = new Point(R.x, R.y);

  float d = dist(trail.x, trail.y, tracker.x, tracker.y);
  if(d > 10){
    ang = calcAngle(tracker.x, tracker.y, trail.x, trail.y);
    if(sizeActive){
      R.x = (int)(d * cos(ang+90)) + tracker.x;
      R.y = (int)(d * sin(ang+90)) + tracker.y;
      L.x = (int)(d * cos(ang-90)) + tracker.x;
      L.y = (int)(d * sin(ang-90)) + tracker.y;
    }else{
      R.x = (int)(WIDTH * cos(ang+90)) + tracker.x;
      R.y = (int)(WIDTH * sin(ang+90)) + tracker.y;
      L.x = (int)(WIDTH * cos(ang-90)) + tracker.x;
      L.y = (int)(WIDTH * sin(ang-90)) + tracker.y;
    }
  }
}

float calcAngle(int ax, int ay, int bx, int by){
  float a = atan2(ay-by, ax-bx);
  return a;
}

class Follower{
  int x, y, tx, ty, speed;

  Follower(int xx, int yy, int sspeed){
    x = xx;
    y = yy;
    tx = 0;
    ty = 0;
    speed = sspeed;
  }

  void update(int tx, int ty){
    int xDif = tx - x;
    int yDif = ty - y;
    x = x + xDif/speed;
    y = y + yDif/speed;
  }

  void draw(){
    fill(0);
    rect(x, y, 10, 10);
  }
}

class Content{
  Color bg;
  boolean isSizeActive;
  int memLength;
  BImage img;

  Content(Color bbg, String str_img, int mmemLength, boolean iisSizeActive){
    isSizeActive = iisSizeActive;
    bg = bbg;
    img = loadImage(str_img);
    memLength = mmemLength;
  }
}
}