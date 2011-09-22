// ALPHABOT
// by Nikita Pashenkov
//
// Created:                  Nov 2000
// Ported to Proce55ing:     Dec 2002
  

float rotX, rotY;
int POS_NUM = 19;

float preset[][] =
{
  {0, 30, 0, 0, 0, 60, 30, 0, 0, 0, 0, -90, 0, 0, 0, 0, 0, 0, 0},                    // a
  {0, 0, 0, 0, 0, -10, -20, -90, -100, -110, 80, 100, 110, 0, 0, 0, 0, 0, 0},        // b  
  {10, 20, 90, 0, 0, 0, -20, 0, 0, 0, 90, 0, 0, 0, 0, 0, 0, 0, 0},                   // c
  {0, 0, 80, 120, 0, 0, 0, 0, 0, 0, 80, 120, 0, 0, 0, 0, 0, 0, 0},                   // d 
  {0, 0, 0, 270, 0, 0, 0, -90, 0, 0, 90, 0, 0, 0, 0, 0, 0, 0, 0},                    // e
  {0, 0, 0, 270, 0, 0, 0, -90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},                     // f
  {10, 20, 90, 0, 0, 0, -20, 0, 0, 0, 90, 100, 0, 0, 0, 0, 0, 0, 0},                 // g
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -90, 0, 0, -90, 0, 0, 150, 0},                   // h
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0},                        // i
  {-20, -25, 0, 0, 0, 0, 20, 0, 0, 0, -90, -120, 0, 0, 0, 0, 110, 0, 0},             // j
  {0, 0, 0, -60, -150, -10, -90, 0, 0, 0, 0, 0, 0, -130, 0, 0, 0, 0, 0},             // k
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 90, 0, 0, 0, 0, 0, 0, 0, 0},                        // l
  {0, 0, 40, 160, 0, 0, 0, 40, 160, 0, 0, 0, 0, 0, 0, 0, -50, 200, 0},               // m
  {0, 0, 30, 180, 180, 0, 0, 0, 180, 180, 0, 0, 0, -30, 180, 180, 0, 160, 0},        // n
  {0, 0, 90, 0, 0, 0, 0, 90, 0, 0, 90, 0, 0, -90, 0, 0, 0, 150, 0},                  // o
  {0, 0, 90, 90, 110, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},                     // p  
  {0, 0, 90, 0, 0, 0, 0, 90, 0, 0, 90, -165, 0, -90, 0, 0, 0, 150, 0},               // q
  {0, 0, 90, 90, 125, -10, -90, 0, 0, 0, 0, 0, 0, -130, 0, 0, 0, 0, 0},              // r
  {0, -90, 0, 0, 0, 90, 90, 0, 0, 0, -90, 0, 0, 0, 0, 0, 125, 0, 0},                 // s
  {0, 0, 90, 0, 0, 0, 0, 90, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0},                      // t
  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 90, 0, 0, -90, 0, 0, 0, 150, 0},                    // u
  {20, 20, 0, 0, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 140, 0},                   // v
  {20, 20, 0, 0, 0, 0, 15, 0, 0, 0, 50, 140, 0, -50, 140, 0, 0, 210, 0},             // w
  {-30, 0, 0, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -135, 30},                  // x
  {0, 30, 0, 0, 0, 0, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75, 0, 0},                     // y
  {-20, 0, 0, 0, 0, 0, 0, 70, 0, 0, 70, 0, 0, 0, 0, 0, 0, 0, 0}                      // z
};
// preset[*][0]        // angle: part 1 bottom
// preset[*][1]        // angle: part 1 middle 
// preset[*][2]        // angle: part 1 top 1st degree
// preset[*][3]        // angle: part 1 top 2nd degree
// preset[*][4]        // angle: part 1 top 3rd degree
// preset[*][5]        // angle: part 2 top
// preset[*][6]        // angle: part 2 middle
// preset[*][7]        // angle: part 2 top 1st degree
// preset[*][8]        // angle: part 2 top 2nd degree
// preset[*][9]        // angle: part 2 top 3rd degree
// preset[*][10]       // angle: part 1 bottom 1st degree
// preset[*][11]       // angle: part 1 bottom 2nd degree
// preset[*][12]       // angle: part 1 bottom 3rd degree
// preset[*][13]       // angle: part 2 bottom 1st degree
// preset[*][14]       // angle: part 2 bottom 2nd degree
// preset[*][15]       // angle: part 2 bottom 3rd degree
// preset[*][16]       // distance: part 1 starting distance
// preset[*][17]       // distance: part 2 starting distance
// preset[*][18]       // distance: part 2 'x' special case


