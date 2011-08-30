float theta = 0.0;

void setup() {
  size(100,100,P3D);
}

void draw() {
  background(127);
  stroke(255);
  fill(51);

  translate(width/2,height/2);
  rotate(theta);
  rect(-25,-25,50,50);

  theta += 0.02;
}

