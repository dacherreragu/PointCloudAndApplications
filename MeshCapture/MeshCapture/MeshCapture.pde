import SimpleOpenNI.*;


SimpleOpenNI kinect;
float        zoomF =0.5f;
float        rotX = radians(180);  
float        rotY = radians(0);

int         steps           = 3; 
float       strokeW         = 0.6;
boolean texture;
PVector   s_rwp = new PVector(); 
int       kdh;
int       kdw;
int       max_edge_len = 50;
float     strokeWgt = 0.4;
int       i00, i01, i10, i11; 
PVector   p00, p10, p01, p11; 
PVector   k_rwp; 

  
void setup()
{
  size(1024,768,OPENGL);


  kinect = new SimpleOpenNI(this);
  kinect.setMirror(false);

  if(kinect.enableDepth() == false) {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();     return;
  }
  if(kinect.enableRGB() == false) {
     println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
     exit();     return;
  }
  // align depth data to image data
  kinect.alternativeViewPointDepthToImage();
  
  kdh = kinect.depthHeight();
  kdw = kinect.depthWidth();

  
  smooth();
  stroke(0);
  perspective(radians(45),
              float(width*10000)/float(height*10000),
              10,150000);
}

void draw()
{
   kinect.update();
   PImage    rgbImage = kinect.rgbImage();
   PImage    textures = loadImage("text3.jpeg");
   PVector[] realWorldMap = kinect.depthMapRealWorld();


  background(0,0,0);
  
    // set the scene pos
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  if (strokeWgt == 0) noStroke();
  else strokeWeight(strokeWgt);
  
  println(frameRate);

 for(int y=0;y < kdh-steps;y+=steps)
  {
    int y_steps_kdw = (y+steps)*kdw;
    int y_kdw = y * kdw;
    for(int x=0;x < kdw-steps;x+=steps)
    {
      i00 = x + y_kdw;
      i01 = x + y_steps_kdw;
      i10 = (x + steps) + y_kdw;
      i11 = (x + steps) + y_steps_kdw;

      p00 = realWorldMap[i00];
      p01 = realWorldMap[i01];
      p10 = realWorldMap[i10];
      p11 = realWorldMap[i11];
      beginShape(TRIANGLES);  
      if(texture==true){
        texture(rgbImage);}
      else{
        texture(textures);} // llenar el triangulo con una textura
      if ((p00.z > 0) && (p01.z > 0) && (p10.z > 0) && //reviza por valores no validos
          (abs(p00.z-p01.z) < max_edge_len) && (abs(p10.z-p01.z) < max_edge_len)) { //busca la longitud del borde
            vertex(p00.x,p00.y,p00.z, x, y); // x,y,x,u,v   posicion y referencia de la textura
            vertex(p01.x,p01.y,p01.z, x, y+steps);
            vertex(p10.x,p10.y,p10.z, x+steps, y);
          }
      if ((p11.z > 0) && (p01.z > 0) && (p10.z > 0) &&
          (abs(p11.z-p01.z) < 50) && (abs(p10.z-p01.z) < max_edge_len)) {
            vertex(p01.x,p01.y,p01.z, x, y+steps);
            vertex(p11.x,p11.y,p11.z, x+steps, y+steps);
            vertex(p10.x,p10.y,p10.z, x+steps, y);
          }
      endShape();
   }
  }
 
}



void keyPressed()
{

 switch(key)
  {
    case '+': if (steps < 9) steps++; break;
    case '-': if (steps > 1) steps--; break;
    case '5': texture=true; break;
    case '6': texture=false; break;
  }
 switch(keyCode)
  {
    case LEFT:
      rotY += 0.1f;
      break;
    case RIGHT:
      // zoom out
      rotY -= 0.1f;
      break;
    case UP:
      if(keyEvent.isShiftDown())
        zoomF += 0.01f;
      else
        rotX += 0.1f;
      break;
    case DOWN:
      if(keyEvent.isShiftDown())
      {
        zoomF -= 0.01f;
        if(zoomF < 0.01)
          zoomF = 0.01;
      }
      else
        rotX -= 0.1f;
      break;
  }
}
