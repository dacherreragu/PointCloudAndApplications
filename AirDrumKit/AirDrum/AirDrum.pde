import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;
SimpleOpenNI kinect;
float rotation = 0;
// dos objetos AudioSnippet
Minim minim;
AudioSnippet kick; 
AudioSnippet snare;
// declarar los dos objetos hotpoint
Hotpoint snareTrigger; 
Hotpoint kickTrigger;
float s = 1;
void setup() {
 size(1024, 768, OPENGL);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 minim = new Minim(this);
 // cargar ambos archivos de audio
 snare = minim.loadSnippet("hat.wav"); 
 kick = minim.loadSnippet("kick.wav");
 // inicializar hotpoints con sus orígines (x,y,z) y su tamaño
 snareTrigger = new Hotpoint(200, 0, 600, 150); 
 kickTrigger = new Hotpoint(-200, 0, 600, 150);
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
 kickTrigger.check(currentPoint);
 point(currentPoint.x, currentPoint.y, currentPoint.z);
 }
 println(snareTrigger.pointsIncluded); 
 if(snareTrigger.isHit()) { 
 snare.play();
 }
 if(!snare.isPlaying()) {
 snare.rewind();
 }
 if (kickTrigger.isHit()) {
 kick.play();
 }
 if(!kick.isPlaying()) {
 kick.rewind();
 }
 // mostrar cada hotpoint y borrar sus puntos
 snareTrigger.draw(); 
 snareTrigger.clear();
 kickTrigger.draw(); 
 kickTrigger.clear();
}
void stop()
{
 // asegurarse de cerrar
 // ambos objetos AudioPlayer
 kick.close();
 snare.close();
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