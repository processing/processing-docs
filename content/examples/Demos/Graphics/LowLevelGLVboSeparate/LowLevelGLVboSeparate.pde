// Draws a triangle using low-level OpenGL calls.

import java.nio.*;

PShader sh;

float[] vertices;
float[] colors;

FloatBuffer vertexBuffer;
FloatBuffer colorBuffer;

int vertexVboId;
int colorVboId;

final static int VERT_CMP_COUNT = 4; // vertex component count (x, y, z, w) -> 4
final static int CLR_CMP_COUNT = 4;  // color component count (r, g, b, a) -> 4

public void setup() {
  size(640, 360, P3D);

  // Loads a shader to render geometry w/out
  // textures and lights.
  sh = loadShader("frag.glsl", "vert.glsl");

  vertices = new float[12];
  colors = new float[12];

  vertexBuffer = allocateDirectFloatBuffer(12);
  colorBuffer = allocateDirectFloatBuffer(12);

  PGL pgl = beginPGL();

  // allocate buffer big enough to get all VBO ids back
  IntBuffer intBuffer = IntBuffer.allocate(2);
  pgl.genBuffers(2, intBuffer);

  vertexVboId = intBuffer.get(0);
  colorVboId = intBuffer.get(1);

  endPGL();
}

public void draw() {

  PGL pgl = beginPGL();

  background(0);

  // The geometric transformations will be automatically passed
  // to the shader.
  rotate(frameCount * 0.01f, width, height, 0);

  updateGeometry();
  sh.bind();

  // get "vertex" attribute location in the shader
  final int vertLoc = pgl.getAttribLocation(sh.glProgram, "vertex");
  // enable array for "vertex" attribute
  pgl.enableVertexAttribArray(vertLoc);

  // get "color" attribute location in the shader
  final int colorLoc = pgl.getAttribLocation(sh.glProgram, "color");
  // enable array for "color" attribute
  pgl.enableVertexAttribArray(colorLoc);

  /*
    BUFFER LAYOUT from updateGeometry()

    Vertex buffer:

      xyzwxyzwxyzw...

      |v1  |v2  |v3  |...
      |0   |4   |8   |...
      |xyzw|xyzw|xyzw|...


    Color buffer:

      rgbargbargba...

      |v1  |v2  |v3  |...
      |0   |4   |8   |...
      |rgba|rgba|rgba|...

    stride (values per vertex) is 4 floats in both cases
    vertex offset is 0 floats in both cases
   */
  final int vertexStride = VERT_CMP_COUNT * Float.BYTES;
  final int colorStride  =  CLR_CMP_COUNT * Float.BYTES;
  final int vertexOffset =              0 * Float.BYTES;
  final int colorOffset  =              0 * Float.BYTES;


  { // VERTEX
    // bind VBO
    pgl.bindBuffer(PGL.ARRAY_BUFFER, vertexVboId);
    // fill VBO with data
    pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * vertices.length, vertexBuffer, PGL.DYNAMIC_DRAW);
    // associate currently bound VBO with shader attribute
    pgl.vertexAttribPointer(vertLoc, VERT_CMP_COUNT, PGL.FLOAT, false, vertexStride, vertexOffset);
  }

  { // COLOR
    // bind VBO
    pgl.bindBuffer(PGL.ARRAY_BUFFER, colorVboId);
    // fill bound VBO with data
    pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * colors.length, colorBuffer, PGL.DYNAMIC_DRAW);
    // associate currently bound VBO with shader attribute
    pgl.vertexAttribPointer(colorLoc, CLR_CMP_COUNT, PGL.FLOAT, false, colorStride, colorOffset);
  }

  // unbind VBOs
  pgl.bindBuffer(PGL.ARRAY_BUFFER, 0);


  pgl.drawArrays(PGL.TRIANGLES, 0, 3);


  // disable arrays for attributes before unbinding the shader
  pgl.disableVertexAttribArray(vertLoc);
  pgl.disableVertexAttribArray(colorLoc);

  sh.unbind();

  endPGL();
}

// Triggers a crash when closing the output window using the close button
//public void dispose() {
//  PGL pgl = beginPGL();

//  IntBuffer intBuffer = IntBuffer.allocate(2);
//  intBuffer.put(vertexVboId);
//  intBuffer.put(colorVboId);
//  intBuffer.rewind();
//  pgl.deleteBuffers(2, intBuffer);

//  endPGL();
//}

void updateGeometry() {
  // Vertex 1
  vertices[0] = 0;
  vertices[1] = 0;
  vertices[2] = 0;
  vertices[3] = 1;

  colors[0] = 1;
  colors[1] = 0;
  colors[2] = 0;
  colors[3] = 1;

  // Vertex 2
  vertices[4] = width/2;
  vertices[5] = height;
  vertices[6] = 0;
  vertices[7] = 1;

  colors[4] = 0;
  colors[5] = 1;
  colors[6] = 0;
  colors[7] = 1;

  // Vertex 3
  vertices[8] = width;
  vertices[9] = 0;
  vertices[10] = 0;
  vertices[11] = 1;

  colors[8] = 0;
  colors[9] = 0;
  colors[10] = 1;
  colors[11] = 1;

  vertexBuffer.rewind();
  vertexBuffer.put(vertices);
  vertexBuffer.rewind();

  colorBuffer.rewind();
  colorBuffer.put(colors);
  colorBuffer.rewind();
}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}