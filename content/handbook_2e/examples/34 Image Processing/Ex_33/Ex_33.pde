PImage arch = loadImage("arch.jpg");
size(arch.width, arch.height);
int count = width * height;
arch.loadPixels();
loadPixels();
for (int i = 0; i < count; i++) {
  pixels[i] = arch.pixels[count - i - 1];
}
updatePixels();
