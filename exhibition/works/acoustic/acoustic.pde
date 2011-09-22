// acoustic cartography --------------------------------------------------------
//
// 2004 daniel rothaug
// mailto: daniel@acoustic-cartography.com
// http://www.acoustic-cartoghraphy.com
//
// modified 2004-12-31
// p5 version: 74


int screenwidth = 800;
int screenheight = 600-44;

int imgheight = 350;   // image heigth
int imgwidth = 350;    // image width
int imgmargin = 43;    // top and bottom image imgmargin

int res = 10;	       // resolution
int mode = 1;          // default visualisation
int fmode = 1;     	   // default frequency mode

int nmznum = -50;      // default zoom
int colormode = 2;     // default colormode

int min = 58;	       // min db value
int max = 78;	       // max db value
int offset;
int count = 4;
int dx;      

float d, h, nmx, nmy, nmz;

float rxnum = 1.08;
float rznum = -0.72;
float rx, rz;
float dnum = 1;

PFont univers57, univers;

boolean autorotate = false;		
boolean showimage = true;       
boolean showstage = true;       
boolean showdisplay = false;	
boolean showfilter = false;		
boolean showmarker = false;    
boolean showoutline = false;   
boolean showfrequencies = true;

stage mystage = new stage();
display mydisplay = new display();
vimage vimage = new vimage();

int add = 1;
int img_num = 11;
frequencies[] img = new frequencies[img_num];



// setup ------------------------------------------------------------------------------------------

void setup() {

  background(0);

  size(screenwidth, screenheight);
  
  // center
  nmx = width/2;
  nmy = height/2 + 60;
  
  univers57 = loadFont("Univers_57_Condensed_14.vlw");
  univers = loadFont("Univers_57_Condensed.vlw");
  
  // load texture image
  vimage.load("texture.jpg");

  // init image sequence
  for(int i=0; i<img.length; i+=add) {
    img[i] = new frequencies(i);                    
  }
}


// draw -------------------------------------------------------------------------------------------

void draw() {

  clear();

  push();

  transform();
  
  if (autorotate) { rznum += PI/36; }
  if (showimage || showmarker) { vimage.update(); }
  if (showimage) { vimage.render(); }

  if (showfrequencies) {
    
    for(int i=1; i<img.length; i+=add) {
    
      colorMode(HSB, 360);
      
      switch (fmode) {
        case 1: img[i].vertexmap(color(0, 0, i*360/img.length, 80), 0, false); break;
        case 2: img[i].vertexmap(color(convertHSB(i, img.length), 360, 360, 80), 0, false); break;
        case 3: img[i].pixelmap(color(0, 0, 360, 200), 0); break;
        case 4: img[i].outline(color(0, 0, 360, 180)); break;
      }
      
    }
    
  }
  
  if (showmarker) {
    marker(100, 100);
    marker(200, 100);
    marker(240, 240);
    marker(30, 50);
    marker(100, 300);
  }
  
  if (showstage) { mystage.scala(); }
  if (showfilter) { mystage.layer(); }

  pop();
  
  // display
  if (showdisplay || mouseX > width-20) {
  
    // show
    if (abs(width-220-dx) >  0.1) { dx += (width-220-dx)/1.5; }
    mydisplay.render(dx, 0);
  } else {
  
    // hide
    if (abs(width+1-dx) >  0.1) { dx += (width+1-dx)/1.5; mydisplay.render(dx, 0);}
  }
  
}



// -----------------------------------------------------------------------------
// functions
// -----------------------------------------------------------------------------


// 3d marker -------------------------------------------------------------------

void marker(int _x, int _y) {

  if (_y > imgmargin && _y < imgheight - imgmargin) {
  
    colorMode(HSB, 360);
    
    fill(convertHSB(count, img.length), 360, 360, 80);
    stroke(convertHSB(count, img.length), 360, 360);
    
    line(_x, _y, 0, _x, _y, vimage.p[_x][_y].t - 4);
    
    stroke(convertHSB(count, img.length), 360, 360, 80);
    line(_x, _y, vimage.p[_x][_y].t-4, 350, _y, vimage.p[_x][_y].t - 4);
    line(_x, _y, vimage.p[_x][_y].t-4, 0, _y, vimage.p[_x][_y].t - 4);
    line(_x, _y, vimage.p[_x][_y].t-4, _x, 0, vimage.p[_x][_y].t - 4);
    line(_x, _y, vimage.p[_x][_y].t-4, _x, 350, vimage.p[_x][_y].t - 4);
    
    push();
      translate(_x, _y, vimage.p[_x][_y].t);
      box(8);
      textFont(univers, 10);
      fill(convertHSB(count, img.length), 360, 360);
      text(int(vimage.p[_x][_y].t*(max-min)/255) + min  + " db", 10, 4);
    pop();
    
    push();
      translate(0, 0, vimage.p[_x][_y].t);
      noFill();
      rect(0, 0, imgwidth, imgheight);
    pop();
    
  }
  
}


