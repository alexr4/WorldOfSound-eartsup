
//Sketch properties
int pWidth = 1280;
int pHeight = 800;
String appName = "MusicAnalysis";
String version = "Alpha";
String subVersion = "0.0.1";
String frameName;

FFTObject fftobj;
Timer timer;

boolean debug;
boolean play;

float gamma;
float speedGamma;



void setup()
{
  size(pWidth, pHeight, P2D);
  smooth(8);
  appParameter();

  int nbBande = 10;
  initMinim("01 - Boards of canada Reach For The Dead.mp3");
  fftobj = new FFTObject(nbBande, 100);
  background(40);


  speedGamma = 0.001;
}

void draw()
{
  background(40);

  if (fftobj.isPlaying())
  {
    fftobj.computeAverageLowMedHighLevel();

    float subLevel = fftobj.averageSubBass;
    float bassLevel = fftobj.averageBass;
    float midRangeLevel = fftobj.averageMidRange;
    float highMidLevel = fftobj.averageHighMid;
    float highsLevel = fftobj.averageHighs;

    float subRadius = 60;
    float bassRadius = 120;
    float midRangeRadius = 180;
    float highMidRadius = 240;
    float highsRadius = 300;
    float fftRadius = 360; 

    float dividerHue = 360 / 6;   

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

      PVector subCoord = getCoord(phi, subRadius);
      PVector bassCoord = getCoord(phi, bassRadius);
      PVector midRangeCoord = getCoord(phi, midRangeRadius);
      PVector highMidCoord = getCoord(phi, highMidRadius);
      PVector highsCoord = getCoord(phi, highsRadius);
      PVector fftCoord = getCoord(phi, fftRadius);

      float subHue = map(i, 0, fftobj.nbDividerBande, 0, dividerHue);// + subLevel / 2;
      float bassHue = map(i, 0, fftobj.nbDividerBande, dividerHue, dividerHue*2);// + bassLevel;
      float midRangeHue = map(i, 0, fftobj.nbDividerBande, dividerHue*2, dividerHue*3);// + midRangeLevel;
      float highMidHue = map(i, 0, fftobj.nbDividerBande, dividerHue*3, dividerHue*4);// + highMidLevel;
      float highsHue = map(i, 0, fftobj.nbDividerBande, dividerHue*4, dividerHue*5);// + highsLevel;
      float fftHue = map(i, 0, fftobj.nbDividerBande, dividerHue*5, dividerHue*6);// + fftobj.getFFTLevel(i);

      float margin = 10;
      float subWidth = subLevel;//constrain(subLevel, 0, 120/2 - margin);
      float bassWidth = bassLevel;//constrain(bassLevel, 0, 180/2 - 120/2 - margin);
      float midRangeWidth = midRangeLevel;//constrain(midRangeLevel, 0, 240/2 - 180/2 - margin);
      float highMidWidth = highMidLevel;//constrain(highMidLevel, 0, 300/2 - 240/2 - margin);
      float highsWidth = highsLevel;//constrain(highsLevel, 0, 360/2 - 300/2 - margin);

      //subBass
      fill(subHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(subCoord.x, subCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, subWidth, 2);
      popMatrix();

      //bass
      fill(bassHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(bassCoord.x, bassCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, bassWidth, 2);
      popMatrix();

      //midRange
      fill(midRangeHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(midRangeCoord.x, midRangeCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, midRangeWidth, 2);
      popMatrix();

      //highmidRange
      fill(highMidHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(highMidCoord.x, highMidCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, highsWidth, 2);
      popMatrix();

      //highsRange
      fill(highsHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(highsCoord.x, highsCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, highsLevel, 2);
      popMatrix();

      //fft
      fill(fftHue, 100, 100);
      noStroke();
      pushMatrix();
      rectMode(CENTER);
      translate(highsCoord.x, highsCoord.y);
      rotate(phi);
      //fill(c0, 100, 100);
      rect(0, 0, fftobj.getFFTLevel(i), 2);
      popMatrix();
    }
    popStyle();
    popMatrix();
  } else
  {
    pushStyle();
    fill(127);
    noStroke();
    textSize(12);
    textAlign(LEFT, CENTER);
    text("Press 'p' to play/pause music\nPress 's' to stop music\nPress 'd' to show music analysis debug\n\nMusic : "+fftobj.getTitle()+"\nFrom : "+fftobj.getAuthor(), 40, height/2);
    popStyle();
  }

  if (debug)
  {
    fftobj.showDebug();
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

PVector getCoord(float angle, float radius)
{
  return new PVector(cos(angle)*radius, sin(angle)*radius);
}

/**************************************************************************
 OLD VISU
/*
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
 */
