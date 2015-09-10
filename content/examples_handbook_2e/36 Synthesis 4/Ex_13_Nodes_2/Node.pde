class Node {
  int x;  // X-coordinate
  int y;  // Y-coordinate
  int radius = 50;  // Radius
  int id;  // The index within the array
  Node[] otherNodes;  // Reference to the array of Nodes

  Node(int tempId, Node[] tempOthers) {
    id = tempId;
    otherNodes = tempOthers;
  }

  // Define the location
  void setPosition() {
    x = mouseX;
    y = mouseY;
  }

  // Draw to the display window
  void display() {
    ellipseMode(RADIUS);
    noStroke();
    fill(255, 40);
    ellipse(x, y, radius, radius);
  }
  
  // Draw the lines between overlapping Nodes
  void displayNetwork(int nodeCount) {
    stroke(255);
    for (int i = id+1; i < nodeCount; i++) {
      if (overlap(otherNodes[i])) {
        line(x, y, otherNodes[i].x, otherNodes[i].y);
      }
    }
  }

  // Calculate if this Node is overlapping with another
  boolean overlap(Node n) {
    float distanceFromCenters = dist(x, y, n.x, n.y);
    float diameter = radius + n.radius;
    if (distanceFromCenters < diameter) {
      return true;
    } else {
      return false;
    }
  }
}