float pos_preset[];
float pos_current[];


void setup()
{
  size(400, 400);
  background(255);

  rotX = 0;
  rotY = 0;

  lights();
  //noStroke();

  pos_preset = new float[POS_NUM];
  pos_current = new float[POS_NUM];
  
  for(int i=0; i<POS_NUM; i++)
    pos_preset[i] = preset[0][i]; 
}


void mouseDragged()
{
  rotX += mouseX - pmouseX;
  rotY += mouseY - pmouseY;
}


void keyPressed() 
{
  if(key >= 'A' && key <= 'z') 
  {
    key -= (key > 'Z') ? 'a' : 'A';
    for(int i=0; i<POS_NUM; i++)
      pos_preset[i] = preset[key][i]; 
  }
}


void loop()
{
  translate(200, 200, 75);
  scale(.65);

  rotateZ(-PI/2);                                          
  rotateX(0.9*PI);  
  rotateX(-rotX*0.005);
  translate(0, 0, -75);

  fill(102, 153, 102);
  draw_bot();
  fold_bot();
  //delay(10);
}


void draw_bot()
{
  boolean flip = true;

  translate(-150, 50-pos_current[16], 0);               // initial parts translate
  rotateZ(pos_current[0]*PI/180);                       // initial parts angle
  draw_part(160, 40, 70, !flip);

  push();
    translate(10, 0, 10);  
    rotateZ(-pos_current[10]*PI/180);                   // part 1 bottom 1st degree
    draw_part(140, 35, 50, flip);

    translate(110, 12, 10);
    rotateZ(PI-pos_current[11]*PI/180);                 // part 1 bottom 2nd degree
    draw_part(122.5, 30.625, 30, flip);

    translate(95, 5, 10);
    rotateZ(PI-pos_current[12]*PI/180);                 // part 1 bottom 3rd degree
    draw_part(107, 26.8, 10, flip);
  pop();

  translate(150, 0, 0);
  rotateZ(-pos_current[1]*PI/180);                      // part 1 bend
  translate(150, 0, 70);
  rotateY(180*PI/180);
  draw_part(160, 40, 70, !flip);

  push();                                               // part 1
    translate(10, 0, 10);
    rotateZ(-pos_current[2]*PI/180);                    // part 1 top 1st degree
    draw_part(140, 35, 50, flip);

    translate(110, 12, 10);
    rotateZ(PI-pos_current[3]*PI/180);                  // part 1 top 2nd degree
    draw_part(122.5, 30.625, 30, flip);

    translate(94, 5, 10);
    rotateZ(PI-pos_current[4]*PI/180);                  // part 1 top 3rd degree
    draw_part(107, 26.8, 10, flip);
  pop();
  
  rotateX(180*PI/180);                                  // flip part
  rotateZ(pos_current[18]*PI/180);                      // part 2 starting distance
  translate(0, pos_current[17], 0);                     // 'x' special case
  rotateZ(pos_current[5]*PI/180);                       // angle between parts
  draw_part(160, 40, 70, !flip);

  push();                                               // part 2
    translate(10, 0, 10);
    rotateZ(-pos_current[7]*PI/180);                    // part 2 top 1st degree
    draw_part(140, 35, 50, flip);

    translate(110, 12, 10);
    rotateZ(PI-pos_current[8]*PI/180);                  // part 2 top 2nd degree
    draw_part(122.5, 30.625, 30, flip);

    translate(96, 5, 10);
    rotateZ(PI-pos_current[9]*PI/180);                  // part 2 top 3rd degree
    draw_part(107, 26.8, 10, flip);
  pop();

  translate(150, 0, 0);
  rotateZ(-pos_current[6]*PI/180);                      // part 2 bend
  translate(150, 0, 70);
  rotateY(PI);
  draw_part(160, 40, 70, !flip);

  push();            
    translate(10, 0, 10);
    rotateZ(pos_current[13]*PI/180);                    // part 2 bottom 1st degree
    draw_part(140, 35, 50, flip);

    translate(110, 12, 10);
    rotate(PI-pos_current[14]*PI/180);                  // part 2 bottom 2nd degree
    draw_part(122.5, 30.625, 30, flip);

    translate(94, 5, 10);
    rotate(PI-pos_current[15]*PI/180);                  // part 2 bottom 3rd degree
    draw_part(107, 26.8, 10, flip);
  pop();
}


