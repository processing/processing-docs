//
//*****************************************************************************************//
// RELATIONS_ENVIROMENT                                                                    //
// by Alessandro Capozzo March-May 2004, www.ghostagency.net - alessandro@ghostagency.net  //
// inspired by Reynolds' boids algorithm                                                   //
// and all the similar beautyful works by proce55ing people.                               //
// built with proce55ing alpha .68                                                         //
// ****************************************************************************************//
//
// A flock of worm-like shapes moves in a 3D space, each shapes position is orthogonally projected
// on the enviroment walls, each creature could be connected with the others by an ephemeral net of relations.
// Are realtions cause or effect?
//
//SETTING
//var countList sets the number of 'worms', var num sets the number of nodes for each worm.
Structure [] list;
int num=3;
int countList=65;
float rotateView=PI*.3;
void setup() {
  size(400,400);
  framerate(30);
  list=new Structure[countList];
  for(int index=0;index<countList;index++){
    int xx=int(random(width)+1);
    int yy=int(random(height)+1);
    int zz=int(random(height)+1);
    list[index]=new Structure(index,num,xx,yy,zz);
    list[index].startMe();
  }
}

void loop() {
  background(140,35,80);
  // view perspective
  rotateY(rotateView);
  translate(160,0,-200);
  for(int index=0;index<countList;index++){
    list[index].update();
  }

}
// 'worms' class
class Structure{
  int id;
  int colorSpeed;
  int nBall;
  int xBall,yBall,zBall;
  public color st;
  public Ball [] cont;

  Structure (int me,int n,int stx,int sty,int stz){
    id=me;
    nBall=n;
    xBall=stx;
    yBall=sty;
    zBall=stz;

  }
  void startMe(){
    cont=new Ball[nBall];
    for (int index = 0; index < nBall; index++) {
      int rx=int(random(500));
      int ry=int(random(500));
      int rz=int(random(200));
      // each 'worm' is built with x nodes (istances of Ball class)
      cont[index]=new Ball(.04*(index+2),ry,rx,rz,15,index,xBall,yBall,zBall,id);
    }

  }
  void update(){
    colorSpeed=int(abs(cont[0].velocityX)+abs(cont[0].velocityY)+abs(cont[0].velocityZ));
    stroke(255-(colorSpeed),200,220-colorSpeed,90);
    st=color (255-(colorSpeed),200,220-colorSpeed,90);
    fill(255-(colorSpeed),190,210-colorSpeed,90);
    // update each node
    for (int res = 0; res <nBall; res++) {
      int ox=cont[res].bx;
      int oy= cont[res].by;
      int oz= cont[res].bz;
      cont[res].update();
      int nx=cont[res].bx;
      int ny= cont[res].by;
      int nz= cont[res].bz;

    }
  }
  // nodes class
  class Ball {

