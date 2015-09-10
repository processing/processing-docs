PImage arch;

void setup() {
  size(100, 100);
  arch = loadImage("arch.jpg");
}

void draw() {
  image(arch, 0, 0);
  int x = constrain(mouseX, 0, 99);
  int y = constrain(mouseY, 0, 99);
  arch.loadPixels();
  arch.pixels[y*width + x] = color(0);
  arch.updatePixels();
  image(arch, 50, 0);
}
