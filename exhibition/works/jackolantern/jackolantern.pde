// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// Jack O Lantern
// Elise Co
// October 2003

// Pumpkin-feeding candy game
// Use an off-the-shelf serial LCD module for bonus pumpkin friend!
// Uses serial LCD module BPK216 from www.seetron.com

//boolean SERIAL = true;

byte[] message1 = {' ', ' ', ' ', ' ', ' ', 'H','a','p','p','y', ' ', ' ', ' ', ' ', ' ', ' '};
byte[] message2 = {' ', ' ', 'H','a','l','l','o','w','e','e','n','!','!','!', ' ', ' '};

//ascii pumpkins
String asciijack = "         ,_   .-.      \n         \\ `\\/ '`     \n    _.--'|  |'--._    \n  .' /  /`--`\\  \\ '.  \n /  ;  /\\    /\\  ;  \\ \n;  |  /__\\  /__\\  |  ;\n|  |   |  /\\  |   |  |\n;  |   ; '--' ;   |  ;\n \\  ;'\\/''\\/''\\/';  / \n  '._\\\\_/\\__/\\_//_.'  \n     `'--'--'--'`     \n";
String asciijack2 = "         ,_   .-.      \n         \\ `\\/ '`     \n    _.--'|  |'--._    \n  .' /  /`--`\\  \\ '.  \n /  ;  /\\    /\\  ;  \\ \n;  |  /__\\  /__\\  |  ;\n|  |   |  /\\  |   |  |\n;  |   ; '--' ;   |  ;\n \\  ;\\/\\/\\/\\/\\/\\/;  / \n  '._ \\\\/\\/\\/\\/\\/_.'  \n     `'--'--'--'`     \n";

BFont ocr;
BImage begin;
int beginmillis = 0;

boolean playing = false;

pumpkin jack;
ship feeder;
int MAXCANDY = 15;
candy[] candies = new candy[MAXCANDY];
int ncandy = 0;

void setup() {
  size(400, 400);

  /*
  if (SERIAL) {
    beginSerial(); //default 9600; set DIP switch on lcd to 9600
    for (int i=0;i<4;i++) {
      serialWrite(254); //sending a command to LCD
      serialWrite(96+i*8); //getting correct memory address to write custom characters
      serialWrite(customs[i]); //loading custom characters
    }
  }

  clearlcd();
  */
  ocr = loadFont("OCR-B.vlw.gz");
  begin = loadImage("staticjack.jpg");

  jack = new pumpkin(0, 0);
  feeder = new ship(200, 340);
  for (int i=0;i<MAXCANDY;i++) {
    candies[i] = new candy((8+(MAXCANDY-1)*20)-i*20, 380);
  }
}

boolean gameover = false;
int score = 0;

String[] levels = {"li'l boo", "ghoul", "ghost", "specter", "phantasm"};
String level;

void loop()
{
  if(playing == false) {
  
    background(begin);
    textFont(ocr, 24);
    fill(234, 195, 11);
    text("click to begin!", 18, 45);
  
  } else {
  
    //background(0, 0, 60);
    background(12, 21, 44);

    if (millis() < beginmillis+4000) { //display instructions for the first 4 seconds of game
      noStroke();
      //fill(0, 255, 0);
      fill(234, 195, 11);
      textFont(ocr, 20);
      text("this pumpkin is hungry!", 18, 220);
      textFont(ocr, 18);
      text("use 'a' and 's' keys to move\npress any other key to launch candy", 18, 250);
    }

    // Base Line
    stroke(102, 102, 102);
    line(0, 370, 400, 370);

    for (int i=0;i<MAXCANDY;i++) {
      if(candies[i].swallowed==false && jack.swallow(candies[i].myx, candies[i].myy)) {
        candies[i].swallowed = true;
        score++;
      }
      if (candies[i].swallowed == true) {
        candies[i].draw();
      }
    }
    //draw background rect for eaten candies to pass under
    noStroke();
    //fill(0, 0, 60);
    fill(12, 21, 44);
    rect(0, 0, 400, 109+jack.myy);
    jack.draw();
    for (int i=0;i<MAXCANDY;i++) {
      if (candies[i].swallowed == false) {
        candies[i].draw();
      }
    }
    feeder.draw();
    if (candies[MAXCANDY-1].myy<-10) {//all out of candy
      gameover = true;
    }
    if (gameover) {
      noStroke();
      //fill(255, 0, 0);
      fill(227, 67, 18);
      textFont(ocr, 24);
      if (score == MAXCANDY) level="dracula";
      else  level = levels[score/(MAXCANDY/5)];
      text("final score: " + nf(score, 2) + "\nhappy halloween, " + level + "!!!", 18, 250);
      textFont(ocr, 15);
      text("press spacebar to reset", 18, 300);

      if (keyPressed && key == 32) {
        reset();
        gameover = false;
      }
      /*
      if (SERIAL) {
        serialWrite(254);
        serialWrite(128);
        serialWrite(message1);
        serialWrite(254);
        serialWrite(192);
        serialWrite(message2);
      }
      */
    }
    else {
      /*
      if (SERIAL) {
        if (!jack.openmouth) {
          closemouth();
        }
        else {
          drawteeth();
        }
      }
      */
    }
    noStroke();
    fill(204, 204, 204);
    textFont(ocr, 30);
    text(nf(score, 2), 350, 370);
  }
}

