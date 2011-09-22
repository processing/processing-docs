float a;
int increment = 20;
BFont Futura;
String[] lines;

void setup(){
  size(330,500);
  background(0);
  framerate(30);
  hint(0);
  Futura = loadFont("Futura-Light.vlw.gz");
  textFont(Futura, 20);
  lines = loadStrings("processing.txt");
  a = height - increment;
}

void loop()
{
  background(0);
  a = a - 1; 
  if (a < -2100) { 
    a = height; 
  } 
  for(int i=0; i<lines.length; i++) {
    text(lines[i], 15, a + (i*increment));
  }
}

