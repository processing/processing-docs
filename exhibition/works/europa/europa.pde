// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

/* 
	 Title: Europa 
	 	for Lauren Ely
	 	by Glen Murphy  (http://glenmurphy.com/)
	 	
	 Applet appears on: http://bodytag.org/
	 
	 Code is unoptimised, and speed is entirely dependant on
	 processor speed; this applet is not future-proof.
	 
	 Coded in Processing - http://processing.org/
*/

int WIDTH = 300;
int HEIGHT = 400;
int WH = WIDTH*HEIGHT;

BImage bg; //300x400 image
int distMap[] = new int[WH]; // reflection distortion

int blend(int org, int col, int alpha) { 
  // org is original colour 
  // col is colour to add 
  // alpha is a value between 0 and 255,  
  // where 0 makes 'col' completely opaque 
 
  int r1=(org&0x0000ff); 
  int g1=(org&0x00ff00); 
  int b1=(org&0xff0000); 
  int r2=(col&0x0000ff); 
  int g2=(col&0x00ff00); 
  int b2=(col&0xff0000); 
   
  int r3=(((alpha*(r1-r2)) >>8 )+r2)&0x000000ff; 
  int g3=(((alpha*(g1-g2)) >>8 )+g2)&0x0000ff00; 
  int b3=(((alpha*(b1-b2)) >>8 )+b2)&0x00ff0000; 
 
  return (r3)|(g3)|(b3); 
  }

void drawline(int x0, int y0, int x1, int y1, int pix, int buffer[]) {
	if(x0 < 0 || x0 >= WIDTH || y0 < 0 || y0 >= HEIGHT || x1 < 0 || x1 >= WIDTH || y1 < 0 || y1 >= HEIGHT) return;
	
	int alp=24;
	
	int dy = y1 - y0;
	int dx = x1 - x0;
	int stepx, stepy;
	
	if (dy < 0) { dy = -dy;  stepy = -WIDTH; } else { stepy = WIDTH; }
	if (dx < 0) { dx = -dx;  stepx = -1; } else { stepx = 1; }
	dy <<= 1;
	dx <<= 1;
	
	y0 *= WIDTH;
	y1 *= WIDTH;
	
	if (dx > dy) {
		int fraction = dy - (dx >> 1);
		while (x0 != x1) {
			if (fraction >= 0) {
				y0 += stepy;
				fraction -= dx;
				}
			x0 += stepx;
			fraction += dy;
			buffer[x0+y0] = blend(pix, buffer[x0+y0], alp);
			}
		}
	
	else {
		int fraction = dx - (dy >> 1);
		while (y0 != y1) {
			if (fraction >= 0) {
				x0 += stepx;
				fraction -= dy;
				}
			y0 += stepy;
			fraction += dx;
			buffer[x0+y0] = blend(pix, buffer[x0+y0], alp);
			}
		}
	}

class Skater {
	float x, y;
	float dir, xvel, yvel, xacc, yacc;
	int lastx, lasty;
	
	int sprdir = 0;
	int legdown; // 0 - right, 1 - left, 2 - both
	
	// feet position
	int lastleft;
	int left;
	int lastright;
	int right;
	
	int type;
	
	Skater(float xIn, float yIn, float xvelIn, float yvelIn, float dirIn, int typeIn) {
		x = xIn;
		y = yIn;
		
		xvel = xvelIn;
		yvel = yvelIn;
		
		lastx = (int)xIn;
		lasty = (int)yIn;
		
		dir = dirIn;
		type = typeIn;
		legdown = 0;
		}
	}

class Sprite {
	int vol;
	int[] px = new int[300]; // make bigger if you think you'll be needing larger sprites
	
	int width;
	int height;
	
	Sprite(BImage img, int widthIn, int heightIn, int pos) {
		width = widthIn;
		height = heightIn;
		vol = width*height;
		
		int maxpos;
		
		if(img.height <= height*pos) {
			maxpos = img.height/height-1;
			pos = maxpos - pos%maxpos;
			for(int i = 0; i < vol; i++) {
				px[i] = img.pixels[pos*vol+(width-1-i%width)+((int)(i/width)*width)];
				}			
			}
		else {
			for(int i = 0; i < vol; i++) {
				px[i] = img.pixels[i+pos*vol];
				}
			}
		
		}
	
	void show(int x, int y) {
		int pix;
		for(int i = 0; i < vol; i++) {
			if(px[i] != 0xff00ff00) {
				pix = x+(y*WIDTH)+(i%width)+((int)(i/width)*WIDTH);
				if(pix < WH && pix > 0) {pixels[pix] = px[i];}
				}
			}
		}

