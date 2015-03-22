
//Sketch properties
int pWidth = 1280;
int pHeight = 800;
String appName = "MusicAnalysis";
String version = "Alpha";
String subVersion = "0.0.0";
String frameName;

FFTObject fftobj;
Timer timer;

boolean debug;
boolean play;

float gamma;

float speedPhi;
float speedTheta;
float speedOmega;
float speedGamma;

float phiRadius;
float thetaRadius;
float omegaRadius;
float etaRadius;

void setup()
{
  size(pWidth, pHeight, P2D);
  smooth(8);
  appParameter();

  int nbBande = 10;
  initMinim("01 - Boards of canada Reach For The Dead.mp3");
  fftobj = new FFTObject(nbBande, 20);
  background(40);

  phiRadius = 60;
  thetaRadius = 80;
  omegaRadius = 160;
  etaRadius = 200;
  
  speedGamma = 0.001;
}

void draw()
{
  background(40);
  
  fftobj.computeAverageLowMedHighLevel();
  speedPhi = fftobj.getAverageLow();
  speedTheta = fftobj.getAverageMedium();
  speedOmega = fftobj.getAverageHigh();
  
  gamma += speedGamma;
  
  pushMatrix();
  pushStyle();
  translate(width/2, height/2);
  rotate(gamma);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();
  for (int i=0; i< fftobj.nbDividerBande; i++)
  {
    float phi = map(i, 0, fftobj.nbDividerBande, 0, TWO_PI);

    float nphi = phi+speedPhi/10;
    float ntheta = phi+speedTheta/20;
    float nomega = phi+speedOmega;
    float leveli = fftobj.getFFTLevel(i);
   

    float x0 = cos(phi-gamma)*phiRadius;
    float y0 = sin(phi-gamma)*phiRadius;
    float x1 = cos(phi)*thetaRadius;
    float y1 = sin(phi)*thetaRadius;
    float x2 = cos(phi+gamma)*omegaRadius;
    float y2 = sin(phi+gamma)*omegaRadius;
    float x3 = cos(phi)*etaRadius;
    float y3 = sin(phi)*etaRadius;

    float c0 = map(i, 0, fftobj.nbDividerBande, 100, 200);
    float c1 = map(i, 0, fftobj.nbDividerBande, 0, 100);
    float c2 = map(i, 0, fftobj.nbDividerBande, 200, 360);
    float c3 = map(i, 0, fftobj.nbDividerBande, 1, 360);
    c0 += speedPhi*1.5;
    c1 += speedTheta*1.5;
    c2 += speedOmega*1.5;
    c3 += leveli;

    //Low
    pushMatrix();
    rectMode(CENTER);
    translate(x0, y0);
    rotate(nphi-gamma);
    fill(c0, 100, 100);
    rect(0, 0, speedPhi, 2);
    popMatrix();

    //Medium
    pushMatrix();
    rectMode(CORNER);
    translate(x1, y1);
    rotate(ntheta);
    fill(c1, 100, 100);
    rect(0, 0, speedTheta*25, speedTheta);
    popMatrix();

    //High
    pushMatrix();
    rectMode(CENTER);
    translate(x2, y2);
    rotate(phi+gamma);
    fill(c2, 100, 100);
    rect(0, 0, speedOmega*100, 2);
    popMatrix();
    
    //fft
    pushMatrix();
    translate(x3, y3);
    rotate(phi);
    fill(c3, 100, 100);
    rect(0, 0, leveli, 2);
    popMatrix();
  }
  popStyle();
  popMatrix();

  if (debug)
  {
    fftobj.showDebugLowMedHigh(30, height-60);
    fftobj.showFrequencyBands(200, height-60);
    fftobj.displayInformations(30, 30);
  }
  showFpsOnFrameTitle();
}

void keyPressed()
{
  if (key == 'p')
  {
    if (!play)
    {
      fftobj.play();
    } else
    {
      fftobj.pause();
    }
    play = !play;
  }

  if (key == 'r')
  {
    fftobj.rewind();
  }
  if (key == 's')
  {
    if (play == true)
    {
      fftobj.stop();
      play = false;
    }
  }

  if (key == 'd')
  {
    debug = !debug;
  }
}

//App Parameters
void appParameter()
{
  frameName = appName+"_"+version+"_"+subVersion;
  frame.setTitle(frameName);
}

void showFpsOnFrameTitle()
{
  frame.setTitle(frameName+"    FPS : "+int(frameRate));
}

