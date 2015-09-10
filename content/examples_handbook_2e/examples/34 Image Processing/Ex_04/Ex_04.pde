PImage trees, crop;

void setup() {
  size(100, 100);
  trees = loadImage("topanga.jpg");
}

void draw() {
  image(trees, 0, 0); 
  crop = get();  // Get the entire window
  image(crop, 0, 50);   // Draw the image in a new position 
}
