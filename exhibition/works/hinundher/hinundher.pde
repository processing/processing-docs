// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

// 'hin und her'
// by boris mueller [esono.com]
// based on the poem 'der und die' by ernst jandl
// made with processing [processing.org]


// define letters:
// each array contains the pixel layout of a Monaco 9 pt letter
int[][][] alphaList = {
{{2,3},{3,3},{4,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{4,6},{5,6},{2,7},{3,7},{5,7}},               //a
{{1,1},{1,2},{1,3},{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{1,7},{2,7},{3,7},{4,7}},         //b
{{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{1,6},{2,7},{3,7},{4,7},{5,7}},                      //c
{{5,1},{5,2},{2,3},{3,3},{4,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7},{5,7}},        //d
{{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{2,5},{3,5},{4,5},{5,5},{1,6},{2,7},{3,7},{4,7},{5,7}},          //e
{{4,1},{5,1},{3,2},{2,3},{3,3},{4,3},{3,4},{3,5},{3,6},{3,7}},                          //f
{{2,3},{3,3},{4,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7},{5,7},{5,8},{2,9},{3,9},{4,9}},  //g
{{1,1},{1,2},{1,3},{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{1,7},{5,7}},              //h
{{3,1},{2,3},{3,3},{3,4},{3,5},{3,6},{3,7}},                                  //i
{{3,1},{2,3},{3,3},{3,4},{3,5},{3,6},{3,7},{3,8},{1,9},{2,9}},                          //j
{{1,1},{1,2},{1,3},{4,3},{1,4},{3,4},{1,5},{2,5},{3,5},{1,6},{4,6},{1,7},{5,7}},                //k
{{2,1},{2,2},{2,3},{2,4},{2,5},{2,6},{3,7},{4,7}},                                //l
{{1,3},{2,3},{3,3},{4,3},{1,4},{3,4},{5,4},{1,5},{3,5},{5,5},{1,6},{3,6},{5,6},{1,7},{3,7},{5,7}},        //m
{{1,3},{3,3},{4,3},{1,4},{2,4},{5,4},{1,5},{5,5},{1,6},{5,6},{1,7},{5,7}},                    //n
{{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7}},                    //o
{{1,3},{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{1,7},{2,7},{3,7},{4,7},{1,8},{1,9}},        //p
{{2,3},{3,3},{4,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7},{5,7},{5,8},{5,9}},        //q
{{1,3},{3,3},{4,3},{1,4},{2,4},{5,4},{1,5},{1,6},{1,7}},                            //r
{{2,3},{3,3},{4,3},{5,3},{1,4},{2,5},{3,5},{4,5},{5,6},{1,7},{2,7},{3,7},{4,7}},                //s
{{2,1},{2,2},{1,3},{2,3},{3,3},{4,3},{2,4},{2,5},{2,6},{3,7},{4,7}},                      //t
{{1,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{4,6},{5,6},{2,7},{3,7},{5,7}},                    //u
{{1,3},{5,3},{1,4},{5,4},{2,5},{4,5},{2,6},{4,6},{3,7}},                            //v
{{1,3},{3,3},{5,3},{1,4},{3,4},{5,4},{1,5},{3,5},{5,5},{1,6},{3,6},{5,6},{2,7},{4,7}},              //w
{{1,3},{5,3},{2,4},{4,4},{3,5},{2,6},{4,6},{1,7},{5,7}},                            //x
{{1,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7},{5,7},{5,8},{2,9},{3,9},{4,9}},        //y
{{1,3},{2,3},{3,3},{4,3},{5,3},{4,4},{3,5},{2,6},{1,7},{2,7},{3,7},{4,7},{5,7}},                //z
{{2,1},{4,1},{2,3},{3,3},{4,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{4,6},{5,6},{2,7},{3,7},{5,7}},        //Š [ae]
{{2,1},{4,1},{1,3},{5,3},{1,4},{5,4},{1,5},{5,5},{1,6},{4,6},{5,6},{2,7},{3,7},{5,7}},              //š [oe]
{{2,1},{4,1},{2,3},{3,3},{4,3},{1,4},{5,4},{1,5},{5,5},{1,6},{5,6},{2,7},{3,7},{4,7}},              //Ÿ [ue]
{{3,1},{4,1},{2,2},{5,2},{1,3},{5,3},{1,4},{4,4},{1,5},{5,5},{1,6},{5,6},{1,7},{3,7},{4,7},{1,8}},        //§ [sz]
{{1000, 1000}},                                                  //space - bit of a hack
{{1000, 1000}}                                                  //line break
};

// the text in the display, can be changed.
// the text should only contain characters
// * is used for line breaks
// Umlaute are masked; Š=. Ÿ=, š=- §=/
String fullText       = "hin und her und ihr kam*der ist wie ein ist was*das ist was das ist f,r*uns nun los und gib wie*das eis weg s,/ und k,/*bis ans end der uhr und*tag aus aug und ohr weg*nur gut und na/ und s,/*und tau mit rum und los";

int monoLetterWidth   = 6;
int defaultPixSize     = 5;
int xOffset       = 20;
int yOffset       = 20;
int textLength       = fullText.length();
PixLetter[] pixLetterList = new PixLetter[textLength];

void setup() 
{ 
  // define stage
  size(729, 570);
  background(255);

  
  // initialize letters
  for (int t=0; t<textLength; t++)
    {
    // get letter reference for letter
    String cLetter       = fullText.substring(t, (t+1));
    int letterRef       = getLetterRef(cLetter);
    
    // check for line breaks --> 30
    int tempLetterWidth   = monoLetterWidth;
    if (letterRef == 30){newLine(); tempLetterWidth = 0;}
  
    // get array that contains letter layout
    int[][] letterPixList   = alphaList[letterRef];
    int pixPerLetter     = letterPixList.length;
      
      // create and position letter object
    PixLetter tempObject   = new PixLetter(tempLetterWidth, letterPixList, pixPerLetter, defaultPixSize, xOffset, yOffset);
    tempObject.setupLetter();
    
    xOffset = xOffset + (tempLetterWidth * defaultPixSize);
    pixLetterList[t] = tempObject;
    }
}


int getLetterRef(String inLetter){
      int lRef = -1;
    if ("a".equals(inLetter)){lRef = 0;}
    if ("b".equals(inLetter)){lRef = 1;}
    if ("c".equals(inLetter)){lRef = 2;}
    if ("d".equals(inLetter)){lRef = 3;}
    if ("e".equals(inLetter)){lRef = 4;}
    if ("f".equals(inLetter)){lRef = 5;}
    if ("g".equals(inLetter)){lRef = 6;}
    if ("h".equals(inLetter)){lRef = 7;}
    if ("i".equals(inLetter)){lRef = 8;}
    if ("j".equals(inLetter)){lRef = 9;}
    if ("k".equals(inLetter)){lRef = 10;}
    if ("l".equals(inLetter)){lRef = 11;}
    if ("m".equals(inLetter)){lRef = 12;}
    if ("n".equals(inLetter)){lRef = 13;}
    if ("o".equals(inLetter)){lRef = 14;}
    if ("p".equals(inLetter)){lRef = 15;}
    if ("q".equals(inLetter)){lRef = 16;}
    if ("r".equals(inLetter)){lRef = 17;}
    if ("s".equals(inLetter)){lRef = 18;}
    if ("t".equals(inLetter)){lRef = 19;}
    if ("u".equals(inLetter)){lRef = 20;}
    if ("v".equals(inLetter)){lRef = 21;}
    if ("w".equals(inLetter)){lRef = 22;}
    if ("x".equals(inLetter)){lRef = 23;}
    if ("y".equals(inLetter)){lRef = 24;}
    if ("z".equals(inLetter)){lRef = 25;}
    if (".".equals(inLetter)){lRef = 26;}
    if (",".equals(inLetter)){lRef = 27;}
    if ("-".equals(inLetter)){lRef = 28;}
    if ("/".equals(inLetter)){lRef = 29;}
    if ("*".equals(inLetter)){lRef = 30;}
    if (" ".equals(inLetter)){lRef = 31;}
    
    // if string not in array, show blank space
    if (lRef == -1){lRef = 31;}
    
    return lRef;
}


void loop() 
{
  for(int i=0; i<textLength; i++) 
    {
      pixLetterList[i].drawLetter();
    }
}


void mousePressed() {
  for(int i=0; i<textLength; i++) 
    {
    pixLetterList[i].wave(mouseX, mouseY);
    }  
}


void newLine(){
  xOffset = 20;
  yOffset = yOffset + (12 * defaultPixSize);
}


// classes
// ---------------

class PixLetter {
  int[][] pixPosList;
  RePixel newPixObj;
  RePixel[] pixObjList;
  int letterWidth;
  int maxPixel;
  int xPos, yPos;
  int pixSize;
  int xOff, yOff;
  
  PixLetter (int iLetWidth, int[][] iPixelList, int iMaxPixel, int iPixSize, int iXoff, int iYoff){
    // every letter object contains n RePixel objects that represent the
    // pixels of the letter
    letterWidth = iLetWidth;
    pixPosList  = iPixelList;
    maxPixel    = iMaxPixel;
    pixSize     = iPixSize;
    xOff        = iXoff;
    yOff        = iYoff;
    pixObjList  = new RePixel[maxPixel]; 

  }

  void setupLetter(){
    // position the pixels of the letter
    for (int i=0; i<maxPixel; i++)
    {
      int xPixPos   = xOff + (pixPosList[i][0] * pixSize);
      int yPixPos   = yOff + (pixPosList[i][1] * pixSize);
      newPixObj    = new RePixel(xPixPos, yPixPos, pixSize);
      pixObjList[i] = newPixObj;
    }
    
  }
  
  
  void drawLetter(){
    for(int i=0; i<maxPixel; i++)
    {
      pixObjList[i].update();
    }
    
  }
  
  void changeSize(int newPixSize){
    pixSize = newPixSize;
    for(int i=0; i<maxPixel; i++)
    {
      pixObjList[i].changeSize(pixSize);
    }
  }
  
  void wave(int inX, int inY){
    for(int i=0; i<maxPixel; i++)
    {
      int nx = inX;
      int ny = inY;
      pixObjList[i].wave(nx, ny);
    }
  
  }
}
  
  
//----------------

class RePixel {
  int xPos, yPos, size;
  int regSize;
  int distCount   = 0;
  int maxEpicenter   = 8;
  int waveLength   = 40;
  float impact;
  float allWaveSize = 0.0;
  float[][] distList = new float[maxEpicenter][3];
  
  RePixel (int iXpos, int iYpos, int iSize){  
    xPos    = iXpos;
    yPos    = iYpos;
    regSize = iSize;
    size    = regSize;
    
  }
  
  void update(){
    // maximum click points are defined in maxEpicenter
    allWaveSize = 0;
    for (int i=0; i<maxEpicenter; i++)
    {
    // calculate cos curve
    float tempDist = distList[i][0];
    tempDist = tempDist - 5;
    impact = cos(tempDist / waveLength);
    distList[i][0] = tempDist;
    
    // fade amplitude over time
    float tempAmplitude = distList[i][1];
    tempAmplitude = tempAmplitude * 0.98;
    if (tempAmplitude < 0.2){tempAmplitude = 0;}
    distList[i][1] = tempAmplitude;
    
    // response to initial click
    // waves should build up nice and slow
    float tempClickImpact = distList[i][2];
    if (tempClickImpact < 1)
    {
      tempClickImpact = tempClickImpact * 2.0;
      if (tempClickImpact > 1){tempClickImpact = 1;};
      distList[i][2] = tempClickImpact;
    }
    
    // calculate wavesize related to i click point
    // and add it to current state
    float tempWaveSize = tempAmplitude * impact * tempClickImpact;
    allWaveSize = allWaveSize + tempWaveSize;
  }
  
  float waveSize = (allWaveSize + 1) * regSize;
  size = int(waveSize);
  if (size < 0){size = 0;}
  draw();
  }
    
  void changeSize(int iSize){
      size = iSize;
  }
  
  void wave(int inX, int inY){
    // set the values for the new wave 
    int clickX = inX;
    int clickY = inY;
    int dX = clickX - xPos;
    int dY = clickY - yPos;
    // pythagoras:
    float trueDist = sqrt(sq(dX)+sq(dY));
    
    // initial impact
    // sets the 'reactivity' of the first wave
    float clickImpact = 0.015;

  // distance fade impact
  // the height of the amplitude depends on the distance to the click point
    float fadeCalc     = 1.00001;
    float waveExp      = -1 * sq(trueDist);
  float amplitude    = (pow(fadeCalc, waveExp)) * 10.0;
  distList[distCount][0] = trueDist;
  distList[distCount][1] = amplitude;
  distList[distCount][2] = clickImpact;
  
  distCount = distCount + 1;
  if (distCount == maxEpicenter){distCount = 0;}
}
    
  void draw() 
  { 
    // calculate the intesity of the red
    // every rect that is bigger than 32 px should be deep red
    // so 8 is about OK
    int rpixCol = (size - regSize) * 8;
    if (rpixCol > 255){rpixCol = 255;}
    if (rpixCol < 0)  {rpixCol = 0;}
    fill(rpixCol, 0, 0);
    
    // draw the rect
    rectMode(CENTER_DIAMETER);
    noStroke();
    rect(xPos, yPos, size, size);
  }
}
