/*

WWW.ORTHO-TYPE.IT

- Mikkel Crone Koser
- Enrico Bravi
- Paolo Palma

(c) 2004-2005

*/

int typeSize = 4;
int oldTypeSize = typeSize;
int h;
int w;
int d;
float lineStrength = 18;//(typeSize/2);
int numLettersOnscreen = 20;

ColorPick palette;

int letter = 0;
int[] curString = new int[numLettersOnscreen];
Letter[] chars = new Letter[numLettersOnscreen];

//String sourceString = "!#$%&'()*+,-./:;=?@[]_{}~ó€ƒ£?¤©È?????";
//String sourceString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789";
//String sourceString = "abcdefghijklmnopqrstuvwxyz !?*+-=@$£%&()";
//String sourceString = "ORTHO-TYPE.IT";
String sourceString = "Processing";

Rotater pov;
LineSize lineSizer;

int keycode;
int activeChar = -1;
int nextCharHilite = activeChar+1;

boolean topBtm = true;
boolean leftRight = true;
boolean frontBack = true;

int showCursorCounter = 0;

Hslider letterHeightSlider = new Hslider(645, 10, 50, 14, 25);
int letterHeight = h;
int oldLetterHeight = h;

Hslider letterWidthSlider = new Hslider(645, 28, 50, 14, 25);
int letterWidth = w;
int oldLetterWidth = w;

Hslider letterDepthSlider = new Hslider(645, 46, 50, 14, 25);
int letterDepth = d;
int oldLetterDepth = d;

Vslider letterSizeSlider = new Vslider(505, 10, 14, 50, 28);

IconButton btnLeft, btnRight, btnTop;

ColorChooser ccLeft, ccRight, ccTop;// = new ColorChooser(100, 50, 14, 14, "colors2.jpg");

/*
AIExport ai; // illustrator export object
*/

void setup(){
  size(760, 360);
  background(0);
  ellipseMode(CENTER_DIAMETER);
  rectMode(CENTER_DIAMETER);
  stroke(255);
  fill(200, 0, 0);

  pov = new Rotater(450, 10, 50, 50);
  lineSizer = new LineSize(700, 10, 50, 20);
  palette = new ColorPick(1000, 10, 50, 50);

  btnTop = new IconButton(585, 10, 14, 14, "top.gif", "top_off.gif");
  btnLeft = new IconButton(585, 28, 14, 14, "left.gif", "left_off.gif");
  btnRight = new IconButton(585, 46, 14, 14, "right.gif", "right_off.gif");

  ccTop = new ColorChooser(565, 10, 14, 14, "colors2.jpg", palette.dark);
  ccRight = new ColorChooser(565, 28, 14, 14, "colors2.jpg", palette.medium);
  ccLeft = new ColorChooser(565, 46, 14, 14, "colors2.jpg", palette.light);

  for(int i=0; i<numLettersOnscreen; i++){
    // create empty SPACE (ascii 32)
    curString[i] = 32;

    // look in sourceString for what letters to assign
    if(i < sourceString.length()){
      curString[i] = (int)sourceString.charAt(i);
    }

    // add char to chars-array (all letters on screen ... objects)i
    int tmpX = (7*typeSize)+i*(9*typeSize);

    chars[i] = new Letter(tmpX, 100, 0, curString[i]);
  }

  for(int i=0; i<numLettersOnscreen; i++){
  }

  // start Illustrator exporter
  //println("press 's' to grab the frame you want to save for illustrator");
  //println("...thren press 'd' to actually save the file");
  /*
  ai = new AIExport( this, 1 );
  */
}

void mousePressed(){
  // POV
  if(mouseX > pov.x && mouseX < pov.x+pov.w && mouseY > pov.y && mouseY < pov.y+pov.h) pov.active = true;

  // LINESIZER
  if(dist(lineSizer.x + lineSizer.dim/2, lineSizer.y + lineSizer.dim/2, mouseX, mouseY) < lineSizer.lineSize) lineSizer.active = true;

  // LETTER_SIZE_SLIDER
  letterSizeSlider.mouseCheck();

  // LETTER HEIGHT SLIDER
  letterHeightSlider.mouseCheck();

  // LETTER WIDTH SLIDER
  letterWidthSlider.mouseCheck();

  // LETTER DEPTH SLIDER
  letterDepthSlider.mouseCheck();

  // ICON BUTTONS --> turning sides on/off
  btnTop.mouseCheck();   topBtm = btnTop.active;
  btnLeft.mouseCheck();  leftRight = btnLeft.active;
  btnRight.mouseCheck(); frontBack = btnRight.active;
}

void mouseReleased(){
  pov.active = false;
  lineSizer.active = false;
  letterSizeSlider.active = false;
  letterHeightSlider.active = false;
  letterWidthSlider.active = false;
  letterDepthSlider.active = false;
  ccLeft.mouseClick();
  ccRight.mouseClick();
  ccTop.mouseClick();
}

void loop(){
  background(255, 255, 255);

  if(activeChar != -1){
    curString[activeChar] = keycode;
    chars[activeChar].charNum = curString[activeChar];
  }

  nextCharHilite = activeChar+1;
  if(nextCharHilite >= numLettersOnscreen){
    nextCharHilite = 0;
  }

  //rect((7*typeSize)+nextCharHilite*(9*typeSize), (100-(typeSize*2)) + (typeSize*6), 8*typeSize, 10*typeSize);

  //char-cursor
  fill(0, 0, 0);
  showCursorCounter++;
  if(showCursorCounter < 15){
    rect((7*typeSize)+nextCharHilite*(9*typeSize), 100+4*typeSize + (typeSize*(letterHeight-3)), 8*typeSize, 1);//typeSize);
  }else if(showCursorCounter > 30){
    showCursorCounter = 0;
  }

  /*
  ai.setLayer( 1 );
  noStroke();
  fill( 200, 0, 0 );
  */

  pov.update();
  lineSizer.update();
  lineStrength = lineSizer.getLineSize();

  //palette.update();
  palette.light = ccLeft.clr;
  palette.medium = ccRight.clr;
  palette.dark = ccTop.clr;

  //lineStrength = (float)lineSizer.lineSize;
  // CHECK SIZE
  letterSizeSlider.update();
  oldTypeSize = typeSize;
  typeSize = (int)(20 * ((100 - letterSizeSlider.getVal())/100f));
  if(oldTypeSize != typeSize){
    buildGrid();
  }

  // CHECK HEIGHT
  letterHeightSlider.update();
  oldLetterHeight = letterHeight;
  letterHeight = (int)(18 * (letterHeightSlider.getVal()/100f));
  if(oldLetterHeight != letterHeight){
    buildGrid();
  }

  // CHECK WIDTH
  letterWidthSlider.update();
  oldLetterWidth = letterWidth;
  letterWidth = (int)(10 * (letterWidthSlider.getVal()/100f));
  if(oldLetterWidth != letterWidth){
    buildGrid();
  }

  // CHECK DEPTH
  letterDepthSlider.update();
  oldLetterDepth = letterDepth;
  letterDepth = (int)(10 * (letterDepthSlider.getVal()/100f));
  if(oldLetterDepth != letterDepth){
    buildGrid();
  }

  // RENDER CHARS
  for(int i=0; i<numLettersOnscreen; i++){
    chars[i].changeRotation(pov.getRotX(), pov.getRotY());
    chars[i].render();
  }

  // RENDER SIDE-BUTTONS ... turning sides on/off
  btnLeft.render();
  btnRight.render();
  btnTop.render();

  // COLOURCHOOSER FOR SIDE-BUTTONS
  ccLeft.update();
  ccRight.update();
  ccTop.update();
}

/*
void keyPressed(){
  if( key=='e' ) ai.exportOneFrame();
  if( key=='s' ) ai.takeSnapShot();
  if( key=='d' ) ai.dumpSnapShots();
  if( key=='r' ) ai.toggleContinuousRecording();
}
*/

/*
public void keyPressed(java.awt.event.KeyEvent e){
  keycode = e.getKeyChar();

  if(key != SHIFT){
    activeChar++;
    if(activeChar >= numLettersOnscreen){
      activeChar = 0;
    }
  }
}
*/

void keyPressed(){
  showCursorCounter = 0;

  if((int)key >= 32 && (int)key != 37 && (int)key != 39){
    keycode = (int)key;
    activeChar++;
    if(activeChar >= numLettersOnscreen){
      activeChar = 0;
    }
  }

  if((int)key == 8){ // BACKSPACE
    activeChar--;
    activeChar = max(activeChar, -1);
    keycode = chars[max(activeChar, 0)].charNum;
    chars[activeChar+1].charNum = 32;
  }

  if((int)key == 37){ // LEFT
    activeChar--;
    activeChar = max(activeChar, -1);
    keycode = chars[max(activeChar, 0)].charNum;
  }

  if((int)key == 39){ // RIGHT
    activeChar++;
    activeChar = min(activeChar, numLettersOnscreen-2);
    keycode = chars[activeChar].charNum;
  }
}

void keyReleased(){
  //keyActive = false;

}

void keyboardListener(){
  //sourceString.char[0] = char(keycode);
}

class ColorChooser{
  /* INTERFACE

  CONSTRUCT: 
  ColorChooser c = new ColorChooser(100, 50, 14, 14, "colors2.jpg");

  LOOP:
  c.update();

  MOUSEPRESSED:
  c.mouseClick();

  GET COLOUR VALUE
  c.getColor();       // return a color
  */

  int x, y, w, h;
  int palH = 50;
  int palW = 50;
  boolean rollOver = false;
  color clr;
  BImage myPalette;

  ColorChooser(int x, int y, int w, int h, String pal, color initCol){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    myPalette = loadImage("colors2.jpg");
    clr = initCol;
  }

  void setColor(color newColor){
    clr = newColor;
  }

