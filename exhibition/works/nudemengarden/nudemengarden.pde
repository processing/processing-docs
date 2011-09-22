// Nudemen Garden
//---------------------------------------------------------------------
// by Francis Lam (f@db-db.com)  and Henry Chu (henry@exvis.net)
// You can use and modify our codes don't do it for commercial purposes and 
// please drop us an email!
// Apr 2004
//---------------------------------------------------------------------

// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


int res = 10;            // collision detection area

int totalPixels;         // total for array setup
int[][] vPixels;         // video pixel array
int startx, starty;      // pixel to be modified

int bb;                  // hue, saturation, brightness
int brightMean;

boolean newFrame;

// Global variables for rain drops

float[] rain_x;
float[] rain_y;
float[] rain_speed;

int[] rainStartF;
int[] rainStopF;
int[] rainCurrF;
int[] rainStage;  //0:falling 1:landing 2:sitting 3:standing-up 4: standing 5:walking left 6: walking right

int rain_total=30;
int dropLimit=90; //smaller the number, lighter the region they land
int[][] rainTF = {{9,8,1,4,1,5,5}};
int rainTypeTotal = rainTF.length;
int[] rainType;

BImage[][] rainImg;

//////////////////////////////////////////////////////////////////////
int flowerMax = 40;//15;
int cactusMax = 40;//4;
int mimosaMax = 40;//6;

Flower[] flowerList = new Flower[flowerMax];
Cactus[] cactusList = new Cactus[cactusMax];
Mimosa[] mimosaList = new Mimosa[mimosaMax];

BImage[] flowerImageList = new BImage[3];
BImage[] leafImageList = new BImage[3];

BImage spike;
BImage cactusTop;
BImage cactus;
BImage cactusBall;
BImage mimosa;
BImage cloud;

/////////////////////////////////////////////////////////////////////

void setup() { 
println("!!!");
  size(320, 240); 
  background(0);
  ellipseMode(CENTER_DIAMETER);
  noStroke();
  
  vPixels   = new int[height][width];
  
  rainStartF = new int[rain_total];
  rainStopF = new int[rain_total];
  rainCurrF = new int[rain_total];
  rainStage = new int[rain_total];
  
  rain_x = new float[rain_total];
  rain_y = new float[rain_total];
  rain_speed= new float[rain_total];  
  rainType = new int[rain_total];



  rainImg = new BImage[rain_total][50];
  
  /// henry var init start////////////////////////////////////////////////////
  
  spike = loadImage("spike.gif");
  cactusTop = loadImage("cactusTop.gif");
  cactus = loadImage("cactus.gif");
  cactusBall = loadImage("cactusBall.gif");
  mimosa = loadImage("mimosa.gif");
  flowerImageList[0] = loadImage("flower1.gif");
  flowerImageList[1] = loadImage("flower2.gif");
  flowerImageList[2] = loadImage("flower3.gif");
  leafImageList[0] = loadImage("leaf1.gif");
  leafImageList[1] = loadImage("leaf2.gif");
  leafImageList[2] = loadImage("leaf3.gif");

  for (int i=0; i<cactusMax; i++){
      cactusList[i] = new Cactus(0,240,300,50,false);
  }
  for (int i=0; i<mimosaMax; i++){
     mimosaList[i] = new Mimosa(0,240,50,90,false);
  }
  for (int i=0; i<flowerMax; i++){  
      flowerList[i] = new Flower(0,240,10,70,false);  
  }

/////henry var init end///////////////////////////////////////////
  beginVideo(width, height,24);
  
  // init raindrops
  for(int i=0; i<rain_total; i++) { 
  
    initVar(i); 
  
  }
 
  
}


void loop() {


  if (newFrame){

    image(video,0,0);
    newFrame = false;
    drawPlant();    
    drawRain();
  }
  
// Saves each frame as line-0000.tif, line-0001, etc. 
   //saveFrame("garden_close-####.tif"); 
}

void mouseReleased(){
  growNew("Mimosa", mouseX);
}

void videoEvent(){
  if (!newFrame){
    newFrame = true;
  }
}

// get raindrop's total frames
int getTotalFrames(int i){
 int sum=0;
 for (int k=0; k<rainTF[i].length; k++)
   sum = sum + rainTF[i][k];
 return(sum);
}

