// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


int num = 300;
Module[] mods, mods2;
boolean clearScreen = true;
int[] q = {1,-1};
float delay = 40.0f;
boolean initialized = false;
int bo = 6;
int is = 11;
ImageButton button, button2;
BFont myFont;
float fx, fy;

void setup(){
  size(640,480);
  noBackground();
  BImage uplo = loadImage("up_lo.gif");
  BImage uphi = loadImage("up_hi.gif");
  BImage updo = loadImage("up_down.gif");
  BImage dolo = loadImage("down_lo.gif");
  BImage dohi = loadImage("down_hi.gif");
  BImage dodo = loadImage("down_down.gif");
  int x1 = bo;
  int y1 = height - bo - is;
  int x2 = bo*2 + is;
  button = new ImageButton(x1, y1, is, is, uplo, uphi, updo);
  button2 = new ImageButton(x2, y1, is, is, dolo, dohi, dodo);
  myFont = loadFont("RotisSanSer-Bold.vlw.gz");
  setFont(myFont,14);
  fx = bo*3 + is*2;
  fy = height - bo - is;
  mods = new Module[num];
  mods2 = new Module[num];
  for (int i=0;i<num;i++){
    int qq = q[(int)(random(2))];// 1 or -1 for direction
    mods[i] = new Module(i, random(width), random(height), random(360), random(10,40), qq);//i, x, y, angle, radius, direction, color
    mods2[i] = new Module(i, mods[i].x, mods[i].y, mods[i].myAngle, 0, mods[i].dir);//i, x, y, angle, radius, direction, color
  }
if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height){initialized = true;}
  num = 50;
  colorMode(RGB, num);
  cleanUp();
}

void loop(){
  noSmooth();
  fill(num);
  button.update();
  button2.update();
  button.display();
  button2.display();
  fill(0);
  rect(fx,fy,22,11);
  smooth();
  fill(num);// white
  String txt = nf(num,0);
  text(txt, fx+2, fy+9);
  if (!initialized){
  if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height){initialized = true;}// end if
  }
  if(initialized == true){
    for (int i=0;i<num;i++){
      Module M = mods[i];
      Module M2 = mods2[i];
      M.updateMe();
      M2.updateMe2();
      M2.connectMe2();
      if (M.x < 0 || M.x > width || M.y < 0 || M.y > height){
        M.x = mouseX;
        M.y = mouseY;
        M2.x = mods[i].x;
        M2.y = mods[i].y;
        M.myAngle = random(360);
        M2.myAngle = M.myAngle;
        M.myRadius = random(10,40);
        M2.myRadius = M.myRadius+i*i;
      }
    }
  }
}

class Module{
  int i;
  float x, y, myAngle, myRadius, dir;
  float mh, mv, mdif;
  float xxx, yyy, xxxx, yyyy;
  float dh, dv, ddif;
  float mx = width/2;
  float my = height/2;
  Module(int spriteNum, float xx, float yy, float deg, float rad, float pp){
    i = spriteNum;
    x = xx;
    y = yy;
    myAngle = deg;
    myRadius = rad;
    dir = pp;
    mh = 0;
    mv = 0;
    mdif = 0;
  }
  void updateMe(){
    mh = x - mouseX;
    mv = y - mouseY;
    mdif = sqrt(mh*mh+mv*mv);
    dh = width/2 - mouseX;
    dv = height/2 - mouseY;
    ddif = sqrt(dh*dh+dv*dv);
    if(dir == 1){
      myAngle +=  abs(ddif - mdif)/50.00f;
    }else{
      myAngle -=  abs(ddif - mdif)/50.00f;
    }
    myRadius +=  mdif/100.00f;
    if(myRadius > width){
      myRadius = random(10,40);
    }
    if(abs(mouseX - mx ) > 1) {
      mx += (mouseX - mx)/delay;
    }
    if(abs(mouseY - my) > 1) {
      my += (mouseY - my)/delay;
    }
    x = mx + (myRadius * cos(myAngle * PI/180));
    y = my + (myRadius * sin(myAngle * PI/180));
    stroke(num/(i+1), num/(i+1), num/(i+1));
    point(x,y);
  }

