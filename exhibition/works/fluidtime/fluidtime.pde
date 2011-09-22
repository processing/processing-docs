// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

   /*
    * fluidtime:ptt applet
    * visual model for bus arrival rappresentation
    * fluidtime project
    * 
    * takeThree: visualisation of three bus lines at one stop in turin (torino)
    * takeOne: visualisation of one bus line at one stop in turin (torino)
    * tellOne: visualisation of one bus line at one stop in turin (torino)
    * 
    * michael kieslinger | interaction design institute ivrea research
    * victor zambrano | 00forward.com
    * antonio terreno | java2me.org
    * 
    * data request query
    * code base: http://81.114.121.228:8080/fluidTime/servlet/ViewController
    * 3 routes:  ?app=PTT&cmd=getInfo&stop=10&route=1&route=36&route=38
    * 1 route:   ?app=PTT&cmd=getInfo&stop=10&route=36
    *
    */


String appletName = "take3"; // default applet choice
int checkPeriod = 60; // seconds for the next data rerieval

//// BUS DATA ARRAYS AND VARIABLES
int stops;
int[] routes;

//// FLAGS
boolean parsed = false;
boolean once = false;
boolean debug = false;         //// true for data retrieval debugging mode
boolean connected = true;      //// check if running as (application || applet)

//// SELECT SCREEN FLAGS AND FIELD VARIABLES
boolean select = true;
String stopString = "";
String routeString = "";
boolean selFermata = false;
boolean selLinea = false;
int selScreen = -1;
int appletSelect = 1;

//// SPRITE VARIABLES
Sprite bg, busicon, logo, error;
Sprite wait05, wait10, wait15, wait20, wait25, wait30;
Sprite bus5, bus12, bus20, bus26, bus30;

//// ERROR AND MESSAGES VARIABLES
boolean errorFlag = false;
String errorString = "n";
String errorMsg = "Applet error";

//// DATA RELOADING VARIABLES
int currentMinute, lastMinute;

//// FONT LOADING VARIABLES
BFont U65, U75;

//// NETWORK VARS
//// path for retrieving files (images and fonts)
static String filePath = "http://www.fluidtime.net/applets/protected/images/";
//// path if online
String proxy = "http://www.fluidtime.net/applets/protected/ptt.xml.php?";
//// path if offline
String direct = "http://81.114.121.228:8080/fluidTime/servlet/ViewController?app=PTT&cmd=getInfo&";
String stream;

PTT pttdata;

//// MAIN METHOD //////////////////////////////////////////////////////

static public void main(String args[]) {
    /*
    * example of args retrieval:
    
    arg1 = args.length > 0  // if there is an argument
           ? args[0]        // use the argument
           : "default1";   // else use the local machine

    arg2 = args.length > 1
           ? args[1]
           : "default2";
    */
    
    try {
        Frame frame = new Frame();
        Class c = Class.forName("ptt");
        BApplet applet = (BApplet) c.newInstance();
        applet.init();
        applet.start();

        Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();

        frame.setLayout(new BorderLayout());
        frame.setTitle("ptt");
        frame.add(applet, BorderLayout.CENTER);
        frame.pack();

        frame.setLocation((screen.width - applet.g.width) / 2,
            (screen.height - applet.g.height) / 2);
        
        //// this does not work with processing, haven't figured out why
        //Image icon = Toolkit.getDefaultToolkit().getImage(filePath + "ptt_icon.gif");
        //frame.setIconImage(icon);
        
        //// this does
        frame.setIconImage(Toolkit.getDefaultToolkit().getImage(filePath + "ptt_icon.gif"));

        frame.show();
        applet.requestFocus(); // get keydowns right away 

        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.out.println("\nfluidtime:ptt ended, arrivederci...");
                System.exit(0);
            }
        });
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
    }



//// SETUP AND LOOP ///////////////////////////////////////////////////

void setup() {
  size(128, 128);
  //// load files remotely
  loadFiles();
  //// setup the timer vars
  currentMinute = lastMinute = millis();
  //// clears the console in authoring time
  clearOutput(8);
  //// checks if it runs as an applet or an application
  connected = online();
}

