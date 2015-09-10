Ring[] rings;                  // Declare the array
int numRings = 50;
int currentRing = 0;

void setup() {
  size(100, 100);
  rings = new Ring[numRings];  // Create the array
  for (int i = 0; i < numRings; i++) {
    rings[i] = new Ring();     // Create each object
  }
}

void draw() {
  background(0);
  for (int i = 0; i < numRings; i++) {
    rings[i].grow();
    rings[i].display();
  }
}

// Click to create a new Ring
void mousePressed() {
  rings[currentRing].start(mouseX, mouseY);
  currentRing++;
  if (currentRing >= numRings) {
    currentRing = 0;
  }
}