  void updateMe2(){
    mh = x - mouseX;
    mv = x - mouseY;
    mdif = sqrt(mh*mh+mv*mv);
    dh = width/2 - mouseX;
    dv = height/2 - mouseY;
    ddif = sqrt(dh*dh+dv*dv);
    for (int i=0;i<num;i++){
      mods2[i].myAngle = mods[i].myAngle;
      mods2[i].myRadius = mods[i].myRadius+i;
    }
    if(abs(mouseX - mx ) > 1) {
      mx += (mouseX - mx)/delay;
    }
    if(abs(mouseY - my) > 1) {
      my += (mouseY - my)/delay;
    }
    x = mx + (myRadius * cos(myAngle * PI/180));
    y = my + (myRadius * sin(myAngle * PI/180));
    stroke(num/2, num/2, num/2);
    point(x,y);
  }

  void connectMe2(){
    xxx = mods[i].x;
    yyy = mods[i].y;
    xxxx = mods2[i].x;
    yyyy = mods2[i].y;
    noStroke();
    fill (0, num/7.0f, num/(i+1)+num/4.f, 20);
    beginShape(QUADS);
    vertex(xxx,yyy);
    vertex(xxx+1,yyy+1);
    vertex(xxxx,yyyy);
    vertex(xxxx+1,yyyy+1);
    endShape();
  }
}

void mousePressed(){
  for(int i=0;i<num;i++){
    mods[i].x = random(width);
    mods[i].y = random(height);
    mods[i].myAngle = random(360);
    mods2[i].myAngle = mods[i].myAngle;
    mods[i].myRadius = random(10,40);
    mods2[i].myRadius = mods[i].myRadius+i*i;
  }
  clearScreen = true;
  cleanUp();
}

void cleanUp()
{
  if(clearScreen) {
    fill(num);
    noStroke();
    rect(0,0, width, height-is-bo);
    rect(0,height-is-bo, bo, is);
    rect(bo+is,height-is-bo, bo, is);
    rect(bo*2+is*2,height-is-bo, bo, is);
    rect(bo*3+is*4,height-is-bo, width - bo*3+is*4, is);
    rect(0,height-bo, width, bo);
    clearScreen = false;
  }
}

class Button
{
  int x, y;
  int w, h;
  boolean over = false;
  boolean pressed = false;

  void pressed()
  {
    if(over && mousePressed) {
      pressed = true;
    } else {
      pressed = false;
    }
  }
}

class ImageButton extends Button
{
  BImage uplo;
  BImage uphi;
  BImage updo;
  BImage currentimage;
  ImageButton(int _x1, int _y1, int _w, int _h, BImage _uplo, BImage _uphi, BImage _updo)
  {
    x = _x1;
    y = _y1;
    w = _w;
    h = _h;
    uplo = _uplo;
    uphi = _uphi;
    updo = _updo;
    currentimage = uplo;
  }

  void update()
  {
    over();
    pressed();
    if(pressed) {
      currentimage = updo;
      if (x == bo){
      if (num < 300){num = num + 10;}
        colorMode(RGB, num);
      }else{
      if (num >= 20){ num = num - 10;}
        colorMode(RGB, num);
      }
    } else if (over){
      currentimage = uphi;
    } else {
      currentimage = uplo;
    }
  }

  void over()
  {
    if( overRect(x, y, w, h) ) {
      over = true;
    } else {
      over = false;
    }
  }

  void display()
  {
    image(currentimage, x, y);
  }
}

boolean overRect(int x, int y, int width, int height)
{
  if (mouseX >= x && mouseX <= x+width &&
  mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