  void update(){
    // set drawing mode for this class
    rectMode(CORNER);
    checkRollOver();

    drawSmall();

    if(rollOver){
      drawLarge();
    }

    if(rollOver){
      // get color from pixel
      if(mouseX > x-palW && mouseX < x && mouseY > y && mouseY < y+palH){
        clr = get(mouseX, mouseY);
      }
    }

    // reset RECT drawing mode
    rectMode(CENTER_DIAMETER);
  }

  color getColor(){
    return clr;
  }

  void mouseClick(){
    rollOver = false;
  }

  void drawSmall(){
    fill(clr);
    stroke(0);
    rect(x, y, w, h);
  }

  void drawLarge(){
    image(myPalette, x-palW, y);
    noFill();
    rect(x-palW, y, palW, palH);
  }

  void checkRollOver(){
    // show colour-area?
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      rollOver = true;
    }

    // outside area?
    if(mouseX < x-palW || mouseX > x+w || mouseY < y || mouseY > y+palH){
      rollOver = false;
    }
    if(mouseX > x && mouseY > y+h){
      rollOver = false;
    }
  }
}

class IconButton{
  /*
  EFFECTIVELY A RADIOBUTTON CLASS

  CONSTRUCT:
  IconButton btn = new IconButton(100, 100, 14, 14, "left.gif", "left_off.gif");

  LOOP:
  btn.render();

  MOUSEPRESSED:
  btn.mouseCheck();

  h.active // tells the state of the button
  */

  int x, y, w, h;
  boolean active = true;
  BImage icoOn, icoOff;

  IconButton(int x, int y, int w, int h, String icoOnFile, String icoOffFile){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    icoOn = loadImage(icoOnFile);
    icoOff = loadImage(icoOffFile);
  }

  void render(){
    if(active){
      image(icoOn, x, y);
    }else{
      image(icoOff, x, y);
    }
  }

  void mouseCheck(){
    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      active = !active;
    }
  }
}

class Hslider{
  /*
  CONSTRUCT:
  Hslider h = new Hslider(130, 80, 50, 50, 25);

  LOOP:
  h.update();

  MOUSEPRESSED:
  h.mouseCheck();

  MOUSERELEAED:
  h.active = false;

  h.getVal() // returns FLOAT percentage 0-100
  */
  int x, y, w, h, val;
  boolean active = false;

  Hslider(int x, int y, int w, int h, int val){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.val = x+val;
  }

  void mouseCheck(){
    if(mouseY > y && mouseY < y+h){
      if(mouseX > (val)-10 && mouseX < (val)+10) active = true;
    }
  }

  void update(){
    if(active){
      val = mouseX;
      val = max(x, val);
      val = min(x+w, val);
    }

    render();
  }

  void render(){

    noStroke();

    fill(palette.light);
    rectMode(CORNER);
    rect(x, y, val-x, h);

    // dragger
    stroke(0);
    fill(255, 255, 255);
    line(val, y, val, y+h);
    rect(val-1, y, 2, 2);
    rect(val-1, y+h-2, 2, 2);

    // outer rext
    stroke(0);
    noFill();
    rectMode(CENTER_DIAMETER);
    rect(x+w/2, y+h/2, w, h);
  }

  float getVal(){ // returns percentage of width
    return ((float)(val-x) / float(w))*100f;
  }
}

class Vslider{
  /*
  CONSTRUCT:
  Vslider v = new Vslider(130, 80, 50, 50, 25);

  LOOP:
  v.update();

  MOUSEPRESSED:
  v.mouseCheck();

  MOUSERELEAED:
  v.active = false;

  GET VALUE
  v.getVal() // returns FLOAT percentage 0-100
  */
  int x, y, w, h, val;
  boolean active = false;

  Vslider(int x, int y, int w, int h, int val){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.val = y+val;
  }

  void mouseCheck(){
    if(mouseX > x && mouseX < x+w){
      if(mouseY > (val)-10 && mouseY < (val)+10) active = true;
    }
  }

  void update(){
    if(active){
      val = mouseY;
      val = max(y, val);
      val = min(y+h, val);
    }

    render();
  }

  void render(){

    noStroke();

    fill(palette.light);
    beginShape(POLYGON);
    vertex(x, val);
    vertex(x+w, val);
    vertex(x+w, y+h);
    vertex(x, y+h);
    endShape();

    // dragger
    stroke(0);
    fill(255, 255, 255);

    line(x, val, x+w, val);
    rect(x+1, val, 2, 2);
    rect(x+w-1, val, 2, 2);

    // outer rext
    stroke(0);
    noFill();
    rectMode(CENTER_DIAMETER);
    rect(x+w/2, y+h/2, w, h);
  }

  float getVal(){ // returns percentage of width
    return ((float)(val-y) / float(h))*100f;
  }
}

class LineSize{
  /*
  CONSTRUCT:
  lineSizer = new LineSize(200, 200, 50, 10);

  LOOP:
  lineSizer.update();

  MOUSEPRESSED:
  if(dist(lineSizer.x + lineSizer.dim/2, lineSizer.y + lineSizer.dim/2, mouseX, mouseY) < lineSizer.lineSize) lineSizer.active = true;

  MOUSERELEASED:
  lineSizer.active = false;
  */

  int x, y, dim;
  int lineSize;
  boolean active = false;

  LineSize(int x, int y, int dim, int lineSize){
    this.x = x;
    this.y = y;
    this.dim = dim;
    this.lineSize = lineSize;
  }

  void update(){
    if(active){
      int newSize = (int)dist(lineSizer.x + lineSizer.dim/2, lineSizer.y + lineSizer.dim/2, mouseX, mouseY);
      newSize = min(newSize, dim);

      lineSize = newSize;
    }

    // DRAW GRID
    stroke(204, 204, 204);
    for(int j=0; j<=dim; j+= (dim/10)){
      for(int i=0; i<=dim; i+= (dim/10)){
        point(x+i, y+j);
      }
    }

    // dimension reader
    stroke(64, 64, 64);
    fill(palette.light);
    rect(x + dim/2, y + dim/2, lineSize, lineSize);

    stroke(0);
    noFill();
    rectMode(CORNER);
    rect(x, y, dim, dim);
    rectMode(CENTER_DIAMETER);
  }

  float getLineSize(){
    return ((float)lineSize / (float)w) * max((typeSize * typeSize/5f), 1);
  }
}

class ColorPick{
  /*
  INTERFACING THIS CLASS
  ----------------------
  init:
  ColorPick palette;
  palette = new ColorPick(100, 100, 50, 50);

  loop:
  palette.update();

  fetch information:
  fill(palette.light);
  fill(palette.medium);
  fill(palette.dark);
  */

  int x, y, w, h;
  boolean active;
  BImage source;
  color light, medium, dark;

  ColorPick(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    medium = color(132, 139, 116);
    calcColors();
    source = loadImage("colors2.jpg");
  }

  void calcColors(){
    light = color(red(medium)*1.2, green(medium)*1.2, blue(medium)*1.2);
    dark = color(red(medium)*0.8, green(medium)*0.8, blue(medium)*0.8);
  }

  void update(){
    image(source, x, y);
    stroke(0);
    noFill();
    rect(x+w/2, y+h/2, w, h);

    if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h){
      if(mousePressed){
        medium = get(mouseX, mouseY);
        this.calcColors();
      }
    }
  }
}

class Rotater{
  /*

  CONSTRUCT:
  Rotater pov = new Rotater(x, y, w, h);

  LOOP:
  pov.update();

  MOUSEPRESS:
  if(dist(mouseX, mouseY, pov.eye.x, pov.eye.y) < 10){
    pov.active = true;
  }

  MOUSERELEASE:
  pov.active = false;

  GET ROTATION DATA:
  pov.getRotX()      <------ returns a percentage (0f -100f)
  pov.getRotY()      <------ returns a percentage (0f -100f)

  */

  int x, y;
  int w, h;
  Point eye;
  FPoint teye;

  boolean active = false;

  Rotater(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    eye = new Point(x + w/2, y + h/2);
    teye = new FPoint(float(x + w/2), float(y + h/2));
  }

  void update(){
    if(pov.active){
      eye.x = mouseX;
      eye.y = mouseY;

      teye.x += (eye.x - teye.x)/5f;
      teye.y += (eye.y - teye.y)/5f;

      teye.x = min(x+w, teye.x);
      teye.x = max(x, teye.x);

      teye.y = min(y+h, teye.y);
      teye.y = max(y, teye.y);
    }

    this.render();
  }

  float getRotY(){
    return ((float)(teye.x - x)/(float)w)*100f;
  }

  float getRotX(){
    return -((float)((h-teye.y) - y)/(float)h)*100f;
  }

  void render(){
    stroke(255);

    // BOTTOM
    fill(palette.dark);
    beginShape(POLYGON);
    vertex(x, y+h);
    vertex(x+w, y+h);
    vertex(teye.x, teye.y);
    vertex(x, y+h);
    endShape();

    // RIGHT
    fill(palette.light);
    beginShape(POLYGON);
    vertex(teye.x, y);
    vertex(x+w, y);
    vertex(x+w, y+h);
    vertex(teye.x, teye.y);
    vertex(teye.x, y);
    endShape();

    // LEFT
    fill(palette.medium);
    beginShape(POLYGON);
    vertex(teye.x, y);
    vertex(teye.x, teye.y);
    vertex(x, y+h);
    vertex(x, y);
    vertex(teye.x, y);
    endShape();

    /* DOT */
    if(active){
      fill(palette.light);
      rect(teye.x, teye.y, 6, 6);
    }else{
      fill(palette.dark);
      rect(teye.x, teye.y, 4, 4);
    }

    rectMode(CORNER);
    stroke(0);
    noFill();
    rect(x, y, w, h);
    rectMode(CENTER_DIAMETER);
  }
  class FPoint{
    float x, y;

    FPoint(float fx, float fy){
      x = fx;
      y = fy;
    }
  }
}

