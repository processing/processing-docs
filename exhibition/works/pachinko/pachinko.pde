// friendster pachinko / krister olsson, sound by yoshi sodeoka / 2004
//
// disclaimer: this code is a mess. i've made no attempt to clean it up or make it
// remotely legible. sadly, i don't have the time. use at your own risk!
//
// (i'm just happy it works. lots of bad form.)

// constants

final boolean connected=true;
final String docBase="http://www.tree-axis.com/pretendster/";

final int kMaxBalls=9999;
final int kMaxScore=9999999;

final int kDuckSpacer=50;

final int kGameIntro=0;
final int kGameIntroOut=1;
final int kGameSelectID=2;
final int kGameLoadID=3;
final int kGameLoadIDDone=4;
final int kGameLoadIDError=5;
final int kGameSetup=6;
final int kGamePlay=7;
final int kResetGame=8;
final int kGameOver=9;

// balls

final int kBallWaitingLaunch=1;
final int kBallCB=2;
final int kBallInPlay=3;
final int kBallRunningLeft=4;
final int kBallPlatform=5;
final int kBallJumpToCave=6;
final int kBallRunIntoCave=7;

final int kLive=0;
final int kDie=1;

// swimming ducks

final int kDartingOn=0;
final int kDrifting=1;
//final int kFlipUp=2;
//final int kFlipDown=3;
//final int kPopped=4;

final int kLeft=0;
final int kRight=1;

// marching ducks

final int kNoSpecial=0;
final int kBob=1;
final int kFlipUp=2;
final int kFlipDown=3;
final int kPopped=4;

// URL loading

final int kNotLoaded=0;
final int kLoading=1;
final int kLoaded=2;
final int kLoadFailed=3;

// FFIDContainer

final int kIntroPicMaxSize=50;
final int kGamePicMaxSize=40;

final String unknownString="<unknown>";
final String iFriends0String="no friends          (            )";
final String gFriends0String="...";

// sounds

final int kLowPriority=0;
final int kMediumPriority=1;
final int kHighPriority=2;
final int kHighestPriority=3;

AudioClip silenceSound; // used by system to avoid latency/memory issues
SoundEffect currSoundEffect;
int currSoundPriority;

SoundEffect gunkanSound,bounceSound,alliSound,duckBounceSound,wallSound,platformSound,windmillDieSound,splashSound,alliDieSound;
SoundEffect gameOverSound,fireSound,fireworksSound,introSound,selectSound,notLoadedSound,caveSound,loadedSound,quitSound,pointsSound;

// globals

ArrayList balls=new ArrayList();
ArrayList particles=new ArrayList();
ArrayList scoreBubbles=new ArrayList();
ArrayList loadQueue=new ArrayList();
ArrayList loadedFIDs=new ArrayList();
ArrayList fireworks=new ArrayList();

boolean isApplet=false;
int masterClock;

BFont gameFont,boldBubbleFont,smallScoreBubbleFont,largeScoreBubbleFont;
int gameState;
BImage[] numbers=new BImage[10];
final int[] numbersHOffset={0,-2,0,2,-2,2,0,2,0,0};
final int numberWidth=44;

BImage friendsterNoPhotoImage,noPhotoImage,badPhotoImage;
int loadingFID;

LoadURL FIDLoader=new LoadURL();
LoadURL HSLoader;
FIDContainer mainFIDContainer,tempFIDContainer;
FIDContainer[] secondaryFIDContainers=new FIDContainer[4];
int topSecondaryFIDContainer;

BImage textureImage;

// intro and friendster ID selection

MarchingDuck titleDuck;
BImage pachinkoTileImage,duckImage,duckPatternedImage,duckAlpha;

int hGrid,vGrid,lastGridTime;
int lastRunFrame=0;

MarchingDuck[] marchingDucks;
int[] duckPops;

BImage titleImage,checkmarkImage,nocheckImage;
BImage[] titleBgdImages=new BImage[2];

final int fIDsLength=6;
int[] fIDs=new int[fIDsLength];
float[] fIDZooms=new float[fIDsLength];
int currZoom;
float zoomDir;
int currFIDPos,lastSlotChangeTime;

int currTriAlpha,currTriAlphaDir,lastTriFadeTime;

int textFadeInTime;
final float boxX=43;

int arrowMoveTime;

// main screen

final int rightPanelWidth=76;
final int wallWidth=30;
final int waterMaskStart=15;

int score,displayScore;
int displayBalls;

BImage bgdImage,bgdBlowImage,rightPanelImage,bubbleImage,bubbleGreyImage;
BImage pegImage,pegFrontImage,pegFrontBandImage;
BImage pegShadowImage;
BImage signImage,signBlueImage;
BImage[] windmillImages=new BImage[4];
BImage[] windmillShadowImages=new BImage[4];
BImage[] cbImages=new BImage[4];
BImage cbShadowImage;
BImage[] runLImages=new BImage[3];
BImage[] runRImages=new BImage[3];
BImage fallLImage,fallRImage,runWhiteImage,runRedImage,runRedBorderImage;

BImage[] platformRipplesImages=new BImage[3];
BImage[] platformImages=new BImage[4];
BImage caveImage,caveMaskImage,floorImage;
BImage alliClosedImage,alliOpenImage;
BImage tinyDuckRightImage,tinyDuckLeftImage;
BImage tinyPatternedDuckRightImage,tinyPatternedDuckLeftImage;

BImage noNameImage,flourishImage;

int currWaterLevel,fireDelayTime,windmillTime,lastWindmillAnimTime,lastSlowWindmillAnimTime;
int activeWindmill,windmill1Frame,windmill2Frame;
int platformDisplacement,peopleOnPlatform;
int alliTime,alliStartTime,alliSnapTime,currAlliX;

boolean showHelp,endGame,fireBall,slidingRightPanel,alliActive;
int slidingRightPanelStartTime;

SwimmingDuck[] swimmingDucks=new SwimmingDuck[3];

// taken from toxi's post on processing discourse. circumvents jar cache issues

