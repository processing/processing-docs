// Based on example scripts of Amit Pitaru and suggestions 
// of the great people getting around Processing forum
// Set the volume to get the right visualisation


int outputLen = 1024;
int k;


// For stand alone application

static public void main(String args[]) {        
   BApplet.main(new String[] { "min_mod" });
}


void setup()
{
  size(800,600);
  Sonia.start(this);
  LiveInput.start();
  LiveOutput.start(outputLen,outputLen*2);
  LiveOutput.startStream();
}


void loop()
{
  noStroke();
  background(50);
  LiveInput.getSpectrum();
  for ( int j = 0; j < 100; j++){
  for ( int i = 0; i < LiveInput.signal.length;i++){
    if(i == 0|| i == LiveInput.signal.length - 1){ 
        k = 0;   
    } else {
        k = 1;
    } 
    LiveInput.signal[i] = (LiveInput.signal[i+k]+LiveInput.signal[i-k])/2;
    }
  }
  draw_waveform();
 }
 
 
 
void liveOutputEvent()
{
    float freq = 4.0;
    float oneCycle = (TWO_PI) / outputLen;
    float amp = 1.0; 
    for (int i=0; i < outputLen; i++) {
      LiveOutput.data[i] = amp* sin(float(i*oneCycle*freq));
    }
}


void draw_waveform(){
  for( int i = 0; i < LiveInput.signal.length-1; i=i+3){
    stroke(120);
    fill(50);
    rect(i/2, height/2 - LiveInput.signal[i]/24,100,1);
  }
}


public void stop(){
  Sonia.stop();
  super.stop();
}

