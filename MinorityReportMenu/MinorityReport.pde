import SimpleOpenNI.*;
SimpleOpenNI kinect;

int kinectWidth = 640;
int kinectHeight = 480;
float reScale;

int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;

int count=0;
int [] recentX=new int[3];
int [] recentY=new int[3];

int currentImage = 0;

ScalableImage [] picCollection = new ScalableImage[3];

void setup()
{
  size(1920, 1080);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  
  reScale = (float) width / kinectWidth;

  for (int i=0;i<picCollection.length;i++)
  {
    picCollection[i]=new ScalableImage();
    picCollection[i].content=loadImage("image"+(i+1)+".gif");
  }
}

void draw() 
{
  scale(reScale);
  background(0);
  closestValue = 8000;
  kinect.update();
  int[] depthValues = kinect.depthMap();
  for (int y = 0; y < 480; y++) 
  {
    for (int x = 0; x < 640; x++) 
    {
      int i = x + y * 640;
      int currentDepthValue = depthValues[i];
      if (currentDepthValue > 610 && currentDepthValue < 1300 && currentDepthValue < closestValue) 
      {
        closestValue = currentDepthValue;
        recentX[count]=x;
        recentY[count]=y;
      }
    }
  }

  count++;
  if (count>2)
  {
    count=0;
  }

  closestX=(recentX[0]+recentX[1]+recentX[2])/3;
  closestY=(recentY[0]+recentY[1]+recentY[2])/3;

  float interpolatedX = lerp(lastX, closestX, 0.3);
  float interpolatedY = lerp(lastY, closestY, 0.3);


  picCollection[currentImage].imageX=interpolatedX;
  picCollection[currentImage].imageY=interpolatedY;
  picCollection[currentImage].imageScale=map(closestValue, 610, 1300, 0, 4);
  
  image(kinect.rgbImage(), 0, 0);

  for (int i=0;i<picCollection.length;i++)
  {
    ScalableImage picture=new ScalableImage();
    picture=picCollection[i];
    image(picture.content, picture.imageX, picture.imageY, picture.imageWidth * picture.imageScale, picture.imageHeight * picture.imageScale);
  }

  lastX = interpolatedX;
  lastY = interpolatedY;
}
void mousePressed() {
  // incrementar imagen actual
  currentImage++;

  if (currentImage > 2) 
  {
    currentImage = 0;
  }
  println(currentImage);
}