public BImage loadImage(String file) {
  try {
    byte[] imgarray=loadBytes(file);
    java.awt.Image awtimage=Toolkit.getDefaultToolkit().createImage(imgarray);
    MediaTracker tracker = new MediaTracker(this);
    tracker.addImage(awtimage, 0);
    try {
      tracker.waitForAll();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    int w = awtimage.getWidth(null);
    int h = awtimage.getHeight(null);
    int[] pix = new int[w*h];

    PixelGrabber pg = new PixelGrabber(awtimage, 0, 0, w, h, pix, 0, w);

    try {
      pg.grabPixels();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }

    BImage img=new BImage(pix,w,h,RGB);

    if (file.toLowerCase().endsWith(".gif")) {
      for (int i = 0; i < pix.length; i++) {
        if ((pix[i] & 0xff000000) != 0xff000000) {
          img.format=RGBA;
          break;
        }
      }
    }
    return img;
  }
  catch(Exception e) {
    return null;
  }
}

// our custom sound nonsense. requires a browser

void initSound() {
  // set up our sound engine

  if (isApplet) {
    silenceSound=getAudioClip(getClass().getResource("silence.au"));
    silenceSound.loop();
  }

  currSoundPriority=0;
  currSoundEffect=null;
}

void playSound(SoundEffect soundToPlay, int priority) {
  if (isApplet) {
    // are we currently playing a sound?

    boolean playSound=true;

    if (currSoundEffect!=null) {
      // are we playing a sound now?

      if (millis()<currSoundEffect.startTime+currSoundEffect.duration) {
        if (soundToPlay==currSoundEffect) {
          // same as current sound playing

          playSound=false;
        } else if (priority<=currSoundPriority) {
          // don't interrupt

          playSound=false;
        } else {
          // let the sound finish?

          // we should stop the sound, but too much clicking.
          //currSoundEffect.stop();
        }
      }
    }

    if (playSound) {
      currSoundPriority=priority;
      currSoundEffect=soundToPlay;

      currSoundEffect.play();
    }
  }
}

void soundCleanup() {
  if (currSoundEffect!=null) {
    currSoundEffect.stop();

    currSoundPriority=0;
    currSoundEffect=null;
  }

  if (isApplet) silenceSound.stop();
}

class SoundEffect {
  int duration,startTime; // in millis
  private AudioClip sound;

  public SoundEffect(String soundString) {
    if (isApplet) {
      startTime=0;
      sound=getAudioClip(getClass().getResource(soundString));

      // calculate duration. seems kinda lame to reload
      // au only

      byte[] data=loadBytes(soundString);

      // get header

      int dataSize=((data[8]&0xff)<<24)+((data[9]&0xff)<<16)+((data[10]&0xff)<<8)+(data[11]&0xff);
      duration=dataSize/16+50; // add 50 milliseconds or so to compensate for latency
    }
  }

  void play() {
    sound.play();
    startTime=millis();
  }

  void stop() {
    sound.stop();
    startTime=0;
  }
}

void setup() {
  size(400,514);
  framerate(9999);
  imageMode(CENTER_DIAMETER);
  strokeWeight(1);
  g.depthTest=false;

  if (online()) isApplet=true;

  // set up our fonts

  gameFont=loadFont("Goudy_Old_Style.vlw");
  boldBubbleFont=loadFont("Helvetica_Bold.vlw");
  smallScoreBubbleFont=loadFont("Goudy_Old_Style_Bold14.vlw");
  largeScoreBubbleFont=loadFont("Goudy_Old_Style_Bold18.vlw");
  textSpace(SCREEN_SPACE);
  textFont(gameFont);

  for (int i=0;i<10;i++) {
    numbers[i]=loadImage(nf(i,1)+".gif");
  }

  // ducks!

  duckImage=loadImage("duck_s_small.gif");
  duckPatternedImage=loadImage("duck_patterned_small.gif");
  duckAlpha=loadImage("duck_s_small_alpha.gif");

  duckImage.alpha(duckAlpha);
  duckPatternedImage.alpha(duckAlpha);

  int numDucks=((width/kDuckSpacer)+1)*2; // so it takes a while for the patterned duck to come back
  marchingDucks=new MarchingDuck[numDucks];

  // our duck pop order, this is unnecessary and is a really silly way to do it

  ArrayList tempDuckPops=new ArrayList();
  duckPops=new int[numDucks];
  for (int i=0;i<numDucks;i++) tempDuckPops.add(new Integer(i));

  for (int i=0;i<numDucks;i++) {
    int temp=int(random(tempDuckPops.size()));
    duckPops[i]=((Integer)tempDuckPops.get(temp)).intValue();
    tempDuckPops.remove(temp);
  }

  // title, selection etcetera

  pachinkoTileImage=loadImage("pachinko_tile.gif");
  titleImage=loadImage("title.gif");
  titleBgdImages[0]=loadImage("titlebgd1.gif");
  titleBgdImages[1]=loadImage("titlebgd2.gif");
  checkmarkImage=loadImage("checkmark.gif");
  nocheckImage=loadImage("nocheck.gif");

  // game images

  bgdImage=loadImage("bgd.gif");
  bgdBlowImage=loadImage("bgd_blow.gif");

  rightPanelImage=loadImage("right_panel.gif");
  bubbleImage=loadImage("bubble.gif");
  bubbleGreyImage=loadImage("bubble_grey.gif");

  friendsterNoPhotoImage=loadImage("nophoto.jpg");
  noPhotoImage=loadImage("nophoto.gif");
  badPhotoImage=loadImage("badphoto.gif");
  textureImage=loadImage("texture.gif");
  pegImage=loadImage("peg.gif");
  pegFrontImage=loadImage("peg_front.gif");
  pegFrontBandImage=loadImage("peg_front_band.gif");
  pegShadowImage=loadImage("peg_shadow.gif");

  signImage=loadImage("sign.gif");
  signBlueImage=loadImage("sign_blue.gif");

  for (int i=0;i<4;i++) {
    windmillImages[i]=loadImage("windmill"+(i+1)+".gif");
    windmillShadowImages[i]=loadImage("windmill_shadow"+(i+1)+".gif");
  }

  for (int i=0;i<4;i++) cbImages[i]=loadImage("cb"+(i+1)+".gif");
  cbShadowImage=loadImage("cb_shadow.gif");

  for (int i=0;i<3;i++) {
    runLImages[i]=loadImage("run_l"+(i+1)+".gif");
    runRImages[i]=loadImage("run_r"+(i+1)+".gif");
  }

  fallLImage=loadImage("fall_l.gif");
  fallRImage=loadImage("fall_r.gif");
  runWhiteImage=loadImage("run_white.gif");
  runRedImage=loadImage("run_red.gif");
  runRedBorderImage=loadImage("run_red_border.gif");

  for (int i=0;i<3;i++) platformRipplesImages[i]=loadImage("platform_ripples"+(i+1)+".gif");
  for (int i=0;i<4;i++) platformImages[i]=loadImage("platform"+(i+1)+".gif");

  caveImage=loadImage("cave.gif");
  caveMaskImage=loadImage("cave_mask.gif");
  floorImage=loadImage("floor.gif");
  floorImage.alpha(loadImage("floor_alpha.gif"));

  alliOpenImage=loadImage("alli_open.gif");
  alliClosedImage=loadImage("alli_closed.gif");

  tinyDuckLeftImage=loadImage("duck_s_tiny.gif");
  tinyDuckRightImage=loadImage("duck_s_tiny.gif");

  BImage tla=loadImage("duck_tiny_left_alpha.gif");
  BImage tra=loadImage("duck_tiny_right_alpha.gif");

  tinyDuckLeftImage.alpha(tla);
  tinyDuckRightImage.alpha(tra);

  tinyPatternedDuckLeftImage=loadImage("duck_patterned_tiny.gif");
  tinyPatternedDuckRightImage=loadImage("duck_patterned_tiny.gif");

  tinyPatternedDuckLeftImage.alpha(tla);
  tinyPatternedDuckRightImage.alpha(tra);

  noNameImage=loadImage("no_name.gif");
  flourishImage=loadImage("flourish.gif");

  // our FIDContainers

  mainFIDContainer=new FIDContainer();
  tempFIDContainer=new FIDContainer();

  for (int i=0;i<4;i++) {
    secondaryFIDContainers[i]=new FIDContainer();
  }

  // sounds

  initSound();
  gunkanSound=new SoundEffect("gunkan.au");
  bounceSound=new SoundEffect("bounce.au");
  alliSound=new SoundEffect("alli.au");
  duckBounceSound=new SoundEffect("duck_bounce.au");
  wallSound=new SoundEffect("wall.au");
  platformSound=wallSound; //new SoundEffect("silence.au");
  windmillDieSound=new SoundEffect("windmill_die.au");
  splashSound=new SoundEffect("splash.au");
  alliDieSound=new SoundEffect("alli_die.au");
  gameOverSound=new SoundEffect("game_over.au");
  fireSound=new SoundEffect("fire.au");
  fireworksSound=new SoundEffect("fireworks.au");
  introSound=new SoundEffect("intro.au");
  selectSound=new SoundEffect("select.au");
  notLoadedSound=new SoundEffect("not_loaded.au");
  caveSound=new SoundEffect("cave.au");
  loadedSound=new SoundEffect("loaded.au");
  quitSound=new SoundEffect("quit.au");
  pointsSound=new SoundEffect("points.au");

  // ready to go

  titleDuck=new MarchingDuck(width/2+30,height/2+18,duckImage,true,true);
  masterClock=millis();

  gameState=kGameIntro;
}

void loop() {
  background(255);

  switch(gameState) {
    case kGameIntro:
    // intro mode

    float lt=1;
    float dt=0;
    float pt=1;

    if (millis()-masterClock<1500) {
      // radiating lines

      lt=getTimeFrac(500,1000);
      pt=getTimeFrac(1000,150);

    } else if (millis()-masterClock<2250) {
      dt=getTimeFrac(1500,750);
    } else {
      if (masterClock!=0) {
        titleDuck.dropX=titleDuck.x+3+int(random(1,3)*3);
        titleDuck.dropStartTime=millis();
        masterClock=0;
        dt=1.01;
        playSound(introSound,kHighestPriority);
      } else dt=1.0;
    }

    drawIntroDuck(lt,dt,pt);

    break;

    case kGameIntroOut:

    drawIntroDuckMask(1-getTimeFrac(1700,350));

    float t;

    if (millis()-masterClock<1000) {
      drawIntroDuck(1-getTimeFrac(0,1000),1,1);
    } else if (millis()-masterClock<1500) {
      t=getTimeFrac(1000,500);

      titleDuck.by=int((height/2+18)*(1-t)+(height+200)*t);
      titleDuck.draw(1);
    } else if (millis()-masterClock<1900) {
      t=getTimeFrac(1500,400);

      titleDuck.by=height+200;
      titleDuck.y=int((height/2+18)*(1-t)+(height+200)*t);
      titleDuck.draw(1);
    } else if (millis()-masterClock<2150) {
      // nothing i guess...
    } else {
      goSelect();
    }

    break;

    case kGameSelectID:
    // selecting ID

    // update numbers

    if (millis()-lastSlotChangeTime>50){
      lastSlotChangeTime=millis();

      for (int i=currFIDPos;i<fIDsLength;i++) {
        if (++fIDs[i]>9) fIDs[i]=0;
      }
    }

    // draw grid

    if (fIDZooms[1]>.4) {
      drawGrid();
    }

    // draw bgd texture

    float txt=getTimeFrac(0,500);

    drawTexture(txt);

    // update our ducks

    marchDucks(txt);

    // draw numbers

    float ax=0,ay=0;

    boolean doDrawArrow=false;
    if (fIDZooms[0]==1) doDrawArrow=true;

    for (int i=0;i<fIDsLength;i++) {
      push();
      translate(width/2+(numberWidth*(i-(fIDsLength/2))+numberWidth/2)+numbersHOffset[fIDs[i]],height/5*3+5,-45);
      for (int j=0;j<=180;j+=20) {
        if (j==180) noTint();
        else tint(0,j);

        image(numbers[fIDs[i]],0,0);
        translate(0,2*fIDZooms[i],15*fIDZooms[i]);
      }

      if (fIDZooms[i]<1 && i<=currZoom) {
        fIDZooms[i]+=.2;
        if (i==currZoom && i!=fIDsLength-1 && fIDZooms[i]==.4) currZoom++;
      }

      if (i==currFIDPos) {
        ax=screenX(-numbersHOffset[fIDs[i]],numbers[fIDs[i]].height/2+10,-15);
        ay=screenY(-numbersHOffset[fIDs[i]],numbers[fIDs[i]].height/2+10,-15);
      }
      pop();
    }

    // draw arrow + photo + text

    if (doDrawArrow) {
      if (currFIDPos<=5) drawArrow(ax,ay,true);

      drawPhotoText("Select a Friendster with the space bar or 0-9 keys.",min(((millis()-textFadeInTime)/1000.0)*255,255));
    } else textFadeInTime=millis();

    break;

    case kGameLoadID:
    case kGameLoadIDDone:
    case kGameLoadIDError:

    // draw grid

    drawGrid();

    // draw bgd texture

    drawTexture(1);

    // update our ducks

    marchDucks(1);

    // draw numbers

    int rai=int(((millis()-arrowMoveTime)%3000)/(3000/fIDsLength));
    ax=ay=0;

    for (int i=0;i<fIDsLength;i++) {
      push();
      translate(width/2+(numberWidth*(i-(fIDsLength/2))+numberWidth/2)+numbersHOffset[fIDs[i]],height/5*3+5,-45);
      for (int j=0;j<=180;j+=20) {
        if (j==180) noTint();
        else tint(0,j);

        image(numbers[fIDs[i]],0,0);
        translate(0,2*fIDZooms[i],15*fIDZooms[i]);

        if (i==rai) {
          ax=screenX(-numbersHOffset[fIDs[i]],numbers[fIDs[i]].height/2+10,-15);
          ay=screenY(-numbersHOffset[fIDs[i]],numbers[fIDs[i]].height/2+10,-15);
        }
      }
      fIDZooms[i]+=zoomDir;

      pop();
    }

    if (fIDZooms[0]<=.2 || fIDZooms[0]>=1) {
      zoomDir=-zoomDir;
    }

    // draw arrow

    currTriAlpha=128;
    drawArrow(ax,ay,false);

    // draw photo + text

    if (gameState==kGameLoadID) {
      // are we loaded?

      if (FIDLoader.loadStatus==kLoaded) {
        mainFIDContainer.parse(loadingFID,FIDLoader.data);

        masterClock=millis();
        FIDLoader.loadStatus=kNotLoaded;
        if (mainFIDContainer.ok) {
          playSound(loadedSound,kHighPriority);
          gameState=kGameLoadIDDone;
        } else {
          playSound(notLoadedSound,kHighPriority);
          gameState=kGameLoadIDError;
        }
      } else if (FIDLoader.loadStatus==kLoadFailed) {
        // start over

        masterClock=millis();
        FIDLoader.loadStatus=kNotLoaded;
        gameState=kGameLoadIDError;
      }

      drawPhotoText("Loading Friendster...",255);
    } else if (gameState==kGameLoadIDDone) {
      // success!

      drawPhotoText("Friendster loaded!",255);

      float temp=255*(1-getTimeFrac(0,5000));
      stroke(255,0,0,temp);
      noFill();

      int tx=width-140;
      int ty=197;
      int sub=33;

      line(tx-sub,ty-sub,tx+(sub-1),ty-sub);
      line(tx+sub,ty-sub,tx+sub,ty+(sub-1));
      line(tx+sub,ty+(sub-1),tx-(sub-1),ty+(sub-1));
      line(tx-sub,ty+(sub-1),tx-sub,ty-(sub-1));

      tint(255,0,0,temp);
      image(checkmarkImage,tx,ty);

      if (millis()-masterClock>5000) {
        couldLoadContinue();
      }
    } else if (gameState==kGameLoadIDError) {
      // error! draw a big 'X' and start over

      drawPhotoText("Could not load Friendster! Try another.",255);

      float temp=255*(1-getTimeFrac(0,5000));
      stroke(255,0,0,temp);
      noFill();

      int tx=width-140;
      int ty=197;
      int sub=33;

      line(tx-sub,ty-sub,tx+(sub-1),ty-sub);
      line(tx+sub,ty-sub,tx+sub,ty+(sub-1));
      line(tx+sub,ty+(sub-1),tx-(sub-1),ty+(sub-1));
      line(tx-sub,ty+(sub-1),tx-sub,ty-(sub-1));

      tint(255,0,0,temp);
      image(nocheckImage,tx,ty);

      if (millis()-masterClock>5000) {
        couldNotLoadReset();
      }
    }

    break;

    case kGameSetup:
    // out with the old, in with the new

    // OLD

    undrawGrid();

    // NEW

    float xt=getTimeFrac(1050,250);
    float yt=getTimeFrac(1150,250);

    drawMainBackground(getTimeFrac(1150,500));
    drawPool(xt,yt);

    float pegt=getTimeFrac(1500,750);
    float ct=getTimeFrac(1875,375);
    drawPegBacks(xt,yt,ct,pegt); // shadows too

    drawConveyorPlatform(ct);
    drawPegFronts(pegt);
    drawRightPanel(getTimeFrac(950,250));
    drawScore(getTimeFrac(2200,250));
    drawHelp(getTimeFrac(2400,600));

    // OLD STUFF TO GET RID OF

    txt=1-getTimeFrac(0,500);

    drawTexture(txt);

    // pop ducks

    int temp=min(marchingDucks.length,(millis()-masterClock)/25);
    for (int i=0;i<temp;i++) {
      if (marchingDucks[duckPops[i]].specialType!=kPopped) marchingDucks[duckPops[i]].doPop();
    }

    marchDucks(txt);

    // draw numbers

    float fally=getTimeFrac(500,500)*height/5*3;

    if (fally<height/5*3) {
      for (int i=0;i<fIDsLength;i++) {
        push();
        translate(width/2+(numberWidth*(i-(fIDsLength/2))+numberWidth/2)+numbersHOffset[fIDs[i]],height/5*3+5+fally,-45);
        for (int j=0;j<=180;j+=20) {
          if (j==180) noTint();
          else tint(0,j);

          image(numbers[fIDs[i]],0,0);
          translate(0,2*fIDZooms[i],15*fIDZooms[i]);
        }

        pop();
      }
    }
    drawPhotoText("Friendster Loaded!",(1-getTimeFrac(0,500))*255);

    if (millis()-masterClock>3000) {
      // create our ducks

      for (int i=0;i<swimmingDucks.length;i++) swimmingDucks[i]=new SwimmingDuck(i);

      // let's go

      gameState=kGamePlay;
    }

    drawParticles();
    break;

    case kGamePlay:
    case kGameOver:
    drawMainBackground(1);
    drawPool(1,1);
    drawPegBacks(1,1,1,1);
    drawConveyorPlatform(1);
    updateBalls();
    swimDucks();
    doAlli();
    drawParticles();
    drawPegFronts(1);
    drawRightPanel(1);
    doScoreBubbles();
    drawScore(1);

    manageLoadQueue();

    if (showHelp) drawHelp(1);

    // logic

    // do we have any balls left? if not -> kGameOver

    if (endGame) {
      // end the game here -> kEndGame
      // pop ducks

      for (int i=0;i<swimmingDucks.length;i++) {
        swimmingDucks[i].doPop();
      }

      // pop alli

      if (alliActive) {
        for (int i=135;i<225;i+=5) {
          float pex,pey;
          push();

          translate(currAlliX+6,height-135+11+6,0);
          rotateZ(i*PI/180);

          translate(0,70+random(50),0);

          pex=screenX(0,0,0);
          pey=screenY(0,0,0);

          pop();

          particles.add(new Particle(currAlliX+6,height-135+11+6,pex,pey,3,int(500+random(1750)),10,74,26));
        }
      }

      // pop balls

      while(balls.size()>0) {
        Ball tb=(Ball)balls.get(0);

        tb.doPop();
        tb.kill();
      }

      // kill our load queue

      loadQueue.clear();
      threadCleanup();

      masterClock=millis();
      gameState=kResetGame;
    } else if (gameState==kGameOver) {
      drawGameOver(getTimeFrac(0,600));
    } else if (checkGameOver()) {
      masterClock=millis();

      HSLoader.load("pachinkoHS.php?friendsterid="+mainFIDContainer.FID+"&score="+score);

      fireworks.clear();
      playSound(gameOverSound,kHighestPriority);
      gameState=kGameOver;
    } else if (fireBall && millis()>fireDelayTime) {
      // if we have any balls left, fire one

      doFireBall();
      fireDelayTime=millis()+250;
      fireBall=false;
    }

    break;

    case kResetGame:

    xt=getTimeFrac(950,250);
    yt=getTimeFrac(850,250);

    drawMainBackground(1-getTimeFrac(650,500));
    drawPool(1-xt,1-yt);

    pegt=getTimeFrac(500,500);
    ct=getTimeFrac(325,375);
    drawPegBacks(1-xt,1-yt,1-ct,1-pegt); // shadows too
    drawConveyorPlatform(1-ct);
    drawParticles();
    drawPegFronts(1-pegt);
    drawRightPanel(1-getTimeFrac(1300,250));
    doScoreBubbles();
    drawScore(1-getTimeFrac(0,250));

    if (millis()-masterClock>1750) {
      goSelect();
    }

    break;
  }
}

public void threadCleanup() {
  // clean up our threads!

  if (FIDLoader!=null) FIDLoader.stop(); // stop loading our URL if necessary ('if' is redundant)
  if (mainFIDContainer!=null) mainFIDContainer.stop(); // stop loading our image if necessary ('if' is redundant)

  // secondary FIDContainers

  for (int i=0;i<4;i++) {
    if (secondaryFIDContainers[i]!=null) secondaryFIDContainers[i].stop();
  }
}

public void stop() {
  threadCleanup();
  soundCleanup();
  super.stop();
}

void mousePressed() {
  switch(gameState) {
    case kGameIntro:
    // intro mode

    masterClock=millis();

    gameState=kGameIntroOut;
    playSound(introSound,kHighestPriority);
    break;

    case kGameLoadIDDone:
    case kGameLoadIDError:

    masterClock-=5000;
    break;

    case kGamePlay:
    showHelp=false;
    break;

    case kGameOver:
    endGame=true;
    break;
  }
}

void keyPressed() {
  switch(gameState) {
    case kGameSelectID:
    // select ID
    int tk=key;

    if ((tk==' ' || (tk>='0' && tk<='9')) && (millis()-textFadeInTime)>500) {

      if (tk!=' ') fIDs[currFIDPos]=tk-48;

      if (currFIDPos<=5) playSound(selectSound,kMediumPriority);
      if (++currFIDPos>5) {
        // all done

        arrowMoveTime=millis();

        zoomDir=-.1;

        // load our friendster id

        loadingFID=0;

        for (int i=0;i<fIDsLength;i++) {
          loadingFID*=10;
          loadingFID+=fIDs[i];
        }

        gameState=kGameLoadID;

        FIDLoader.load("getSpiderData.php?friendsterid="+loadingFID);
      }
    }
    break;

    case kGamePlay:
    tk=key;
    if (tk==' ') fireBall=true;
    else if ((tk=='Q' || tk=='q') && (!endGame)) {
      playSound(quitSound,kHighestPriority);
      endGame=true;
    }

    showHelp=false;
    break;

    case kGameOver:
    tk=key;
    if (tk=='Q' || tk=='q') endGame=true;
    break;
  }
}

// draw routines

float getTimeFrac(int start, int dur) {
  return constrain((millis()-(masterClock+start))/float(dur),0,1);
}

void drawIntroDuckMask(float t) {
  fill(244*t+255*(1-t));
  noStroke();
  ellipse(width/2-70,height/2-70,140,140);
  ellipse(width/2-70,height/2-50,20,20);
  ellipse(width/2+70-20,height/2-50,20,20);
  ellipse(width/2-70,height/2+50-20,20,20);
  ellipse(width/2+70-20,height/2+50-20,20,20);
  rect(width/2-70,height/2-40,140,80);
  rect(width/2-60,height/2-50,120,100);

  tint(255,(sin((millis()-2500)/1000.0)*148+128));
  image(pachinkoTileImage,width/2,height/2);
}

void drawIntroDuck(float lt, float dt, float pt) {
  // radiating lines

  final float[] rotArray={.125,.5,.75,.75,.5,.25,.125};
  final float[] strokeArray={250,240,230,220,230,240,250};

  noStroke();

  int ta=int(lt*360.0);
  float k=millis()/(3*180.0)*PI;

  for (int i=0;i<ta;i+=6) {
    float rot=0;

    for (int j=0;j<strokeArray.length;j++) {
      float sx,sy,ex,ey;
      push();

      translate(width/2,height/2,0);

      push();

      rotateZ((i+rot+k)*PI/180);
      translate(0,height);

      sx=screenX(0,0,0);
      sy=screenY(0,0,0);

      pop();

      rot+=rotArray[j];
      rotateZ((i+rot+k)*PI/180);
      translate(0,height);

      ex=screenX(0,0,0);
      ey=screenY(0,0,0);

      pop();

      fill(strokeArray[j]);
      triangle(width/2,height/2,sx,sy,ex,ey);
    }
  }

  // mask

  drawIntroDuckMask(1);

  // duck

  titleDuck.y=int(-100*(1-dt)+(height/2+18)*dt);
  titleDuck.draw(pt);
}

void goSelect() {
  // reset grid

  hGrid=vGrid=-10;
  lastGridTime=millis();

  // reset ducks

  int numDucks=marchingDucks.length;

  int specialDuck=2;

  int patternedDuck1=max(3,int(random(numDucks)));
  int patternedDuck2=max(3,int(random(numDucks)));

  for (int i=0;i<numDucks;i++) {
    if (i==specialDuck) marchingDucks[i]=new MarchingDuck(500+i*kDuckSpacer,102,duckImage,true,false);
    else if (i==patternedDuck1 || i==patternedDuck2) marchingDucks[i]=new MarchingDuck(500+i*kDuckSpacer,102,duckPatternedImage,false,false);
    else marchingDucks[i]=new MarchingDuck(500+i*kDuckSpacer,102,duckImage,false,false);
  }

  // reset fIDs

  for (int i=0;i<fIDsLength;i++) {
    fIDs[i]=int(random(10));
    fIDZooms[i]=0;
  }
  currZoom=0;

  currFIDPos=0;
  lastSlotChangeTime=millis();

  loadedFIDs.clear();

  // reset arrow

  currTriAlpha=0;
  currTriAlphaDir=1;
  lastTriFadeTime=millis();

  // reset FIDContainers

  mainFIDContainer.reset();

  for (int i=0;i<4;i++) {
    secondaryFIDContainers[i].reset();
  }

  // go!

  masterClock=millis();
  textFadeInTime=millis();
  gameState=kGameSelectID;
}

void drawGrid() {
  if (millis()-lastGridTime>50) {
    lastGridTime=millis();

    hGrid=min(hGrid+60,height);
    vGrid=min(vGrid+44,width);

    int blend=128;
    for (int j=0;j<4;j++) {
      stroke(96,blend);

      for (int i=0;i<hGrid;i+=14) {
        line(0,i+j,width/constrain((hGrid-i)/20,1,8),i+j);
      }

      for (int i=0;i<vGrid;i+=14) {
        line(i+j,0,i+j,height/constrain((vGrid-i)/20,1,8));
      }

      blend/=3;
    }
  }
}

void undrawGrid() {
  if (millis()-lastGridTime>50) {
    lastGridTime=millis();

    hGrid=max(hGrid-60,0);
    vGrid=max(vGrid-44,0);

    int blend=96;
    for (int j=0;j<4;j++) {
      stroke(96,blend);

      for (int i=0;i<hGrid;i+=14) {
        line(0,i+j,width/constrain((hGrid-i)/20,1,8),i+j);
      }

      for (int i=0;i<vGrid;i+=14) {
        line(i+j,0,i+j,height/constrain((vGrid-i)/20,1,8));
      }

      blend/=3;
    }
  }
}

void marchDucks(float t) {
  // ducks

  for (int i=0;i<marchingDucks.length;i++) {
    marchingDucks[i].march();
    marchingDucks[i].draw(1);
  }

  if (t>0) {
    // we've done the ducks, now do the waves

    smooth();
    stroke(2,135,195,100*t);
    strokeWeight(2);

    int y=139;
    float dx=sin(millis()/500.0)*10+50;
    float x=-((dx*(width/40.0)-width)/2.0);
    int dy=11;

    while (x<width) {
      curve(x,y,x+dx*.25,y-dy,x+dx*.75,y+dy,x+dx,y);
      x+=dx;
    }

    x=-20+(millis()%500)/25;
    dx=20;
    dy=6;

    while (x<width) {
      curve(x,y,x+dx*.25,y-dy,x+dx*.75,y+dy,x+dx,y);
      x+=dx;
    }
    strokeWeight(1);
    noSmooth();

    // running men

    imageMode(CORNER);
    tint(255,192*t);

    x=(millis()%1400)/70;

    for (int i=-20;i<width;i+=20) {
      image(runRImages[lastRunFrame],x+i,height-75);
    }

    lastRunFrame=++lastRunFrame%3;
    imageMode(CENTER_DIAMETER);
  }
}

void drawTexture(float t) {
  if (t>0) {

    noTint();
    image(textureImage,-200*(1-t)+75*t,220);

    noStroke();
    fill(255);
    rect((90+boxX-200)*(1-t)+(90+boxX)*t,225,100,40);
  }
}

void drawArrow(float x,float y, boolean throb) {
  stroke(255);
  fill(255);
  triangle(x,y,x+10,y+10,x-10,y+10);

  stroke(96,0,0);
  fill(255,0,0,currTriAlpha);
  triangle(x,y,x+10,y+10,x-10,y+10);

  if (millis()-lastTriFadeTime>50 && throb) {
    lastTriFadeTime=millis();
    currTriAlpha+=currTriAlphaDir*15;

    if (currTriAlpha==255 || currTriAlpha==0) currTriAlphaDir=-currTriAlphaDir;
  }
}

void drawPhotoText(String tt, float ta) {
  if (ta>0) {
    int tw=mainFIDContainer.ipwidth;
    int th=mainFIDContainer.ipheight;

    // border

    rectMode(CENTER_DIAMETER);
    noStroke();
    fill(48,ta);
    rect(55+boxX,235,tw+12,th+12);
    fill(255);
    rect(55+boxX,235,tw+6,th+6);
    rectMode(CORNER);

    // picture

    tint(255,ta);
    if (mainFIDContainer.picture.width!=tw || mainFIDContainer.picture.height!=th) smooth();

    image(mainFIDContainer.picture,55+boxX,235,tw,th);
    noSmooth();

    // name+friends box

    int nameWidth=12; // right margin
    for (int i=0;i<mainFIDContainer.firstName.length();i++) nameWidth+=gameFont.width(mainFIDContainer.firstName.charAt(i));

    fill(255);
    rect(92+boxX,225,nameWidth,40);

    // tt box

    stroke(255,255-ta,255-ta);
    fill(255);
    rect(boxX,height-60,290,25);

    noStroke();
    fill(255,0,0,ta/2);
    rect(boxX+4,height-60+26,291,4);
    rect(boxX+291,height-60+4,4,26);

    // name+friends

    fill(255,0,0,ta);
    text(mainFIDContainer.firstName+"\n"+mainFIDContainer.iFriendsString,92+boxX,245);

    // tt

    text(tt,boxX+10,height-40);

    // running man image

    int friendWidth=0;
    for (int i=0;i<mainFIDContainer.iFriendsString.length()-10;i++) friendWidth+=gameFont.width(mainFIDContainer.iFriendsString.charAt(i));

    imageMode(CORNER);
    image(runWhiteImage,91+boxX+friendWidth,250);
    imageMode(CENTER_DIAMETER);
  }
}

void couldLoadContinue() {
  // set up our balls

  for (int i=0; i<mainFIDContainer.FFIDArray.length; i++) balls.add(new Ball(mainFIDContainer.FFIDArray[i]));

  // our friendster ids

  for (int i=0;i<4;i++) secondaryFIDContainers[i].reset();
  topSecondaryFIDContainer=2;
  loadedFIDs.add(new Integer(mainFIDContainer.FID));

  // our HS loader

  HSLoader=new LoadURL();

  // score and windmills and clock and platform

  peopleOnPlatform=0;
  activeWindmill=int(random(2))+1;
  windmill1Frame=windmill2Frame=0;
  fireDelayTime=0;
  score=0;
  displayScore=kMaxScore;
  displayBalls=kMaxBalls;
  masterClock=windmillTime=lastWindmillAnimTime=lastSlowWindmillAnimTime=alliTime=millis();

  showHelp=true;
  endGame=fireBall=slidingRightPanel=alliActive=false;

  gameState=kGameSetup;

  playSound(gunkanSound,kHighestPriority);
}

void couldNotLoadReset() {
  // reset fIDs

  currZoom=fIDsLength;

  for (int i=0;i<fIDsLength;i++) {
    fIDs[i]=int(random(10));
    fIDZooms[i]=1;
  }

  currFIDPos=0;
  lastSlotChangeTime=millis();

  gameState=kGameSelectID;
}

void drawParticles() {
  // draw all our particles

  for (int i=0;i<particles.size();i++) {
    Particle tp=(Particle)particles.get(i);
    if (tp.isAlive()) {
      tp.draw();
    } else {
      particles.remove(i);
      i--;
    }
  }
}

void drawMainBackground(float t) {
  imageMode(CORNER);
  tint(255,255*t);

  if (sin(millis()/2222)>.5) image(bgdBlowImage,0,0);
  else image(bgdImage,0,0);
  imageMode(CENTER_DIAMETER);
}

void drawPool(float xt, float yt) {
  if (xt>0 || yt>0) {
    // set water level

    currWaterLevel=int(sin((millis()-masterClock)/1000)*1.75);

    // simplify!

    int wallLeftEdge=int((width-rightPanelWidth)-wallWidth*xt)-1;
    int wallRightEdge=int((width-rightPanelWidth)+wallWidth*(1-xt))-1;

    int water1Top=int((height+25)-135*yt+currWaterLevel);
    int water1Bottom=water1Top+30;

    imageMode(CORNER);

    // clear out see-thru water

    noStroke();
    fill(255);
    rect(0,water1Bottom,width-75,height-water1Bottom);

    // side wall

    noStroke();
    fill(208);

    beginShape(QUADS);
    vertex(wallLeftEdge,0);
    vertex(wallLeftEdge,height);
    vertex(wallRightEdge+1,height);
    vertex(wallRightEdge+1,0);
    endShape();

    // side wall darker edges

    stroke(153,128);

    line(wallLeftEdge,water1Top-1,wallRightEdge,water1Bottom-1);

    // drawn on top of images for some reason, so we have to draw a rect...

    noStroke();
    fill(153,128);

    rect(wallLeftEdge-1,0,1,water1Top);
    rect(0,water1Top-1,wallLeftEdge,1);
    rect(wallRightEdge,0,1,water1Bottom-1);

    // rocky floor

    tint(255,128);
    image(floorImage,0,water1Bottom-currWaterLevel);

    // solid water

    fill(0,176,255);

    beginShape(QUADS);
    vertex(0,water1Top);
    vertex(wallLeftEdge,water1Top);
    vertex(wallRightEdge,water1Bottom+1);
    vertex(0,water1Bottom+1);
    endShape();

    // water darker edges

    stroke(2,135,195);

    line(wallLeftEdge,water1Top,wallRightEdge,water1Bottom);
    line(wallLeftEdge-1,water1Top,wallRightEdge-1,water1Bottom);

    // drawn on top of images for some reason, so we have to draw a rect...

    noStroke();
    fill(3,136,196);

    rect(wallRightEdge,water1Bottom,1,height-water1Bottom);

    // see-thru water

    fill(0,176,255,196);
    rect(0,water1Bottom,wallRightEdge,height-water1Bottom);

    // cave

    noTint();
    image(caveImage,327-30*xt,height-135*yt);

    imageMode(CENTER_DIAMETER);
  }
}

void drawPegBacks(float xt,float yt,float ct,float t) {
  if (t>0) {
    int wallLeftEdge=int((width-rightPanelWidth)-wallWidth*xt)-1;
    int water1Top=int((height+25)-135*yt+currWaterLevel);

    noStroke();
    fill(128,80*t);
    imageMode(CORNER);

    boolean odd=true;

    for (int row=2;row<7*t;row++) {
      if (odd) {
        for (int col=1;col<6;col++) {
          tint(0,159,232);
          image(pegShadowImage,col*33+21-4,water1Top);
          ellipse(col*33+21-4,row*51+19-4,16,16);
          tint(255,255*t);
          image(pegImage,col*33+21,row*51+19);
        }
      } else {
        for (int col=0;col<6;col++) {
          tint(0,159,232);
          image(pegShadowImage,col*33+37-4,water1Top);
          ellipse(col*33+37-4,row*51+19-4,16,16);
          tint(255,255*t);
          image(pegImage,col*33+37,row*51+19);
        }
      }

      odd=!odd;
    }

    // windmills

    if (activeWindmill==1) {
      if (millis()>lastWindmillAnimTime+50) {
        if (++windmill1Frame>3) windmill1Frame=0;
        lastWindmillAnimTime=millis();
      }

      if (millis()>lastSlowWindmillAnimTime+1000) {
        if (++windmill2Frame>3) windmill2Frame=0;
        lastSlowWindmillAnimTime=millis();
      }

      if (millis()-windmillTime>5000) {
        windmillTime=millis();
        activeWindmill=-2;
      }
    } else if (activeWindmill==2) {
      if (millis()>lastWindmillAnimTime+50) {
        if (++windmill2Frame>3) windmill2Frame=0;
        lastWindmillAnimTime=millis();
      }

      if (millis()>lastSlowWindmillAnimTime+1000) {
        if (++windmill1Frame>3) windmill1Frame=0;
        lastSlowWindmillAnimTime=millis();
      }

      if (millis()-windmillTime>5000) {
        windmillTime=millis();
        activeWindmill=-1;
      }
    } else {
      if (millis()>lastSlowWindmillAnimTime+1000) {
        if (++windmill1Frame>3) windmill1Frame=0;
        if (++windmill2Frame>3) windmill2Frame=0;
        lastSlowWindmillAnimTime=millis();
      }

      if (millis()-windmillTime>2500) {
        windmillTime=millis();
        activeWindmill=-activeWindmill;
      }
    }

    tint(0,159,232);
    image(windmillShadowImages[3-windmill1Frame],0*33+21-4,water1Top);
    image(windmillShadowImages[windmill2Frame],6*33+21-4,water1Top);

    ellipse(0*33+21-4,1.33*51+19-4,16,16);
    ellipse(6*33+21-4,1.33*51+19-4,16,16);

    tint(255,255*t);
    image(pegImage,(0)*33+21,(1.33)*51+19);
    image(pegImage,(6)*33+21,(1.33)*51+19);

    // conveyor belt shadow

    tint(0,159,232);
    image(cbShadowImage,-145*(1-ct)-21*ct-2,water1Top+7);

    imageMode(CENTER_DIAMETER);

    // draw back line

    fill(3,136,196);

    rect(0,water1Top,wallLeftEdge,1);
  }
}

void swimDucks() {
  for (int i=0;i<swimmingDucks.length;i++) {
    swimmingDucks[i].swim();
    swimmingDucks[i].drawShadow();
  }

  for (int i=0;i<swimmingDucks.length;i++) {
    swimmingDucks[i].draw();
  }
}

void doAlli() {
  if (alliActive) {
    int d=millis()-alliStartTime;

    if (d>5000) {
      alliActive=false;
      alliTime=millis();
    } else {
      BImage cam;

      if (millis()-alliSnapTime>250) cam=alliOpenImage;
      else cam=alliClosedImage;

      tint(255);
      imageMode(CORNER);

      int sx,ex;
      float t;

      sx=ex=297-17;

      if (d<500) {
        sx=width-rightPanelWidth;
        t=d/500.0;
      } else if (d>4500) {
        ex=width-rightPanelWidth;
        t=(d-4500)/500.0;
      } else t=1;

      currAlliX=int(sx*(1-t)+ex*t);
      image(cam,currAlliX,height-135+11);
      imageMode(CENTER_DIAMETER);
    }
  } else {
    int popOutTime=3000-constrain((millis()-masterClock)/250,0,1500); // increase alli frequency as time passes
    if (millis()-alliTime>popOutTime) {
      alliSnapTime=-999999;
      alliActive=true;
      alliStartTime=millis();

      if (random(2)<1) playSound(alliSound,kHighPriority);
    }
  }
}

void updateBalls() {
  // balls

  peopleOnPlatform=0; // need to reset to compute number of people on platform for platform displacement

  for (int i=0;i<balls.size();i++) {
    Ball tb=(Ball)balls.get(i);

    if (tb.move()==kDie) {
      tb.kill();
      i--;
    } else tb.draw();
  }
}

void drawScore(float t) {
  if (t>0) {
    tint(255,(t*255+(sin(millis()/500.0)*64+64+127)*2)/3);

    // score

    displayScore=min(displayScore+100,score);

    String s=nf(min(kMaxScore,displayScore),7);
    for (int i=0;i<s.length();i++) {
      BImage temp=numbers[s.charAt(i)-'0'];

      image(temp,numberWidth/2.5*i+15,height-15,temp.width/2,temp.height/2);
    }

    // balls

    int freeb=0;
    for (int i=0;i<balls.size();i++) {
      if (((Ball)balls.get(i)).state==kBallWaitingLaunch) freeb++;
    }

    displayBalls=min(displayBalls+15,freeb);

    s=nf(min(kMaxBalls,displayBalls),4);
    for (int i=0;i<s.length();i++) {
      BImage temp=numbers[s.charAt(i)-'0'];

      image(temp,numberWidth/2.5*i+232,height-15,temp.width/2,temp.height/2);
    }

    image(runWhiteImage,width-94,height-15,runWhiteImage.width,runWhiteImage.height);
  }
}

void drawConveyorPlatform(float t) {
  if (t>0) {
    imageMode(CORNER);

    // conveyor belt

    noTint();
    image(cbImages[3-int((millis()%500)/125)],-145*(1-t)-21*t,23);

    // platform

    tint(255,t*255);
    if (t==1) {
      image(platformRipplesImages[int(sin((millis()-masterClock)/333)*1.75)+1],237,402+currWaterLevel);
      platformDisplacement=constrain(peopleOnPlatform,0,3);
    } else platformDisplacement=0;

    image(platformImages[platformDisplacement],237,402+currWaterLevel);

    imageMode(CENTER_DIAMETER);
  }
}

void drawPegFronts(float t) {
  if (t>0) {
    imageMode(CORNER);
    tint(255,255*t);

    boolean odd=true;
    for (int row=2;row<7*t;row++) {

      if (odd) {
        for (int col=1;col<6;col++) {
          if (row==6 || sin(row*col)>0) image(pegFrontBandImage,col*33+21+8,row*51+19+8);
          else image(pegFrontImage,col*33+21+8,row*51+19+8);
        }
      } else {
        for (int col=0;col<6;col++) image(pegFrontImage,col*33+37+8,row*51+19+8);
      }

      odd=!odd;
    }

    image(windmillImages[3-windmill1Frame],(0)*33+21+2,(1.33)*51+19+2);
    image(windmillImages[windmill2Frame],(6)*33+21+2,(1.33)*51+19+2);

    float winda;

    if (activeWindmill==1 || activeWindmill==-2) {
      // draw a little wind

      if (activeWindmill==1) winda=min(255,(255*((millis()-windmillTime)/1000.0)))*t;
      else winda=min(255,(255*(1-(millis()-windmillTime)/500.0)))*t;

      int x=0*33+21+35;
      int y=int(1.33*51+19+23-4);

      int dx=30;
      float dy=4.5;

      int waveStart=int(millis()/(2000.0/dx));

      noStroke();
      fill(85,172,212,winda);
      for (int i=0;i<dx;i+=2,x+=2) {
        float cy=sin((waveStart-x)/dy)*dy;

        rect(x,y+cy,1,2);
      }
    } else if (activeWindmill==2 || activeWindmill==-1) {
      if (activeWindmill==2) winda=min(255,(255*((millis()-windmillTime)/1000.0)))*t;
      else winda=min(255,(255*(1-(millis()-windmillTime)/500.0)))*t;

      int y=int(1.33*51+19+23-4);

      int dx=30;
      float dy=4.5;

      int x=6*33+21-dx;

      int waveStart=int(millis()/(2000.0/dx));

      noStroke();
      fill(85,172,212,winda);

      for (int i=0;i<dx;i+=2,x+=2) {
        float cy=sin((waveStart+x)/dy)*dy;

        rect(x,y+cy,1,2);
      }
    }

    // cave mask

    if (t==1) {
      noTint();
      image(caveMaskImage,297+11,height-135);
    }

    imageMode(CENTER_DIAMETER);
  }
}

void drawBorder(float x,float y,float w,float h, float a) {
  rectMode(CENTER_DIAMETER);
  noStroke();
  fill(48,255*a);
  rect(x,y,w+12,h+12);
  fill(255,255);
  rect(x,y,w+6,h+6);
  rectMode(CORNER);
}

void drawTextBubble(String s,float x,float y, float w, float a, BImage b) {
  // bubble

  tint(255,255*a);
  image(b,x,y);

  // text

  fill(255,255*a);
  textMode(ALIGN_CENTER);
  textFont(boldBubbleFont);
  text(s,x,y+4);
  textFont(gameFont);
  textMode(ALIGN_LEFT);
}

void drawRightPanel(float t) {
  if (t>0) {

    // draw panel

    noTint();
    float panelx=(width+1)*(1-t)+(width-rightPanelWidth)*t;

    imageMode(CORNER);
    image(rightPanelImage,panelx,0);
    imageMode(CENTER_DIAMETER);

    // draw the photos on the panel

    int tw,th;

    // first main

    tw=mainFIDContainer.gpwidth;
    th=mainFIDContainer.gpheight;

    drawBorder(panelx+38,55,tw,th,1);

    if (mainFIDContainer.picture.width!=tw || mainFIDContainer.picture.height!=th) smooth();

    image(mainFIDContainer.picture,panelx+38,55,tw,th);
    noSmooth();

    drawTextBubble("ONE",panelx+38,16,58,1,bubbleImage);

    // name

    noStroke();
    fill(255,208);
    rect(int(panelx),81,76,18);
    if (t<1) mainFIDContainer.scrollTime=millis()+2500;
    mainFIDContainer.renderName();
    imageMode(CORNER);
    tint(255);
    image(mainFIDContainer.nameImage,panelx+8,82);

    tint(255,t*255);
    image(signImage,257,29);

    textMode(ALIGN_RIGHT);
    textFont(boldBubbleFont);
    fill(255,0,0,t*255);
    text(mainFIDContainer.gFriendsString,width-rightPanelWidth-17,55);
    textFont(gameFont);

    tint(255,255*t);
    image(runRedImage,width-rightPanelWidth-15,46);

    imageMode(CENTER_DIAMETER);

    // now secondaries

    for (int i=0;i<4;i++) {
      float a0,a1;
      float maxBlend=1;
      int srpd=millis()-slidingRightPanelStartTime;
      float basey=102*(i+1);

      if (i==0 && slidingRightPanel) {
        a0=a1=constrain(1-(srpd/250.0),0,maxBlend);
      } else {
        a0=maxBlend;

        if (slidingRightPanel) {
          a1=constrain(1-(srpd-250)/250.0,0,maxBlend);
          float mt=constrain((srpd-400)/400.0,0,1);
          basey=(1-mt)*basey+mt*(102*i);
        } else a1=maxBlend;
      }

      if (a0>0) {
        tw=secondaryFIDContainers[i].gpwidth;
        th=secondaryFIDContainers[i].gpheight;

        drawBorder(panelx+38,55+basey,tw,th,a0);
        if (secondaryFIDContainers[i].picture.width!=tw || secondaryFIDContainers[i].picture.height!=th) smooth();

        tint(255,a0*255);
        image(secondaryFIDContainers[i].picture,panelx+38,55+basey,tw,th);
        noSmooth();

        drawTextBubble(nf(min(99999,topSecondaryFIDContainer+i),0),panelx+38,16+basey,58,a0,bubbleGreyImage);

        // update name

        noStroke();
        fill(255,208*a0);
        rect(int(panelx),81+basey,76,18);
        if (t<1) secondaryFIDContainers[i].scrollTime=millis()+2500;
        secondaryFIDContainers[i].renderName();

        imageMode(CORNER);
        tint(255,255*a0);
        image(secondaryFIDContainers[i].nameImage,panelx+8,82+basey);
      }

      imageMode(CORNER);
      if (i==3) {
        tint(255,128*t);
        image(signBlueImage,257,29+102*(i+1));
        tint(0,176,255,148*t);
        image(signBlueImage,257,29+102*(i+1));
        fill(255,255*t);
        rect(257+19,29+102*(i+1)+13,48,18);
      } else {
        tint(255,255*t);
        if (sin(masterClock*(i+1))>0) image(signImage,257,29+102*(i+1));
        else image(signBlueImage,257,29+102*(i+1));
      }

      textMode(ALIGN_RIGHT);
      textFont(boldBubbleFont);
      fill(255,0,0,t*255*a1);
      text(secondaryFIDContainers[i].gFriendsString,width-rightPanelWidth-17,55+102*(i+1));
      textFont(gameFont);

      tint(255,255*t);
      image(runRedImage,width-rightPanelWidth-15,46+102*(i+1));

      imageMode(CENTER_DIAMETER);

    }

    textMode(ALIGN_LEFT);

    if (slidingRightPanel && millis()-slidingRightPanelStartTime>800) {
      // finished sliding, now parse accordingly

      for (int i=0;i<3;i++) {
        secondaryFIDContainers[i]=secondaryFIDContainers[i+1];
      }

      secondaryFIDContainers[3]=tempFIDContainer;
      for (int i=0; i<tempFIDContainer.FFIDArray.length; i++) balls.add(new Ball(tempFIDContainer.FFIDArray[i]));
      tempFIDContainer=new FIDContainer();
      topSecondaryFIDContainer++;
      slidingRightPanel=false;
    }
  }
}

void drawHelp(float t) {
  if (t>0) {
    int rx=(width/2)-(200/2);
    int ry=int((2.74*51+24)*t+(-47)*(1-t));

    stroke(255,0,0);
    fill(255);
    rect(rx,ry-51,200,41+51);

    noStroke();
    fill(255,0,0,128);
    rect(rx+4,ry+42,201,4);
    rect(rx+201,ry+4-51,4,42+51);

    fill(255,0,0);

    text("Press the space bar to fire friends \n(or hit the Q key to start over).",rx+10,ry+20);

    // draw some running men

    imageMode(CORNER);
    float x,a;

    for (int i=0;i<5;i++) {
      x=((millis()+i*6666)%11340)/63;

      if (x>100) a=min(192,(180-x)*10);
      else a=min(192,x*10);

      tint(255,a);
      image(runRImages[(lastRunFrame+i)%3],x+rx+4,ry-42+(i*8));
    }
    lastRunFrame=++lastRunFrame%3;

    imageMode(CENTER_DIAMETER);
  }
}

void drawGameOver(float t) {
  if (t>0) {
    int rx=(width/2)-(200/2);
    int ry=int((2.74*51+24)*t+(-47)*(1-t));

    stroke(255,0,0);
    fill(255);
    rect(rx,ry-51,200,41+51);

    noStroke();
    fill(255,0,0,128);
    rect(rx+4,ry+42,201,4);
    rect(rx+201,ry+4-51,4,42+51);

    fill(255,0,0);

    text("Press the Q key to play again.",rx+10,ry+35);

    // Game Over

    String gString="THE END";
    int chars=gString.length();
    int tw=0;

    for (int i=0;i<chars;i++) {
      tw+=largeScoreBubbleFont.width(gString.charAt(i));
    }

    float spacer=(180-tw)/float(chars-1);
    float ex=0;

    textFont(largeScoreBubbleFont);

    float spx=0;

    for (int i=0;i<chars;i++) {
      float gst=getTimeFrac(1000+i*100,500);

      if (gst>0 && gString.charAt(i)!=' ') {
        float x=10+180*(1-gst)+ex*gst;

        fill(255,0,0,(gst*255+(sin(millis()/500.0)*64+64+127)*2)/3);
        text(gString.substring(i,i+1),rx+x,ry-16);
      } else if (i==3) spx=ex+largeScoreBubbleFont.width(gString.charAt(i))+spacer/2;

      ex+=largeScoreBubbleFont.width(gString.charAt(i))+spacer;
    }

    textFont(gameFont);

    tint(255,getTimeFrac(1000+(chars)*100,500)*128);
    image(flourishImage,rx+spx,ry);

    tint(255,(getTimeFrac(1000+(chars+5)*100,500)*(sin(millis()/500.0)*64+64+127)));
    image(runRedBorderImage,rx+176,ry+26);

    // check status of HS load

    if (HSLoader.loadStatus==kLoaded && HSLoader.data.equals("1")) {
      // got a high score

      float ht=constrain((millis()-(HSLoader.loadTime+750))/600.0,0,1);

      int ha=108;

      stroke(255,0,0,255*ht);
      fill(255,ht*255);
      rect(rx,ry-51+ha,200,61);

      noStroke();
      fill(255,0,0,ht*128);
      rect(rx+4,ry-9+ha+20,201,4);
      rect(rx+201,ry+4-51+ha,4,62);

      fill(255,0,0,ht*255);

      text("A new top score!",rx+10,ry-15+20+ha);

      // draw some running men

      imageMode(CORNER);
      float x,a;

      x=(millis()%5670)/31.5;

      if (x>100) a=min(192,(180-x)*10);
      else a=min(192,x*10);

      tint(255,a*ht);

      float flx=x+rx+4;
      float fly=ry-32+ha+(sin(millis()/250.0)*8);
      float frx=(180-x)+rx+4;
      float fry=ry-32+ha-(sin((millis()+666)/250.0)*8);

      image(fallLImage,flx,fly);
      image(fallRImage,frx,fry);

      if (random(128)>64) {
        float sprayx=random(width-30)+15;
        float sprayy=random(height*.66)+15;

        // shower of sparks

        for (int i=0;i<360;i+=30) {
          float pex,pey;
          push();

          translate(sprayx,sprayy,0);
          rotateZ(i*PI/180);

          translate(0,50+random(30),0);

          pex=screenX(0,0,0);
          pey=screenY(0,0,0);

          pop();

          int r,g,b;

          int ran=int(random(2));

          if (ran==0) {
            r=214;
            g=128;
            b=171;
          } else {
            r=g=0;
            b=255;
          }

          fireworks.add(new Particle(sprayx,sprayy,pex,pey,2,2000,r,g,b));
        }

        playSound(fireworksSound,kMediumPriority);
      }

      // draw existing fireworks

      for (int i=0;i<fireworks.size();i++) {
        Particle tp=(Particle)fireworks.get(i);
        if (tp.isAlive()) {
          tp.draw();
        } else {
          fireworks.remove(i);
          i--;
        }
      }

      imageMode(CENTER_DIAMETER);
    }
  }
}

void doFireBall() {
  // here we go!

  for (int i=0;i<balls.size();i++) {
    Ball tb=(Ball)balls.get(i);
    if (tb.state==kBallWaitingLaunch) {
      tb.start();
      playSound(fireSound,kMediumPriority);
      break;
    }
  }
}

void increaseScore(int amount, float x, float y) {
  // add a little score animation to the list here

  score+=amount;
  scoreBubbles.add(new ScoreBubble(amount,x,y));
}

void doScoreBubbles() {
  for (int i=0;i<scoreBubbles.size();i++) {
    ScoreBubble tsb=(ScoreBubble)scoreBubbles.get(i);

    if (tsb.update()==kDie) {
      scoreBubbles.remove(i);
      i--;
    }
  }
}

boolean checkGameOver() {
  if (!loadQueue.isEmpty()) return false;
  if (FIDLoader.loadStatus!=kNotLoaded) return false;
  if (slidingRightPanel) return false;

  for (int i=0;i<balls.size();i++) {
    Ball tb=(Ball)balls.get(i);

    if (tb.state!=kBallRunningLeft) return false;
  }

  return true;
}

void manageLoadQueue() {
  // handle our load queue

  if (!slidingRightPanel) {
    switch(FIDLoader.loadStatus) {
      case kNotLoaded:
      if (!loadQueue.isEmpty()) {
        // load the next FID

        loadingFID=((Integer)loadQueue.get(0)).intValue();
        loadedFIDs.add(new Integer(loadingFID)); // have to do this now
        loadQueue.remove(0);
        FIDLoader.load("getSpiderData.php?friendsterid="+loadingFID);
      }
      break;

      case kLoaded:
      // right panel scrolling

      tempFIDContainer.parse(loadingFID,FIDLoader.data);

      if (tempFIDContainer.ok) {
        // see if we have any empty slots

        boolean freeContainer=false;

        for (int i=0;i<4;i++) {
          if (secondaryFIDContainers[i].FID==0) {
            secondaryFIDContainers[i]=tempFIDContainer;
            for (int j=0; j<tempFIDContainer.FFIDArray.length; j++) balls.add(new Ball(tempFIDContainer.FFIDArray[j]));
            tempFIDContainer=new FIDContainer();
            freeContainer=true;
            break;
          }
        }

        if (!freeContainer) {
          slidingRightPanel=true;
          slidingRightPanelStartTime=millis();
        }
      } else {
        // oh well...
      }

      FIDLoader.loadStatus=kNotLoaded;
      break;

      case kLoadFailed:
      // oh well...

      FIDLoader.loadStatus=kNotLoaded;
      break;
    }
  }
}

// our scoreBubble class

class ScoreBubble {
  private int x,y,startTime,tscale;
  private String amountString;
  private BFont font;
  private boolean isZero;

  public ScoreBubble(int mamount, float mx, float my) {
    x=int(mx);
    y=int(my);
    amountString=nf(mamount,0);
    startTime=millis();

    if (mamount==0) isZero=true;
    else isZero=false;

    if (mamount<100) font=smallScoreBubbleFont;
    else font=largeScoreBubbleFont;
  }

  public int update() {
    if (millis()-startTime>666) return kDie;
    else {
      if (isZero) {
        tint(255,255*(1-(millis()-startTime)/666.0));
        imageMode(CORNER);
        image(runRedBorderImage,x-runRedBorderImage.width/2,y-runRedBorderImage.height);
        imageMode(CENTER_DIAMETER);
      } else {
        fill(255,0,0,255*(1-(millis()-startTime)/666.0));
        textMode(ALIGN_CENTER);
        textFont(font);
        text(amountString,x,y);
        textFont(gameFont);
        textMode(ALIGN_LEFT);
      }
      y-=5;
      return kLive;
    }
  }
}

// our ball class

class Ball {
  public int state,FID;
  public float x,y,dx,dy;
  private int lastRunFrame=0,lastRunTime,lastVTime;
  private BImage fallImage;
  private boolean splashed;

  // special xs and ys for platform + cave

  private float sx,sy,ex,ey;
  private int startMoveTime,platformRunDuration;

  public Ball(int mFID) {
    state=kBallWaitingLaunch;
    FID=mFID;

    if (random(2)>.5) fallImage=fallRImage;
    else fallImage=fallLImage;
  }

  public void doPop() {
    if (state!=kBallWaitingLaunch) {
      // pop the ball! (must kill manually!)

      int water1Top=int((height+25)-135+currWaterLevel);
      int water1Mid=water1Top+waterMaskStart;

      for (int i=0;i<360;i+=20) {
        float pex,pey;
        push();

        translate(x,y,0);
        rotateZ(i*PI/180);

        translate(0,50+random(30),0);

        pex=screenX(0,0,0);
        pey=screenY(0,0,0);

        pop();

        int r,g,b;

        if (y>water1Mid+6) { // sloppy...
          r=138;
          g=b=255;
        } else r=g=b=85;

        particles.add(new Particle(x,y,pex,pey,2,int(500+random(1250)),r,g,b));
      }
    }
  }

  public void start() {
    state=kBallCB;

    x=-2;
    y=25;
    dx=7;
    dy=0;

    splashed=false;
    lastRunTime=millis();

    lastVTime=0;
  }

  public boolean checkCollision(float t,float l, float b, float r) {
    if (((x+4>l && x+4<r) || (x-4<r && x-4>l)) &&
    ((y-5<b && y-5>t) || (y+5>t && y+5<b))) return true;
    else return false;
  }

  public boolean checkAlli() {
    if (alliActive && x+4>=currAlliX && y+5>=height-135+11) {

      for (int i=135;i<225;i+=15) {
        float pex,pey;
        push();

        translate(x,height-135+11,0);
        rotateZ(i*PI/180);

        translate(0,50+random(30),0);

        pex=screenX(0,0,0);
        pey=screenY(0,0,0);

        pop();

        particles.add(new Particle(x,height-135+11,pex,pey,2,2000,255,0,0));
      }

      alliSnapTime=millis();

      playSound(alliDieSound,kMediumPriority);
      return true;
    } else return false;
  }

  public int move() {
    if (state!=kBallWaitingLaunch) {
      if (millis()-lastRunTime>=20) {
        int water1Top=int((height+25)-135+currWaterLevel);
        int water1Mid=water1Top+waterMaskStart;
        int water1Bottom=water1Top+30;

        x+=dx;
        y+=dy;

        switch(state) {
          case kBallCB:
          if (x>=130) {
            x+=random(3)-1;
            y+=3;
            dy=7;
            dx=0;

            state=kBallInPlay;
            lastVTime=millis();
          }
          break;

          case kBallInPlay:
          if (y>=height-40+random(4)) {
            y=constrain(y,height-40,height-40+4);
            dx=-3;
            dy=0;
            state=kBallRunningLeft;
          } else if (y>water1Mid) {
            if (y>water1Bottom+20 && random(4)<1) {
              particles.add(new Particle(x,y-5,x,water1Bottom,2,3000,138,255,255,false));
            }
          } else if (y>60) {
            // gravity

            dy+=(millis()-lastVTime)/66.0; // acceleration
            lastVTime=millis();

            // add wind from windmills

            if (activeWindmill==1) {
              dx+=33/dist(x,y,(0)*33+21+2,(1.33)*51+19+2);

            } else if (activeWindmill==2) {
              dx-=33/dist(x,y,(6)*33+21+2,(1.33)*51+19+2);
            }

            if (checkAlli()) return kDie;

            // collision detection with ducks

            for (int i=0;i<swimmingDucks.length;i++) {
              SwimmingDuck td=swimmingDucks[i];
              if (td.checkCollision(y-5,x-4,y+5,x+4)) {
                if (td.doHit()==kDie) {
                  // renumber our dnums

                  for (int j=0;j<swimmingDucks.length;j++) {
                    if (swimmingDucks[j].dnum<swimmingDucks[i].dnum) swimmingDucks[j].dnum++;

                    if (j!=i) swimmingDucks[j].newDrift(true);
                  }

                  swimmingDucks[i]=new SwimmingDuck(0);
                } else {
                  // bounce

                  dx+=random(5)-2;
                  dy+=random(5)-2;

                  dy=-dy;
                  playSound(duckBounceSound,kMediumPriority);
                }
                break;
              }
            }

            // collision detection with pegs

            int collx=0,colly=0;

            boolean odd=true, collided=false, bluePeg=false;

            for (int row=2;row<7;row++) {
              colly=row*51+19+8+5;

              if (odd) {
                for (int col=1;col<6;col++) {
                  collx=col*33+21+8+5;
                  if (checkCollision(colly-5,collx-5,colly+5,collx+5)) {
                    if (row==6 || sin(row*col)>0) bluePeg=true;
                    collided=true;
                    break;
                  }
                }
              } else {
                for (int col=0;col<6;col++) {
                  collx=col*33+37+8+5;
                  if (checkCollision(colly-5,collx-5,colly+5,collx+5)) {
                    collided=true;
                    break;
                  }
                }
              }

              if (collided) break;
              else odd=!odd;
            }

            // collision detection with windmills

            if (!collided) {
              collx=(0)*33+21+8+5;
              colly=int((1.33)*51+19+8+5);
              if (checkCollision(colly-5,collx-5,colly+5,collx+5)) {

                // blood and guts

                for (int i=0;i<360;i+=30) {
                  float pex,pey;
                  push();

                  translate(x,y,0);
                  rotateZ(i*PI/180);

                  translate(0,50+random(30),0);

                  pex=screenX(0,0,0);
                  pey=screenY(0,0,0);

                  pop();

                  particles.add(new Particle(x,y,pex,pey,2,2000,255,0,0));
                }
                playSound(windmillDieSound,kMediumPriority);
                return kDie;
              }
            }

            if (!collided) {
              collx=(6)*33+21+8+5;
              colly=int((1.33)*51+19+8+5);
              if (checkCollision(colly-5,collx-5,colly+5,collx+5)) {
                // blood and guts

                for (int i=0;i<360;i+=30) {
                  float pex,pey;
                  push();

                  translate(x,y,0);
                  rotateZ(i*PI/180);

                  translate(0,50+random(30),0);

                  pex=screenX(0,0,0);
                  pey=screenY(0,0,0);

                  pop();

                  particles.add(new Particle(x,y,pex,pey,2,2000,255,0,0));
                }

                playSound(windmillDieSound,kMediumPriority);
                return kDie;
              }
            }
            // process collision detection

            if (collided) {
              // put some english on the ball

              dx+=random(5)-2;
              dy+=random(5)-2;

              if (x>collx) {
                // man is to the right of peg

                if (dx<0) dx=-dx;
                x=collx+4;
              } else if (x<collx) {
                if (dx>0) dx=-dx;
                x=collx-5-4;
              }

              if (y>colly) {
                // man is to the bottom of peg

                if (dy<0) dy=-dy;
                y=colly+5+5;
              } else if (y<colly) {
                if (dy>0) dy=-dy;
                y=colly-5-5;
              }

              // sparks + score

              int r,g,b;

              if (bluePeg) {
                score+=20;
                r=78;
                g=144;
                b=174;
              } else {
                score+=5;
                r=g=b=153;
              }

              for (int i=0;i<360;i+=60) {
                float pex,pey;
                push();

                translate(x,y,0);
                rotateZ(i*PI/180);

                translate(0,50+random(30),0);

                pex=screenX(0,0,0);
                pey=screenY(0,0,0);

                pop();

                particles.add(new Particle(x,y,pex,pey,2,2000,r,g,b));
              }

              playSound(bounceSound,kLowPriority);
            }

            // check for collision with wall

            if (x<-4) return kDie;
            if (x>(width-rightPanelWidth)-wallWidth*.66 && y-5<height-135) {
              dx+=random(5)-2;
              dy+=random(5)-2;

              dx=-dx*.5; // we should half it, but it makes it too easy...?
              x+=dx;

              for (int i=0;i<180;i+=60) {
                float pex,pey;
                push();

                translate(x,y,0);
                rotateZ(i*PI/180);

                translate(0,50+random(30),0);

                pex=screenX(0,0,0);
                pey=screenY(0,0,0);

                pop();

                particles.add(new Particle(x,y,pex,pey,2,2000,85,85,85));
              }

              playSound(wallSound,kLowPriority);
            }

            // check for collision with platform-ish area

            if (y>=407+currWaterLevel && x>269) {
              dx=dy=0;
              sx=x;
              sy=y;
              startMoveTime=millis();

              if (x<298-platformDisplacement) {
                // on the platform, red sparks

                for (int i=155;i<205;i+=10) {
                  float pex,pey;
                  push();

                  translate(x,y,0);
                  rotateZ(i*PI/180);

                  translate(0,50+random(30),0);

                  pex=screenX(0,0,0);
                  pey=screenY(0,0,0);

                  pop();

                  particles.add(new Particle(x,y,pex,pey,2,int(500+random(1250)),85,85,85));
                }

                y=constrain(y,407,412);

                ex=297-platformDisplacement;
                ey=constrain(y,407,409);

                state=kBallPlatform;
              } else {
                ex=width-rightPanelWidth;
                ey=y=constrain(y,407,409);
                state=kBallRunIntoCave;
              }

              platformRunDuration=int(1000/(30.0/dist(sx,sy,ex,ey)));
              playSound(platformSound,kLowPriority);
            }
          }

          dx=constrain(dx,-9,9);
          dy=constrain(dy,-9,9);

          break;

          case kBallRunningLeft:
          // should we release an air bubble?

          if (random(8)<1) {
            particles.add(new Particle(x,y-5,x,water1Bottom,2,3000,138,255,255,false));
          }

          if (x<-12) return kDie;
          break;

          case kBallPlatform:
          // on the platform

          if (checkAlli()) return kDie;

          peopleOnPlatform++;

          float t=(millis()-startMoveTime)/float(platformRunDuration);
          if (t>1) {
            x=sx=ex;
            y=sy=ey;

            ex=x+12;
            ey=y-4;

            startMoveTime=millis();

            platformRunDuration=int(1000/(30.0/dist(sx,sy,ex,ey))*1.15);
            state=kBallJumpToCave;
          } else {
            x=(1-t)*sx+t*ex;
            y=(1-t)*sy+t*ey;
          }
          break;

          case kBallJumpToCave:

          t=(millis()-startMoveTime)/float(platformRunDuration);
          if (t>1) {
            x=sx=ex;
            y=sy=ey;

            ex=width-rightPanelWidth;

            startMoveTime=millis();

            platformRunDuration=int(1000/(30.0/dist(sx,sy,ex,ey)));
            state=kBallRunIntoCave;
          } else {
            x=(1-t)*sx+t*ex;
            y=(1-t)*sy+t*ey-sin(t*PI+.15)*4;
          }

          return kLive; // lock our frame

          case kBallRunIntoCave:

          if (checkAlli()) return kDie;

          t=(millis()-startMoveTime)/float(platformRunDuration);
          if (t>1) {
            if (loadedFIDs.indexOf(new Integer(FID))==-1) {
              loadQueue.add(new Integer(FID));
              increaseScore(0,width-rightPanelWidth-16,y-10);
              playSound(caveSound,kHighPriority);
            } else {
              increaseScore(750,width-rightPanelWidth-16,y-10);
              playSound(pointsSound,kHighPriority);
            }

            return kDie;
          } else {
            x=(1-t)*sx+t*ex;
            y=(1-t)*sy+t*ey;
          }

          break;
        }

        lastRunFrame=(lastRunFrame+1)%3;
        lastRunTime=millis();
      }
    }

    return kLive;
  }

  public void draw() {
    int water1Top=int((height+25)-135+currWaterLevel);
    int water1Mid=water1Top+waterMaskStart;
    int water1Bottom=water1Top+30;

    int drawX=int(x)-9/2;
    int drawY=int(y)-11/2;

    noTint();
    switch(state) {
      case kBallCB:
      image(runRImages[lastRunFrame],x,y);
      break;

      case kBallInPlay:

      // use blend rather than a mask

      int h=constrain(11-((drawY+11)-water1Mid),0,11);

      if (h==0) {
        // below water level, reset acceleration

        int t=constrain((water1Bottom+1)-drawY,0,11);
        int drift=int(sin(millis()/250)*1.75);

        blend(fallImage,0,t,9,11,drift+drawX,drawY+t,drift+drawX+9,drawY+11,ADD);

        dy=3;
      } else {
        blend(fallImage,0,0,9,h,drawX,drawY,drawX+9,drawY+h,BLEND);

        if (h<11) {
          dx=0;
          dy=3;

          if (!splashed) {
            // create a splash!

            for (int i=155;i<205;i+=10) {
              float pex,pey;
              push();

              translate(x,water1Mid-5,0);
              rotateZ(i*PI/180);

              translate(0,70+random(50),0);

              pex=screenX(0,0,0);
              pey=screenY(0,0,0);

              pop();

              particles.add(new Particle(x,water1Mid-5,pex,pey,2,int(500+random(1250)),32,32,126));
            }

            playSound(splashSound,kLowPriority);
            splashed=true;
          }
        }
      }
      break;

      case kBallRunningLeft:
      blend(runLImages[lastRunFrame],0,0,9,11,drawX,drawY,drawX+9,drawY+11,ADD);
      break;

      case kBallPlatform:
      image(runRImages[lastRunFrame],x,y+currWaterLevel+platformDisplacement);
      break;

      case kBallJumpToCave:
      case kBallRunIntoCave:
      image(runRImages[lastRunFrame],x,y);
      break;
    }
  }

  public void kill() {
    balls.remove(balls.indexOf(this));
  }
}

// our particle class

class Particle {
  float sx,sy,ex,ey;
  int r,g,b,diameter;
  int birthTime,life;

  private float v;
  private int lastVTime;
  private boolean gravity;

  public Particle(float msx,float msy,float mex,float mey,int mdiameter,int mLife,int mr,int mg,int mb) {
    sx=msx;
    sy=msy;
    ex=mex;
    ey=mey;

    diameter=mdiameter;

    r=mr;
    g=mg;
    b=mb;

    birthTime=lastVTime=millis();
    life=mLife;
    v=0;

    gravity=true;
  }

  public Particle(float msx,float msy,float mex,float mey,int mdiameter,int mLife,int mr,int mg,int mb,boolean mgravity) {
    sx=msx;
    sy=msy;
    ex=mex;
    ey=mey;

    diameter=mdiameter;

    r=mr;
    g=mg;
    b=mb;

    birthTime=lastVTime=millis();
    life=mLife;
    v=0;

    gravity=mgravity;
  }

  public void draw() {
    if (isAlive()) {
      float x,y,blend;
      float t=(millis()-birthTime)/float(life);

      // gravity

      if (gravity) {
        v+=((millis()-lastVTime)/1000.0)*100; // acceleration
        lastVTime=millis();
      }

      x=(1-t)*sx+t*ex;
      y=(1-t)*sy+t*(ey+v);
      blend=(1-t)*196;

      noStroke();
      fill(r,g,b,blend);
      ellipse(x-diameter/2,y-diameter/2,diameter,diameter);
    }
  }

  public boolean isAlive() {
    if (millis()<birthTime+life) return true;
    else return false;
  }
}

// our swimming duck class

class SwimmingDuck {
  public int state,dnum;

  private int sx,x,ex,y;
  private int startMoveTime,driftTime,randomBobTime,flipTime;
  private int direction,hp,dunk,score;
  private boolean patterned;
  private BImage leftImage,rightImage;

  public SwimmingDuck(int mdnum) {
    dnum=mdnum;

    if (random(4)<1) {
      hp=3;
      patterned=true;
      leftImage=tinyPatternedDuckLeftImage;
      rightImage=tinyPatternedDuckRightImage;
      score=500;
    } else {
      hp=1;
      patterned=false;
      leftImage=tinyDuckLeftImage;
      rightImage=tinyDuckRightImage;
      score=100;
    }

    dunk=flipTime=0;
    state=kDartingOn;

    sx=-(swimmingDucks.length-dnum)*70;
    ex=int(int(dnum*70+2)+62);
    y=(height+25)-129;

    direction=kRight;

    driftTime=3000;
    startMoveTime=millis()+((swimmingDucks.length-1)*333)-(dnum*333);
    randomBobTime=int(random(100000));
  }

  public boolean checkCollision(float t,float l, float b, float r) {
    // first do body

    int hw=rightImage.width/2;
    int hh=rightImage.height/2;

    int dl=x-hw;
    int dr=x+hw;
    int dt=y;
    int db=y+hh;

    if ((l<dr && r>dl) && (b>dt && t<db)) return true;

    // now do head, based on direction

    dt=y-hh;

    if (direction==kRight) dl=x;
    else dr=x;

    if ((l<dr && r>dl) && (b>dt && t<db)) return true;

    return false;
  }

  public int doHit() {
    if (--hp<0) {
      // popped
      doPop();
      increaseScore(score,x,y-10);
      playSound(pointsSound,kHighPriority);
      return kDie;
    } else {
      // lite pop

      increaseScore(50,x,y-10);

      for (int i=155;i<205;i+=10) {
        float pex,pey;
        push();

        translate(x,y-5,0);
        rotateZ(i*PI/180);

        translate(0,70+random(50),0);

        pex=screenX(0,0,0);
        pey=screenY(0,0,0);

        pop();

        int r,g,b;

        if (patterned) {
          r=214;
          g=128;
          b=171;
        } else {
          r=g=255;
          b=0;
        }

        particles.add(new Particle(x,y-5,pex,pey,2,int(500+random(1250)),r,g,b));
      }

      dunk=3;
      return kLive;
    }
  }

  public void doPop() {
    // pop the duck!

    state=kPopped;

    for (int i=135;i<225;i+=5) {
      float pex,pey;
      push();

      translate(x,y+4,0);
      rotateZ(i*PI/180);

      translate(0,70+random(50),0);

      pex=screenX(0,0,0);
      pey=screenY(0,0,0);

      pop();

      int r,g,b;

      if (patterned) {
        r=214;
        g=128;
        b=171;
      } else {
        r=g=255;
        b=0;
      }

      particles.add(new Particle(x,y+4,pex,pey,3,int(500+random(1750)),r,g,b));
    }
  }

  private void newDrift(boolean forceLoc) {
    if (gameState==kGameOver && state==kDrifting && x>=15 && random(2)<1) {
      state=kFlipUp;
      flipTime=millis();
    } else {
      state=kDrifting;

      // choose a drift location

      sx=x;
      if (forceLoc) {
        driftTime=3000;
        startMoveTime=millis()+((swimmingDucks.length-1)*333)-(dnum*333);
        ex=int(int(dnum*70+2)+62);
      } else {
        driftTime=int(5000+random(5000));
        startMoveTime=millis();
        ex=int(random(224)+15);
      }

      if (ex<x) direction=kLeft;
      else if (ex>x) direction=kRight;
    }
  }

  public void drawShadow() {
    if (state!=kPopped) {
      int radius=int(sin((millis()-masterClock)/333)*1.75);

      noStroke();
      fill(2,135,195,192);
      smooth();
      ellipseMode(CENTER_DIAMETER);
      ellipse(x+1,y+currWaterLevel+9,31+(radius*2),6);
      ellipseMode(CORNER);
      noSmooth();
    }
  }

  public void draw() {
    noTint();

    if (state==kFlipUp) {
      float mod=min(1,(millis()-flipTime)/333.0);

      push();
      translate(x,y-(30*mod));

      if (direction==kRight) {
        rotateZ((2*PI)-PI*mod);
        image(rightImage,0,0);
      } else {
        rotateZ(PI*mod);
        image(leftImage,0,0);
      }
      pop();
    } else if (state==kFlipDown) {
      float mod=min(1,(millis()-flipTime)/333.0);

      push();
      translate(x,y-(30*(1-mod)));

      if (direction==kRight) {
        rotateZ((2*PI)-(PI*2*mod+PI*(1-mod)));
        image(rightImage,0,0);
      } else {
        rotateZ(PI*2*mod+PI*(1-mod));
        image(leftImage,0,0);
      }
      pop();
    } else if (state!=kPopped) {
      // use blend rather than a mask

      int water1Top=int((height+25)-135+currWaterLevel);
      int water1Mid=water1Top+waterMaskStart;

      int bob=int(sin((millis()+randomBobTime)/1111)*1.25);

      if (direction==kRight) {
        int drawY=y+currWaterLevel-10+bob+dunk;
        int w=rightImage.width;
        int rh=rightImage.height;
        int h=constrain(rh-((drawY+rh)-water1Mid),0,rh);
        blend(rightImage,0,0,w,h,x-10,drawY,x+w-10,drawY+h,BLEND);
      } else {
        int drawY=y+currWaterLevel-10+bob+dunk;
        int w=leftImage.width;
        int rh=leftImage.height;
        int h=constrain(rh-((drawY+rh)-water1Mid),0,rh);
        blend(leftImage,1,0,w,h,x-10+1,drawY,x+w-10,drawY+h,BLEND);
      }

      dunk=max(0,dunk-1);
    }
  }

  public void swim() {
    if (state==kFlipUp) {
      if (millis()-flipTime>333) {
        state=kFlipDown;
        flipTime=millis();
      }
    } else if (state==kFlipDown) {
      if  (millis()-flipTime>333) {

        ex=sx=x;
        startMoveTime=millis();
        driftTime=int(5000+random(5000));
        state=kDrifting;
      }
    } else if (state!=kPopped) {
      if (millis()-startMoveTime>driftTime) {
        newDrift(false);
      } else {
        float t=(millis()-startMoveTime)/float(driftTime);

        // check to see if we intersect

        int nx=int(sx*(1-t)+ex*t);

        boolean collision=false;

        for (int i=0;i<swimmingDucks.length;i++) {
          SwimmingDuck td=swimmingDucks[i];
          if (td!=this) {
            if ((td.x+12>nx-12 && td.x+12<nx+12) || (td.x-12<nx+12 && td.x-12>nx-12)) {
              collision=true;
              break;
            }
          }
        }

        if (collision) {
          newDrift(true);
        } else x=nx;
      }
    }
  }
}

// our marching duck class

class MarchingDuck {
  int x,y;
  BImage dImage;
  boolean specialDuck,hasPuddle;

  int by;
  int dropX,dropStartTime;

  private int nextMoveTime;
  private int sy,ey,specialType;
  private int currSpecialTime,nextSpecialTime,specialDur;

  public MarchingDuck(int mx,int my,BImage mDImage,boolean mSpecialDuck, boolean mHasPuddle) {
    x=mx;
    y=by=sy=ey=my;
    dImage=mDImage;
    specialDuck=mSpecialDuck;
    hasPuddle=mHasPuddle;
    nextMoveTime=millis();
    nextSpecialTime=millis()+int(random(4000));
  }

  public void doPop() {
    // pop the duck!

    y=sy=ey=by;
    specialType=kPopped;

    for (int i=0;i<360;i+=10) {
      float psx,psy,pex,pey;
      push();

      translate(x,y,0);
      rotateZ(i*PI/180);
      translate(0,10,0);

      psx=screenX(0,0,0);
      psy=screenY(0,0,0);

      translate(0,30+random(30),0);

      pex=screenX(0,0,0);
      pey=screenY(0,0,0);

      pop();

      int tr=255;
      int tg=255;
      int tb=0;

      if (hasPuddle && !(i>45 && i<315)) {
        tr=0;
        tg=176;
        tb=255;
      } else if (dImage==duckPatternedImage) {
        tr=214;
        tg=128;
        tb=171;
      }

      particles.add(new Particle(psx,psy,pex,pey,4,int(500+random(1750)),tr,tg,tb));
    }
  }

  public void draw(float t) {
    tint(255,255*t);

    if (specialType!=kPopped) {
      if (specialDuck) {
        // pachinko!

        imageMode(CORNER);
        image(titleBgdImages[int(random(2))],x-67,y-53);
        image(titleImage,x-57,y-47);
        imageMode(CENTER_DIAMETER);
      }

      if (hasPuddle) {
        // puddle

        smooth();
        noStroke();
        fill(0,176,255,255*t);
        ellipse(x-22,by+11,43,7);
        noSmooth();
      }

      push();
      translate(0,0,0); // getting some weird 2d duck glitches

      if (specialType==kFlipUp) {
        float mod=min(1,(millis()-currSpecialTime)/float(specialDur));

        if (by-y<4) {
          // clear the pool!

          image(dImage,x,y);
        } else {
          push();
          translate(x,y);
          rotateZ(PI*mod);
          image(dImage,0,0);
          pop();
        }

      } else if (specialType==kFlipDown) {
        float mod=min(1,(millis()-currSpecialTime)/float(specialDur));

        if (by-y<4) {
          // clear the pool!

          image(dImage,x,y);
        } else {
          push();
          translate(x,y);
          rotateZ(PI*2*mod+PI*(1-mod));
          image(dImage,0,0);
          pop();
        }

      } else image(dImage,x,y);
      
      pop();
    }

    if (hasPuddle) {
      // front puddle

      if (specialType!=kPopped) {
        fill(0,176,255,255*t);
        rect(x-13,by+15,26,2);
        rect(x-7,by+17,14,1);
      }

      // drip

      if (dropStartTime>0) {
        float temp=min(1,(millis()-dropStartTime)/1000.0);

        if (temp>1) {
          temp=1;
          dropStartTime=0;
        }

        noStroke();
        fill(0,176,255,((1-temp)*192)*t);

        float ty=(by+22)*(1-temp)+(by+150)*temp;

        smooth();
        beginShape(POLYGON);
        vertex(dropX,ty);
        bezierVertex(dropX+3,ty+5);
        bezierVertex(dropX+2,ty+9);
        bezierVertex(dropX-2,ty+9);
        bezierVertex(dropX-2,ty+5);
        endShape();
        noSmooth();

        stroke(0,176,255,192*t);
        point(dropX-1,(by+20)*(1-temp)+(by+100)*temp);
      }
    }
  }

  public void march() {
    if (millis()>nextMoveTime) {
      int temp=x-5;
      if (temp==-150) temp=300+(marchingDucks.length/2)*kDuckSpacer; // bad form
      x=temp;
      nextMoveTime=millis()+50;
    }

    if (specialType!=kPopped) {
      if (millis()>nextSpecialTime) {
        // should we flip or bob?

        if (random(8)>7) {
          sy=by;
          ey=by-50;

          specialDur=333;
          specialType=kFlipUp;
          currSpecialTime=millis();
        } else if (!hasPuddle) {
          sy=by+10;
          ey=by;

          specialDur=500;
          specialType=kBob;
          currSpecialTime=millis();
        } else specialDur=100;

        nextSpecialTime=millis()+specialDur*4+int(random(500));
      } else if (millis()-currSpecialTime<specialDur) {
        // do our flip or bob

        float mod=(millis()-currSpecialTime)/float(specialDur);
        y=int(ey*mod+sy*(1-mod));
      } else {
        y=ey;

        if (specialType==kFlipUp) {
          ey=by;
          sy=y;

          specialType=kFlipDown;
          currSpecialTime=millis();
        } else {
          if (hasPuddle && specialType==kFlipDown) {
            // drip drip drip

            dropX=x+3+int(random(1,3)*3);
            dropStartTime=millis();
          }

          specialType=kNoSpecial;
        }
      }
    }
  }
}

// FID Container Data

class FIDContainer implements Runnable {

  public boolean ok;
  public String firstName;
  public String pictureURL;
  public int[] FFIDArray;
  public int FID;

  public String iFriendsString,gFriendsString;

  public BImage picture;
  public BGraphics nameImage;
  public int ipwidth,ipheight,gpwidth,gpheight;
  public int scrollTime;

  private Thread pictureThread;
  private int nameWidth;

  // ignore the rest...

  public FIDContainer() {
    nameImage=new BGraphics(60,16);
    nameImage.textSpace(SCREEN_SPACE);
    nameImage.textFont(gameFont);

    reset();
  }

  public void reset() {
    ok=false;
    firstName=unknownString;
    iFriendsString=iFriends0String;
    gFriendsString=gFriends0String;
    picture=noPhotoImage;
    ipwidth=gpwidth=picture.width;
    ipheight=gpheight=picture.height;

    pictureThread=null;
    nameWidth=0;
    scrollTime=millis();
    FID=0;
  }

  public void parse(int mFID, String data) {
    // split on ampersand

    FID=mFID;

    String[] vars=split(data,'&');

    for (int i=0;i<vars.length;i++) {
      String[] theVar=split(vars[i],'=');

      if (theVar[0].equals("ok")) {
        if (theVar[1].equals("yes")) ok=true;
        else ok=false;
      } else if (theVar[0].equals("firstName")) {
        firstName=URLDecoder.decode(theVar[1]);
        nameWidth=0;

        for (int j=0;j<firstName.length();j++) nameWidth+=gameFont.width(firstName.charAt(j));

        if (nameWidth>60) {
          nameWidth+=gameFont.width("+")+gameFont.width(" ")*4;
        }

        scrollTime=millis();
      } else if (theVar[0].equals("pictureURL")) {

        if (isApplet) pictureURL="slurpImage.php?url="+theVar[1];
        else pictureURL=theVar[1];

        // load picture asynchronously

        pictureThread=new Thread(this);
        pictureThread.start();

      } else if (theVar[0].equals("FFIDArray")) {
        FFIDArray=toInt(split(theVar[1],','));

        if (FFIDArray==null) {
          iFriendsString=iFriends0String;
          gFriendsString=gFriends0String;
        } else {
          if (FFIDArray.length==1) {
            iFriendsString="1 friend          (            )";
            gFriendsString="1";
          } else {
            gFriendsString=nf(FFIDArray.length,0);
            iFriendsString=gFriendsString+" friends          (            )";
          }
        }
      }
    }
  }

  public void renderName() {
    nameImage.background(255);

    if (nameWidth==0) {
      nameImage.image(noNameImage,12,2);
    } else if (nameWidth<=60) {
      nameImage.fill(255,0,0);
      nameImage.textMode(ALIGN_CENTER);
      nameImage.text(firstName,nameImage.width/2,12);
    } else {
      // scroll!

      int scroll=0;

      if (millis()>scrollTime) scroll=int((millis()-scrollTime)/50.0)%nameWidth;
      nameImage.fill(255,0,0);
      nameImage.textMode(ALIGN_LEFT);
      nameImage.text(firstName+"  +  "+firstName,-scroll,12);
    }
  }

  public void run() {
    if (!pictureURL.equals("http://photos.friendster.com/images/nophoto.jpg")) picture=loadImage(pictureURL);
    else picture=null;

    if (picture!=null) {
      // compare size

      if (picture.width<=4 && picture.height<=4) picture=null;
      else if (picture.pixels.length==friendsterNoPhotoImage.pixels.length) {
        // is it friendsterNoPhotoImage? compare manually

        boolean same=true;
        for (int i=0;i<friendsterNoPhotoImage.pixels.length;i++) {
          if (picture.pixels[i]!=friendsterNoPhotoImage.pixels[i]) {
            same=false;
            break;
          }
        }

        if (same) picture=null;
      }
    }

    // loaded?

    if (picture!=null) {
      // scale for intro + game

      if (picture.width>picture.height) {
        if (picture.width>kIntroPicMaxSize) {
          ipheight=int(picture.height/(picture.width/float(kIntroPicMaxSize)));
          ipwidth=kIntroPicMaxSize;
        } else {
          ipwidth=picture.width;
          ipheight=picture.height;
        }

        if (picture.width>kGamePicMaxSize) {
          gpheight=int(picture.height/(picture.width/float(kGamePicMaxSize)));
          gpwidth=kGamePicMaxSize;
        } else {
          gpwidth=picture.width;
          gpheight=picture.height;
        }
      } else {
        if (picture.height>kIntroPicMaxSize) {
          ipwidth=int(picture.width/(picture.height/float(kIntroPicMaxSize)));
          ipheight=kIntroPicMaxSize;
        } else {
          ipwidth=picture.width;
          ipheight=picture.height;
        }

        if (picture.height>kGamePicMaxSize) {
          gpwidth=int(picture.width/(picture.height/float(kGamePicMaxSize)));
          gpheight=kGamePicMaxSize;
        } else {
          gpwidth=picture.width;
          gpheight=picture.height;
        }
      }

      // make sure they are a multiple of 2

      if ((ipwidth/2)*2!=ipwidth) ipwidth--;
      if ((ipheight/2)*2!=ipheight) ipheight--;

      if ((gpwidth/2)*2!=gpwidth) gpwidth--;
      if ((gpheight/2)*2!=gpheight) gpheight--;

    } else {
      picture=badPhotoImage;
      ipwidth=gpwidth=picture.width;
      ipheight=gpheight=picture.height;
    }
    
    stop();
  }

  public void stop() {
    pictureThread=null;
  }
}

// asynchronous URL loader (no callback yet, sorry)

class LoadURL implements Runnable {
  private Thread loadThread;
  private String theURL;
  int loadStatus,loadTime;
  String data;

  public LoadURL() {
    loadStatus=kNotLoaded;
  }

  public void load(String tURL) {
    if (connected) {
      theURL=tURL;

      loadStatus=kLoading;
      loadThread=new Thread(this);
      loadThread.start();
    } else {
      // only works for FID loading, not HS loading

      int fakeFriends=int(random(100))+1;
      String fakeString=String(101);

      for (int i=1;i<fakeFriends;i++) fakeString+=","+String(101+i);

      data="ok=yes&firstName=FID"+tURL.substring(31,tURL.length())+"&pictureURL=http://photos.friendster.com/images/nophoto.jpg&FFIDArray="+fakeString;
      loadStatus=kLoaded;
      loadTime=millis();
    }
  }

  public void run() {
    try {
      if (isApplet) data=(loadStrings(theURL))[0];
      else data=(loadStrings(docBase+theURL))[0];

      loadStatus=kLoaded;
      loadTime=millis();
    } catch (NullPointerException e) {
      println("NullPointerException: "+theURL);
      loadStatus=kLoadFailed;
    }
    
    stop();
  }

  public void stop() {
    loadThread=null;
  }
}
