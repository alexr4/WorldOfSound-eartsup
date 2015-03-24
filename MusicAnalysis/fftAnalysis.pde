/*
Music analysis is not just frequency analysis. Analyze frequency by homogeneous bande is not the best way to have
 a view of medium, low and high.
 In order to complete a good view of sound, the following class developped 3 methods to get the average level of
 Low, Medium and High. Each of these are allocate on differents frequency range :
 Low : from 0 to 269
 Medium : from 269 to 5000
 High : from 5000 to 10000
 */

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer music;
AudioMetaData meta;

void initMinim(String songPath)
{
  minim = new Minim(this);
  music = minim.loadFile(songPath, 1024);
  meta = music.getMetaData();

  // loop music
  //music.loop();
}

class FFTObject
{
  //variables
  FFT fft;
  float specSize;
  int nbDividerBande;
  float step;

  int ys;
  int yi;

  Timer timer;  
  int countDown;
  float averageLow, averageMedium, averageHigh;

  //constructeur
  FFTObject(int nbDividerBande_, float step_)
  {
    fft = new FFT( music.bufferSize(), music.sampleRate() );
    specSize =  fft.specSize();
    nbDividerBande = round(fft.specSize()/nbDividerBande_);
    step = step_;

    ys = 25;
    yi = 15;


    countDown= floor(1000/25);
    timer = new Timer(countDown);
  }

  //methode

  void play()
  {
    music.play();
    timer.start();
  }

  void pause()
  {
    music.pause();
  }

  void rewind()
  {
    music.rewind();
  }

  void stop()
  {
    pause();
    rewind();
  }

  void computeAverageLowMedHighLevel()
  {
    if (timer.isFinished())
    {
      averageLow = getLow();
      averageMedium = getMedium();
      averageHigh = getHigh();
      
      timer.start();
    }
  }
  
  void showDebug()
  {
    showDebugLowMedHigh(30, height-60);
    showFrequencyBands(200, height-60);
    displayInformations(30, 30);
  }

  void displayInformations(float x_, float y_)
  {
    float y = y_;

    fill(127);
    text("File Name: " + getFilename(), x_, y);
    text("Length (in seconds): " + getMusicLength()/1000, x_, y+=yi);
    text("Title: " + getTitle(), x_, y+=yi);
    text("Author: " + getAuthor(), x_, y+=yi); 
    text("Album: " + getAlbum(), x_, y+=yi);
    text("Date: " + getDate(), x_, y+=yi);
    text("Comment: " + getComment(), x_, y+=yi);
    text("Track: " + getTrack(), x_, y+=yi);
    text("Genre: " + getGenre(), x_, y+=yi);
    text("Copyright: " + getCopyright(), x_, y+=yi);
    text("Disc: " + getDisc(), x_, y+=yi);
    text("Composer: " + getComposer(), x_, y+=yi);
    text("Orchestra: " + getOrchestra(), x_, y+=yi);
    text("Publisher: " + getPublisher(), x_, y+=yi);
    text("Encoded: " + getEncoded(), x_, y+=yi);
    text("Music playback : "+getPosition()/1000+" / "+getMusicLength()/1000, x_, y+=yi);
  }

  void showFrequencyBands(float x, float y)
  {
    if (isPlaying())
    {
      float res = 10;
      noFill();
      beginShape();
      fill(255, 50);
      stroke(255, 100);
      vertex(x, y);
      for (int i = 0; i<nbDividerBande; i++)
      {
        float level = getFFTLevel(i);
        float xi = x+i*res;
        float yi = y-level;

        vertex(xi, yi);
      }
      vertex(x+(res*nbDividerBande), y);
      endShape(CLOSE);

      pushStyle();
      colorMode(HSB, nbDividerBande, 1, 1, 1);
      for (int i = 0; i<nbDividerBande; i++)
      {
        float level = getFFTLevel(i);
        float xi = x+i*res;
        float yi = y-level;

        stroke(i, 1, 1);       
        line(xi, yi, xi, y);
      }
      popStyle();

      float r0 = map(269, 0, 10000, 0, x+(res*nbDividerBande));
      float r1 = map(5000-269, 0, 10000, 0, x+(res*nbDividerBande));
      float r2 = x+(res*nbDividerBande)-(x+(r1+r0));

      rectMode(CORNER);
      noStroke();
      fill(255, 0, 0);
      rect(x, y+5, r0, 5);
      fill(0, 255, 0);
      rect(x+r0, y+5, r1, 5);
      fill(0, 0, 255);
      rect(x+r0+r1, y+5, r2, 5);
    }
  }