void reset() {
  for (int i=0;i<MAXCANDY;i++) {

    candies[i].set(20+i*20, 380);
    candies[i].myangle = 0;
    candies[i].swallowed = false;
    candies[i].speed = 0;
    candies[i].rspeed = 0;
    score = 0;
    ncandy = 0;
  }

}

class pumpkin
{
  float myx;
  float myy;
  float lastx;
  float lasty;
  float mark;
  float targett;
  float targetx;
  float targety;
  boolean openmouth;
  float moutht;
  boolean still;

  //pumpkin is about 171 pixels wide

  pumpkin(int x, int y) {
    myx = x;
    myy = y;
    targety = 30;
    openmouth = false;
    still = true;
    moutht = millis();
  }

  void moveTo(float tx, float ty, float t) {
    lastx = myx;
    lasty = myy;
    targetx = tx;
    targety = ty;
    mark = millis();
    targett = t;
    still = false;

  }

  void updatePos() {
    if (still == true) return;
    float m = millis();
    if (m>=targett+mark) {
      still = true;
      return;
    }
    float step = (m-mark)/targett;
    myx = interpolate(step, lastx, targetx);
    myy = interpolate(step, lasty, targety);
  }

  void draw() {
    updatePos();
    float m = millis();
    if (m>moutht) {
      if (openmouth) {
        moutht = m+random(500, 2500);
        openmouth = false;
      }
      else {
        moutht = m+random(200, 1500);
        openmouth = true;
      }
    }
    if (jack.still) {
      jack.moveTo(random(230), random(50), random(1000, 4000));
    }

    noStroke();
    fill(255, 150, 20);
    textFont(ocr, 15);

    if (!openmouth) {
      text(asciijack2, myx, myy);
    }
    else {
      text(asciijack, myx, myy);
    }
  }

  boolean swallow(float x, float y) {
    if (openmouth && hitRect(x, y, 45+myx, 98+myy, 85, 22)) {
      return true;
    }
    else {
      return false;
    }
  }

}

class candy
{
  float myx;
  float myy;
  float speed;
  boolean swallowed;
  color mycolor;
  float myangle;
  float rspeed;

  candy(float x, float y) {
    mycolor = color(random(255), random(255), random(255));
    myx = x;
    myy = y;
    speed = 0;
    myangle = 0;
    rspeed = 0;
    swallowed = false;
  }

  void draw() {
    if (myy > -20) { //don't need to draw/update off-screen guys
      myy -= speed;
      myangle+=rspeed;

      noStroke();
      push();
      translate(myx, myy);
      rotate(myangle);
      fill(mycolor);
      fill(255, 115, 0);
      quad(0, 0, 4, 0, 6, 12, -2, 12);
      fill(255, 255, 0);
      quad(0, 0, 4, 0, 5.4, 8, -1.4, 8);
      fill(255, 255, 255);
      quad(0, 0, 4, 0, 4.7, 4, -0.7, 4);
      pop();
    }
  }

  void set(float x, float y) {
    myx = x;
    myy = y;
    if (random(10)>5) rspeed = random(0.08, 0.12);
    else rspeed = -random(0.08, 0.12);
    speed = 10;
  }
}

class ship
{
  float myx;
  float myy;
  float mark;

  ship(float x, float y) {
    myx = x;
    myy = y;
    mark = millis();
  }

