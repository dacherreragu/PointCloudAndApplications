import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;
SimpleOpenNI kinect;
float rotation = 0;
// cuatro objetos AudioSnippet
Minim minim;
AudioSnippet kick; 
AudioSnippet snare;
AudioSnippet kick1; 
AudioSnippet snare1;
// declarar los dos objetos hotpoint
Hotpoint snareTrigger; 
Hotpoint kickTrigger;
Hotpoint snareTrigger1;
Hotpoint kickTrigger1;
float s = 1;
void setup() {
 size(1024, 768, OPENGL);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 minim = new Minim(this);
 // cargar ambos archivos de audio
 snare = minim.loadSnippet("kick.wav"); 
 kick = minim.loadSnippet("kick.wav");
 snare1 = minim.loadSnippet("hat.wav"); 
 kick1 = minim.loadSnippet("hat.wav");
 // inicializar hotpoints con sus orígines (x,y,z) y su tamaño
 snareTrigger = new Hotpoint(200, 0, 600, 150); 
 kickTrigger = new Hotpoint(-200, 0, 600, 150);
 snareTrigger1 = new Hotpoint(400, -150, 600, 150); 
 kickTrigger1 = new Hotpoint(-400, -150, 600, 150);
}
void draw() {
 background(0);
 kinect.update();
 translate(width/2, height/2, -1000);
 rotateX(radians(180));
 translate(0, 0, 1400);
 rotateY(radians(map(mouseX, 0, width, -180, 180)));
 translate(0, 0, s*-1000);
 scale(s);
 stroke(255);
 PVector[] depthPoints = kinect.depthMapRealWorld();
  for (int i = 0; i < depthPoints.length; i+=10) {
 PVector currentPoint = depthPoints[i];
 // revisar cada hotpoint para ver si incluye el punto actual (currentPoint)
 snareTrigger.check(currentPoint); 
 snareTrigger1.check(currentPoint); 
 kickTrigger.check(currentPoint);
 kickTrigger1.check(currentPoint);
 point(currentPoint.x, currentPoint.y, currentPoint.z);
 }
 println(snareTrigger.pointsIncluded); 
 if(snareTrigger.isHit()) { 
 snare.play();
 }
 if(!snare.isPlaying()) {
 snare.rewind();
 }
 if(snareTrigger1.isHit()) { 
 snare1.play();
 }
 if(!snare1.isPlaying()) {
 snare1.rewind();
 }
 if (kickTrigger.isHit()) {
 kick.play();
 }
 if(!kick.isPlaying()) {
 kick.rewind();
 }
 if (kickTrigger1.isHit()) {
 kick1.play();
 }
 if(!kick.isPlaying()) {
 kick1.rewind();
 }
 // mostrar cada hotpoint y borrar sus puntos
 snareTrigger.draw(); 
 snareTrigger.clear();
 kickTrigger.draw(); 
 kickTrigger.clear();
 snareTrigger1.draw(); 
 snareTrigger1.clear();
 kickTrigger1.draw(); 
 kickTrigger1.clear();
}
void stop()
{
 // asegurarse de cerrar
 // ambos objetos AudioPlayer
 kick.close();
 snare.close();
 kick1.close();
 snare1.close();
 minim.stop();
 super.stop();
}
void keyPressed() {
 if (keyCode == 38) {
 s = s + 0.01;
 }
 if (keyCode == 40) {
 s = s - 0.01;
 }
}
