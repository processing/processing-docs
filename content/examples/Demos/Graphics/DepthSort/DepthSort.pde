// Depth sorting example by Jakub Valtar 
// https://github.com/JakubValtar

void setup() {
  size(640, 720, P3D);
  colorMode(HSB, 100, 100, 100, 100);
    
  frameRate(60);
}
 
void draw() {    
    //beginRaw(PDF, "output" + frameCount + ".pdf");
    
  if (!mousePressed) {
    hint(ENABLE_DEPTH_SORT);
  } else {
    hint(DISABLE_DEPTH_SORT);
  }
    
  noStroke();
  
  background(0);
 
  translate(width/2, height/2, -300);
  scale(2);
    
  int rot = frameCount;

  rotateZ(radians(90));
  rotateX(radians(rot/60.0f * 10));
  rotateY(radians(rot/60.0f * 30));
 
  blendMode(ADD);
    
  for (int i = 0; i < 100; i++) {
    fill(map(i % 10, 0, 10, 0, 100), 100, 100, 30);
 
    beginShape(TRIANGLES);
    vertex(200, 50, -50);
    vertex(100, 100, 50);
    vertex(100, 0, 20);
    endShape();
 
    rotateY(radians(270.0f/100));
  }
    
  //endRaw();
  
  if (frameCount % 30 == 0) println(frameRate);
}  