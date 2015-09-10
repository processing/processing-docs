PImage arch;

void setup() {
  size(100, 100);
  arch = loadImage("arch.jpg");
}

void draw() {
  image(arch, 0, 0);
  loadPixels();
  for (int i = 0; i < width*height; i++) {
    color p = pixels[i];  // Read color from screen
    float r = red(p);       
    float g = green(p);     
    float b = blue(p);      
    float bw = (r + g + b) / 3.0;
    bw = constrain(bw + mouseX, 0, 255);
    pixels[i] = color(bw);  // Assign modified value
  }
  updatePixels();
  line(mouseX, 0, mouseX, height);
}