class Letter{
  int x, y, z;
  int charNum;
  float targetRotY = 0f;
  float targetRotX = 0f;
  float curRotY = 0f;
  float curRotX = 0f;
  float rotSpeed = 10f;

  Letter(int x, int y, int z, int charNum){
    this.x = x;
    this.y = y;
    this.z = z;
    this.charNum = charNum;
  }

  void render(){
    noStroke();
    fill(200, 0, 0);

    if(curRotY != targetRotY) curRotY += (targetRotY - curRotY)/rotSpeed;
    if(curRotX != targetRotX) curRotX += (targetRotX - curRotX)/rotSpeed;

    beginCamera();
    ortho(-(width/2) ,(width/2), -(height/2), (height/2), 100, -100);
    translate(x, y, z);
    translate(-width/2, -height/2, 0);
    rotateX(radians(curRotX));
    rotateY(radians(curRotY));
    endCamera();

    drawLetter(charNum);
  }

  /*
  void changeRotation(){
    targetRotY -= 45;
    if(targetRotY < -90) targetRotY = 0;

    if(targetRotY < -15 && targetRotY > -60){
      targetRotX = -30f;
    }else{
      targetRotX = 0f;
    }
  }
  */

  void changeRotation(float pctX, float pctY){
    //targetRotX = (pctX * -30)/100f;
    //targetRotY = (pctY * -90)/100f;

    targetRotX = -12 + (pctX * 30)/100f;
    targetRotY = (pctY * -90)/100f;
  }
}

void aline(Point3D a, Point3D b){
  float x = (a.x + b.x)/2f;
  float y = (a.y + b.y)/2f;
  float z = (a.z + b.z)/2f;

  float w = abs(a.x - b.x) + lineStrength;
  float h = abs(a.y - b.y) + lineStrength;
  float d = abs(a.z - b.z) + lineStrength;

  rectangle3D(x, y, z, w, h, d);
}

