// This project was built with MultiProcessing and
// will not execute with the standard Processing software.
// MultiProcessing was developed by Simon Greenwold for the 
// course 872a Model Based Design at the Yale School of 
// Architecture in Winter 2003


//  Julia Stanat
//  872a _ Model Based Design - Yale School of Architecture
//  FINAL PROJECT  - December 19 2003
//  Professor  = Simon Greenwold


color spawnedBeeFill;
color spawnedBeeStroke;

HoneyBee drone = new HoneyBee();
class HoneyBee extends Particle {
public HoneyBee() {}

  color beeFill;
  color beeStroke;
  float radius = 12;

  void setup() {
    ellipseMode(CENTER_DIAMETER);
  }

  void firstLoop() {
    addMagnet(this, 0.4);
    enableCollision(radius + 2);
  }

  void loop() {
    push();
    //translate(pos[0], pos[1], pos[2]);
    //noStroke();
    stroke(beeStroke);
    fill(beeFill);
    //noFill();
    ellipse(pos[0], pos[1],radius*2,radius*2);
    pop();
  }
}

void setup(){
  size(1024,512);
  rectMode(CENTER_DIAMETER);
}

void firstLoop() {
  background(0);
  noCursor();
  gravity(0);

  spawnedBeeFill = color(0, 0, 0, 2);
  spawnedBeeStroke = color(255, 0, 0, 15);
  for (int i = 0; i < 100; i++) {

    HoneyBee bee2 = (HoneyBee)spawnParticle(drone);
    bee2.beeStroke = spawnedBeeStroke;
    bee2.beeFill = spawnedBeeFill;
    bee2.pos[0] = random(width/3.0);
    bee2.pos[1] = random(height);
    bee2.pos[2] = random(0);
  }
  
  spawnedBeeStroke = color(0, 255, 0, 5);
  for (int i = 0; i < 100; i++) {
    HoneyBee bee2 = (HoneyBee)spawnParticle(drone);
    bee2.beeStroke = spawnedBeeStroke;
    bee2.beeFill = spawnedBeeFill;    
    bee2.pos[0] = random(width/3.0) + 2 * (width/3.0);
    bee2.pos[1] = random(height);
    bee2.pos[2] = random(0);
  }
}


void loop(){
  
}


