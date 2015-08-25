/**
 * Wave Gradient 
 * by Ira Greenberg.  
 * 
 * Generate a gradient along a sin() wave.
 */

float amplitude = 30;
float fillGap = 2.5;

void setup() {
  size(640, 360);
  background(200);
  
  // To efficiently set all the pixels on screen, make the set() 
  // calls on a PImage, then write the result to the screen.
  PImage gradient = createImage(width, height, RGB);
  float frequency = 0;
  
  for (int i =- 75; i < height+75; i++){
    // Reset angle to 0, so waves stack properly
    float angle = 0;
    // Increasing frequency causes more gaps
    frequency += 0.002;
    for (float j = 0; j < width+75; j++){
      float py = i + sin(radians(angle)) * amplitude;
      angle += frequency;
      color c = color(abs(py-i)*255/amplitude, 255-abs(py-i)*255/amplitude, j*(255.0/(width+50)));
      // Hack to fill gaps. Raise value of fillGap if you increase frequency
      for (int filler = 0; filler < fillGap; filler++){
        gradient.set(int(j-filler), int(py)-filler, c);
        gradient.set(int(j), int(py), c);
        gradient.set(int(j+filler), int(py)+filler, c);
      }
    }
  }
  // Draw the image to the screen
  set(0, 0, gradient);
  // Another alternative for drawing to the screen
  //image(gradient, 0, 0);
}