void loop() {
  background(255);
  
  if (debug) debugMode();
  
  if (select) {
    //// draws the selection screen
    bgDraw(0);
    selectDraw();
  } else {
    if(errorFlag) {
      //// draws the error screen
      errorDraw();
      
    } else {
      //// draws the info screen
      bgDraw(1);
      drawDataApp(appletSelect);
      
      if(setTimePeriod(checkPeriod)) getDataApp();
    }
  }
  updateButton(selScreen);
}


//// METHODS /////////////////////////////////////////////////////

//// displaying data input
//// (this method could use a very good optimisation!!)
void drawDataApp(int myApplet) {
  String tstop, troute, ttimes = null;
  int stops;
  int routes;
  int times;
  int dh = 23;
  int count = 0;
  int total = 0;
  float wide = 0.0;

    //// takeThree display
  if (myApplet == 1) {
    int hr = 17;
    int ht = 30;

    //// stops
    stops = pttdata.getNumberOfStops();
    for (int k=0; k<stops; k++) {
      tstop = ((pttdata.getStopAt(k)).getValue()).trim();

      //// routes
      routes = (pttdata.getLastStop()).getNumberOfRoutes();
      for (int j=0; j<routes; j++) {
        hr = hr + dh;
        troute = (((pttdata.getStopAt(k)).getRouteAt(j)).getValue()).trim();
        textFont(U75, 16);
        fill(#FFFFFF);
        wide = U75.width(troute);
        text( troute , 116-wide/2, hr );

        //// times
        times = ((pttdata.getLastStop()).getRouteAt(j)).getNumberOfTimes();
        for (int i=0; i<times; i++) {
          ttimes = ((pttdata.getStopAt(k)).getRouteAt(j)).getTimeAt(i);
          ht = 30 + 23*j;

          //// show text for the time
          if (debug) {
            textFont(U75, 12);
            fill(#333333);
            String t = ttimes+"|";
            wide = U75.width(t);
            text(t, width - ( (Integer.parseInt(ttimes)*103)/30 ) - 25 - wide, ht+10);
          } else {
            busicon.display(width - ( (Integer.parseInt(ttimes)*103)/30 ) - 47, ht);
          }
        }
      }
    }
    
    //// takeOne display
  } else if (myApplet == 2) {
    int hr = 112;
    int ht = 87;

    stroke(#ff0000);
    line(66, 98, 128, 98);

    //// stops
    stops = pttdata.getNumberOfStops();
    for (int k=0; k<stops; k++) {
      tstop = ((pttdata.getStopAt(k)).getValue()).trim();

      //// routes
      routes = (pttdata.getLastStop()).getNumberOfRoutes();
      for (int j=0; j<routes; j++) {
        troute = (((pttdata.getStopAt(k)).getRouteAt(j)).getValue()).trim();
        textFont(U75, 16);
        fill(#FFFFFF);
        wide = U75.width(troute);
        text( troute , 116-wide/2, hr );

        //// times
        times = ((pttdata.getLastStop()).getRouteAt(j)).getNumberOfTimes();
        for (int i=times-1; i>-1; i--) {
          ttimes = ((pttdata.getStopAt(k)).getRouteAt(j)).getTimeAt(i);
          int pos = Integer.parseInt(ttimes);

          /* //// bus size calculations | currently not used
          int myScale = 100-(pos*100/30);
          int sw = myScale*41/100;
          int sh = myScale*42/100; */

          //// decides wich bus image to show
          if (pos >= 0 && pos < 6) busicon = bus5;
          else if (pos >= 6 && pos < 13) busicon = bus12;
          else if (pos >= 13 && pos < 21) busicon = bus20;
          else if (pos >= 21 && pos < 27) busicon = bus26;
          else if (pos >= 27) busicon = bus30;
          //// calculates the image positioning
          int busW = 83 - ( (pos*68)/30 );
          int busH = 53 - ( (pos*23)/30 );
          //// show text for the time
          if (debug) {
            textFont(U75, 12);
            fill(#333333);
            String t = ttimes+"|";
            wide = U75.width(t);
            text(t, busW, busH);
          } else {
            busicon.display(busW, busH);
          }
        }
      }
    }

    //// tellOne display
  } else if (myApplet == 3) {
    int hr = 97;
    int ht = 87;

    //// stops
    stops = pttdata.getNumberOfStops();
    for (int k=0; k<stops; k++) {
      tstop = ((pttdata.getStopAt(k)).getValue()).trim();

      //// routes
      routes = (pttdata.getLastStop()).getNumberOfRoutes();
      for (int j=0; j<routes; j++) {
        troute = (((pttdata.getStopAt(k)).getRouteAt(j)).getValue()).trim();
        textFont(U75, 16);
        fill(#FFFFFF);
        wide = U75.width(troute);
        text( troute , 116-wide/2, ht+10 );

        //// times
        times = ((pttdata.getLastStop()).getRouteAt(j)).getNumberOfTimes();
        for (int i=0; i<times; i++) {
          ttimes = ((pttdata.getStopAt(k)).getRouteAt(j)).getTimeAt(i);
          int pos = Integer.parseInt(((pttdata.getStopAt(k)).getRouteAt(j)).getTimeAt(0));
          Sprite wait = wait05;
          //// show reference image
          if (pos >= 0 && pos < 6) wait = wait05;
          else if (pos >= 6 && pos < 11) wait = wait10;
          else if (pos >= 11 && pos < 16) wait = wait15;
          else if (pos >= 16 && pos < 21) wait = wait20;
          else if (pos >= 21 && pos < 26) wait = wait25;
          else if (pos >= 26) wait = wait30;
          wait.display(0, 25);

          //ht = 87; //30 + 23*k;
          if (debug) {
            //// show text for the time
            textFont(U75, 12);
            fill(#333333);
            String t = ttimes+"|";
            wide = U75.width(t);
            text(t, width - ( (Integer.parseInt(ttimes)*103)/30 ) - 25 - wide, ht+10);
          } else {
            //// show bus images
            busicon.display(width - ( (Integer.parseInt(ttimes)*103)/30 ) - 47, ht);
          }
        }
      }
    }

  } else {
    errorFlag = true;
    errorMsg = "Applet error";
  }
  //once = true;
}

   /*
    * xml parser for fluidtime applets 5.03b
    * uses KXml2 parser (non validating, event handler)
    * http://kobjects.dyndns.org/kobjects/auto?self=$c0a80001000000f5ad6a6fb3
    * data parsing classes by Antonio Terreno | http://antonioterreno.java2me.org
    *
    */

void getDataApp() {
  loadAppletFiles(appletName);
  
  //// builds the filePath
  stream = setStream();
    //println("stream= "+stream);
    
  //// gets the file!!
  try {
    /* processing style input reader */
    InputStream input = loadStream(stream);
    InputStreamReader isr = new InputStreamReader(input);
    
    // parse it
    pttdata = new KxmlFluidTime();
    pttdata.parse(input);
    
    parsed = true;

  } catch (final IOException e) {
    println("IOException: " + e);
    errorFlag = true;
    errorMsg = "File not found";
    
  } catch (final SAXException e) {
    println("SAXException: " + e);
    errorFlag = true;
    errorMsg = "Data error";
    
  } catch (final XmlPullParserException e) {
    println("XmlPullParserException: " + e);
    errorFlag = true;
    errorMsg = "No bus data";
    
  } catch (final Throwable e) {
    println("Other Exception: " + e);
    errorFlag = true;
    errorMsg = "Applet error";
    
  } finally {
      //if (parsed) select = false;
      select = false;
    //input.close(); // no need to close it, P5 takes care of it!
  }
  // xml doc is parsed
}

//// sets the default strings for the stop & line(s)
//// + prints out error string if one is thrown
void debugMode() {
    if (select) {
        if (appletSelect == 0) {
            stopString = "10";
            routeString = "1 36 38";
        } else {
            stopString = "10";
            routeString = "38";
        }
    }
    textFont(U65, 12);
    fill(0);
    text( errorString , 0, 25);
}

//// file loading (remote)
void loadFiles() {
  try {
    // load images
    logo = new Sprite(filePath + "select.gif");
    error = new Sprite(filePath + "error.gif");

    // load fonts
    U65 = loadFont(filePath + "Univers65.vlw.gz");
    U75 = loadFont(filePath + "Univers75.vlw.gz");
    textFont(U65, 18);

  } catch (Exception e) {
    println("exception: " + e);
    errorFlag = true;
    errorMsg = "Image not found";
  }
}

void loadAppletFiles(String myApplet) {
    try {
        bg = new Sprite(filePath + myApplet + "_bg.gif");
        busicon = new Sprite(filePath + "bus_side.gif");
    
        if (myApplet.equalsIgnoreCase("take1")) {
            bus5 = new Sprite(filePath + "bus_5.gif");
            bus12 = new Sprite(filePath + "bus_12.gif");
            bus20 = new Sprite(filePath + "bus_20.gif");
            bus26 = new Sprite(filePath + "bus_26.gif");
            bus30 = new Sprite(filePath + "bus_30.gif");
            
        } else if (myApplet.equalsIgnoreCase("tell1")) { // tell(one)
            wait05 = new Sprite(filePath + myApplet + "_05.gif");
            wait10 = new Sprite(filePath + myApplet + "_10.gif");
            wait15 = new Sprite(filePath + myApplet + "_15.gif");
            wait20 = new Sprite(filePath + myApplet + "_20.gif");
            wait25 = new Sprite(filePath + myApplet + "_25.gif");
            wait30 = new Sprite(filePath + myApplet + "_30.gif");
        }
        
  } catch (Exception e) {
    println("exception: " + e);
    errorFlag = true;
    errorMsg = "Image not found";
    
  }
}

//// draws the selection screen
void selectDraw() {
  boolean first = false;
  
  //// draw bg
  rectMode(CORNER);
  noStroke();
  if (selScreen == -1) {
    int bh = 50;
    
    // selection band
    switch(appletSelect) {
      case 1:
          bh = 50;
          appletName = "take3";
          break;
      case 2:
          bh = 70;
          appletName = "take1";
          break;
      case 3:
          bh = 90;
          appletName = "tell1"; // tell(one)
          break;
      default:
          bh = 200;
          appletName = "take3";
    }
    
    fill(95, 132, 178);
    rect(0, bh-4, width, 16);
    
    //// applet title
    textFont(U75, 14);
    fill(95, 132, 178);
    text( "Seleziona:" , 20, 40); // "Select:"
    
    //// selections
    textFont(U75, 21);
    
    //// takeThree (default)
    fill(95, 132, 178);
    if (appletSelect==1) fill(255);
    text( "take3" , 40, 60);
    
    //// takeOne
    fill(95, 132, 178);
    if (appletSelect==2) fill(255);
    text( "take1" , 40, 80);
    
    //// tellOne
    fill(95, 132, 178);
    if (appletSelect==3) fill(255);
    text( "tell1" , 40, 100);

    //// draw message
  } else if (selScreen == 0) {
  
    //// applet title
    textFont(U75, 21);
    fill(95, 132, 178);
    text( appletName , 20, 40);

    fill(95, 132, 178);
    rect(0, 75, width, 30);
    fill(255);
    rect(20, 87, width-40, 15);
    textFont(U65, 12);
    fill(255);
    text( "Inserisce la fermata:" , 20, 85);
    textFont(U75, 14);
    fill(60);
    text( stopString , 22, 99);

    //// draw bus station
  } else if (selScreen == 1) {
  
    //// applet title
    textFont(U75, 21);
    fill(95, 132, 178);
    text( appletName , 20, 40);

    textFont(U75, 14);
    fill(51, 67, 122);
    if (selFermata) {
      text( "Fermata "+stops , 20, 52);
    } else {
      text( "Fermata NULL" , 20, 52);
    }

    //// draw message
    fill(95, 132, 178);
    rect(0, 75, width, 30);
    fill(255);
    rect(20, 87, width-40, 15);
    textFont(U65, 12);
    fill(255);
    if (appletSelect == 1) text( "Inserisce le linee:" , 20, 85);
    else text( "Inserisce la linea:" , 20, 85);
    textFont(U75, 14);
    fill(60);
    text( routeString , 22, 99);

    //// draw bus stop text
  } else if (selScreen == 2) {
  
    //// applet title
    textFont(U75, 21);
    fill(95, 132, 178);
    text( appletName , 20, 40);

    textFont(U75, 14);
    fill(51, 67, 122);
    if (selFermata) {
      text( "Fermata "+stops , 20, 52);
    } else {
      text( "Fermata NULL" , 20, 52);
    }

    //// draw bus lines numbers
    textFont(U75, 14);
    fill(51, 67, 122);
    if (routes.length == 3) {
      text( "Linee "+routes[0]+", "+routes[1]+", "+routes[2] , 20, 64);
    } else if (routes.length == 2) {
      text( "Linee "+routes[0]+", "+routes[1] , 20, 64);
    } else if (routes.length == 1) {
      text( "Linea "+routes[0] , 20, 64);
    } else {
      text( "Linea(e) NULL" , 20, 64);
    }

    //// draw message
    //fill(95, 132, 178); // blue band, i prefer the orange one!
    fill(255, 0, 0);
    rect(0, 93, width, 12);
    textFont(U65, 10);
    fill(255);
    text( "Contattando Server..." , 22, 102);
    if (!first) {
      repaint();
      first = true;
    }
    //// now we have all the info we need to query the server
    getDataApp();
    //if (parsed) select = false;
  }
}

//// handles the input on the fake fields in the selection screen
void setData() {

  if (selScreen == 0 && stopString.length() != 0 && stopString != " " && stopString != "") {
    stops = Integer.parseInt(stopString);
    selFermata = true;
  } else if (selScreen == 1 && routeString.length() != 0 && routeString != " " && routeString != "") {
    routes = splitInts(routeString, ' ');
    selLinea = true;
  }
}

String setStream() {
  String output;
  if(connected) output = proxy;
  else output = direct;

  if(stops > 0) output += "stop="+stops; // error handling??
  if (routes.length > 0) output += "&route="+routes[0]; // error handling??
  if (routes.length > 1) output += "&route="+routes[1]; // error handling??
  if (routes.length > 2) output += "&route="+routes[2]; // error handling??
  
  return output;
}

//// drawing the background
void bgDraw(int var) {
  if (var == 0) {
    //// draw select screen background
    logo.display(0, 0);
  } else if (var == 1) {
    //// draw visualisation background
    bg.display(0, 0);
  }
  //// draw clock and info
  String hh = setZero(hour());
  String mm = setZero(minute());
  String ss = setZero(second());
  textFont(U65, 12);
  fill(95, 132, 178);
  text( hh+":"+mm+":"+ss , 90, 10);
  text( "ATM Torino" , 74, 20);
  //text( "Esci" , 108, 126);
  //text( "Indietro" , 3, 126);
  //// insert here the status code ////
}

void errorDraw() {
  //// error handling screen
  logo.display(0, 0);
  error.display(0, 40);
  textFont(U75, 14);
  fill(#FFFFFF);
  text( "Errore:" , 35, 55 );
  text( errorMsg , 35, 65 );
  fill(95, 132, 178);
  text( "Prema ENTER" , 35, 90 );
  text( "per riavviare" , 35, 100 );
}

//// queries the server every <period> seconds
boolean setTimePeriod(int period) {
  boolean done = false;
  currentMinute = millis();
  if(currentMinute > (lastMinute+(period*1000))) {
    done = true;
    lastMinute = currentMinute;
  }
  if(debug) {
    fill(0);
    textFont(U75, 12);
    text( lastMinute + " | " + currentMinute, 18, 125);
  }
  return done;
}

//// what to do if button is pressed
void mousePressed() {
    if (selScreen == -1) { 
        if (appletSelect <= 3 && appletSelect >= 1) selScreen = 0; 
    } else if (selScreen == 0) { 
        //// code for buttons in the 
        //// stop selection screen
    } else if (selScreen == 1) { 
        //// code for buttons in the 
        //// line(s) selection screen
    } else if (selScreen == 2) { 
        //// code for buttons in the 
        //// bus display screen
    }
}

//// keyboard input
public void keyPressed(KeyEvent e) {
  //println(e);
  int kc = e.getKeyCode();
  char newChar;
  
  if (kc == 61) debug = !debug;
  if (kc == 69 && debug) errorFlag = !errorFlag;
  if (select) {
    if (kc == 10) {
      setData();
      if (selScreen < 3) selScreen++;
    } else if (kc == 37) {
      if (selScreen == 2) selLinea = false;
      if (selScreen == 1) selFermata = false;
      if (selScreen > -1) selScreen--;
    } else if (kc == 32 || (kc > 47 && kc < 58) || (kc > 95 && kc < 106)) {
      if (selScreen == -1) {
          if (kc == 48 || kc == 97) {
              appletName = "take3";
              appletSelect = 1;
              selScreen = 0;
          }
          if (kc == 49 || kc == 98) {
              appletName = "take1";
              appletSelect = 2;
              selScreen = 0;
          }
          if (kc == 50 || kc == 99) {
              appletName = "tell1"; // tell(one)
              appletSelect = 3;
              selScreen = 0;
          }
      } else if (selScreen == 0) {
          //newChar = e.getKeyChar();
        stopString = stopString + e.getKeyChar();
      } else if (selScreen == 1) {
          //newChar = e.getKeyChar();
        routeString = routeString + e.getKeyChar();
      }
    } else if (kc == 8) {
      if (selScreen == 0) {
        stopString = "";
      } else if (selScreen == 1) {
        routeString = "";
      }
    } else if (kc == 38 && appletSelect > 1) {
      appletSelect--;
    } else if (kc == 40 && appletSelect < 3) {
      appletSelect++;
    } else if (kc == 10) selScreen = 0;
  } else {
    if (kc==37 || (kc == 10 && errorFlag)) {
      stopString = "";
      routeString = "";
      selLinea = false;
      selFermata = false;
      select = true;
      selScreen = -1;
      errorFlag = false;
    }
  }
}

//// AUXILIARY METHODS ///////////////////////////////////////////////

//// Sprite class for transparent GIFs
//// by Glen Murphy | bodytag.org
class Sprite {
  int wh;       //// Size of the sprite (width*height)
  int[] px;     //// Array for storing the sprite
  int swidth;   //// Width of the sprite
  int sheight;  //// Height of the sprite
  BImage img;   //// The image that is the sprite

  Sprite(String imageName) {
    loadSprite(imageName);
    swidth = img.width;
    sheight = img.height;
    wh = swidth*sheight;
    px = new int[wh];

    //// Load the image into the px[] array
    for(int i=0; i < wh; i++) {
      px[i] = img.pixels[i];
    }
  }

  void loadSprite(String name) {
    img = loadImage(name);
  }

  void display(int x, int y) {
    if (-x>=swidth || -y>=sheight) return;
    int tw=(x<0) ? x+swidth : min(width-x,swidth);
    int th=(y<0) ? y+sheight : min(height-y, sheight);
    int offset1=((x<0) ? -x : 0)+((y<0) ? -y : 0)*swidth;
    int offset2=((x<0) ? 0 : x)+((y<0) ? 0 : y)*width;
    int yy=-1;
    while(++yy<th) {
      int xx=-1;
      while(++xx<tw) {
        if(px[offset1] != 0x00FFFFFF) pixels[offset2] = px[offset1];
        offset1++;
        offset2++;
      }
      offset1+=(swidth-tw);
      offset2+=(width-tw);
    }
  }
}

//// button controls - to be implemented
boolean overRect(int x, int y, int width, int height) { 
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) { 
    return true; 
  } else { 
    return false; 
  } 
}

//void update(int x, int y) { 
void updateButton(int currentScreen) { 
    if (currentScreen == -1) {
        int oldAppletSelect = appletSelect;
        if ( overRect(0, 46, width, 16) ) { 
            appletSelect = 1; 
        } else if ( overRect(0, 66, width, 16) ) { 
            appletSelect = 2;  
        } else if ( overRect(0, 86, width, 16) ) { 
            appletSelect = 3;  
        } else appletSelect = 0; 
    }
}

//// cleans the output field
void clearOutput(int times) {
  if(!connected) for(int i=0; i<=times; i++) println();
}

//// puts a zero if the input is one digit
String setZero(int data) {
  String val;
  if (data < 10) {
    val = "0" + data;
  } else {
    val = "" + data;
  }
  return val;
}

//// END APPLET //////////////////////////////////////////////////////////////////////////