	void showref(int x, int y) {
		int pix;
		for(int i = 0; i < vol; i++) {
			if(px[i] != 0xff00ff00) {
				pix = x+(y*WIDTH)+(i%width)-((int)(i/width)*WIDTH);
				if(pix < WH && pix > 0) {pixels[distMap[pix]] = blend(px[i],bg.pixels[pix],96);}
				}
			}
		}

	}

class Couple {
	Skater boi;
	Skater girl;

	int attached = 0;
	float attachxvel, attachyvel;
	
	BImage img_girlhead, img_boihead, img_leg_right, img_leg_left, img_leg_both;
	
	Sprite girlhead[] = new Sprite[8];
	Sprite boihead[] = new Sprite[8];
	Sprite leg_right[] = new Sprite[8];
	Sprite leg_left[] = new Sprite[8];
	Sprite leg_both[] = new Sprite[8];
	Sprite body;
	
	/* Feet position offsets, so that ice-trail drawings are accurate */
	int skate_bothdown_right[] = new int[8];
	int skate_bothdown_left[] = new int[8];
	int skate_rightdown[] = new int[8];
	int skate_leftdown[] = new int[8];
	
	Couple() {
		img_girlhead = loadImage("res_girl_head.gif");
		img_boihead = loadImage("res_boi_head.gif");
		img_leg_right = loadImage("res_legdown_right.gif");
		img_leg_left = loadImage("res_legdown_left.gif");
		img_leg_both = loadImage("res_legdown_both.gif");
		
		skate_bothdown_right = new int[]{-3, -2, -1, 3, 3, 2, -2, -4};
		skate_bothdown_left = new int[]{3, 4, 3, -2, -3, -3, 1, 2};
		
		skate_rightdown = new int[]{-3,-2,-1,3, 3, 2, 1,-3};
		skate_leftdown = new int[]{3,4,2,-2,-3,-4,-2,2};
		
		for(int i = 0; i < 8; i++) {
			girlhead[i] = new Sprite(img_girlhead, 11, 11, i);
			boihead[i] = new Sprite(img_boihead, 11, 11, i);
			leg_right[i] = new Sprite(img_leg_right, 15, 5, i);
			leg_left[i] = new Sprite(img_leg_left, 15, 5, i);
			leg_both[i] = new Sprite(img_leg_both, 15, 5, i);
			}
		body = new Sprite(loadImage("res_body.gif"), 9, 6, 0);
		
		boi = new Skater(30, 150, 1, 2, radians(90), 0);
		girl = new Skater(270, 150, -1, 2, radians(300), 1);
		}
	
	void display(Skater obj) {
		/* draw trails */
		if(obj.lastleft > -10 && obj.left > -10)
			drawline(obj.lastx+obj.lastleft, obj.lasty, (int)obj.x+obj.left, (int)obj.y, 0xffffffff, bg.pixels);
		if(obj.lastright > -10 && obj.right > -10)
			drawline(obj.lastx+obj.lastright, obj.lasty, (int)obj.x+obj.right, (int)obj.y, 0xffffffff, bg.pixels);
		
		body.show((int)obj.x-4, (int)obj.y-10);
		body.showref((int)obj.x-4, (int)obj.y+10);
		
		int offset = 0;
		if(obj.sprdir > 4) {offset = -2;}
		
		if(obj.type == 1) {
			girlhead[obj.sprdir].show((int)obj.x-4+offset, (int)obj.y-18);
			girlhead[obj.sprdir].showref((int)obj.x-4+offset, (int)obj.y+19);
			}
		else {
			boihead[obj.sprdir].show((int)obj.x-4+offset, (int)obj.y-18);
			boihead[obj.sprdir].showref((int)obj.x-4+offset, (int)obj.y+19);
			}
			
		if(obj.legdown == 0) {
			leg_right[obj.sprdir].show((int)obj.x-7,(int)obj.y-4);
			leg_right[obj.sprdir].showref((int)obj.x-7,(int)obj.y+5);
			}
		if(obj.legdown == 1) {
			leg_left[obj.sprdir].show((int)obj.x-7,(int)obj.y-4);
			leg_left[obj.sprdir].showref((int)obj.x-7,(int)obj.y+5);
			}
		if(obj.legdown == 2) {
			leg_both[obj.sprdir].show((int)obj.x-7,(int)obj.y-4);
			leg_both[obj.sprdir].showref((int)obj.x-7,(int)obj.y+5);
			}
		
		}
	
