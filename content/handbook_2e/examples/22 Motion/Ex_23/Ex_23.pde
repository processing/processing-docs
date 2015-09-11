PFont font; 
String s = "AREA";
float angle = 0.0;
  
void setup() {
  size(100, 100);
  font = createFont("SourceCodePro-Light.otf", 48);
  textFont(font);
  fill(0);
}

void draw() {
  background(204);
  angle += 0.05;
  for (int i = 0; i < s.length(); i++) {
    float c = sin(angle + i/PI);
    textSize((c + 1.0) * 15 + 10);
    text(s.charAt(i), i*20, 60);
  }
}
