// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

//INEQUALITY
//JOSH ON

HScrollbar hs1, hs2;

//CEO income data from Business Week via www.socialistworker.org
int ceodata[][] = {{1960,41},{1970,79},{1980,42},{1990,85},
                   {1995,141},{1996,209},{1997,326},{1998,419},
                   {1999,475},{2000,531},{2001,411},{2010,411}};
int dif = 100;
float rad = 1.1;
int yr = 1960;
int n = 0;
float diff = 10;
float d = 1.0;
BFont myfont;
BImage bg;

void setup()
{
  size(200,232);
  ellipseMode(CENTER_DIAMETER);
  noBackground();
  bg = loadImage("bg.gif");
  //set up font
  hint(SMOOTH_IMAGES);
  myfont = loadFont("Univers67.vlw.gz");
  setFont(myfont, 18);
  //make scrollbar
  hs1 = new HScrollbar(12, 59, width-24, 16, 17);
}

//INTERPOLATION METHOD
int interp(int a1,int a2,int a3,int b1,int b3) {
  return b1+((((a2-a1)*(b3-b1))/(a3-a1)));
}

void loop()
{
  System.arraycopy(bg.pixels, 0, pixels, 0, width*height); //puts in bgimage
  yr = 1960 +int(hs1.getPos()/(178/41)); //uses slider pos to set year between 1960 and 2004
  dif = 100;// resets dif
  for (int i=0; i < 11; i=i+1){//loops through the CEO data array looking for the data for the closest year available
    if (dif > abs(yr - ceodata[i][0])) {
      n = i;
      dif = abs(yr - ceodata[i][0]);
    }
  }
  
  //INTERPOLATES DATA FROM DISCRETE INFO SO THE HEADS WILL SCALE CONTINUOSLY
  diff = (yr - ceodata[n][0]);
  if (diff == 0){
    d = ceodata[n][1];
  }
  else if (diff < 0){
    d = interp(ceodata[n-1][0],yr,ceodata[n][0],ceodata[n-1][1],ceodata[n][1]);
  } else {
    d = interp(ceodata[n][0],yr,ceodata[n+1][0],ceodata[n][1],ceodata[n+1][1]);
  }
  
  //DRAW HEADS -scale so AREA reflects relative INCOME
  fill(255);
  smooth();
  noStroke();
  rad = sqrt(d/PI)*22;
  ellipse(100, 205-(rad/2), rad, rad);
  rad = sqrt(1/PI)*22;
  ellipse(60, 205-(rad/2), rad, rad);
  hs1.update();
  hs1.draw();
  noSmooth();
  
  //DRAW EYES
  point(58,201);
  point(61,201);
  point(97,201);
  point(100,201);
  
  //WRITE TEXT
  fill(0);
  text("IN "+ceodata[n][0]+" US CEOs WERE PAID", 15, 27);
  text(""+ ceodata[n][1]+" TIMES MORE THAN THE", 15, 39);
  text("AVERAGE WORKER.", 15, 51);
}

class HScrollbar
{
  int swidth, sheight;    // width and height of bar
  int xpos, ypos;         // x and y position of bar
  float spos, newspos;    // x position of slider
  int sposMin, sposMax;   // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }
  void update() {
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    
    newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    if(abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void draw() {
    noFill();
    rect(xpos, ypos, swidth-1, sheight);
    if(over || locked) {
      fill(255);
    } else {
      fill(255);
    }
    //rect(spos, ypos, sheight, sheight);
    triangle(spos+7, ypos + sheight, spos+14, ypos, spos, ypos);
  }

  float getPos() {
    // convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
