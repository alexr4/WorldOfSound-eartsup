class Cell
{
  //Add to each object
  int row, col;
  
  //variabkes
  PVector location;
  float cellWidth, cellHeight;
  float colorCell;
  
  //debugBehabior
  float noiseWeight, noiseOff, noiseSpeed, oCellWidth;
  
  Cell(int row_, int col_, float x, float y, float w, float h)
  {
    row = row_;
    col = col_;
    location = new PVector(x, y);
    cellWidth = w;
    cellHeight = h;
    colorCell = random(0, 360);
    
    //debugBNehavior
    oCellWidth = cellWidth;
    noiseSpeed = random(0.001, 0.01);
    noiseOff = noiseSpeed;
    noiseWeight = noise(noiseOff) * oCellWidth;
  }
  
  void run()
  {
    behavior01();
  }
  
  void behavior01()
  {
    noiseWeight = noise(noiseOff) * oCellWidth;
    cellWidth = noiseWeight;
    cellHeight = cellWidth;
    noiseOff += noiseSpeed;
  }
  
  void display()
  {if(debug)
    {
      displayDebug();
    }
    
    pushStyle();
    colorMode(HSB, 360, 100, 100);
    noStroke();
    fill(colorCell, 100, 100);
    ellipse(location.x, location.y, cellWidth, cellHeight);
    popStyle();
  }
  
  void displayDebug()
  {
    pushStyle();
    noStroke();
    fill(40);
    rectMode(CENTER);
    rect(location.x, location.y, oCellWidth, oCellWidth);
    popStyle();
  }
}