void draw_part(float x, float y, float z, boolean flip)
{
  push();
    translate(-10, -20, 0);
    draw_part_h(0, x, 0, y, 0, 10);

    if(z > 10)                                          // if larger than smallest part 
    {
      if(flip)
        draw_part_v2(0, x, 0, y, 0, z);
      else
        draw_part_v1(0, x, 0, y, 0, z);
      draw_part_h(0, x, 0, y, z-10, z);
    }
  pop();
 }


void draw_part_v1(float x0, float x1, float y0, float y1, float z0, float z1)
{
  float dx = x1 - x0;
  float dy = y1 - y0;

  beginShape(QUADS);
    vertex(dx*0.375,  dy*1.5,      z0+10);
    vertex(dx*0.75,   dy*1.5,      z0+10);
    vertex(dx*0.75,   dy*1.5,      z1-10);
    vertex(dx*0.375,  dy*1.5,      z1-10);
    
    vertex(dx*0.75,   dy*1.5,      z0+10);
    vertex(dx*0.75,   dy*1.5-10,   z0+10);
    vertex(dx*0.75,   dy*1.5-10,   z1-10);
    vertex(dx*0.75,   dy*1.5,      z1-10);
    
    vertex(dx*0.75,   dy*1.5-10,   z0+10);
    vertex(dx*0.375,  dy*1.5-10,   z0+10);
    vertex(dx*0.375,  dy*1.5-10,   z1-10);
    vertex(dx*0.75,   dy*1.5-10,   z1-10);
    
    vertex(dx*0.25,   dy*1.33,     z0+10);
    vertex(dx*0.375,  dy*1.5,      z0+10);
    vertex(dx*0.375,  dy*1.5,      z1-10);
    vertex(dx*0.25,   dy*1.33,     z1-10);
    
    vertex(dx*0.25,   dy*1.33,     z0+10);
    vertex(dx*0.25,   dy*1.33-10,  z0+10);
    vertex(dx*0.25,   dy*1.33-10,  z1-10);
    vertex(dx*0.25,   dy*1.33,     z1-10);
    
    vertex(dx*0.25,   dy*1.33-10,  z0+10);
    vertex(dx*0.375,  dy*1.5-10,   z0+10);
    vertex(dx*0.375,  dy*1.5-10,   z1-10);
    vertex(dx*0.25,   dy*1.33-10,  z1-10);
  endShape();  
}


