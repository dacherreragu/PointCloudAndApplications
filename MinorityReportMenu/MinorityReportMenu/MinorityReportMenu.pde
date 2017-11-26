import SimpleOpenNI.*;
SimpleOpenNI kinect;
int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;
float image1X;
float image1Y;
// declarar variables para
// escala de imagen y dimensiones
float image1scale;
int image1width = 100;
int image1height = 100;
float image2X;
float image2Y;
float image2scale;
int image2width = 100;
int image2height = 100;
float image3X;
float image3Y;
float image3scale;
int image3width = 100;
int image3height = 100;
// realizar seguimiento de qué imagen se está moviendo
int currentImage = 1;
 // declarar variables
// para almacenar las imagenes
PImage image1;
PImage image2;
PImage image3;
void setup()
{
 size(640, 480);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 // cargar las imágenes
 image1 = loadImage("jojo.png");
 image2 = loadImage("jojo2.jpg");
 image3 = loadImage("jojo3.jpg");
}
void draw(){
 background(0);
 closestValue = 8000;
 kinect.update();
 int[] depthValues = kinect.depthMap();
 for(int y = 0; y < 480; y++){
 for(int x = 0; x < 640; x++){
 int reversedX = 640-x-1;
 int i = reversedX + y * 640;
 int currentDepthValue = depthValues[i];
 if(currentDepthValue > 610 && currentDepthValue < 1525
 && currentDepthValue < closestValue){
 closestValue = currentDepthValue;
 closestX = x;
 closestY = y;
 }
 }
 }
 float interpolatedX = lerp(lastX, closestX, 0.3);
 float interpolatedY = lerp(lastY, closestY, 0.3);
 // seleccionar la imagen actual
 switch(currentImage){ 
 case 1:
 // actualizar sus coordenadas x-y
 // dese las coordenadas interpoladas
 image1X = interpolatedX; 
 image1Y = interpolatedY;
 // actualziar su escala
 // desde closestValue
 // 0 = invisible, 4 = tamaño cuádruple
 image1scale = map(closestValue, 610,1525, 0,4);
 break;
 case 2:
 image2X = interpolatedX;
 image2Y = interpolatedY;
 image2scale = map(closestValue, 610,1525, 0,4);
 break;
 case 3:
 image3X = interpolatedX;
 image3Y = interpolatedY;
 image3scale = map(closestValue, 610,1525, 0,4);
 break;
 }
 // dibujar toda la imagen en la pantalla
 // usar las variables de escala guardadas para establecer sus dimensiones
 image(image1,image1X,image1Y,
 image1width * image1scale, image1height * image1scale); 
 image(image2,image2X,image2Y,
 image2width * image2scale, image2height * image2scale);
 image(image3,image3X,image3Y,
 image3width * image3scale, image3height * image3scale);
 lastX = interpolatedX;
 lastY = interpolatedY;
}
void mousePressed(){
 // aumentar la imagen actual
 currentImage++;
 // pero volver a la imagen 0
 // si se llega a 3
 if(currentImage > 3){
 currentImage = 1;
 }
 println(currentImage);
}