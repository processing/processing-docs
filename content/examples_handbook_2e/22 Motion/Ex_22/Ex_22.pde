PFont font;
String[] words = { "Three", "strikes", "and", "youʼre", "out...", " "  };
int whichWord = 0;

void setup() {
  size(100, 100);
  font = createFont("SourceCodePro-Light.otf", 22);
  textFont(font);
  textAlign(CENTER);
  frameRate(4);
  fill(0);
}

void draw() {
  background(204);
  text(words[whichWord], width/2, 55);
  whichWord++;
  if (whichWord == words.length) {
    whichWord = 0;
  }
}