// get raindrop's total frames from stage
int getTotalFramesFrom(int i, int stageNo){
 int sum=0;
 for (int k=0; k<stageNo+1; k++)
   sum = sum + rainTF[i][k];
 return(sum);
}

// init snow properties
void initVar(int i){

    
    rain_x[i]=random(width);
    rain_y[i]=-100-random(100);
    rain_speed[i]=random(5,10);
    
    //rainType[i]= (int) random(rainTypeTotal);
    rainType[i]=0;
    
    rainGotoStage(0, rainType[i], i);
    
    
    
    int temp=getTotalFrames(rainType[i]);
    
    for (int k=0; k<temp; k++)
    {
      rainImg[i][k]= loadImage("rain"+rainType[i]+"f"+k+".gif"); 
      
     } 
    
}

//goto a raindrop's stage
void rainGotoStage(int stageNo, int rType, int i){

    if (stageNo==0) rainStartF[i]=0;
    else
    {
       rainStartF[i]=getTotalFramesFrom(rType,stageNo-1);
    }

    rainStopF[i]=rainStartF[i]+rainTF[rType][stageNo]-1;
    
    rainCurrF[i]=rainStartF[i];
    
    rainStage[i]=stageNo;


}

void drawRain(){

  
  
  for(int i=0; i<rain_total; i++)
  {
    rain_y[i]+=rain_speed[i];
    if (rain_y[i]>height || rain_x[i]<-100 || rain_x[i]>width+100) {
         
     
     
     // planting
     if (rain_y[i]>height && rain_x[i]>0 && rain_x[i]<width) {
        
        
         if ( int(random(100))>50) growNew("Flower", rain_x[i]);
         else if (int(random(100))>10) growNew("Mimosa", rain_x[i]);
         else growNew("Cactus", rain_x[i]);
      } 
      
      // rebuild
     initVar(i);
    }
    
  if (rain_y[i]>0 && rain_y[i]<height)checkCam(i);
    
  // render rain     
   
     image(rainImg[i][rainCurrF[i]],rain_x[i]-rainImg[i][rainCurrF[i]].width/2, rain_y[i]);
     
     if (rainCurrF[i]>=rainStopF[i]) 
     {
       if (rainStage[i]==0) //falling down
       {
         
       }
       else rainCurrF[i]=rainStartF[i]; //looping
     }
     else rainCurrF[i]++;
   
  }
  


      
}

void checkCam(int ri)
{
  // check video area of the ball 

    startx=(int)(rain_x[ri])-(int)(res/2);
    starty=(int)(rain_y[ri]+rainImg[ri][0].height)-(int)(res/2);
    
    if (startx<0) startx=0;
    if (starty<0) starty=0;
    if (startx>width-res) startx=width-res;
    if (starty>height-res) starty=height-res;

    brightMean=0;
            
    for(int j=starty; j<starty+res; j++){
    for(int i=startx; i<startx+res; i++){
    
      
      vPixels[j][i] = video.pixels[(j * video.width) + i];
      bb = (int)(brightness(vPixels[j][i]));
      
      brightMean += bb;

     }
     }
     
     brightMean = (int) ( brightMean/res/res);
     
     if (brightMean < dropLimit ) 
     {
       
       rain_y[ri]-=rain_speed[ri];
      
       //landing.. (1)
       if (rainStage[ri]==0) rainGotoStage(1, rainType[ri], ri);
       
       
       //sitting (2)
       if (rainStage[ri]==1 && rainCurrF[ri]==rainStopF[ri]) rainGotoStage(2, rainType[ri], ri);
       
       // standing up (3)
       if (rainStage[ri]==2 && rainCurrF[ri]==rainStopF[ri] && random(100)>95) rainGotoStage(3, rainType[ri], ri);
       
       // standing(4)
       if (rainStage[ri]==3 && rainCurrF[ri]==rainStopF[ri]) rainGotoStage(4, rainType[ri], ri);
       
       // walking LEFT(5) Right (6)
       if (rainStage[ri]==4 && rainCurrF[ri]==rainStopF[ri] && random(100)>90) 
       {
          if (random(100)>50) rainGotoStage(5, rainType[ri], ri);
          else rainGotoStage(6, rainType[ri], ri);
       }
       
       // walking 
       float step=random(2,5);
       if (rainStage[ri]==5) rain_x[ri]-=step;
       else if (rainStage[ri]==6) rain_x[ri]+=step;
       
       
     }
     else
     {
       //falling...
       
       if (rainStage[ri]!=0) 
       {
          // if they walking...
          if (rainStage[ri]==5) rain_x[ri]-=20;
          else if (rainStage[ri]==6) rain_x[ri]+=20;
          
          //change to falling stage
          rainGotoStage(0, rainType[ri], ri);
       }
     }
     
     //println("bright:"+brightMean);
    
}