    int bx,by,bz;
    int difX,difY,difZ;
    int dim;
    int me;
    float radius,radius2;
    float objX,objY,objZ;
    float beta,beta2,dista;
    float xSpeed,ySpeed,zSpeed,ndelay;
    float angx,angy,angz,coef;
    int posx,posy,posz;
    float dirX,dirY,dirZ;
    int sx,sy,sz;
    int adgX,adgY,adgZ;
    int parent;
    int flagx,flagy,flagz;
    float velocityX;
    float velocityY;
    float velocityZ;
    Ball(float d,int initX,int initY,int initZ,int magnitude, int iid,int _sx,int _sz,int _sy,int _pid){
      ndelay=d;
      bx=initX;
      by=initY;
      bz=initZ;
      difX=0;
      difY=0;
      difZ=0;
      xSpeed=0.00;
      ySpeed=0.00;
      zSpeed=0.00;
      dim=magnitude;
      me=iid;
      parent=_pid;
      //inizialise 'worm head'
      if(me==0){
        posx=int(random(height));
        posy=int(random(width));
        posz=int(random(height));
        xSpeed=_sx;
        ySpeed=_sy;
        zSpeed=_sz;
        dirX=xSpeed;
        dirY=ySpeed;
        dirZ=zSpeed;
        }
    }
    void update (){
      if(me!=0){
        // if this node is not an 'head'
        distance();
      } else{
        // head, so find new position: flocking behaviour
        // for algorithm description check >>  http://www.red3d.com/cwr/steer/gdc99/  
        float ax=0;
        float ay=0;
        float az=0;
        int atrac=0;
        float ndelay=.13;
        // cohesion: define new flock center
        for (int r1=0;r1<countList-1;r1++){
          if(r1!=id){
            ax+=list[r1].cont[0].bx;
            ay+=list[r1].cont[0].by;
            az+=list[r1].cont[0].bz;
          }

        }
        ax=ax/(countList-1);
        ax=(ax-bx)*0.002;
        ay=ay/(countList-1);
        ay=(ay-by)*0.002;
        az=az/(countList-1);
        az=(az-bz)*0.002;
        int cx=0;
        int cy=0;
        int cz=0;
        // separation, keep distance + draw 'relations'
        for (int r2=0;r2<countList;r2++){
          if(r2!=id){
            for(int ND=0;ND<num;ND++){
              float distanza=dist(bx,by,bz,list[r2].cont[ND].bx,list[r2].cont[ND].by,list[r2].cont[ND].bz);
              if(abs(distanza)<8){
              // 2d array: list[worm].cont[each node]
                cx=cx-(bx-list[r2].cont[ND].bx);
                cy=cy-(by-list[r2].cont[ND].by);
                cz=cz-(bz-list[r2].cont[ND].bz);
                 } else  if(abs(distanza)<50){
                // it draws 'relations'
                stroke(200-distanza,200-distanza,200-distanza,100);
                line(bx,by,bz,list[r2].cont[ND].bx,list[r2].cont[ND].by,list[r2].cont[ND].bz);
              }
            }
          }

        }
        float velox=0;
        float veloy=0;
        float veloz=0;
        int distC=0;
        // velocity: each object try to follow neighbours
        for (int r3=0;r3<countList;r3++){
          float distanza=dist(bx,by,bz,list[r3].cont[0].bx,list[r3].cont[0].by,list[r3].cont[0].bz);
          if(abs(distanza)<200){
            if(r3!=id){
              distC++;
              velox=velox+list[r3].cont[0].velocityX;
              veloy=veloy+list[r3].cont[0].velocityY;
              veloz=veloz+list[r3].cont[0].velocityZ;
            }
          }

        }
        velox=velox/(distC);
        velox=(velox-velocityX)*0.06;
        veloy=veloy/(distC);
        veloy=(veloy-velocityY)*0.06;
        veloz=veloz/(distC);
        veloz=(veloz-velocityZ)*0.06;
        // vectors sum
        velocityX+=ax+cx+velox;
        velocityY+=ay+cy+veloy;
        velocityZ+=az+cz+veloz;
        //limit to new vectors
        int limitV=15;
        if(velocityX>limitV){
          velocityX=limitV;
        }
        if(velocityY>limitV){
          velocityY=limitV;
        }
        if(velocityX<-limitV){
          velocityX=-limitV;
        }
        if(velocityY<-limitV){
          velocityY=-limitV;
        }
        if(velocityZ<-limitV){
          velocityZ=-limitV;
        }
        if(velocityZ<-limitV){
          velocityZ=-limitV;
        }
        //new position
        bx=bx+int(velocityX);
        by=by+int(velocityY);
        bz=bz+int(velocityZ);
        // enviroment limits
        if(bx<30){
          if(velocityX<0){
            velocityX+=1;
          }
          if(bx<0){
            bx+=30;
          }
        }
        if(by<30){
          if(velocityY<0){
            velocityY+=1;
          }
          if(by<0){
            by+=30;
          }
        }
        if(bz<30){
          if(velocityZ<0){
            velocityZ+=1;
          }
          if(bz<0){
            bz+=30;
          }
        }
        if (bx>(width-30)){
          if(velocityX>0){
            velocityX-=1;
          }
          if(bx>width){
            bx-=30;
          }
        }
        if (bz>(width-30)){
          if(velocityZ>0){
            velocityZ-=1;
          }
          if(bz>width){
            bz-=30;
          }
        }
        if (by>(height-30)){
          if(velocityY>0){
            velocityY-=1;
          }
          if(by>height){
            by-=30;
          }
        }
        //draw projections
        stroke(200*(bx*.1),200*(by*.1),200*(bz*.1),20);
        line(cont[0].bx,400,cont[me].bz,cont[0].bx,cont[0].by,cont[me].bz);
        line(400,cont[0].by,cont[0].bz,cont[0].bx,cont[0].by,cont[0].bz);
        line(cont[0].bx,cont[0].by,0,cont[0].bx,cont[0].by,cont[0].bz);
        stroke(200*(bx*.1),10*(by*.08),3*(bz*.01),60);
        line(cont[0].bx,400,cont[me].bz,cont[0].bx,400,400);
        line(400,cont[0].by,cont[0].bz,400,0,cont[0].bz);
        line(cont[0].bx,cont[0].by,0,0,cont[0].by,0);
        //
      }
    }
    // determinig new node position, for not 'head' nodes
    void distance(){
      objX=cont[me-1].bx-bx;
      objY=cont[me-1].by-by;
      objZ=cont[me-1].bz-bz;
      dista=sqrt(sq(objX)+sq(objY)+sq(objZ));
      //__________________________
      if(abs(dista)!=15){
        // new angles and radius
        beta=float(Math.atan(objY/objX));
        beta2=float(Math.atan(objZ/objY));
        radius2=Math.abs(float(15 * Math.sin(beta2)));
        radius=Math.abs(float(15 * Math.cos(beta2)));
        //_________________________
        if(objY>=0){
          radius*=1;
        } else {
          radius*=-1;
        }
        if(objZ>=0){
          radius2*=1;
        } else {
          radius2*=-1;
        }
        // **********this the 'core'****************
        if(beta>0){
          bx=cont[me-1].bx-int((radius)*cos(beta));
          by=cont[me-1].by-int((radius)*sin(beta));
        }else {
          bx=cont[me-1].bx+int((radius)*cos(beta));
          by=cont[me-1].by+int((radius)*sin(beta));
        }
        if(beta2>0){
          bz=cont[me-1].bz-int((radius2)*sin(beta2));
        } else {
          bz=cont[me-1].bz+int((radius2)*sin(beta2));
        }
        //*******************************************
        // draw 'bodies segments'
        line(cont[me-1].bx,cont[me-1].by,cont[me-1].bz,bx,by,bz);
        stroke(st);
      }

    }
  }

}