  void showDebugLowMedHigh(float x, float y)
  {
    if (isPlaying())
    {
      float res = 50;


      pushStyle();
      noStroke();
      rectMode(CORNER);

      for (int i =0; i<3; i++)
      {
        float xi = x+i*res;
        float yi = y;

        if (i%3 == 0)
        {
          fill(255, 0, 0);
          yi += averageLow;
        } else if (i%3 == 1)
        {
          fill(0, 255, 0);
          yi += averageMedium;
        } else if (i%3 ==2)
        {
          fill(0, 0, 255);
          yi += averageHigh;
        }
        rect(xi, y, res, y-yi);
      }
      popStyle();

      //debugText
      fill(255);
      text("averages sampled\non "+countDown+" milliseconds", x, y+30);
      fill(255, 0, 0);
      text("Low", x, y+15);     
      text(averageLow, x, y-averageLow-10);
      fill(0, 255, 0);
      text("Medium", x+res, y+15);
      text(averageMedium, x+res, y-averageMedium-10);
      fill(0, 0, 255);
      text("High", x+res*2, y+15);
      text(averageHigh, x+res*2, y-averageHigh-10);
    }
  }



  boolean isPlaying()
  {
    return music.isPlaying();
  }

  float getFreq(float freq)
  {
    fft.forward( music.mix ); 
    return fft.getFreq(freq);
  }

  float getAverageFreqOn(float start, float end, float step)
  {
    float average = 0;
    float size = 0;//end-start;

    try
    {
      for (float i=start; i < end; i+= step)
      {
        if (getFreq(i) > 0)
        {
          average += getFreq(i);
          size ++;
        }
      }
      float finalAverage = average/size;

      return finalAverage;
    }
    catch(Exception e)
    {
      return average;
    }
  }

  float getLow()
  {
    return fftobj.getAverageFreqOn(40, 269, step);
  }

  float getMedium()
  {
    /* float size = 5000 - 269;
     float newStep = map(step, 0, 269, 0, size);*/

    return getAverageFreqOn(269, 5000, step);
  }

  float getHigh()
  {
    /*float size = 10000 - 5000;
     float newStep = map(step, 0, 269, 0, size);*/

    return getAverageFreqOn(5000, 10000, step);
  }
  
  float getAverageLow()
  {
    return averageLow;
  }
  
  float getAverageMedium()
  {
    return averageMedium;
  }
  
  float getAverageHigh()
  {
    return averageHigh;
  }

  float getFFTLevel(int index)
  {
    fft.forward( music.mix ); 
    float fftLevel = fft.getBand(index); 

    return fftLevel;
  }

  int getNumberBande()
  {
    return nbDividerBande;
  }

  int getMusicLength()
  {
    return music.length();
  }

  String getFilename()
  {
    return meta.fileName();
  }

  String getTitle()
  {
    return meta.title();
  }

  String getAuthor()
  {
    return meta.author();
  }

  String getAlbum()
  {
    return meta.album();
  }

  String getDate()
  {
    return meta.date();
  }

  String getComment()
  {
    return meta.comment();
  }

  String getTrack()
  {
    return meta.track();
  }

  String getGenre()
  {
    return meta.genre();
  }

  String getCopyright()
  {
    return meta.copyright();
  }

  String getDisc()
  {
    return meta.disc();
  }

  String getComposer()
  {
    return meta.composer();
  }

  String getOrchestra()
  {
    return meta.orchestra();
  }

  String getPublisher()
  {
    return meta.publisher();
  }

  String getEncoded()
  {
    return meta.encoded();
  }

  float getPosition()
  {
    return music.position();
  }

  float getPan()
  {
    return music.getPan();
  }

  float getVolume()
  {
    return music.getVolume();
  }

  float getGain()
  {
    return music.getGain();
  }
}

