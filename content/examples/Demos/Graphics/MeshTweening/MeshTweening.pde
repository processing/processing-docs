// Use of custom vertex attributes.
// Inspired by 
// http://pyopengl.sourceforge.net/context/tutorials/shader_4.html

PShader sh;
PShape grid;

void setup() {
  size(640, 360, P3D);
  sh = loadShader("frag.glsl", "vert.glsl");
  shader(sh);
  
  grid = createShape();
  grid.beginShape(QUADS);
  grid.noStroke();  
  grid.fill(150);  
  float d = 10;
  for (int x = -500; x < 500; x += d) {
    for (int y = -500; y < 500; y += d) {
      grid.fill(255 * noise(x, y));
      grid.attribPosition("tweened", x, y, 100 * noise(x, y));
      grid.vertex(x, y, 0);
     
      grid.fill(255 * noise(x + d, y));
      grid.attribPosition("tweened", x + d, y, 100 * noise(x + d, y));
      grid.vertex(x + d, y, 0);
      
      grid.fill(255 * noise(x + d, y + d));
      grid.attribPosition("tweened", x + d, y + d, 100 * noise(x + d, y + d)); 
      grid.vertex(x + d, y + d, 0);
      
      grid.fill(255 * noise(x, y + d));
      grid.attribPosition("tweened", x, y + d, 100 * noise(x, y + d));
      grid.vertex(x, y + d, 0);    
    }
  }
  grid.endShape();  
}

void draw() {
  background(255);
  
  sh.set("tween", map(mouseX, 0, width, 0, 1));
  
  translate(width/2, height/2, 0);
  rotateX(frameCount * 0.01);
  rotateY(frameCount * 0.01);
  
  shape(grid);
}