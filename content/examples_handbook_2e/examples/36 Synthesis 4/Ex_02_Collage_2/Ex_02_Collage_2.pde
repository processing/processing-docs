Element[] elements = new Element[29];

void setup() {
  size(1200, 600);
  for (int i = 0; i < elements.length; i++) {
    String imageName = "nyt_" + nf(i+1, 2) + ".jpg";
    elements[i] = new Element(imageName);
  }
  noLoop();
}

void draw() {
  background(0);
  for (int i = 0; i < elements.length; i++) {
    elements[i].display();
  }
}

void mousePressed() {
  redraw(); 
}