void draw_part_v2(float x0, float x1, float y0, float y1, float z0, float z1)
{
  float dx = x1 - x0;
  float dy = y1 - y0;
  
  beginShape(QUADS);
    vertex(dx*2/8,     y0,         z0+10);
    vertex(dx*5/8,     y0,         z0+10);
    vertex(dx*5/8,     y0,         z1-10);
    vertex(dx*2/8,     y0,         z1-10);
    
    vertex(dx*5/8,     y0,         z0+10);
    vertex(dx*6/8,     dy/6,       z0+10);
    vertex(dx*6/8,     dy/6,       z1-10);
    vertex(dx*5/8,     y0,         z1-10);
    
    vertex(dx*6/8,     dy/6,       z0+10);
    vertex(dx*6/8,     dy/6+10,    z0+10);
    vertex(dx*6/8,     dy/6+10,    z1-10);
    vertex(dx*6/8,     dy/6,       z1-10);
    
    vertex(dx*5/8,     y0+10,      z0+10);
    vertex(dx*6/8,     dy/6+10,    z0+10);
    vertex(dx*6/8,     dy/6+10,    z1-10);
    vertex(dx*5/8,     y0+10,      z1-10);
      
    vertex(dx*2/8,     y0+10,      z0+10);
    vertex(dx*5/8,     y0+10,      z0+10);
    vertex(dx*5/8,     y0+10,      z1-10);
    vertex(dx*2/8,     y0+10,      z1-10);
    
    vertex(dx*2/8,     y0,         z0+10);
    vertex(dx*2/8,     y0+10,      z0+10);
    vertex(dx*2/8,     y0+10,      z1-10);
    vertex(dx*2/8,     y0,         z1-10);
  endShape();  
}


void draw_part_h(float x0, float x1, float y0, float y1, float z0, float z1)
{
  float dx = x1 - x0;
  float dy = y1 - y0;
  
  beginShape(POLYGON);
    vertex(x0,         y0,         z0);
    vertex(dx*0.625,   y0,         z0);
    vertex(x1,         dy*0.5,     z0);
    vertex(x1,         dy*1.5,     z0);
    vertex(dx*0.375,   dy*1.5,     z0);
    vertex(x0,         y1,         z0);
  endShape();
    
  beginShape(POLYGON);
    vertex(x0,         y0,         z1);
    vertex(dx*0.625,   y0,         z1);
    vertex(x1,         dy*0.5,     z1);
    vertex(x1,         dy*1.5,     z1);
    vertex(dx*0.375,   dy*1.5,     z1);
    vertex(x0,         y1,         z1);
  endShape();
    
  beginShape(QUADS);
    vertex(x0,        y0,          z0);
    vertex(x0,         dy,         z0);
    vertex(x0,         dy,         z1);
    vertex(x0,         y0,         z1);
      
    vertex(x0,         dy,         z0);
    vertex(dx*0.375,   dy*1.5,     z0);
    vertex(dx*0.375,   dy*1.5,     z1);
    vertex(x0,         dy,         z1);
      
    vertex(dx*0.375,   dy*1.5,     z0);
    vertex(dx,         dy*1.5,     z0);
    vertex(dx,         dy*1.5,     z1);
    vertex(dx*0.375,   dy*1.5,     z1);
      
    vertex(dx,         dy*1.5,     z0);
    vertex(dx,         dy*0.5,     z0);
    vertex(dx,         dy*0.5,     z1);
    vertex(dx,         dy*1.5,     z1);
      
    vertex(dx,         dy*0.5,     z0);
    vertex(dx*5/8,     y0,         z0);
    vertex(dx*5/8,     y0,         z1);
    vertex(dx,         dy*0.5,     z1);
      
    vertex(dx*5/8,     y0,         z0);
    vertex(x0,         y0,         z0);
    vertex(x0,         y0,         z1);
    vertex(dx*5/8,     y0,         z1);
  endShape();  
}


void fold_bot()
{
  for(int i=0; i<POS_NUM; i++)
  {
    if(pos_current[i] < pos_preset[i])      
      pos_current[i]++;
    else if(pos_current[i] > pos_preset[i])  
      pos_current[i]--;
  }
}
