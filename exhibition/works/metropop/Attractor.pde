
// this is basically just a random point

class Attractor {
  float x,y;
  Attractor(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Attractor() {
    x = random(width);
    y = random(height);
  }
}
