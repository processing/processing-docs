// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// future versions

Pictures[] mvt;
int numMvt = 25;

BImage foto;
BImage foto2;
BImage foto3;
BImage foto4;
BImage foto5;
BImage foto6;
BImage foto7;
BImage foto8;
BImage foto9;

void setup() 
{
  size(640,384);
  background(255);
  framerate(30);
  noStroke();

  foto  = loadImage("k_01.gif");
  foto2 = loadImage("k_02.gif");
  foto3 = loadImage("k_03.gif");
  foto4 = loadImage("k_04.gif");
  foto5 = loadImage("k_05.gif");
  foto6 = loadImage("k_06.gif");
  foto7 = loadImage("k_07.gif");
  foto8 = loadImage("k_08.gif");
  foto9 = loadImage("k_09.gif");

  mvt = new Pictures[numMvt];
  for (int i =0; i<numMvt; i++) {
    float dia =20; 
    float bs = random (2.0, 5.0); 
    mvt[i] = new Pictures(0.0, dia, bs);
  }
  
  image(foto,0,0);
  image(foto2,214,0);
  image(foto3,427,0);
  image(foto4,0,128);
  image(foto5,214,128);
  image(foto6,427,128);
  image(foto7,0,256);
  image(foto8,214,256);
  image(foto9, 427,256);
}

void loop() {
  for (int i=0; i<numMvt; i++) {
    mvt[i].update();
    mvt[i].display();
  }
}

class Pictures
{
  float y;
  float diameter;
  float speed;
 
  Pictures(float ypos, float dia, float sp)
  {
    y = ypos;
    diameter = dia;
    speed = sp;
  }

  void update() 
  {
    y += speed;
    if(y > height/2) {
      y = -diameter;
    }
  }

  void display()
  {
    image(foto, 0, y);
    image(foto2, 214, -y);
    image(foto3, 427, y);
    image(foto4, -y, 128);
    image(foto5, 214+y, 128);
    image(foto6, 427, y+128);
    image(foto7, 0, 256+y);
    image(foto8, 214-y, 257);
    image(foto9, 427, 257-y);
  }

}