// 3D transformation -----------------------------------------------------------

void transform() {

  if(mousePressed) {
    cursor(MOVE); 
    if (abs(mouseX - nmx) > 0.01) { nmx += (mouseX-nmx)/6.0; }
    if (abs(mouseY - nmy) > 0.01) { nmy += (mouseY-nmy)/6.0; }
  } else {
    cursor(ARROW); 
  }

  // zoom
  if (abs(nmz-nmznum) >  0.01) { nmz -= (nmz-nmznum)/2.0; };
  
  // center
  translate(nmx, nmy, nmz);				
  
  // x-axis rotation
  if (abs(rx-rxnum) >  0.01) { rx -= (rx-rxnum)/2.0; };
  rotateX(rx);
  
  // z-axis rotation
  if (abs(rz-rznum) >  0.01) { rz -= (rz-rznum)/2.0; };
  rotateZ(rz);  
  
  // center again						
  translate(-imgwidth/2, -imgwidth/2);	    
  
  // amplitude
  if (abs(d-dnum) >  0.01) { d -= (d-dnum)/2.0; };

}


// convert color values
int convertHSB (int i, int nn) {

  int min = 240;      // lowest value
  int max = 305;      // highest value
  int range = 360;    // spectrum range
  int c;

  c = i * ( range - (range-max) ) / nn + (range-min);
  if (c > range) { c -= range; }

  return range-c;     // mirror and return value
  
}


// keyboard --------------------------------------------------------------------

void keyPressed() {
  
  switch (keyCode) {
  
    // rotation
    case UP: rxnum += .18; break;
    case DOWN: rxnum -= .18; break;
    case RIGHT: rznum -= .18; break;
    case LEFT: rznum += .18; break;
    
    // filter
    case ALT: showfilter = !showfilter; break;
      
    case 34: showfilter = true; if (offset > 0) { offset -= 5; } break;
    case 33: showfilter = true; if (offset < 255 / 6 * 5) { offset += 5; } break;
    
    // frequencies (F1)
    case 112: fmode = 1; break;
    
    // frequencies (F2)
    case 113: fmode = 2; break;
    
    // frequencies (F3)
    case 114: fmode = 3; break;
    
     // frequencies (F4)
    case 115: fmode = 4; break;
    
  }
  

  switch (key) {

    // visualisations
    case '1': mode = 1; break;
    case '2': mode = 2; break;
    case '3': mode = 3; break;
    case '4': mode = 4; break;
    case '5': mode = 5; break;
    case '6': mode = 6; break;
    case '7': mode = 7; break;
    case '8': mode = 8; break;
    case '9': mode = 9; break;

    // adjust resolution
    case '+': if (res > 1) { res -= 1; }
      println("resolution:\t" + res);
      break;

    case '-': if (res < 30) { res += 1; };
      println("resolution:\t" + res);
      break;
    
    case 'c': 
      if (colormode < 3) { 
        colormode += 1; 
      } else {
        colormode = 1;
      };
      println("colormode:\t" + colormode);
      break;
    
    // save Frame
    case 's': saveFrame(); break;
    
    // zoom in
    case '.': nmznum += 40; break;
    
    // zoom out
    case ',': nmznum -= 40; break;

    // amplitude
    case 'x': dnum += .2; break;
    case 'y': dnum -= .2; break;

    // autorotate
    case 'r': autorotate = !autorotate; break;

    // show / hide vimage
    case 'i': showimage = !showimage; break;
    
    // show / hide frequencies
    case 'f': showfrequencies = !showfrequencies; break;
    
    // show / hide db markers   
    case 'm': showmarker = !showmarker; break;

    // change frequency (space)
    case ' ': if (count < img_num-1) { count += 1; } else { count = 0; }
      println("image:"  + count);
      break;

    // show / hide stage
    case 'b': showstage = !showstage; break;

    // show / hide display
    case 'd': showdisplay = !showdisplay; break;
      
  }

}

// -----------------------------------------------------------------------------
// methods
// -----------------------------------------------------------------------------