void drawLetter(int n){

  // SYMBOLS I  ///////////////////////////////////////////////////////////

  if(n == 33){ // !
    aline(middleSmall[22], middleSmall[19]);
    aline(middleSmall[16], middleSmall[4]);
  }

  if(n == 34){ // "
    aline(frontSmall[1], frontSmall[7]);
    aline(middleSmall[2], middleSmall[8]);
  }

  if(n == 35){ // #
    aline(front[15], middle[15]);
    aline(middle[15], middle[17]);
    aline(middle[17], back[17]);
    aline(back[17], back[19]);

    aline(front[25], middle[25]);
    aline(middle[25], middle[27]);
    aline(middle[27], back[27]);
    aline(back[27], back[29]);

    aline(middle[6], middle[36]);
    aline(back[8], back[38]);
  }

  if(n == 36){ // $
    //aline(back[2], back[7]);
    aline(middle[2], middle[42]);
    aline(back[14], back[9]);
    aline(back[9], back[5]);
    aline(front[5], back[5]);
    aline(front[5], front[20]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(back[22], back[24]);
    aline(back[24], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(front[35], front[30]);
    //aline(front[37], front[42]);
  }

  if(n == 37){ // %
    aline(frontSmall[21], frontSmall[12]);
    aline(frontSmall[12], middleSmall[12]);
    aline(middleSmall[12], middleSmall[14]);
    aline(middleSmall[14], backSmall[14]);
    aline(backSmall[14], backSmall[5]);

    aline(frontSmall[3], frontSmall[6]);
    aline(frontSmall[6], frontSmall[7]);
    aline(frontSmall[7], middleSmall[7]);
    aline(middleSmall[7], middleSmall[4]);
    aline(middleSmall[4], middleSmall[3]);
    aline(middleSmall[3], frontSmall[3]);

    aline(middleSmall[22], middleSmall[23]);
    aline(middleSmall[19], middleSmall[22]);
    aline(backSmall[19], middleSmall[19]);
    aline(backSmall[20], backSmall[19]);
    aline(backSmall[23], backSmall[20]);
    aline(middleSmall[23], backSmall[23]);
  }

  if(n == 38){ // &
    aline(back[9], back[24]);
    aline(back[24], middle[24]);
    aline(middle[24], middle[22]);
    aline(middle[22], middle[7]);
    aline(middle[7], back[7]);
    aline(back[7], back[9]);

    aline(front[20], front[35]);
    aline(front[35], front[38]);
    aline(front[38], middle[38]);
    aline(middle[38], middle[23]);
    aline(middle[23], middle[20]);
    aline(middle[20], front[20]);
    aline(back[33], back[38]);
    aline(back[38], middle[38]);
    aline(middle[38], middle[39]);
  }

  if(n == 39){ // '
    aline(middleSmall[4], middleSmall[7]);
  }

  if(n == 40){ // (
    aline(backSmall[2], backSmall[1]);
    aline(backSmall[1], middleSmall[1]);
    aline(middleSmall[1], middleSmall[25]);
    aline(middleSmall[25], middleSmall[26]);
    aline(middleSmall[26], backSmall[26]);
  }

  if(n == 41){ // )
    aline(frontSmall[24], frontSmall[25]);
    aline(frontSmall[25], middleSmall[25]);
    aline(middleSmall[25], middleSmall[1]);
    aline(middleSmall[1], middleSmall[0]);
    aline(middleSmall[0], frontSmall[0]);
  }

  if(n == 42){ // *
    aline(middleSmall[3], middleSmall[5]);
    aline(frontSmall[4], backSmall[4]);
    aline(middleSmall[1], middleSmall[7]);
  }

  if(n == 43){ // +
    aline(frontSmall[12], middleSmall[12]);
    aline(middleSmall[12], middleSmall[14]);
    aline(middleSmall[14], backSmall[14]);
    aline(middleSmall[7], middleSmall[19]);
  }

  if(n == 44){ // ,
    aline(middleSmall[22], middleSmall[25]);
    aline(middleSmall[25], middleSmall[24]);
  }

  if(n == 45){ // -
    aline(frontSmall[12], frontSmall[13]);
    aline(frontSmall[13], backSmall[13]);
    aline(backSmall[13], backSmall[14]);
  }

  if(n == 46){ // .
    aline(middleSmall[22], middleSmall[19]);
    //   aline(frontSmall[22], frontSmall[23]);
    //   aline(frontSmall[23], frontSmall[20]);
    //   aline(frontSmall[20], frontSmall[19]);
    //   aline(frontSmall[19], frontSmall[22]);
  }

  if(n == 47){ // /
    aline(frontSmall[2], frontSmall[1]);
    aline(frontSmall[1], frontSmall[10]);
    aline(frontSmall[10], middleSmall[10]);
    aline(middleSmall[10], middleSmall[19]);
    aline(middleSmall[19], middleSmall[18]);
    aline(middleSmall[18], middleSmall[24]);
    aline(middleSmall[24], backSmall[24]);
  }

  // NUMBERS //////////////////////////////////////////////////////////////

  if(n == 48){ // 0
    aline(back[5], back[9]);
    aline(back[9], back[39]);

    aline(back[5], front[5]);
    aline(back[39], front[39]);

    aline(front[5], front[35]);
    aline(front[35], front[39]);
  }

  if(n == 49){ // 1
    aline(back[39], middle[39]);
    aline(middle[35], middle[39]);
    aline(front[35], middle[35]);
    aline(middle[37], middle[7]);
    aline(middle[7], middle[6]);
    aline(middle[6], front[6]);
  }

  if(n == 50){ // 2
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[24]);
    aline(back[24], front[24]);
    aline(front[24], front[20]);
    aline(front[20], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  if(n == 51){ // 3
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(back[24], back[21]);
    aline(back[21], middle[21]);
  }

  if(n == 52){ // 4
    aline(back[24], back[39]);
    aline(back[9], back[24]);
    aline(back[24], front[24]);
    aline(front[20], front[24]);
    aline(front[5], front[20]);
  }

  if(n == 53){ // 5
    aline(back[5], back[9]);
    aline(back[20], back[24]);
    aline(back[24], back[39]);

    aline(back[5], front[5]);
    aline(back[20], front[20]);
    aline(back[39], front[39]);

    aline(front[5], front[20]);
    aline(front[35], front[39]);
    aline(front[35], front[30]);
  }

  if(n == 54){ // 6
    aline(back[5], back[9]);
    aline(back[20], back[24]);
    aline(back[24], back[39]);

    aline(back[5], front[5]);
    aline(back[20], front[20]);
    aline(back[39], front[39]);

    aline(front[5], front[35]);
    aline(front[35], front[39]);
  }

  if(n == 55){ // 7
    aline(front[5], middle[5]);
    aline(middle[5], middle[8]);
    aline(middle[8], middle[38]);

    aline(front[21], back[21]);
    aline(back[21], back[24]);
  }

  if(n == 56){ // 8
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(front[35], front[5]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(back[22], back[24]);
  }

  if(n == 57){ // 9
    aline(back[24], front[24]);
    aline(front[24], front[20]);
    aline(front[20], front[5]);
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
  }

  // SYMBOLS II  ///////////////////////////////////////////////////////////

  if(n == 58){ // :
    aline(middleSmall[16], middleSmall[19]);
    aline(middleSmall[13], middleSmall[10]);
  }

  if(n == 59){ // ;
    aline(middleSmall[22], middleSmall[25]);
    aline(middleSmall[25], middleSmall[24]);
    aline(middleSmall[13], middleSmall[10]);
  }

  if(n == 61){ // =
    aline(frontSmall[9], middleSmall[9]);
    aline(middleSmall[9], middleSmall[11]);
    aline(middleSmall[11], backSmall[11]);

    aline(frontSmall[15], middleSmall[15]);
    aline(middleSmall[15], middleSmall[17]);
    aline(middleSmall[17], backSmall[17]);
  }

  if(n == 63){ // ?
    aline(frontSmall[3], backSmall[3]);
    aline(backSmall[3], backSmall[5]);
    aline(backSmall[5], backSmall[14]);
    aline(backSmall[14], backSmall[13]);
    aline(backSmall[13], middleSmall[13]);
    aline(middleSmall[13], middleSmall[16]);
    aline(middleSmall[19], middleSmall[22]);
  }

  if(n == 64){ // @
    aline(back[12], back[14]);
    aline(middle[12], back[12]);
    aline(middle[27], middle[12]);
    aline(middle[29], middle[27]);
    aline(back[29], middle[29]);
    aline(back[29], back[9]);
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  // CAPS LETTERS //////////////////////////////////////////////////////////

  if(n == 65){ // A
    aline(front[35], front[5]);
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[39]);
    aline(front[20], middle[20]);
    aline(middle[20], middle[24]);
    aline(middle[24], back[24]);
  }

  if(n == 66){ // B
    aline(front[20], front[5]);
    aline(front[5], back[5]);
    aline(back[5], back[7]);
    aline(back[7], back[22]);
    aline(back[22], front[22]);
    aline(front[22], front[20]);

    aline(front[20], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[24]);
    aline(back[24], back[22]);
  }

  if(n == 67){ // C
    aline(back[19], back[9]);
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  if(n == 68){ // D
    aline(front[35], front[36]);
    aline(front[36], middle[36]);
    aline(middle[36], middle[39]);
    aline(middle[39], back[39]);
    aline(back[39], back[9]);
    aline(back[9], back[6]);
    aline(back[6], middle[6]);
    aline(middle[6], middle[5]);
    aline(middle[5], front[5]);
    aline(middle[36], middle[6]);
  }

  if(n == 69){ // E
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);

    aline(front[20], back[20]);
    aline(back[20], back[22]);
  }

  if(n == 70){ // F
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[5], front[35]);

    aline(front[20], front[23]);
    aline(front[23], middle[23]);
  }

  if(n == 71){ // G
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[24]);
    aline(back[24], back[22]);
    aline(back[22], middle[22]);
  }

  if(n == 72){ // H
    aline(front[5], front[35]);
    aline(front[20], middle[20]);
    aline(middle[20], middle[24]);
    aline(middle[24], back[24]);
    aline(back[9], back[39]);
  }

  if(n == 73){ // I
    aline(front[5], middle[5]);
    aline(middle[5], middle[9]);
    aline(middle[9], back[9]);
    aline(middle[7], middle[37]);
    aline(front[35], middle[35]);
    aline(middle[35], middle[39]);
    aline(middle[39], back[39]);
  }

  if(n == 74){ // J
    aline(front[7], back[7]);
    aline(back[7], back[9]);
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(front[35], front[25]);
  }

  if(n == 75){ // K
    aline(front[5], front[35]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(middle[7], middle[22]);
    aline(back[39], back[24]);
    aline(back[24], back[22]);
  }

  if(n == 76){ // L
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  if(n == 77){ // M
    aline(front[5], front[35]);
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[7], middle[7]);
    aline(middle[7], middle[22]);
    aline(back[9], back[39]);
  }

  if(n == 78){ // N
    aline(front[5], front[35]);
    aline(front[5], middle[5]);
    aline(middle[5], middle[6]);
    aline(middle[6], middle[16]);
    aline(middle[16], middle[17]);
    aline(middle[17], middle[27]);
    aline(middle[27], middle[28]);
    aline(middle[28], middle[38]);
    aline(middle[38], middle[39]);
    aline(middle[39], back[39]);
    aline(back[39], back[9]);
  }

  if(n == 79){ // O
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[9]);
    aline(back[9], back[5]);
    aline(back[5], front[5]);
  }

  if(n == 80){ // P
    aline(front[35], front[5]);
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[24]);
    aline(back[24], front[24]);
    aline(front[24], front[20]);
  }

  if(n == 81){ // Q
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[9]);
    aline(back[9], back[5]);
    aline(back[5], front[5]);
    aline(front[37], middle[37]);
    aline(middle[37], middle[27]);
  }

  if(n == 82){ // R
    aline(front[35], front[5]);
    aline(front[5], middle[5]);
    aline(middle[5], middle[8]);
    aline(middle[8], middle[23]);
    aline(middle[23], front[23]);
    aline(front[23], front[20]);
    aline(middle[23], back[23]);
    aline(back[23], back[24]);
    aline(back[24], back[39]);
    /*
    aline(front[35], front[5]);
    aline(front[5], back[5]);
    aline(back[5], back[7]);
    aline(back[7], back[22]);
    aline(back[22], front[22]);
    aline(front[22], front[20]);
    aline(middle[22], middle[24]);
    aline(middle[24], middle[39]);
    */
  }

  if(n == 83){ // S
    aline(back[9], back[5]);
    aline(front[5], back[5]);
    aline(front[5], front[20]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(back[22], back[24]);
    aline(back[24], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
  }

  if(n == 84){ // T
    aline(middle[37], middle[7]);
    aline(front[5], middle[5]);
    aline(middle[5], middle[9]);
    aline(middle[9], back[9]);
  }

  if(n == 85){ // U
    aline(front[35], front[5]);
    aline(front[35], front[38]);
    aline(front[38], back[38]);
    aline(back[38], back[8]);
    aline(back[39], back[38]);
  }

  if(n == 86){ // V
    aline(front[5], front[25]);
    aline(front[25], front[27]);
    aline(front[27], middle[27]);
    aline(middle[27], middle[37]);
    aline(middle[37], middle[39]);
    aline(middle[39], back[39]);
    aline(back[39], back[9]);
  }

  if(n == 87){ // W
    aline(front[5], front[35]);
    aline(front[35], front[37]);
    aline(front[37], back[37]);
    aline(back[37], back[39]);
    aline(back[39], back[9]);
    aline(middle[37], middle[22]);
  }

  if(n == 88){ // X
    aline(front[5], front[15]);
    aline(front[15], front[17]);
    aline(front[17], back[17]);
    aline(back[17], back[19]);
    aline(back[19], back[9]);
    aline(middle[17], middle[27]);
    aline(front[35], front[25]);
    aline(front[25], front[27]);
    aline(front[27], back[27]);
    aline(back[27], back[29]);
    aline(back[29], back[39]);
  }

  if(n == 89){ // Y
    aline(front[5], front[20]);
    aline(front[20], front[24]);
    aline(front[24], back[24]);
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[37]);
  }

  if(n == 90){ // Z
    aline(front[5], back[5]);
    aline(back[5], back[9]);
    aline(back[9], back[24]);
    aline(back[24], back[22]);
    aline(back[22], front[22]);
    aline(front[22], front[20]);
    aline(front[20], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  // SYMBOLS III   /////////////////////////////////////////////////////////

  if(n == 91){ // [
    aline(backSmall[2], backSmall[1]);
    aline(backSmall[1], middleSmall[1]);
    aline(middleSmall[1], middleSmall[25]);
    aline(middleSmall[25], middleSmall[26]);
    aline(middleSmall[26], backSmall[26]);
  }

  if(n == 93){ // ]
    aline(frontSmall[24], frontSmall[25]);
    aline(frontSmall[25], middleSmall[25]);
    aline(middleSmall[25], middleSmall[1]);
    aline(middleSmall[1], middleSmall[0]);
    aline(middleSmall[0], frontSmall[0]);
  }

  if(n == 92){ // \
    aline(frontSmall[0], frontSmall[1]);
    aline(frontSmall[1], frontSmall[10]);
    aline(frontSmall[10], middleSmall[10]);
    aline(middleSmall[10], middleSmall[19]);
    aline(middleSmall[19], middleSmall[20]);
    aline(middleSmall[20], middleSmall[26]);
    aline(middleSmall[26], backSmall[26]);
  }

  if(n == 95){ // _
    aline(frontSmall[24], middleSmall[24]);
    aline(middleSmall[24], middleSmall[26]);
    aline(middleSmall[26], backSmall[26]);
  }

  if(n == 39){ // `
    aline(middleSmall[4], middleSmall[7]);
  }

  // SMALL LETTERS /////////////////////////////////////////////////////////////

  if(n == 97){ // a
    aline(front[10], back[10]);
    aline(back[10], back[14]);
    aline(back[14], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(front[35], front[20]);
    aline(front[20], middle[20]);
    aline(middle[20], middle[24]);
    aline(middle[24], back[24]);
  }

  if(n == 98){ // b
    aline(front[5], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[24]);
    aline(back[24], back[20]);
    aline(back[20], front[20]);
  }

  if(n == 99){ // c
    aline(back[19], back[14]);
    aline(back[14], back[10]);
    aline(back[10], front[10]);
    aline(front[10], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  if(n == 100){ // d
    aline(back[9], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
    aline(front[35], front[20]);
    aline(front[20], back[20]);
    aline(back[20], back[24]);
  }

  if(n == 101){ // e
    aline(front[25], middle[25]);
    aline(middle[25], middle[29]);
    aline(middle[29], back[29]);
    aline(back[29], back[14]);
    aline(back[14], back[10]);
    aline(back[10], front[10]);
    aline(front[10], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  if(n == 102){ // f
    aline(back[9], back[7]);
    aline(back[7], middle[7]);
    aline(middle[7], middle[37]);

    aline(middle[16], middle[19]);
    aline(middle[19], back[19]);

    aline(front[35], middle[35]);
    aline(middle[35], middle[39]);
    aline(middle[39], back[39]);
  }

  if(n == 103){ // g
    aline(front[42], front[44]);
    aline(front[44], back[44]);
    aline(back[44], back[14]);
    aline(back[14], back[11]);
    aline(front[10], front[11]);
    aline(back[11], front[11]);
    aline(front[11], front[26]);
    aline(front[26], front[29]);
    aline(front[29], back[29]);
  }

  if(n == 104){ // h
    aline(front[5], front[35]);
    aline(front[20], back[20]);
    aline(back[20], back[24]);
    aline(back[24], back[39]);
  }

  if(n == 105){ // i
    aline(middle[7], middle[12]);
    aline(front[16], middle[16]);
    aline(middle[16], middle[17]);
    aline(middle[17], middle[37]);
    aline(front[35], middle[35]);
    aline(middle[35], middle[39]);
    aline(middle[39], back[39]);
  }

  if(n == 106){ // j
    aline(middle[13], middle[8]);
    aline(middle[17], front[17]);
    aline(middle[17], middle[19]);
    aline(middle[19], back[19]);
    aline(middle[18], middle[43]);
    aline(middle[43], front[43]);
    aline(front[43], front[40]);
    aline(front[40], front[30]);
    /*
    aline(back[13], back[8]);
    aline(middle[17], back[17]);
    aline(back[17], back[18]);
    aline(back[18], back[19]);
    aline(back[18], back[43]);
    aline(back[43], front[43]);
    aline(front[43], front[40]);
    aline(front[40], front[30]);
    */
  }

  if(n == 107){ // k
    aline(front[5], front[35]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(middle[12], middle[22]);
    aline(back[39], back[24]);
    aline(back[24], back[22]);
  }

  if(n == 108){ // l
    aline(front[6], middle[6]);
    aline(middle[6], middle[7]);
    aline(middle[7], middle[37]);
    aline(front[35], middle[35]);
    aline(middle[35], middle[39]);
    aline(middle[39], back[39]);
  }

  if(n == 109){ // m
    aline(front[10], front[35]);
    aline(front[10], middle[10]);
    aline(middle[10], middle[12]);
    aline(back[12], middle[12]);
    aline(back[12], back[14]);
    aline(middle[22], middle[12]);
    aline(back[14], back[39]);
  }

  if(n == 110){ // n
    aline(front[10], front[11]);
    aline(front[11], front[36]);
    aline(front[11], back[11]);
    aline(back[11], back[14]);
    aline(back[14], back[39]);
  }

  if(n == 111){ // o
    aline(front[10], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
    aline(back[39], back[14]);
    aline(back[14], back[10]);
    aline(back[10], front[10]);
  }

  if(n == 112){ // p
    aline(back[14], back[11]);
    aline(back[11], front[11]);
    aline(front[11], front[41]);
    aline(front[10], front[11]);
    aline(front[26], front[29]);
    aline(front[29], back[29]);
    aline(back[29], back[14]);
  }

  if(n == 113){ // q
    aline(back[13], back[14]);
    aline(back[43], back[13]);
    aline(back[13], back[10]);
    aline(back[10], front[10]);
    aline(front[10], front[25]);
    aline(front[25], front[28]);
    aline(front[28], back[28]);
  }

  if(n == 114){ // r
    aline(front[10], front[11]);
    aline(front[11], front[36]);
    aline(front[11], back[11]);
    aline(back[11], back[14]);
    aline(back[14], back[19]);
  }

  if(n == 115){ // s
    aline(back[14], back[10]);
    aline(front[10], back[10]);
    aline(front[10], front[20]);
    aline(front[20], front[22]);
    aline(front[22], back[22]);
    aline(back[22], back[24]);
    aline(back[24], back[39]);
    aline(back[39], front[39]);
    aline(front[39], front[35]);
  }

  if(n == 116){ // t
    aline(middle[6], middle[36]);
    aline(middle[36], middle[39]);
    aline(middle[39], back[39]);
    aline(front[10], front[11]);
    aline(front[11], middle[11]);
    aline(middle[11], middle[13]);
    aline(middle[13], back[13]);
  }

  if(n == 117){ // u
    aline(front[35], front[10]);
    aline(front[35], front[38]);
    aline(front[38], back[38]);
    aline(back[38], back[13]);
    aline(back[39], back[38]);
  }

  if(n == 118){ // v
    aline(front[10], front[25]);
    aline(front[25], front[27]);
    aline(front[27], middle[27]);
    aline(middle[27], middle[37]);
    aline(middle[37], middle[39]);
    aline(middle[39], back[39]);
    aline(back[39], back[14]);
  }

  if(n == 119){ // w
    aline(front[10], front[35]);
    aline(front[35], front[37]);
    aline(front[37], back[37]);
    aline(back[37], back[39]);
    aline(back[39], back[14]);
    aline(middle[37], middle[22]);
  }

  if(n == 120){ // x
    aline(front[10], front[15]);
    aline(front[15], front[17]);
    aline(front[17], back[17]);
    aline(back[17], back[19]);
    aline(back[19], back[14]);
    aline(middle[17], middle[27]);
    aline(front[35], front[25]);
    aline(front[25], front[27]);
    aline(front[27], back[27]);
    aline(back[27], back[29]);
    aline(back[29], back[39]);
  }

  if(n == 121){ // y
    aline(front[10], front[25]);
    aline(front[25], front[29]);
    aline(front[29], back[29]);
    aline(back[14], back[44]);
    aline(back[44], front[44]);
    aline(front[42], front[44]);
  }

  if(n == 122){ // z
    aline(front[10], back[10]);
    aline(back[10], back[14]);
    aline(back[14], back[24]);
    aline(back[24], back[22]);
    aline(back[22], front[22]);
    aline(front[22], front[20]);
    aline(front[20], front[35]);
    aline(front[35], front[39]);
    aline(front[39], back[39]);
  }

  // SYMBOLS IV  //////////////////////////////////////////////////////////

  if(n == 123){ // {
     aline(frontSmall[12], frontSmall[13]);
     aline(frontSmall[13], middleSmall[13]);
     aline(backSmall[2], backSmall[1]);
     aline(backSmall[1], middleSmall[1]);
     aline(middleSmall[1], middleSmall[25]);
     aline(middleSmall[25], middleSmall[26]);
     aline(middleSmall[26], backSmall[26]);
   }

   if(n == 124){ // |
     aline(middleSmall[25], middleSmall[1]);
   }

   if(n == 125){ // {
      aline(frontSmall[24], frontSmall[25]);
      aline(frontSmall[25], middleSmall[25]);
      aline(middleSmall[25], middleSmall[1]);
      aline(middleSmall[1], middleSmall[0]);
      aline(middleSmall[0], frontSmall[0]);
      aline(middleSmall[13], backSmall[13]);
      aline(backSmall[13], backSmall[14]);
    }

    if(n == 126){ // ~
      aline(frontSmall[12], frontSmall[9]);
      aline(frontSmall[9], middleSmall[9]);
      aline(middleSmall[9], middleSmall[10]);
      aline(middleSmall[10], middleSmall[13]);
      aline(middleSmall[13], middleSmall[14]);
      aline(middleSmall[14], backSmall[14]);
      aline(backSmall[14], backSmall[11]);
    }

    if(n == 128){ // ó
      aline(front[15], middle[15]);
      aline(middle[15], middle[18]);
      aline(middle[18], back[18]);
      aline(front[25], middle[25]);
      aline(middle[25], middle[28]);
      aline(middle[28], back[28]);
      aline(back[9], back[6]);
      aline(back[6], middle[6]);
      aline(middle[6], middle[36]);
      aline(middle[36], middle[39]);
      aline(middle[39], back[39]);
    }

    if(n == 131){ // €
      aline(frontSmall[24], frontSmall[25]);
      aline(frontSmall[25], middleSmall[25]);
      aline(middleSmall[25], middleSmall[4]);
      aline(middleSmall[4], backSmall[4]);
      aline(backSmall[4], backSmall[5]);
      aline(frontSmall[12], middleSmall[12]);
      aline(middleSmall[12], middleSmall[14]);
      aline(middleSmall[14], backSmall[14]);
    }

    if(n == 133){ // ƒ
      aline(frontSmall[21], frontSmall[18]);
      aline(middleSmall[22], middleSmall[19]);
      aline(backSmall[23], backSmall[20]);
    }

    if(n == 163){ // £
      aline(front[35], middle[35]);
      aline(middle[35], middle[39]);
      aline(middle[39], back[39]);
      aline(front[25], middle[25]);
      aline(middle[25], middle[28]);
      aline(middle[28], back[28]);
      aline(middle[36], middle[6]);
      aline(middle[6], back[6]);
      aline(back[6], back[8]);
      aline(back[8], back[13]);
    }

    if(n == 166){ // ?
      aline(backSmall[23], backSmall[5]);
      aline(backSmall[5], backSmall[3]);
      aline(backSmall[3], frontSmall[3]);
      aline(frontSmall[3], frontSmall[12]);
      aline(frontSmall[12], frontSmall[13]);
      aline(frontSmall[13], middleSmall[13]);
      aline(middleSmall[3], middleSmall[4]);
      aline(middleSmall[4], middleSmall[22]);
      aline(frontSmall[12], middleSmall[4]);
    }

    if(n == 167){ // ¤
      aline(front[40], front[41]);
      aline(front[41], front[6]);
      aline(front[6], middle[6]);
      aline(middle[6], middle[8]);
      aline(middle[8], middle[18]);
      aline(middle[18], middle[17]);
      aline(middle[18], back[18]);
      aline(back[18], back[19]);
      aline(back[19], back[39]);
      aline(back[39], middle[39]);
      aline(middle[39], middle[37]);
    }

    if(n == 169){ // ©
      aline(backSmall[11], frontSmall[11]);
      aline(frontSmall[11], frontSmall[9]);
      aline(frontSmall[9], frontSmall[3]);
      aline(frontSmall[3], backSmall[3]);
      aline(backSmall[3], backSmall[5]);
    }

    if(n == 170){ // È
      aline(middleSmall[0], backSmall[0]);
      aline(backSmall[0], backSmall[2]);
      aline(backSmall[2], backSmall[11]);
      aline(backSmall[11], frontSmall[11]);
      aline(frontSmall[11], frontSmall[9]);
      aline(frontSmall[9], frontSmall[3]);
      aline(frontSmall[3], middleSmall[3]);
      aline(middleSmall[3], middleSmall[5]);
      aline(middleSmall[5], backSmall[5]);
    }

    if(n == 224){ // ?
      aline(front[6], front[1]);
      aline(front[10], back[10]);
      aline(back[10], back[14]);
      aline(back[14], back[39]);
      aline(back[39], front[39]);
      aline(front[39], front[35]);
      aline(front[35], front[20]);
      aline(front[20], back[20]);
      aline(back[20], back[24]);
    }

    if(n == 225){ // ?
      aline(back[3], back[4]);
      aline(front[10], back[10]);
      aline(back[10], back[14]);
      aline(back[14], back[39]);
      aline(back[39], front[39]);
      aline(front[39], front[35]);
      aline(front[35], front[20]);
      aline(front[20], back[20]);
      aline(back[20], back[24]);
    }

    if(n == 227){ // ?
      aline(front[6], front[1]);
      aline(front[1], middle[1]);
      aline(middle[1], middle[2]);
      aline(middle[2], middle[7]);
      aline(middle[7], middle[8]);
      aline(middle[8], back[8]);
      aline(back[8], back[3]);

      aline(back[3], back[3]);
      aline(middle[1], middle[1]);
      aline(front[10], middle[10]);
      aline(middle[10], middle[14]);
      aline(middle[14], back[14]);
      aline(back[14], back[39]);
      aline(back[39], front[39]);
      aline(front[39], front[35]);
      aline(front[35], front[20]);
      aline(front[20], middle[20]);
      aline(middle[20], middle[24]);
      aline(middle[24], back[24]);
    }

    if(n == 228){ // ?
      aline(back[3], back[3]);
      aline(middle[1], middle[1]);
      aline(front[10], middle[10]);
      aline(middle[10], middle[14]);
      aline(middle[14], back[14]);
      aline(back[14], back[39]);
      aline(back[39], front[39]);
      aline(front[39], front[35]);
      aline(front[35], front[20]);
      aline(front[20], middle[20]);
      aline(middle[20], middle[24]);
      aline(middle[24], back[24]);
    }

    if(n == 229){ // ?
      aline(middle[2], middle[2]);

      aline(front[10], middle[10]);
      aline(middle[10], middle[14]);
      aline(middle[14], back[14]);
      aline(back[14], back[39]);
      aline(back[39], front[39]);
      aline(front[39], front[35]);
      aline(front[35], front[20]);
      aline(front[20], middle[20]);
      aline(middle[20], middle[24]);
      aline(middle[24], back[24]);
    }
  }

  void drawGrid(){
    // draw back_grid
    for(int i=0; i<=34; i++){
      stroke(0, 0, 255);
      point(back[i].x, back[i].y, back[i].z);

      stroke(255, 0, 0);
      point(middle[i].x, middle[i].y, middle[i].z);

      stroke(0, 255, 0);
      point(front[i].x, front[i].y, front[i].z);
    }
  }

  class Point3D{
    int x, y, z;

    Point3D(float x, float y, float z){
      this.x = (int)x;
      this.y = (int)y;
      this.z = (int)z;
    }
  }

  /* *********************************************************************** */
  /* *********************************************************************** */

  ////////////////////////////// SMALL GRID ////////////////////////////////////////////
  Point3D[] backSmall = new Point3D[30];
  Point3D[] middleSmall = new Point3D[30];
  Point3D[] frontSmall = new Point3D[30];

  Point3D[] back = new Point3D[50];
  Point3D[] middle = new Point3D[50];
  Point3D[] front = new Point3D[50];

  void buildGrid(){

    h = letterHeight * typeSize;
    w = letterWidth * typeSize;
    d = letterDepth * typeSize;

    for(int i=0; i<numLettersOnscreen; i++){
      int tmpX = (7*typeSize)+i*(9*typeSize);
      chars[i].x = tmpX;
    }

    //Point3D[] backSmall = {
      //backSmall = {
        backSmall[0] = new Point3D(w*(-1f/4f),  h*(0f/9f),  -d/2f);
        backSmall[1] = new Point3D(w*(0f/4f),   h*(0f/9f),  -d/2f);
        backSmall[2] = new Point3D(w*(1f/4f),   h*(0f/9f),  -d/2f);

        backSmall[3] = new Point3D(w*(-1f/4f),  h*(1f/9f),  -d/2f);
        backSmall[4] = new Point3D(w*(0f/4f),   h*(1f/9f),  -d/2f);
        backSmall[5] = new Point3D(w*(1f/4f),   h*(1f/9f),  -d/2f);

        backSmall[6] = new Point3D(w*(-1f/4f),  h*(2f/9f),  -d/2f);
        backSmall[7] = new Point3D(w*(0f/4f),   h*(2f/9f),  -d/2f);
        backSmall[8] = new Point3D(w*(1f/4f),   h*(2f/9f),  -d/2f);

        backSmall[9] = new Point3D(w*(-1f/4f),  h*(3f/9f),  -d/2f);
        backSmall[10] = new Point3D(w*(0f/4f),   h*(3f/9f),  -d/2f);
        backSmall[11] = new Point3D(w*(1f/4f),   h*(3f/9f),  -d/2f);

        backSmall[12] = new Point3D(w*(-1f/4f),  h*(4f/9f),  -d/2f);
        backSmall[13] = new Point3D(w*(0f/4f),   h*(4f/9f),  -d/2f);
        backSmall[14] = new Point3D(w*(1f/4f),   h*(4f/9f),  -d/2f);

        backSmall[15] = new Point3D(w*(-1f/4f),  h*(5f/9f),  -d/2f);
        backSmall[16] = new Point3D(w*(0f/4f),   h*(5f/9f),  -d/2f);
        backSmall[17] = new Point3D(w*(1f/4f),   h*(5f/9f),  -d/2f);

        backSmall[18] = new Point3D(w*(-1f/4f),  h*(6f/9f),  -d/2f);
        backSmall[19] = new Point3D(w*(0f/4f),   h*(6f/9f),  -d/2f);
        backSmall[20] = new Point3D(w*(1f/4f),   h*(6f/9f),  -d/2f);

        backSmall[21] = new Point3D(w*(-1f/4f),  h*(7f/9f),  -d/2f);
        backSmall[22] =  new Point3D(w*(0f/4f),   h*(7f/9f),  -d/2f);
        backSmall[23] =  new Point3D(w*(1f/4f),   h*(7f/9f),  -d/2f);

        backSmall[24] = new Point3D(w*(-1f/4f),  h*(8f/9f),  -d/2f);
        backSmall[25] = new Point3D(w*(0f/4f),   h*(8f/9f),  -d/2f);
        backSmall[26] = new Point3D(w*(1f/4f),   h*(8f/9f),  -d/2f);

        backSmall[27] = new Point3D(w*(-1f/4f),  h*(9f/9f),  -d/2f);
        backSmall[28] = new Point3D(w*(0f/4f),   h*(9f/9f),  -d/2f);
        backSmall[29] = new Point3D(w*(1f/4f),   h*(9f/9f),  -d/2f);
      //};

      //Point3D[] middleSmall =
      //middleSmall =
      //{
        middleSmall[0] =  new Point3D(w*(-1f/4f),  h*(0f/9f),  0f);
        middleSmall[1] =   new Point3D(w*(0f/4f),   h*(0f/9f),  0f);
        middleSmall[2] =   new Point3D(w*(1f/4f),   h*(0f/9f),  0f);

        middleSmall[3] =   new Point3D(w*(-1f/4f),  h*(1f/9f),  0f);
        middleSmall[4] =   new Point3D(w*(0f/4f),   h*(1f/9f),  0f);
        middleSmall[5] =   new Point3D(w*(1f/4f),   h*(1f/9f),  0f);

        middleSmall[6] =   new Point3D(w*(-1f/4f),  h*(2f/9f),  0f);
        middleSmall[7] =   new Point3D(w*(0f/4f),   h*(2f/9f),  0f);
        middleSmall[8] =   new Point3D(w*(1f/4f),   h*(2f/9f),  0f);

        middleSmall[9] =   new Point3D(w*(-1f/4f),  h*(3f/9f),  0f);
        middleSmall[10] =   new Point3D(w*(0f/4f),   h*(3f/9f),  0f);
        middleSmall[11] =   new Point3D(w*(1f/4f),   h*(3f/9f),  0f);

        middleSmall[12] =   new Point3D(w*(-1f/4f),  h*(4f/9f),  0f);
        middleSmall[13] =   new Point3D(w*(0f/4f),   h*(4f/9f),  0f);
        middleSmall[14] =   new Point3D(w*(1f/4f),   h*(4f/9f),  0f);

        middleSmall[15] =   new Point3D(w*(-1f/4f),  h*(5f/9f),  0f);
        middleSmall[16] =   new Point3D(w*(0f/4f),   h*(5f/9f),  0f);
        middleSmall[17] =   new Point3D(w*(1f/4f),   h*(5f/9f),  0f);

        middleSmall[18] =   new Point3D(w*(-1f/4f),  h*(6f/9f),  0f);
        middleSmall[19] =   new Point3D(w*(0f/4f),   h*(6f/9f),  0f);
        middleSmall[20] =  new Point3D(w*(1f/4f),   h*(6f/9f),  0f);

        middleSmall[21] =   new Point3D(w*(-1f/4f),  h*(7f/9f),  0f);
        middleSmall[22] =   new Point3D(w*(0f/4f),   h*(7f/9f),  0f);
        middleSmall[23] =   new Point3D(w*(1f/4f),   h*(7f/9f),  0f);

        middleSmall[24] =   new Point3D(w*(-1f/4f),  h*(8f/9f),  0f);
        middleSmall[25] =   new Point3D(w*(0f/4f),   h*(8f/9f),  0f);
        middleSmall[26] =   new Point3D(w*(1f/4f),   h*(8f/9f),  0f);

        middleSmall[27] =   new Point3D(w*(-1f/4f),  h*(9f/9f),  0f);
        middleSmall[28] =   new Point3D(w*(0f/4f),   h*(9f/9f),  0f);
        middleSmall[29] =   new Point3D(w*(1f/4f),   h*(9f/9f),  0f);
      //};

      //Point3D[] frontSmall =
      //frontSmall =
      //{
        frontSmall[0] =  new Point3D(w*(-1f/4f),  h*(0f/9f),  d/2f);
        frontSmall[1] =  new Point3D(w*(0f/4f),   h*(0f/9f),  d/2f);
        frontSmall[2] =  new Point3D(w*(1f/4f),   h*(0f/9f),  d/2f);

        frontSmall[3] =  new Point3D(w*(-1f/4f),  h*(1f/9f),  d/2f);
        frontSmall[4] =  new Point3D(w*(0f/4f),   h*(1f/9f),  d/2f);
        frontSmall[5] =  new Point3D(w*(1f/4f),   h*(1f/9f),  d/2f);

        frontSmall[6] =  new Point3D(w*(-1f/4f),  h*(2f/9f),  d/2f);
        frontSmall[7] =  new Point3D(w*(0f/4f),   h*(2f/9f),  d/2f);
        frontSmall[8] =  new Point3D(w*(1f/4f),   h*(2f/9f),  d/2f);

        frontSmall[9] =  new Point3D(w*(-1f/4f),  h*(3f/9f),  d/2f);
        frontSmall[10] =  new Point3D(w*(0f/4f),   h*(3f/9f),  d/2f);
        frontSmall[11] =  new Point3D(w*(1f/4f),   h*(3f/9f),  d/2f);

        frontSmall[12] =  new Point3D(w*(-1f/4f),  h*(4f/9f),  d/2f);
        frontSmall[13] =  new Point3D(w*(0f/4f),   h*(4f/9f),  d/2f);
        frontSmall[14] =  new Point3D(w*(1f/4f),   h*(4f/9f),  d/2f);

        frontSmall[15] =  new Point3D(w*(-1f/4f),  h*(5f/9f),  d/2f);
        frontSmall[16] =  new Point3D(w*(0f/4f),   h*(5f/9f),  d/2f);
        frontSmall[17] =  new Point3D(w*(1f/4f),   h*(5f/9f),  d/2f);

        frontSmall[18] =  new Point3D(w*(-1f/4f),  h*(6f/9f),  d/2f);
        frontSmall[19] =  new Point3D(w*(0f/4f),   h*(6f/9f),  d/2f);
        frontSmall[20] =  new Point3D(w*(1f/4f),   h*(6f/9f),  d/2f);

        frontSmall[21] =  new Point3D(w*(-1f/4f),  h*(7f/9f),  d/2f);
        frontSmall[22] =  new Point3D(w*(0f/4f),   h*(7f/9f),  d/2f);
        frontSmall[23] =  new Point3D(w*(1f/4f),   h*(7f/9f),  d/2f);

        frontSmall[24] =  new Point3D(w*(-1f/4f),  h*(8f/9f),  d/2f);
        frontSmall[25] =  new Point3D(w*(0f/4f),   h*(8f/9f),  d/2f);
        frontSmall[26] =  new Point3D(w*(1f/4f),   h*(8f/9f),  d/2f);

        frontSmall[27] =  new Point3D(w*(-1f/4f),  h*(9f/9f),  d/2f);
        frontSmall[28] =  new Point3D(w*(0f/4f),   h*(9f/9f),  d/2f);
        frontSmall[29] =  new Point3D(w*(1f/4f),   h*(9f/9f),  d/2f);
      //};

      ////////////////////////// NORMAL SIZE GRID ///////////////////////////////

      //Point3D[] back =
      //back =
      //{
        back[0] =  new Point3D(w*(-2f/4f),  h*(0f/9f),  -d/2f);
        back[1] =  new Point3D(w*(-1f/4f),  h*(0f/9f),  -d/2f);
        back[2] =  new Point3D(w*(0f/4f),   h*(0f/9f),  -d/2f);
        back[3] =  new Point3D(w*(1f/4f),   h*(0f/9f),  -d/2f);
        back[4] =  new Point3D(w*(2f/4f),   h*(0f/9f),  -d/2f);

        back[5] =  new Point3D(w*(-2f/4f),  h*(1f/9f),  -d/2f);
        back[6] =  new Point3D(w*(-1f/4f),  h*(1f/9f),  -d/2f);
        back[7] =  new Point3D(w*(0f/4f),   h*(1f/9f),  -d/2f);
        back[8] =  new Point3D(w*(1f/4f),   h*(1f/9f),  -d/2f);
        back[9] =  new Point3D(w*(2f/4f),   h*(1f/9f),  -d/2f);

        back[10] =  new Point3D(w*(-2f/4f),  h*(2f/9f),  -d/2f);
        back[11] =  new Point3D(w*(-1f/4f),  h*(2f/9f),  -d/2f);
        back[12] =  new Point3D(w*(0f/4f),   h*(2f/9f),  -d/2f);
        back[13] =  new Point3D(w*(1f/4f),   h*(2f/9f),  -d/2f);
        back[14] =  new Point3D(w*(2f/4f),   h*(2f/9f),  -d/2f);

        back[15] =  new Point3D(w*(-2f/4f),  h*(3f/9f),  -d/2f);
        back[16] =  new Point3D(w*(-1f/4f),  h*(3f/9f),  -d/2f);
        back[17] =  new Point3D(w*(0f/4f),   h*(3f/9f),  -d/2f);
        back[18] =  new Point3D(w*(1f/4f),   h*(3f/9f),  -d/2f);
        back[19] =  new Point3D(w*(2f/4f),   h*(3f/9f),  -d/2f);

        back[20] =  new Point3D(w*(-2f/4f),  h*(4f/9f),  -d/2f);
        back[21] =  new Point3D(w*(-1f/4f),  h*(4f/9f),  -d/2f);
        back[22] =  new Point3D(w*(0f/4f),   h*(4f/9f),  -d/2f);
        back[23] =  new Point3D(w*(1f/4f),   h*(4f/9f),  -d/2f);
        back[24] =  new Point3D(w*(2f/4f),   h*(4f/9f),  -d/2f);

        back[25] =  new Point3D(w*(-2f/4f),  h*(5f/9f),  -d/2f);
        back[26] =  new Point3D(w*(-1f/4f),  h*(5f/9f),  -d/2f);
        back[27] =  new Point3D(w*(0f/4f),   h*(5f/9f),  -d/2f);
        back[28] =  new Point3D(w*(1f/4f),   h*(5f/9f),  -d/2f);
        back[29] =  new Point3D(w*(2f/4f),   h*(5f/9f),  -d/2f);

        back[30] =  new Point3D(w*(-2f/4f),  h*(6f/9f),  -d/2f);
        back[31] =  new Point3D(w*(-1f/4f),  h*(6f/9f),  -d/2f);
        back[32] =  new Point3D(w*(0f/4f),   h*(6f/9f),  -d/2f);
        back[33] =  new Point3D(w*(1f/4f),   h*(6f/9f),  -d/2f);
        back[34] =  new Point3D(w*(2f/4f),   h*(6f/9f),  -d/2f);

        back[35] =  new Point3D(w*(-2f/4f),  h*(7f/9f),  -d/2f);
        back[36] =  new Point3D(w*(-1f/4f),  h*(7f/9f),  -d/2f);
        back[37] =  new Point3D(w*(0f/4f),   h*(7f/9f),  -d/2f);
        back[38] =  new Point3D(w*(1f/4f),   h*(7f/9f),  -d/2f);
        back[39] =  new Point3D(w*(2f/4f),   h*(7f/9f),  -d/2f);

        back[40] =  new Point3D(w*(-2f/4f),  h*(8f/9f),  -d/2f);
        back[41] =  new Point3D(w*(-1f/4f),  h*(8f/9f),  -d/2f);
        back[42] =  new Point3D(w*(0f/4f),   h*(8f/9f),  -d/2f);
        back[43] =  new Point3D(w*(1f/4f),   h*(8f/9f),  -d/2f);
        back[44] =  new Point3D(w*(2f/4f),   h*(8f/9f),  -d/2f);

        back[45] =  new Point3D(w*(-2f/4f),  h*(9f/9f),  -d/2f);
        back[46] =  new Point3D(w*(-1f/4f),  h*(9f/9f),  -d/2f);
        back[47] =  new Point3D(w*(0f/4f),   h*(9f/9f),  -d/2f);
        back[48] =  new Point3D(w*(1f/4f),   h*(9f/9f),  -d/2f);
        back[49] =  new Point3D(w*(2f/4f),   h*(9f/9f),  -d/2f);

      //};

      //Point3D[] middle =
      //middle =
      //{
        middle[0] =  new Point3D(w*(-2f/4f),  h*(0f/9f),  0f);
        middle[1] =  new Point3D(w*(-1f/4f),  h*(0f/9f),  0f);
        middle[2] =  new Point3D(w*(0f/4f),   h*(0f/9f),  0f);
        middle[3] =  new Point3D(w*(1f/4f),   h*(0f/9f),  0f);
        middle[4] =  new Point3D(w*(2f/4f),   h*(0f/9f),  0f);

        middle[5] =  new Point3D(w*(-2f/4f),  h*(1f/9f),  0f);
        middle[6] =  new Point3D(w*(-1f/4f),  h*(1f/9f),  0f);
        middle[7] =  new Point3D(w*(0f/4f),   h*(1f/9f),  0f);
        middle[8] =  new Point3D(w*(1f/4f),   h*(1f/9f),  0f);
        middle[9] =  new Point3D(w*(2f/4f),   h*(1f/9f),  0f);

        middle[10] =  new Point3D(w*(-2f/4f),  h*(2f/9f),  0f);
        middle[11] =  new Point3D(w*(-1f/4f),  h*(2f/9f),  0f);
        middle[12] =  new Point3D(w*(0f/4f),   h*(2f/9f),  0f);
        middle[13] =  new Point3D(w*(1f/4f),   h*(2f/9f),  0f);
        middle[14] =  new Point3D(w*(2f/4f),   h*(2f/9f),  0f);

        middle[15] =  new Point3D(w*(-2f/4f),  h*(3f/9f),  0f);
        middle[16] =  new Point3D(w*(-1f/4f),  h*(3f/9f),  0f);
        middle[17] =  new Point3D(w*(0f/4f),   h*(3f/9f),  0f);
        middle[18] =  new Point3D(w*(1f/4f),   h*(3f/9f),  0f);
        middle[19] =  new Point3D(w*(2f/4f),   h*(3f/9f),  0f);

        middle[20] =  new Point3D(w*(-2f/4f),  h*(4f/9f),  0f);
        middle[21] =  new Point3D(w*(-1f/4f),  h*(4f/9f),  0f);
        middle[22] =  new Point3D(w*(0f/4f),   h*(4f/9f),  0f);
        middle[23] =  new Point3D(w*(1f/4f),   h*(4f/9f),  0f);
        middle[24] =  new Point3D(w*(2f/4f),   h*(4f/9f),  0f);

        middle[25] =  new Point3D(w*(-2f/4f),  h*(5f/9f),  0f);
        middle[26] =  new Point3D(w*(-1f/4f),  h*(5f/9f),  0f);
        middle[27] =  new Point3D(w*(0f/4f),   h*(5f/9f),  0f);
        middle[28] =  new Point3D(w*(1f/4f),   h*(5f/9f),  0f);
        middle[29] =  new Point3D(w*(2f/4f),   h*(5f/9f),  0f);

        middle[30] =  new Point3D(w*(-2f/4f),  h*(6f/9f),  0f);
        middle[31] =  new Point3D(w*(-1f/4f),  h*(6f/9f),  0f);
        middle[32] =  new Point3D(w*(0f/4f),   h*(6f/9f),  0f);
        middle[33] =  new Point3D(w*(1f/4f),   h*(6f/9f),  0f);
        middle[34] =  new Point3D(w*(2f/4f),   h*(6f/9f),  0f);

        middle[35] =  new Point3D(w*(-2f/4f),  h*(7f/9f),  0f);
        middle[36] =  new Point3D(w*(-1f/4f),  h*(7f/9f),  0f);
        middle[37] =  new Point3D(w*(0f/4f),   h*(7f/9f),  0f);
        middle[38] =  new Point3D(w*(1f/4f),   h*(7f/9f),  0f);
        middle[39] =  new Point3D(w*(2f/4f),   h*(7f/9f),  0f);

        middle[40] =  new Point3D(w*(-2f/4f),  h*(8f/9f),  0f);
        middle[41] =  new Point3D(w*(-1f/4f),  h*(8f/9f),  0f);
        middle[42] =  new Point3D(w*(0f/4f),   h*(8f/9f),  0f);
        middle[43] =  new Point3D(w*(1f/4f),   h*(8f/9f),  0f);
        middle[44] =  new Point3D(w*(2f/4f),   h*(8f/9f),  0f);

        middle[45] =  new Point3D(w*(-2f/4f),  h*(9f/9f),  0f);
        middle[46] =  new Point3D(w*(-1f/4f),  h*(9f/9f),  0f);
        middle[47] =  new Point3D(w*(0f/4f),   h*(9f/9f),  0f);
        middle[48] =  new Point3D(w*(1f/4f),   h*(9f/9f),  0f);
        middle[49] =  new Point3D(w*(2f/4f),   h*(9f/9f),  0f);
      //};

      //Point3D[] front =
      //front =
      //{
        front[0] =  new Point3D(w*(-2f/4f),  h*(0f/9f),  d/2f);
        front[1] =  new Point3D(w*(-1f/4f),  h*(0f/9f),  d/2f);
        front[2] =  new Point3D(w*(0f/4f),   h*(0f/9f),  d/2f);
        front[3] =  new Point3D(w*(1f/4f),   h*(0f/9f),  d/2f);
        front[4] =  new Point3D(w*(2f/4f),   h*(0f/9f),  d/2f);

        front[5] =  new Point3D(w*(-2f/4f),  h*(1f/9f),  d/2f);
        front[6] =  new Point3D(w*(-1f/4f),  h*(1f/9f),  d/2f);
        front[7] =  new Point3D(w*(0f/4f),   h*(1f/9f),  d/2f);
        front[8] =  new Point3D(w*(1f/4f),   h*(1f/9f),  d/2f);
        front[9] =  new Point3D(w*(2f/4f),   h*(1f/9f),  d/2f);

        front[10] =  new Point3D(w*(-2f/4f),  h*(2f/9f),  d/2f);
        front[11] =  new Point3D(w*(-1f/4f),  h*(2f/9f),  d/2f);
        front[12] =  new Point3D(w*(0f/4f),   h*(2f/9f),  d/2f);
        front[13] =  new Point3D(w*(1f/4f),   h*(2f/9f),  d/2f);
        front[14] =  new Point3D(w*(2f/4f),   h*(2f/9f),  d/2f);

        front[15] =  new Point3D(w*(-2f/4f),  h*(3f/9f),  d/2f);
        front[16] =  new Point3D(w*(-1f/4f),  h*(3f/9f),  d/2f);
        front[17] =  new Point3D(w*(0f/4f),   h*(3f/9f),  d/2f);
        front[18] =  new Point3D(w*(1f/4f),   h*(3f/9f),  d/2f);
        front[19] =  new Point3D(w*(2f/4f),   h*(3f/9f),  d/2f);

        front[20] =  new Point3D(w*(-2f/4f),  h*(4f/9f),  d/2f);
        front[21] =  new Point3D(w*(-1f/4f),  h*(4f/9f),  d/2f);
        front[22] =  new Point3D(w*(0f/4f),   h*(4f/9f),  d/2f);
        front[23] =  new Point3D(w*(1f/4f),   h*(4f/9f),  d/2f);
        front[24] =  new Point3D(w*(2f/4f),   h*(4f/9f),  d/2f);

        front[25] =  new Point3D(w*(-2f/4f),  h*(5f/9f),  d/2f);
        front[26] =  new Point3D(w*(-1f/4f),  h*(5f/9f),  d/2f);
        front[27] =  new Point3D(w*(0f/4f),   h*(5f/9f),  d/2f);
        front[28] =  new Point3D(w*(1f/4f),   h*(5f/9f),  d/2f);
        front[29] =  new Point3D(w*(2f/4f),   h*(5f/9f),  d/2f);

        front[30] =  new Point3D(w*(-2f/4f),  h*(6f/9f),  d/2f);
        front[31] =  new Point3D(w*(-1f/4f),  h*(6f/9f),  d/2f);
        front[32] =  new Point3D(w*(0f/4f),   h*(6f/9f),  d/2f);
        front[33] =  new Point3D(w*(1f/4f),   h*(6f/9f),  d/2f);
        front[34] =  new Point3D(w*(2f/4f),   h*(6f/9f),  d/2f);

        front[35] =  new Point3D(w*(-2f/4f),  h*(7f/9f),  d/2f);
        front[36] =  new Point3D(w*(-1f/4f),  h*(7f/9f),  d/2f);
        front[37] =  new Point3D(w*(0f/4f),   h*(7f/9f),  d/2f);
        front[38] =  new Point3D(w*(1f/4f),   h*(7f/9f),  d/2f);
        front[39] =  new Point3D(w*(2f/4f),   h*(7f/9f),  d/2f);

        front[40] =  new Point3D(w*(-2f/4f),  h*(8f/9f),  d/2f);
        front[41] =  new Point3D(w*(-1f/4f),  h*(8f/9f),  d/2f);
        front[42] =  new Point3D(w*(0f/4f),   h*(8f/9f),  d/2f);
        front[43] =  new Point3D(w*(1f/4f),   h*(8f/9f),  d/2f);
        front[44] =  new Point3D(w*(2f/4f),   h*(8f/9f),  d/2f);

        front[45] =  new Point3D(w*(-2f/4f),  h*(9f/9f),  d/2f);
        front[46] =  new Point3D(w*(-1f/4f),  h*(9f/9f),  d/2f);
        front[47] =  new Point3D(w*(0f/4f),   h*(9f/9f),  d/2f);
        front[48] =  new Point3D(w*(1f/4f),   h*(9f/9f),  d/2f);
        front[49] =  new Point3D(w*(2f/4f),   h*(9f/9f),  d/2f);
      //}
    }

    void rectangle3D(float x, float y, float z, float fw, float h, float d){
      beginShape(QUADS);
      // BACK
      if(frontBack){
        fill(palette.light);
        vertex(x-fw/2f, y-h/2f, z-d/2f);
        vertex(x-fw/2f, y+h/2f, z-d/2f);
        vertex(x+fw/2f, y+h/2f, z-d/2f);
        vertex(x+fw/2f, y-h/2f, z-d/2f);
      }

      // BOTTOM
      if(topBtm){
        fill(palette.dark);
        vertex(x-fw/2f, y+h/2f, z-d/2f);
        vertex(x-fw/2f, y+h/2f, z+d/2f);
        vertex(x+fw/2f, y+h/2f, z+d/2f);
        vertex(x+fw/2f, y+h/2f, z-d/2f);
      }

      // LEFT
      if(leftRight){
        fill(palette.medium);
        vertex(x-fw/2f, y-h/2f, z-d/2f);
        vertex(x-fw/2f, y-h/2f, z+d/2f);
        vertex(x-fw/2f, y+h/2f, z+d/2f);
        vertex(x-fw/2f, y+h/2f, z-d/2f);
      }

      endShape();
    }