	void updatepos(Skater obj, Skater targ) {
		int leftfootpos;
		int rightfootpos;
		float vel;
		float dirtarg;
		
		/* archive trail information */
		obj.lastx = (int)obj.x;
		obj.lasty = (int)obj.y;
		
		obj.lastleft = obj.left;
		obj.lastright = obj.right;

		/* do movement */
		vel = sqrt(obj.xvel*obj.xvel + obj.yvel*obj.yvel);
		if(vel < 0.8) {
			obj.legdown = 2;
			if(vel < 0.6) {
				obj.xacc += random(-0.08,0.08);
				obj.yacc += random(-0.08,0.08);
				}
			}

		if(random(20) < 1 && vel < 2 && attached != 1) {
			obj.xacc += random(-0.1,0.1);
			obj.yacc += random(-0.1,0.1);
			obj.legdown = (int)(random(2));
			if(random(2) < 1) {
				dirtarg = atan2(targ.y-obj.y, targ.x-obj.x);
				obj.xacc += 0.1*cos(dirtarg);
				obj.yacc += 0.1*sin(dirtarg);
				}
			}
		else if(attached == 1 && vel < 2) {
			dirtarg = atan2(targ.y-obj.y, targ.x-obj.x);
			obj.xacc *= 0.5;
			obj.yacc *= 0.5;
			obj.xacc += 0.1*cos(dirtarg);
			obj.yacc += 0.1*sin(dirtarg);
			}			

		if(obj.x < 40 && obj.xvel < 0) {
			obj.xacc += 0.07;
			}
		if(obj.x > WIDTH-40 && obj.xvel > 0) {
			obj.xacc -= 0.07;
			}
		if(obj.y < 140 && obj.yvel < 0) {
			obj.yacc += 0.03;
			}
		else if(obj.y > HEIGHT-40 && obj.yvel > 0) {
			obj.yacc -= 0.07;
			}

		obj.xvel *= 0.98;
		obj.yvel *= 0.98;
		obj.xacc *= 0.9;
		obj.yacc *= 0.9;

		if(attached == 1)
			obj.dir = atan2(targ.y-obj.y, targ.x-obj.x);
		else
			obj.dir = atan2(obj.yvel, obj.xvel); 

		/* update position */
		obj.xvel += obj.xacc;
		obj.yvel += obj.yacc;
		
		obj.x += obj.xvel;
		obj.y += obj.yvel*0.6;

		/* work out sprite direction */
		if(obj.dir < PI*0.5) obj.dir+=TWO_PI;
		obj.sprdir = (int)(((obj.dir+PI*0.125-PI*0.5)/TWO_PI)*8)%8;
		
				
		/* work out foot position */
		if(obj.legdown == 2) {
			obj.left = skate_bothdown_left[obj.sprdir];
			obj.right = skate_bothdown_right[obj.sprdir];
			}
		else if(obj.legdown == 0) {
			obj.right = skate_rightdown[obj.sprdir];
			obj.left = -100;
			}
		else {
			obj.left = skate_leftdown[obj.sprdir];
			obj.right = -100;
			}
		
		}
	
	void update() {
		updatepos(girl, boi);
		updatepos(boi, girl);
		if(attached < 0) attached += 1;

		if(boi.x < girl.x + 8 && boi.x > girl.x - 8 && boi.y < girl.y + 8 && boi.y > girl.y - 12 && attached == 0) {
			attached = 1;
			attachxvel = (boi.xvel + girl.xvel);
			attachyvel = (boi.yvel + girl.yvel);
			boi.xvel = attachxvel;
			girl.xvel = attachxvel;
			
			boi.yvel = attachyvel;
			girl.yvel = attachyvel;
			}
		
		if(girl.y < boi.y) {
			display(girl);
			display(boi);
			}
		else {
			display(boi);
			display(girl);
			}

		if(attached == 1 && random(210) < 1) {
			attached = -50;
			}
		
		}
	
	}


Couple c;
Sprite s;

void setup() {
  size(300,400);
  noBackground();
  bg = loadImage("bg1.jpg");
  
  /* create reflection distortion map */
  int r = 0, dist = 0;
  
  for(int i=0; i<WH; i++) {
    r = (int)random(21);
    if(r < 1 && i > WIDTH) {
      dist = i-WIDTH;
      }
    else if(r < 2 && i < WH-WIDTH) {
      dist = i+WIDTH;
      }
    else {
      dist = i;
      }
    distMap[i] = dist;
    }
  
  /* create skaters */
	c = new Couple();
  }

int milli = 0;
int lastmillis = -2000;
int elapsed = 0;

void loop() {
	/* rather crude hack to limit framerate on faster machines */
	milli = millis();
	elapsed = milli - lastmillis;
	lastmillis = milli;
	if(elapsed < 35) {delay(35-elapsed);}
	
	System.arraycopy(bg.pixels, 0, pixels, 0, WH);
	c.update();
  }