  void draw() {
    if (keyPressed) {
      if (key == 'S' || key == 's') {//move right
        if (myx < 390) myx+=7;
      }
      else if (key == 'A' || key == 'a') {//move left
        if (myx>10) myx-=7;
      }
      else { //shoot
        float m = millis();
        if (ncandy<MAXCANDY && m>mark) {
          candies[ncandy].set(myx+2, myy);
          ncandy++;
          mark = m+300; //limit shot frequency
        }
      }
    }
    fill(255, 255, 255);
    //stroke(255, 0, 0);
    noStroke();
    rect(myx, myy, 10, 30);

  }

}

void mousePressed() 
{
  if(playing == false) {
    playing = true;
    beginmillis = millis();
  }
}

float interpolate(float step, float start, float end) {
  return (start+(end-start)*step);
}

boolean hitRect(float tx, float ty, float x, float y, int width, int height)
{
  if (tx >= x && tx <= x+width &&
  ty >= y && ty <= y+height) {
    //print("hit rect\n");
    return true;
  } else {
    return false;
  }
}

/*

// Uncomment the code from here to the end of the page
// to draw on the LCD of the real pumpkin

//lcd drawing functions

void clearlcd() {
  serialWrite(254);//command byte
  serialWrite(1); //clear screen
}

//draw a 2-line motif at a position on the lcd
void drawlcd(int pos, byte[] d1, byte[] d2) { //pos is place on lcd to draw [0-15], arrays are LCD character-code(ascii/custom) sequences
  serialWrite(254);
  serialWrite(128+pos);//position cursor on line1
  serialWrite(d1);//motif line 1
  serialWrite(254);
  serialWrite(192+pos);//position cursor on line2
  serialWrite(d2);//motif line 2
}

//draw a 1-line motif at a position/line on the lcd
void drawlcd(int pos, int line, byte[]d) {
  serialWrite(254);
  if (line == 0) serialWrite(128+pos);
  else serialWrite(192+pos);
  serialWrite(d);//motif
}

//lcd functions for different jackolantern features, using preset arrays

// 1 1 1 1 1  31    3+4=7
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 0  30
// 1 1 1 0 0  28
// 1 1 0 0 1  25
byte[] custom7 = {31, 31, 31, 31, 31, 30, 28, 25};

// 1 0 0 1 1  19    0+4=4
// 0 0 1 1 1  7
// 0 1 1 1 1  15
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
byte[] custom4 = {19, 7, 15, 31, 31, 31, 31, 31};

// 1 1 1 1 1  31    2+1 = 6
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 0 1 1 1 1  15
// 0 0 1 1 1  7
// 1 0 0 1 1  19
byte[] custom6 = {31, 31, 31, 31, 31, 15, 7, 19};

// 1 1 0 0 1  25    1+4 = 5
// 1 1 1 0 0  28
// 1 1 1 1 0  30
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
// 1 1 1 1 1  31
byte[] custom5 = {25, 28, 30, 31, 31, 31, 31, 31};

byte[][] customs = {custom4, custom5, custom6, custom7};

byte curs = (byte)255;
//LCDascii character sequences for different pumpkin features
//final version uses teeth and chomping teeth

//triangle eyes
byte[] fulleye1 = { ' ', 0, 1, ' '};
byte[] fulleye2 = { 0, curs, curs, 1};

//upside-down large V
byte[] winkeye1 = { ' ', 0, 1, ' '};
byte[] winkeye2 = { 0, 3, 2, 1};

//large V
byte[] veye1 = {2, 1, 0, 3};
byte[] veye2 = { ' ', 2, 3, ' '};

//small vs
byte[] vup1 = { 1, 0};
byte[] vup2 = { 2, 3};
byte[] vdown1 = {0, 1};
byte[] vdown2 = {3, 2};

byte[] blank = {' '};
byte[] filler = {curs};

//triangle teeth
byte[] tooth1 = {2, 3};
byte[] tooth2 = {1, 0};
byte[] tooth3 = {0, 1};

//chomping teeth (using custom loaded characters)
byte[] toothy1 = {6, 7};
byte[] toothy2 = {5, 4};
byte[] toothy3 = {4, 5};

void drawteeth() {
  for (int i=0;i<16;i+=2) {
    drawlcd(i, 0, tooth1);
  }
  for (int i=1;i<15;i+=2) {
    drawlcd(i, 1, tooth3);
  }
}

void closemouth() {
  for (int i=0;i<16;i+=2) {
    drawlcd(i, 0, toothy1);
  }
  for (int i=1;i<15;i+=2) {
    drawlcd(i, 1, toothy3);
  }
}

*/
