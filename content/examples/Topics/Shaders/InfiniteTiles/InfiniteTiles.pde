//-------------------------------------------------------------
// Display endless moving background using a tile texture.
// Contributed by martiSteiger
//-------------------------------------------------------------

PImage tileTexture;
PShader tileShader;

void setup() {
  size(640, 480, P2D);
  textureWrap(REPEAT);
  tileTexture = loadImage("penrose.jpg");
  loadTileShader();
}

void loadTileShader() {  
  tileShader = loadShader("scroller.glsl");
  tileShader.set("resolution", float(width), float(height));  
  tileShader.set("tileImage", tileTexture);
}

void draw() {
  tileShader.set("time", millis() / 1000.0);
  shader(tileShader);                    
  rect(0, 0, width, height);
}