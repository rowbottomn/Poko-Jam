import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

int numFiles = 6;

Minim minim;

AudioPlayer[] players = new AudioPlayer[numFiles];
AudioMetaData data ;
AudioPlayer current;


VolumeControl volumeControl;
PVector[] bPos;
boolean[] pressed;
PVector mouse;
PVector bSize;
Dial volume;
int newSelection = -1;
int activeButton = -1; 

void setup() {
  size (800, 600);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  minim = new Minim(this);
  mouse = new PVector();
  volume = new Dial(0, 15, 15, false);
  volume.setTitle("VOLUME");
 // volume.toggleValueDisplay();

  bPos = new PVector[numFiles];
  pressed = new boolean[numFiles];
  bSize = new PVector(100, 50);

  for (int i = 0; i < bPos.length; i ++ ) {
    bPos[i] = new PVector(200 + i*bSize.x*1.10, 400);
    rect(bPos[i].x, bPos[i].y, bSize.x, bSize.y);
 //   pressed[i] = false;
    players[i] = minim.loadFile("song"+i+".mp3");
  }
   volumeControl = new VolumeControl(players, volume);
}

void drawButtons() {
  for (int i = 0; i < bPos.length; i ++ ) {
    if (players[i].isPlaying()){
       fill(100);
    }
    else {
       fill(255);        
    }
    print(bPos[i]);
    rect(bPos[i].x, bPos[i].y, 50, 30, 8);
  }
}

int checkButtons() {
  
    for (int i = 0; i <  bPos.length; i++) {
      if (mousePressed&&abs(mouse.x - bPos[i].x)< bSize.x/2&& abs(mouse.y - bPos[i].y)< bSize.y/2) {
        return i;
      }
    }
  
  return -1;
}

void playSongs(){
   if (activeButton != newSelection && newSelection != -1) {//new selection?
    //pause the current play 
    if (current != null) {
      current.pause();
      current.rewind();//do i need this?
    }      
    current = players[newSelection];
  
 //   println("Volume before: " + current.volume());
    data = current.getMetaData();
   // current.setGain(volume.getSetting()/(float)volume.numDivisions);
  //  println("Playing"+ data.title()); 
    current.play();
    
    activeButton = newSelection;
  }

}



void draw() {
  background(50);
  mouse.set(mouseX, mouseY);  
  newSelection = checkButtons();
  volume.update(mouse);
  
  playSongs();
    volumeControl.update();
  drawButtons();
}
