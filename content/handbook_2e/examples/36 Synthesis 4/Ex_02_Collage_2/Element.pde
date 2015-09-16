class Element {
  float x, y, a;
  PImage img;

  Element(String imageName) {
    img = loadImage(imageName);
  }

  void display() {
    x = random(width);
    y = random(height);
    a = random(0, TWO_PI);
    pushMatrix();
    translate(x, y);
    rotate(a);
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
}