// display ---------------------------------------------------------------------

class display {

  int ls = 28;	// linespace
  int x, y;
  int nn;
  float ty;

  // frequencies in third-octave-bands
  String[] frequencies = {"500", "630", "800", "1000", "1250", "1600", "2000", "2500", "3150", "4000", "5000"};
  String[] frequencies2 = {"447.0 - 562.0", "562.0 - 708.0", "708.0 - 891.0", "891.0 - 1122.0", "1122.0 - 1413.0", "1413.0 - 1778.0", "1778.0 - 2239.0", "2239.0 - 2818.0", "2818.0 - 3548.0", "3548.0 - 4467.0", "4467.0 - 5623.0"};

  
  // render --------------------------------------------------------------------
 
  void render(float _x, float _y) {
    
    colorMode (HSB, 360, 100, 100, 100);
    
    x = int(_x);
    y = int(_y);
    
    overlay(x, 0, x, screenheight);
    
    title(x + 20, y + 40);
    
    //thumbnails(x + 20, y + 80);
    
    focus(x + 20 + 45, y + 500 + nn - 280);
    spectrum(x + 20 + 45, y + 500 - 280);

  }
  
  
  // background ----------------------------------------------------------------
  
  void overlay(int _x, int _y, int _w, int _h) {
    
    noStroke();
    fill(0, 0, 0, 100);
    rect(_x, _y, screenwidth-_w, screenheight);
    
    stroke(0, 0, 360, 30);
    line(_x, _y, _x, screenheight);
    
  }
  
  
  // title ---------------------------------------------------------------------

  void title(int _x, int _y) {

    textFont(univers57);
    textSpace(SCREEN_SPACE);
    textMode(ALIGN_LEFT);
    
    fill(0, 0, 100);
    
    fill(305, 100, 100);
    text("acoustic cartography", _x + 5, _y);

    fill(0, 0, 100);
    text("frequency-analysis", _x + 5, _y + 30);
    text("of an automobile gear", _x + 5, _y + ls * .75 + 30);

  }

	
  // thumbnails ----------------------------------------------------------------
  
  void thumbnails(int _x, int _y) {

    int w = img[count].img.width / 2;	// thumbnail height
    int h = img[count].img.height / 2;	// thumbnail width
    int offset = imgmargin-ls;          // vertical space between thumbnails

    // frequency thumbnail
    image(img[count].img, _x, _y + h - offset, w, h);

    // mask
    fill(0,0,0);
    noStroke();
    rect(_x, _y + h - offset, w, imgmargin/2);
    rect(_x, _y + h*2 - imgmargin/2 - offset, w, imgmargin/2);

    // frame
    noFill();
    stroke(0,0,30);
    rect(_x, _y + h + imgmargin/2 - offset, w, h - imgmargin);

    textFont(univers57);
    textSpace(SCREEN_SPACE);
    textMode(ALIGN_LEFT);
    fill(0, 0, 20);
    text("image " + count + " / " + img_num, _x + 5, _y + h*2 - offset);

    // photographic thumbnail
    image(vimage.c, _x, _y, w, h);
    
    noFill();
    stroke(0,0,30);
    rect(_x, _y + imgmargin/2, w, h - imgmargin);

  }
  
  
  // spectrum ------------------------------------------------------------------
  
  void spectrum(int _x, int _y) {
    
    textFont(univers57);
    textSpace(SCREEN_SPACE);
    textMode(ALIGN_RIGHT);
      
    for (int i=0; i<frequencies.length; i++) {

      int n = ls * (frequencies.length-i);

      fill(convertHSB(i, frequencies.length), 100, 100);
      text(frequencies[i] + " Hz", _x, _y + n);
      
      if (i != count) {
        fill(0, 0, 30);
      }
      
      text(frequencies2[i] + " Hz", _x + 125, _y + n);
      if (i == count) { nn = n; }
      
    }
   
  }
  
  
  // focus ---------------------------------------------------------------------
  
  void focus(int _x, int _y) {

    if (abs(ty - _y) >  0.01) { ty -= (ty - _y) / 1.5; };
    
    int x = _x - 45;
    float y = ty - 14;
    
    noStroke();
    fill(0, 0, 10);
    rect(x, y, 176, 18);

  }
  

}


// frequencies -----------------------------------------------------------------

class frequencies {

  PImage img;

  int[][] imgColors = new int[imgwidth][imgheight];
  int[][] imgPixels = new int[imgwidth][imgheight];

  float t, tt;
  int id;
  int hshift = 175;	// HSB offset