///////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////// Classes written by Henry
///////////////////////////////////////////////////////////////////////////

void drawPlant(){
   for (int i=0; i<cactusMax; i++){
     if(cactusList[i].life>0 && cactusList[i].readyGrow){
       cactusList[i].grow();
     }
   }

   for (int i=0; i<mimosaMax; i++){
     if(mimosaList[i].life>0 && mimosaList[i].readyGrow){
       mimosaList[i].grow();
     }
   }

   for (int i=0; i<flowerMax; i++){
     if(flowerList[i].life>0 && flowerList[i].readyGrow){
       flowerList[i].grow();
     }
   }
}

 void growNew(String type,float x){
   if(type=="Flower"){
     boolean growFinish = false;
     for (int i=0; i<flowerMax && !growFinish; i++){
       if(!flowerList[i].readyGrow){
         flowerList[i] = new Flower(x,240,random(10,20),int(random(15,35)),true);
         growFinish = true;
       }
     }
   }
   if(type=="Cactus"){
     boolean growFinish = false;
     for (int i=0; i<cactusMax && !growFinish; i++){
       if(!cactusList[i].readyGrow){
         cactusList[i] = new Cactus(x,240,random(300,400),int(random(35,70)),true);
         growFinish = true;
       }
     }
   }
   if(type=="Mimosa"){
     boolean growFinish = false;
     for (int i=0; i<mimosaMax && !growFinish; i++){
       if(!mimosaList[i].readyGrow){
         mimosaList[i] = new Mimosa(x,240,50,int(random(35,110)),true);
         growFinish = true;
       }
     }
   }

 }






 class Mimosa{
   float[] xList = new float[300];
   float[] yList = new float[300];
   float[] leafList = new float[300];
   float thickness;
   int currentLeng; // current Length
   int finalLeng; // final Length
   int leng; //length
   float r;
   float motionDetect = 0;
   float foldFactor = 0;//exclusively for mimosa
   float wind = 0;
   float windPower=0;
   float life;
   boolean readyGrow;
   int mKey;

   Mimosa(float X, float Y, float THICKNESS, int LENG, boolean ready){//instantial the flower
     float x = X;
     float y = Y;
     thickness = THICKNESS;
     leng = LENG;
     currentLeng = 0;
     //    finalLeng = int(random(2,5));
     finalLeng = leng;
     readyGrow = ready;
     for(int j=0; j<leng;j++){
       if(j%7==0){
         leafList[j] = 99;
       }
       if(j%7==3){
         leafList[j] = -99;
       }
     }

     for(int i=0; i<leng; i++){
       xList[i] = x;
       yList[i] = y;
       if(leafList[i]==0){
         leafList[i] = -1;
       }
       y -=1;
     }
//     life =(20*30+int(random(5*30)))*3;
     
     life =(5*30+int(random(5*30)))*3;
//     life =400;
//     mKey = 70;
     mKey = int(random(30,80));
   }

   void grow(){/// frame action
     if (readyGrow) life = max(life-3,0);
     
     float motionDetectP = motionDetect;
     motionDetect = 0;
     for(int i=0; i<currentLeng; i++){
       /////check motion before drawing
       color c = video.get(int(xList[i]),int(yList[i]));
       motionDetect = motionDetect + brightness(c);
     }
     float motionDetected=abs(motionDetect-motionDetectP)/currentLeng;
     if (motionDetected>16 && life>currentLeng){
       windPower = min(motionDetected/5,7);
       foldFactor = 1;
       finalLeng = min(finalLeng+5,leng);
     }
     // life matters
     if (life<currentLeng){
       finalLeng = int(life);
     }
     // life matters
     wind = windPower*sin(millis()*0.006 + xList[1]);
     windPower = max(windPower-0.1,float(leng)/500);
     if (foldFactor>0.9){
       foldFactor *= 0.995;
     }else{
       if (foldFactor>0.5){
         foldFactor *= 0.9;
       }else{
         foldFactor *= 0.5;
       }
     }

     currentLeng = min(currentLeng+1,finalLeng);     
     /////////////////////////////////////

//               println(mKey);

     for(int i=0; i<currentLeng; i++){
       float swing = wind*i/currentLeng*1.3*(1+float(i)/20);// behavior affected by wind
       noStroke();
       fill(166,168,72);
       rectMode(CORNER);


       push();
       translate(xList[i]+swing,yList[i]);
       rect(0,0,2,2);
       pop();
       if(leafList[i]!=-1&& i>currentLeng*0.3){
         push();
         translate(xList[i]+swing,yList[i]);
         float leafRotate = 0;
         if(leafList[i]==99){
           leafRotate = PI/3 - float(i)/currentLeng*(0.75*PI);
           leafRotate = leafRotate*(1-foldFactor) + -PI/2*foldFactor;
         }else
         if(leafList[i]==-99){
           leafRotate = PI - (PI/3 - float(i)/currentLeng*(0.75*PI));
           leafRotate = leafRotate*(1-foldFactor) + 3*PI/2*foldFactor;
         }

         rotate(leafRotate);
         scale(float(i)/300+0.4);
         image(mimosa,0,0);
         pop();
       }
     }
     if(life==0){
       readyGrow=false;
//       growNew("Mimosa");
     }
   }
 }

 ///////////////////////////////////

 class Cactus{
   float[] xList = new float[300];
   float[] yList = new float[300];
   float[] leafList = new float[300];
   float thickness;
   int currentLeng; // current Length
   int finalLeng; // final Length
   int leng; //length
   float r;
   float motionDetect = 0;
   float wind = 0;
   float windPower=0;
   float life;
   boolean readyGrow;

   Cactus(float X, float Y, float THICKNESS, int LENG, boolean ready ){//instantial the flower
     float x = X;
     float y = Y;
     thickness = THICKNESS;
     leng = LENG;
     currentLeng = 0;
     readyGrow = ready;
     //    finalLeng = int(random(2,5));
     finalLeng = leng;
     for(int j=0; j<leng;j++){
       if(j%10==0){
         leafList[j] = PI+PI/20;
       }
       if(j%10==7){
         leafList[j] = -PI/20;
       }
     }


     for(int i=0; i<leng; i++){
       xList[i] = x;
       yList[i] = y;
       if(leafList[i]==0){
         leafList[i] = -1;
       }
       y -=1;
     }
     life =(3*30+int(random(3*30)))*3;
   }

   void grow(){/// frame action
     if (readyGrow) life = max(life-3,0);
     float motionDetectP = motionDetect;
     motionDetect = 0;
     for(int i=0; i<currentLeng; i++){
       /////check motion before drawing
       color c = video.get(int(xList[i]),int(yList[i]));
       motionDetect = motionDetect + brightness(c);
     }
     float motionDetected=abs(motionDetect-motionDetectP)/currentLeng;
     if (motionDetected>25 && life>currentLeng){
       windPower = min(motionDetected/3,5);
       finalLeng = min(finalLeng+3,leng);
     }
     // life matters
     if (life<currentLeng){
       finalLeng = int(life);
     }
     // life matters
     wind = windPower*sin(millis()*0.015 + xList[1]);
     windPower = max(windPower-0.5,0);
     currentLeng = min(currentLeng+1,finalLeng);
     /////////////////////////////////////

     for(int i=0; i<currentLeng; i++){
       float swing = wind*i/currentLeng*1.3*(1+float(i)/20);// behavior affected by wind
       noStroke();
       fill(32,145,119);
       ellipseMode(CENTER_DIAMETER);
       float sectionThickness = float(i)/5+sqrt(thickness)/2;
       r = max(sectionThickness,1);

       push();
       translate(xList[i]-r/2+swing,yList[i]);

       //    ellipse(0,0,r,r);
       if(i==currentLeng-1){
         image(cactusTop,0,-r/2+2,r,r/2);
       }else{
         image(cactus,0,0,r,2);
       }
       pop();

       if(leafList[i]!=-1){
         push();
         if(leafList[i]>PI){
           translate(xList[i]+swing-r/2,yList[i]);
         }else{
           translate(xList[i]+swing+r/2,yList[i]);
         }
         rotate(leafList[i]);
         scale(max(float(i)/400+0.1,0.2));
         image(spike,0,0);
         pop();
       }


     }
     if(life==0){
//       growNew("Cactus");
       readyGrow=false;
     }
   }
 }

 ///////////////////////////////////////////////////////////////////////
 class Flower{
   float[] xList = new float[300];
   float[] yList = new float[300];
   float[] leafList = new float[300];
   float thickness;
   int currentLeng; // current Length
   int finalLeng; // final Length
   int leng; //length
   float r;
   float motionDetect = 0;
   float wind = 0;
   float windPower=0;
   float life;
   boolean readyGrow;
   int flowerType;

   Flower(float X, float Y, float THICKNESS, int LENG, boolean ready ){//instantial the flower
     float x = X;
     float y = Y;
     thickness = THICKNESS;
     leng = LENG;
     currentLeng = 0;
     readyGrow = ready;
    // finalLeng = int(random(2,5));
     finalLeng = leng;
     int leafNumber = int(random(2,8));
     for(int j=0; j<leafNumber;j++){
       int whichNodeToGrow = int(random(leng-7));
       if (random(100)>50){
         leafList[whichNodeToGrow] = PI+PI/8;
       }else{
         leafList[whichNodeToGrow] = -PI/8;
       }
     }

     for(int i=0; i<leng; i++){
       xList[i] = x;
       yList[i] = y;
       if(leafList[i]==0){
         leafList[i] = -1;
       }
       y -=1;
     }
     flowerType = int(random(0.4,flowerImageList.length-0.6 ));

     life =(2*30+int(random(3*30)))*3;

   }

   void grow(){/// frame action
     if (readyGrow) life = max(life-3,0);
     float motionDetectP = motionDetect;
     motionDetect = 0;
     for(int i=0; i<currentLeng; i++){
       /////check motion before drawing
       color c = video.get(int(xList[i]),int(yList[i]));
       motionDetect = motionDetect + brightness(c);
     }
     float motionDetected=abs(motionDetect-motionDetectP)/currentLeng;
     if (motionDetected>20 && life>currentLeng){
       windPower = min(motionDetected/3,7);
       finalLeng = min(finalLeng+5,leng);
     }
     // life matters
     if (life<currentLeng){
       finalLeng = int(life);
     }
     // life matters
     wind = windPower*sin(millis()*0.008 + xList[1]);
     windPower = max(windPower-0.3,float(leng)/500);
     currentLeng = min(currentLeng+1,finalLeng);
     /////////////////////////////////////

     for(int i=0; i<currentLeng; i++){
       float swing = wind*i/currentLeng*1.3*(1+float(i)/20);// behavior affected by wind
       noStroke();
       fill(97,120,27);
       rectMode(CENTER_DIAMETER);
       float sectionThickness = thickness*(1-float(leng-currentLeng+i)/leng);
       r = max(sqrt(sectionThickness),1);

       push();
       translate(xList[i]+swing,yList[i]);
       rect(0,0,r,r);
       pop();
       if(leafList[i]!=-1){
         push();
         translate(xList[i]+swing,yList[i]);
         rotate(leafList[i]);
         scale(0.9*(1-float(leng-currentLeng+i)/(1.5*leng)));
         image(leafImageList[flowerType],0,0);
         pop();
       }

       if(i==currentLeng-1){
         push();
         r = float(i*25/50)+5;
         translate(xList[i]+swing,yList[i]-r/2);
         //      rotate(PI*sin(float(millis())/3000+xList[0]));
         image(flowerImageList[flowerType],-r/2,-r/2,r,r);
         pop();
       }

     }

     if(life==0){
//       growNew("Flower");
      readyGrow=false;
     }
   }

 }

 ///////////////////////////////////
