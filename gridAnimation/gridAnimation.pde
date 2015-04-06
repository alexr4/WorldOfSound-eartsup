//Sketch properties
int pWidth = 1280;
int pHeight = 720;
String appName = "WorldOfSound - GridAnimation";
String version = "Alpha";
String subVersion = "0.0.0";
String frameName;

//Grid
Grid grid;
char[] keyBehavior = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

boolean debug;

void setup()
{
  size(pWidth, pHeight, P3D);
  smooth(8);
  appParameter();

  grid = new Grid();
}

void draw()
{
  background(255);
  if (debug)
  {
    grid.debugGrid();
  }

  grid.run();

  showFpsOnFrameTitle();
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

void keyPressed()
{
  if (key == 'd')
  {
    debug = !debug;
  }

  if (key == '+')
  {
    if (grid.actualBehavior < grid.nbBehaviors)
    {
      grid.actualBehavior ++;
    } else
    {
      grid.actualBehavior = 0;
    }
  }

  if (key == '-')
  {
    if (grid.actualBehavior > 0)
    {
      grid.actualBehavior --;
    } else
    {
      grid.actualBehavior = grid.nbBehaviors;
    }
  }
  
  for(int i=0; i< keyBehavior.length; i++)
  {
    if(key == keyBehavior[i])
    {
      grid.actualBehavior = i;
    }
  }
  
}