  frequencies(int _id) {
  
    id = _id;
    loadTexture();
    
  }
  
  
  // load texture image --------------------------------------------------------

  void loadTexture() {
  
    img = loadImage("img_" + id + ".jpg");
    println("img_" + id + ".jpg \t loaded");
    //
    analyse();
    
  }

  
  // pixelmap ------------------------------------------------------------------
  
  void pixelmap(color _c, int _offset) {

    colorMode(RGB, 255);

    for(int i=0; i<imgwidth-res; i+=res) {
      for(int j=imgmargin; j<imgheight-imgmargin; j+=res) {

        if (brightness(imgPixels[j][i]) > 160) {
          stroke(_c);
          point (i, j, imgColors[j][i] * d + _offset);
        }

      }
    }

  }
  
  
  // image outline -------------------------------------------------------------
  
  void outline(color _c) {
  
    beginShape(LINE_STRIP);

    stroke(_c);
    
    // left
    for(int j=imgmargin; j<=imgheight-imgmargin-1; j+=res) {
      int i = 0;
      vertex(vimage.p[i][j].x, vimage.p[i][j].y, imgColors[j][i] * d);
    }
    
    // bottom
    for(int i=0; i<imgwidth; i+=res) {
      int j = imgheight - imgmargin - 1;
      vertex(vimage.p[i][j].x, vimage.p[i][j].y, imgColors[j][i] * d);
    }
    
    // right
    for(int j=imgheight-imgmargin-1; j>=imgmargin; j-=res) {
      int i = imgwidth - 1;
      vertex(vimage.p[i][j].x, vimage.p[i][j].y, imgColors[j][i] * d);
    }
    
    // top
    for(int i=0; i<imgwidth; i+=res) {
      int j = imgmargin;
      int ii = imgwidth - i - 1;
      vertex(vimage.p[ii][j].x, vimage.p[ii][j].y, imgColors[ii][j] * d);
    }
    
    vertex(vimage.p[0][imgmargin].x, vimage.p[0][imgmargin].y, imgColors[0][imgmargin] * d);
    
    endShape();
    
  }
  
  
  // vertexmap -----------------------------------------------------------------
  
  void vertexmap(color _c, int _offset, boolean _texture) {

    colorMode(RGB, 255);

    for(int i=0; i<imgwidth-res; i+=res) {

      if (_texture) {
        beginShape(TRIANGLE_STRIP);
        fill(255);
      } else {
        beginShape(LINE_STRIP);
        fill(0);
      }

      for(int j=imgmargin; j<imgheight-imgmargin; j+=res) {

        t = imgColors[j][i] * d;
        tt = imgColors[j][i+res] * d;

        stroke(_c);
        texture(img);

        vertex(i,j,t + _offset,i,j);
        vertex(i+res, j, tt + _offset, i+res, j);

      }

      endShape();
      
    }

  }


  // analyse image -------------------------------------------------------------
  
  void analyse() {
  
    for(int i=0; i<imgwidth; i++) {
      for(int j=0; j<imgheight; j++) {
          
        imgPixels[i][j] = img.pixels[i*imgheight+j];
        
        h = hue(img.pixels[i*imgheight+j]);
        
        if (h > hshift) {
          h = h - 255;
        }
        
        imgColors[i][j] = int(hshift - h);

      }
    }
    
  }
  

}


// stage -----------------------------------------------------------------------

class stage {

  int n = 6;	// scala
  float off;	// filter position
  
  
  // box -----------------------------------------------------------------------
  
  void scala() {
  
    colorMode(RGB, 255);

    textFont(univers, 18);
    textSpace(OBJECT_SPACE);
    textMode(ALIGN_LEFT);

    rectMode(CORNER);

    for(int i = 0; i < n; i++) {

      push();
      
		  translate(0, 0 ,i * 255/n * d);
		  
		  fill(255, i * 100/n + 50);
		  text(int(i*(max-min)/n) + min + " db", imgwidth+10 , 18/2);
		  
		  noFill();
		  stroke(255, i * 100/n + 50);
		  
		  rect(0, 0, imgwidth, imgheight);
      
      pop();

    }

  }

  
  // db layer ------------------------------------------------------------------
  
  void layer() {
   
    if (abs(off-offset) >  0.01) { off -= (off-offset)/1.5; };
  
    push();
    
		translate(0, 0, off * d);
	
		fill(255);
		textSpace(OBJECT_SPACE);
		textFont(univers, 22);
		
		text(int(off*(max-min)/255) + min + " db", imgwidth + 10 , imgheight);
	
		stroke(255);
		fill(0, 200);
		rect(0, 0, imgwidth, imgheight);
    
    pop();
    
  }

}


