// Use of custom vertex attributes.
// Inspired by 
// http://pyopengl.sourceforge.net/context/tutorials/shader_4.html

PShader sh;

void setup() {
  size(640, 360, P3D);
  sh = loadShader("frag.glsl", "vert.glsl");
  shader(sh);
  noStroke();
}

void draw() {
  background(255);
  
  sh.set("tween", map(mouseX, 0, width, 0, 1));
  
  translate(width/2, height/2, 0);
  rotateX(frameCount * 0.01);
  rotateY(frameCount * 0.01);
  
  fill(150);
  beginShape(QUADS);
  float d = 10;
  for (int x = -500; x < 500; x += d) {
    for (int y = -500; y < 500; y += d) {
      fill(255 * noise(x, y));
      attribPosition("tweened", x, y, 100 * noise(x, y));
      vertex(x, y, 0);
     
      fill(255 * noise(x + d, y));
      attribPosition("tweened", x + d, y, 100 * noise(x + d, y));
      vertex(x + d, y, 0);
      
      fill(255 * noise(x + d, y + d));
      attribPosition("tweened", x + d, y + d, 100 * noise(x + d, y + d)); 
      vertex(x + d, y + d, 0);
      
      fill(255 * noise(x, y + d));
      attribPosition("tweened", x, y + d, 100 * noise(x, y + d));
      vertex(x, y + d, 0);    
    }
  }
  endShape();
}