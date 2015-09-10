void setup() {
  size(100, 100, P3D); 
  noStroke();
}

void draw() {
  background(0);
  fill(0, 51, 102); 
  ambientLight(102, 102, 102);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);
  translate(width/2, height/2, 0);
  float s = map(mouseX, 0, width, 1, 10);
  shininess(s);
  sphere(33);
}