// imagemap --------------------------------------------------------------------

class vimage {

  PImage c;
  
  int[][] cPixels = new int[imgwidth][imgheight];
  particle[][] p = new particle[imgwidth][imgheight];
  
  float tt, tnum;
  String name;
  
  
  // init particles ------------------------------------------------------------
  
  vimage() {
  
    for(int i=0; i<imgwidth; i++) {
      for(int j=imgmargin; j<imgheight-imgmargin; j++) {
        p[i][j] = new particle(i, j);     
      }
    }
    
  }
  
  
  // load image ----------------------------------------------------------------
  
  void load(String _name) {
  
    name = _name;
    c = loadImage(name);
    
    println (name + "\t loaded");
    
    analyse();
    
  }
  
  
  // analyse texture -----------------------------------------------------------
  
  void analyse() {
  
    for(int i=0; i<imgwidth; i++) {
      for(int j=0; j<imgheight; j++) {
        cPixels[j][i] = c.pixels[i*imgheight+j];  
      }
    }
    
  }
  
  
  // render --------------------------------------------------------------------
  
  void render() {
    
    switch (mode) {
    
      case 1: vertexmap(true); break;
        
      case 2: pixelmap(1); break;
        
      case 3: pixelmap(2); break;
      
      case 4: pixelmap(3); break;
        
      case 5: pixelmap(4); break;
        
      case 6: vertexmap(true); pixelmap(2); break;
      
      case 7: pixelmap(3); pixelmap(2); break;
        
      case 8: pixelmap(5); break;
        
      case 9: break;
        
    }
    
    if (showoutline) { outline(); }
    
  }
  
  
  
  
  
  // pixelmap ------------------------------------------------------------------
  
  void pixelmap(int _mode) {
    
    colorMode(RGB, 255);
    
    for(int i=0; i<imgwidth; i+=res) {
      for(int j=imgmargin; j<imgheight-imgmargin; j+=res) {
      
        switch (_mode) {
           
          
          // visualisation: points ---------------------------------------------
          
          case 1:  
             
            switch (colormode) {
              case 1: stroke (255, 255, 255, 200); break;
              case 2: stroke(red(cPixels[i][j]), green(cPixels[i][j]), blue(cPixels[i][j])); break;
              case 3: stroke(red(img[count].imgPixels[j][i]), green(img[count].imgPixels[j][i]), blue(img[count].imgPixels[j][i])); break;
            }
            
             point(p[i][j].x, p[i][j].y, p[i][j].t);
             break;
          
          
          // visualisation: lines ----------------------------------------------
          
          case 2:

            switch (colormode) {
              case 1: stroke (255, 255, 255, 50); break;
              case 2: stroke(red(cPixels[i][j]), green(cPixels[i][j]), blue(cPixels[i][j]), 200); break;
              case 3: stroke(red(img[count].imgPixels[j][i]), green(img[count].imgPixels[j][i]), blue(img[count].imgPixels[j][i]), 200); break;
            }
            
            if (count < img_num - 1) {
              tnum = img[count + 1].imgColors[j][i] * d;
            } else {
              tnum = img[0].imgColors[j][i] * d;
            }
            
            if (abs(tt - tnum) >  0.01) { tt -= (tt - tnum)/2.0; }
            
            line(p[i][j].x, p[i][j].y, p[i][j].t, p[i][j].x, p[i][j].y, tt);
            
            break;
            
          
          // visualisation: cubes ----------------------------------------------
          
          case 3:
            
            rectMode(CORNER);
            
            switch (colormode) {
              case 1: fill(255, 255, 255, 30); stroke (255, 255, 255, 50); break;
              case 2: fill(red(cPixels[i][j]), green(cPixels[i][j]), blue(cPixels[i][j])); stroke(0, 50); break;
              case 3: fill(red(img[count].imgPixels[j][i]), green(img[count].imgPixels[j][i]), blue(img[count].imgPixels[j][i])); stroke(0, 50); break;
            }
             
            push();
              translate(p[i][j].x, p[i][j].y, p[i][j].t);
              box(res-2);
            pop();
            
            break;
            
          
          // visualisation: graph ----------------------------------------------
          
          case 4:
            
            rectMode(CORNER);
            
            switch (colormode) {
              case 1: fill(255, 255, 255, 30); stroke (255, 255, 255, 50); break;
              case 2: fill(red(cPixels[i][j]), green(cPixels[i][j]), blue(cPixels[i][j])); stroke(0, 50); break;
              case 3: fill(red(img[count].imgPixels[j][i]), green(img[count].imgPixels[j][i]), blue(img[count].imgPixels[j][i])); stroke(0, 50); break;
            }
             
            push();
              translate(p[i][j].x, p[i][j].y, p[i][j].t/2);
              box(res-2, res-2, p[i][j].t);
            pop();
            
            break;
          
          
          // visualisation: typography -----------------------------------------
          
          case 5:
            
            noStroke();
            
            switch (colormode) {
              case 1: fill(255, 255, 255, 100); break;
              case 2: fill(red(cPixels[i][j]), green(cPixels[i][j]), blue(cPixels[i][j]), 200); break;
              case 3: fill(red(img[count].imgPixels[j][i]), green(img[count].imgPixels[j][i]), blue(img[count].imgPixels[j][i]), 200); break;
            }
              
            
            textFont(univers, 8);
            textSpace(OBJECT_SPACE);
            textMode(ALIGN_LEFT);
            
            text(int(p[i][j].t * (max - min)/255) + min, p[i][j].x, p[i][j].y, p[i][j].t);
            break;
            
        }
        
      }
    }
    
  }
  
  
  
