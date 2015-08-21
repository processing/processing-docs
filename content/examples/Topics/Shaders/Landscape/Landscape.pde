/**
 * Elevated
 * https://www.shadertoy.com/view/MdX3Rr by inigo quilez
 * Created by inigo quilez - iq/2013
 * License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
 * Processing port by Raphaël de Courville.
 */
 
PShader landscape;

void setup() {
  size(640, 360, P2D);
  noStroke();
   
  // This GLSL code shows how to use shaders from 
  // shadertoy in Processing with minimal changes.
  landscape = loadShader("landscape.glsl");
  landscape.set("resolution", float(width), float(height));   
}

void draw() {
  background(0);
    
  landscape.set("time", millis() / 1000.0);
  shader(landscape); 
  rect(0, 0, width, height);

  if (frameCount % 10 == 0) {  // every 10th frame
    println("frame: " + frameCount + " - fps: " + frameRate);
  }
}
