import SimpleOpenNI.*;


SimpleOpenNI kinect;
float        zoomF =0.5f;
  float        rotX = radians(180);  // por defecto, rotar la escena 180 grados sobre el eje x, 
                                   // los datos de openni vienen al revés.
float        rotY = radians(0);

int         steps           = 3; //para acelerar el dibujo, hacerlo cada tercer punto
float       strokeW         = 0.6;
boolean texture;
PVector   s_rwp = new PVector(); // standarized realWorldPoint;
int       kdh;
int       kdw;
int       max_edge_len = 50;
float     strokeWgt = 0.4;
int       i00, i01, i10, i11; // índices
PVector   p00, p10, p01, p11; // puntos
PVector   k_rwp; // kinect realWorldPoint;

  
void setup()
{
  size(1024,768,OPENGL);

  //kinect = new SimpleOpenNI(this,SimpleOpenNI.RUN_MODE_SINGLE_THREADED);
  kinect = new SimpleOpenNI(this);
  // desactivar espejo
  kinect.setMirror(false);
  // habilitar la generación de depthMap 
  if(kinect.enableDepth() == false) {
     println("No se puede abrir el depthMap, ¡tal vez la cámara no está conectada!"); 
     exit();     return;
  }
  if(kinect.enableRGB() == false) {
     println("No se puede abrir el rgbMap, ¡tal vez la cámara no está conectada o no hay rgbSensor!"); 
     exit();     return;
  }
  // alinear datos de profundidad a datos de imagen
  kinect.alternativeViewPointDepthToImage();
  
  kdh = kinect.depthHeight();
  kdw = kinect.depthWidth();

  
  smooth();
  stroke(0);
  perspective(radians(45),
              float(width)/float(height),
              10,150000);
}

void draw()
{
   kinect.update();
   PImage    rgbImage = kinect.rgbImage();
   PVector[] realWorldMap = kinect.depthMapRealWorld();


  background(0,0,0);
  
  // establecer la posición de la escena
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  
  if (strokeWgt == 0) noStroke();
  else strokeWeight(strokeWgt);
  

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
        texture(rgbImage);} // llenar el triángulo con la textura rgb
      if ((p00.z > 0) && (p01.z > 0) && (p10.z > 0) && // revisar para valores no válidos
          (abs(p00.z-p01.z) < max_edge_len) && (abs(p10.z-p01.z) < max_edge_len)) { // revisar para la longitud del borde
            vertex(p00.x,p00.y,p00.z, x, y); // x,y,x,u,v   posición + referencia de textura
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