  // vertexmap -----------------------------------------------------------------
  
  void vertexmap(boolean _texture) {

    colorMode(RGB, 255);
   
    switch (colormode) {
      case 1: fill(255, 0); stroke(255, 50); break;
      case 2: fill(255); stroke(0, 50); break;
      case 3: fill(255); stroke(0, 50); break;
    }
    
    for(int i=0; i<imgwidth-res; i+=res) {
      
      beginShape(TRIANGLE_STRIP);
      
      if (colormode == 3) {
        texture(img[count].img);
      } else {
        texture(c);
      }
      
      for(int j=imgmargin; j<imgheight-imgmargin-res-1; j+=res) {

        vertex(p[i][j].x, p[i][j].y, p[i][j].t, p[i][j].x, p[i][j].y);
        vertex(p[i+res][j].x, p[i+res][j].y, p[i+res][j].t, p[i+res][j].x, p[i+res][j].y);
        
      }
      
      endShape();
      
    }
    
  }
  
  
  // outline -------------------------------------------------------------------
  
  void outline() {
    
    colorMode(HSB, 360);
   
    /*
    switch (colormode) {
      case 1: stroke(0, 0, 360, 120); break;
      case 2: stroke(0, 0, 360, 120); break;
      case 3: stroke(convertHSB(count, img.length), 360, 360); break;
    }
    */
    
    beginShape(LINE_STRIP);

    // left
    for(int j=imgmargin; j<=imgheight-imgmargin-1; j+=res) {
      int i = 0;
      vertex(p[i][j].x, p[i][j].y, p[i][j].t);
    }
    
    // bottom
    for(int i=0; i<imgwidth; i+=res) {
      int j = imgheight - imgmargin - 1;
      vertex(p[i][j].x, p[i][j].y, p[i][j].t);
    }
    
    // right
    for(int j=imgheight-imgmargin-1; j>=imgmargin; j-=res) {
      int i = imgwidth - 1;
      vertex(p[i][j].x, p[i][j].y, p[i][j].t);
    }
    
    // top
    for(int i=0; i<imgwidth; i+=res) {
      int j = imgmargin;
      int ii = imgwidth - i - 1;
      vertex(p[ii][j].x, p[ii][j].y, p[ii][j].t);
    }
    
    vertex(p[0][imgmargin].x, p[0][imgmargin].y, p[0][imgmargin].t);
    
    endShape();
    
  }
  
  
  // update points -------------------------------------------------------------
  
  void update() {
  
    for(int i=0; i<imgwidth; i++) {
      for(int j=imgmargin; j<imgheight-imgmargin; j++) {
        p[i][j].update(count);
      }
    }
    
  }
  
  
  
  // reference points ----------------------------------------------------------

  class particle {

    int x, y;
    float t, tn;

    particle(int _x, int _y) {
      x = _x;
      y = _y;
    }

    void update(int _count) {
      tn = img[_count].imgColors[y][x] * d;
      if (abs(t-tn) > 0.01) { t -= (t-tn)/2.0; };
    }

    void render(int _count) {
      colorMode(RGB, 255);
      stroke(255);
      point(x, y, t);
    }
  
  }
  
  

}

