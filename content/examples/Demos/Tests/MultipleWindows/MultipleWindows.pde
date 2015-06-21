// Based on code by GeneKao (https://github.com/GeneKao)

ChildApplet child;
boolean mousePressedOnParent = false;
Arcball arcball, arcball2;  

void settings() {
  size(320, 240, P3D);
  smooth();
}

void setup() {
  surface.setTitle("Main sketch");
  arcball = new Arcball(this, 300);
  child = new ChildApplet();
}

void draw() {
  background(250);
  arcball.run();
  if (mousePressed) {
    fill(0);
    text("Mouse pressed on parent.", 10, 10);
    fill(0, 240, 0);
    ellipse(mouseX, mouseY, 60, 60);
    mousePressedOnParent = true;
  } else {
    fill(20);
    ellipse(width/2, height/2, 60, 60);
    mousePressedOnParent = false;
  }
  box(100);
  if (child.mousePressed) {
    text("Mouse pressed on child.", 10, 30);
  }
}

void mousePressed() {
  arcball.mousePressed();
}

void mouseDragged() {
  arcball.mouseDragged();
}

class ChildApplet extends PApplet {
  //JFrame frame;

  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(400, 400, P3D);
    smooth();
  }
  public void setup() { 
    surface.setTitle("Child sketch");
    arcball2 = new Arcball(this, 300);
  }

  public void draw() {
    background(0);
    arcball2.run();
    if (mousePressed) {
      fill(240, 0, 0);
      ellipse(mouseX, mouseY, 20, 20);
      fill(255);
      text("Mouse pressed on child.", 10, 30);
    } else {
      fill(255);
      ellipse(width/2, height/2, 20, 20);
    }

    box(100, 200, 100);
    if (mousePressedOnParent) {
      fill(255);
      text("Mouse pressed on parent", 20, 20);
    }
  }

  public void mousePressed() {
    arcball2.mousePressed();
  }

  public void mouseDragged() {
    arcball2.mouseDragged();
  }
}