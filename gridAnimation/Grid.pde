class Grid
{
  //variables
  float resApp;
  float horizontalMargin;
  float verticalMargin;
  float gridResolution;
  int gridWidth;
  int gridHeight;
  float gridWidthResolution;
  float gridHeightResolution;
  int nbCols;
  int nbRows;

  //behavior
  //circle
  float externalRadius;
  float internalRadius;
  float circleWidth;

  PVector centerGrid;
  //poly
  ArrayList<PVector> polyList;
  float phi, phiSpeed, polyRadius;

  //sinWave
  ArrayList<PVector> sinPolyList;
  float sinHeight;
  float theta;
  float amplitude;
  float period;
  float dx;
  
  //diag
  float startDiag;

  //Array
  ArrayList<Cell> cellList;

  //nb behavior
  int nbBehaviors;
  int actualBehavior;

  //Constructeur
  Grid()
  {
    nbBehaviors = 9;
    actualBehavior = round(random(nbBehaviors));

    horizontalMargin = 20.0;
    verticalMargin = 20.0;
    resApp = (width + 0.0) / (height + 0.0);
    nbCols = 20;
    nbRows = floor(nbCols / resApp);
    gridResolution = 40.0;
    gridWidth = round(width-(horizontalMargin*2));
    gridHeight = round(height-(verticalMargin*2));

    gridWidthResolution = gridWidth/nbCols;//floor(gridWidth/gridResolution);
    gridHeightResolution = gridWidthResolution;//gridHeight/nbCols;//floor(gridHeight/gridResolution);

    cellList = new ArrayList<Cell>();
    initCell();

    //behaviors
    startDiag = nbRows-1;
    
    //circle
    circleWidth = 100;
    externalRadius = 0;
    internalRadius = externalRadius - circleWidth;
    centerGrid = new PVector(horizontalMargin + (gridWidthResolution/2) + ((nbCols/2)*gridWidthResolution), verticalMargin + (gridHeightResolution/2) + ((nbRows/2)*gridHeightResolution));

    //poly
    polyList =  new ArrayList<PVector>();
    phi = HALF_PI;
    phiSpeed = 0.01;
    polyRadius = 300;
    for (int i=0; i<3; i++)
    {
      float theta = map(i, 0, 3, 0, TWO_PI)-phi;
      float x = centerGrid.x + cos(theta) * polyRadius;
      float y = centerGrid.y + sin(theta) * polyRadius;
      polyList.add(new PVector(x, y));
    }

    //sin
    sinPolyList = new ArrayList<PVector>();
    sinHeight = 200;
    amplitude = 250.0;
    period = 1000.0;
    dx = (TWO_PI / period) * gridWidthResolution;

    float ySin = theta;
    for (int i = 0; i<nbCols; i++)
    {
      float x = horizontalMargin + (gridWidthResolution/2) + (i*gridWidthResolution);
      float y = (horizontalMargin + (gridWidthResolution/2) + ((nbRows/2)*gridWidthResolution)) + sin(ySin) * 100;
      ySin += dx;

      sinPolyList.add(new PVector(x, y-sinHeight/2));
    }
    for (int i = nbCols-1; i>-1; i--)
    {
      float x = horizontalMargin + (gridWidthResolution/2) + (i*gridWidthResolution);
      float y = (horizontalMargin + (gridWidthResolution/2) + ((nbRows/2)*gridWidthResolution)) + sin(ySin) * 100;
      ySin -= dx;

      sinPolyList.add(new PVector(x, y+sinHeight/2));
    }
  }

  //Methodes
  void run()
  {
    for (Cell c : cellList)
    {
      c.run();
    }

    if (actualBehavior == 0)
    {
      behavior00();
    } else if (actualBehavior == 1)
    {
      behavior01();
    } else if (actualBehavior == 2) {
      behavior02();
    } else if (actualBehavior == 3) {
      behavior03();
    } else if (actualBehavior == 4) {
      animateDiag(0.1);
      for(int i=0; i<nbCols; i+=4)
      {
        behavior04(floor(startDiag)+i);
      }
    } else if (actualBehavior == 5) {
      animateCircle(8);
      behavior05(centerGrid, externalRadius, internalRadius);
    } else if (actualBehavior == 6) {
      animatePoly();
      behavior06(polyList);
    } else if (actualBehavior == 7) {
      behavior07(5);
    } else if (actualBehavior == 8) {
      behavior08(2);
    } else if (actualBehavior == 9)
    {
      animateSinPoly(0.02);
      behavior06(sinPolyList);
    }
  }

  void behavior00()
  {
    for (Cell c : cellList)
    {
      c.display();
    }
  }

  void behavior01()
  {
    for (Cell c : cellList)
    {
      int row = c.row;
      if (c.col % 2 != 0)
      {
        row = c.row + 1;
      }

      if (row % 2 == 0)
      {
        c.display();
      }
    }
  }

  void behavior02()
  {
    for (Cell c : cellList)
    {
      if (c.col % 2 ==0)
      {
        c.display();
      }
    }
  }

  void behavior03()
  {
    for (Cell c : cellList)
    {
      if (c.row % 2 ==0)
      {
        c.display();
      }
    }
  }

  void behavior04(int startCol)
  {
    for (int i = 0; i<nbCols; i++)
    {
      //int index = (i) + ((i+startCol)*nbRows);
      
      int index = (startCol + i) + (i*nbRows);
      if (index < cellList.size())
      {
        cellList.get(index).display();
      }
    }
  }

  void behavior05(PVector loc, float externalRadius, float internalRadius)
  {
    for (Cell c : cellList)
    {
      float dist = dist(loc.x, loc.y, c.location.x, c.location.y);
      if (dist > internalRadius && dist < externalRadius)
      {
        c.display();
      }
    }
  }

  void behavior06(ArrayList<PVector> vertList)
  {
    for (Cell c : cellList)
    {
      if (pixelInPoly(vertList, c.location))
      {
        c.display();
      }
    }
  }

  void behavior07(int mod)
  {
    for (Cell c : cellList)
    {
      int row = c.row;
      if (c.col % mod != 0)
      {
        row = c.col + mod - 1;
      }

      if (row % 2 == 0)
      {
        c.display();
      }
    }
  }

  void behavior08(int mod)
  {
    for (Cell c : cellList)
    {
      int row = c.row;
      if (c.col % mod != 0)
      {
        row = c.col + mod;
      }

      if (row % mod == 0)
      {
        c.display();
      }
    }
  }


  void initCell()
  {
    for (int i=0; i<nbCols; i++)
    {
      for (int j=0; j<nbRows; j++)
      {
        float centerX = gridWidthResolution/2;
        float centerY = gridHeightResolution/2;
        float x = horizontalMargin + centerX + (i*gridWidthResolution);
        float y = verticalMargin + centerY + (j*gridHeightResolution);

        cellList.add(new Cell(i, j, x, y, gridWidthResolution, gridHeightResolution));
      }
    }
  }

  //Behavior poly
  void animateDiag(float speed)
  {
    startDiag -= speed;
    if(startDiag < 0)
    {
      startDiag = nbRows;
    }
  }
  
  void animateCircle(float speed)
  {
    externalRadius += speed;
    internalRadius = externalRadius - circleWidth;

    if (externalRadius >= width/2)
    {
      externalRadius = 0;
    }
  }

  void animatePoly()
  {
    phi += phiSpeed;
    for (int i=0; i<3; i++)
    {
      float theta = map(i, 0, 3, 0, TWO_PI)-phi;
      float x = centerGrid.x + cos(theta) * polyRadius;
      float y = centerGrid.y + sin(theta) * polyRadius;
      polyList.set(i, new PVector(x, y));
    }
  }

  void animateSinPoly(float speed)
  {
    theta -= speed;

    // sinPolyList.clear();
    float ySin = theta;
    float ySin2 = theta;
    for (int i = 0; i < sinPolyList.size (); i++)
    {
      if (i <= nbCols)
      {
        float x = horizontalMargin + (gridWidthResolution/2) + (i*gridWidthResolution);
        float y = (horizontalMargin + (gridWidthResolution/2) + ((nbRows/2)*gridWidthResolution)) + sin(ySin) * 100;
        ySin += dx;

        sinPolyList.set(i, new PVector(x, y-sinHeight/2));
      } else
      {
        float ni = map(i, nbCols+1, sinPolyList.size()-1, nbCols-1, 0);
        float x = horizontalMargin + (gridWidthResolution/2) + (ni*gridWidthResolution);
        float y = (horizontalMargin + (gridWidthResolution/2) + ((nbRows/2)*gridWidthResolution)) + sin(ySin2) * 100;
        ySin2 -= dx;

        sinPolyList.set(i, new PVector(x, y+sinHeight/2));
      }
    }
  }

  void debugGrid()
  {
    pushStyle();
    for (int i=0; i<nbCols; i++)
    {
      for (int j=0; j<nbRows; j++)
      {
        float centerX = gridWidthResolution/2;
        float centerY = gridHeightResolution/2;
        float x = horizontalMargin + centerX + (i*gridWidthResolution);
        float y = verticalMargin + centerY + (j*gridHeightResolution);

        strokeWeight(1);
        stroke(255, 0, 255);
        noFill();
        rectMode(CENTER);
        rect(x, y, gridWidthResolution, gridHeightResolution);

        strokeWeight(5);
        stroke(0, 255, 0);
        point(x, y);
      }
    }
    popStyle();
  }

  //computation
  boolean pixelInPoly(ArrayList<PVector> verts, PVector pos) {
    int i, j;
    boolean c=false;
    int sides = verts.size();
    for (i=0, j=sides-1; i<sides; j=i++) {
      if (( ((verts.get(i).y <= pos.y) && (pos.y < verts.get(j).y)) || ((verts.get(j).y <= pos.y) && (pos.y < verts.get(i).y))) &&
        (pos.x < (verts.get(j).x - verts.get(i).x) * (pos.y - verts.get(i).y) / (verts.get(j).y - verts.get(i).y) + verts.get(i).x)) {
        c = !c;
      }
    }
    return c;
  }
}

