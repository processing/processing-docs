/**
 * Shape Vertices. 
 * 
 * How to iterate over the vertices of a shape.
 * When loading an obj or SVG, getVertexCount() 
 * will typically return 0 since all the vertices 
 * are in the child shapes. 
 *
 * You should iterate through the children and then
 * iterate through their vertices.
 */

// The shape
PShape pentagram;

void setup() {
  size(600, 400);
  // Load teh shape
  pentagram = loadShape("pentagram.svg");
}

void draw() {
  background(0);
  // Iterate over the children
  int children = pentagram.getChildCount();
  for (int i = 0; i < children; i++) {
    PShape child = pentagram.getChild(i);
    int total = child.getVertexCount();
    // The vertices of each child
    for (int j = 0; j < total; j++) {
      PVector v = child.getVertex(j);
      stroke(255);
      strokeWeight(4);
      ellipse(v.x, v.y, 16, 16);
    }
  }
  
  /* 
  // You could also get the "tessllation"
  // which is a single shape of all the vertices
  PShape tes = pentagram.getTessellation();
  int total = tes.getVertexCount();
  for (int j = 0; j < total; j++) {
    PVector v = tes.getVertex(j);
    point(v.x, v.y, v.z);
  }*/
}
