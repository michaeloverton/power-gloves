import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
import themidibus.*;
import controlP5.*;

// MIDI vars.
MidiBus bus;
boolean noteOn = false; // is note on or off
boolean playChord = false; // should we play a chord? determined by roll
ArrayList<Integer> notesOn = new ArrayList<Integer>(); // Notes being played right now.

// Music theory.
int keyAnchor = 36; // C1 by default TODO: MAKE THIS CONFIGURABLE.
int[] majorIntervals = { 2, 2, 1, 2, 2, 2, 1 };
int[] chord = { 2, 2 };
ArrayList<Integer> keyNotes = new ArrayList<Integer>(); // The notes in our key, calculated in setup.
int note; // note we will play by default.
ArrayList<Integer> notesToPlay = new ArrayList<Integer>();

// Serial vars.
Serial leftPort;
Serial rightPort;
String data="";
float roll, pitch;

// GUI vars.
ControlP5 cp5;
Button powerButton;
Button debugButton;
Textlabel currentKeyLabel;
ListBox keyList;

// Master controls.
boolean makeSound = true;
boolean debugMode = true;

void setup() {
  // List all the available serial ports:
  printArray(Serial.list());

  // Open the ports at 9600 BAUD (BAUD set in Arduino).
  leftPort = new Serial(this, "/dev/cu.usbserial-AB0L9VBG", 9600);
  leftPort.bufferUntil('\n');
    
  rightPort = new Serial(this, "/dev/cu.usbserial-AB0L9FSK", 9600);
  rightPort.bufferUntil('\n');
    
  // Set up MIDI.
  // MidiBus.list();
  bus = new MidiBus(this, "Bus 1", "Bus 1");
  
  // Calculate the notes in our key - 7 octaves.
  note = keyAnchor; // set the default note first.
  int currentNote = keyAnchor;
  keyNotes.add(keyAnchor);
  for(int i=0; i<14; i++) { // WHY IS THIS 14??
    for(int interval : majorIntervals) {
      currentNote = currentNote + interval;
      keyNotes.add(currentNote);
    }
    i++;
  }
  printArray(keyNotes);
  
  // GUI setup.
  // Set up GUI.
  size(400,600);
  noStroke();
  cp5 = new ControlP5(this);
  
  // Turn sound-making on or off.
  powerButton = cp5.addButton("power")
    .setPosition(100,0)
    .setSize(200,19)
    .setColorBackground(color(0,160,100))
    ;
  // Debug
  debugButton = cp5.addButton("debug")
    .setPosition(100,25)
    .setSize(200,19)
    .setColorBackground(color(0,160,100))
    ;
  // Kill switch for cutting MIDI.
  cp5.addButton("kill")
    .setPosition(100,50)
    .setSize(200,19)
    .setColorBackground(color(0,60,100))
    ;
    
  keyList = cp5.addListBox("select key")
   .setPosition(100, 140)
   .setSize(120, 140)
   .setItemHeight(15)
   .setBarHeight(15)
   .setColorBackground(color(255, 128))
   .setColorActive(color(0))
   .setColorForeground(color(255, 100,0))
   ;
   
  keyList.addItem("C", 0);
  keyList.addItem("C#", 1);
  keyList.addItem("D", 2);
  keyList.addItem("D#", 3);
  keyList.addItem("E", 4);
  keyList.addItem("F", 5);
  
  currentKeyLabel = cp5.addTextlabel("keyLabel")
    .setText("KEY: C")
    .setPosition(100,120)
    ;
    
}

void draw() {
  background(33);
}

// Read data from the Serial Port
void serialEvent (Serial port) { 
  // Reads data from the Serial Port up to the character '.'
  data = port.readStringUntil('\n');
  
  // if you got any bytes other than the linefeed:
  if (data != null && makeSound) {
    data = trim(data);
    
    // Split the string at "/"
    String items[] = split(data, '/');
    if (items.length > 1) {
      // Get roll and pitch in degrees.
      roll = float(items[0]);
      pitch = float(items[1]);
      
      if (port == leftPort) { // Left hand note trigger.
        if (debugMode) {
          println("LEFT PORT: roll:"+roll+", pitch:"+pitch);
        }
        
        if(pitch > 0 && !noteOn) {
          noteOn = true;
          bus.sendNoteOn(1, note, 100);
          notesOn.add(note);
        } else if (pitch <= 0 && noteOn) {
          killNotes();
          noteOn = false;
        }
      }
      else { // Right hand note/chord select.
        if (debugMode) {
          println("RIGHT PORT: roll:"+roll+", pitch:"+pitch);
        }
        
        // Reverse the pitch so that we choose low notes when pointing down.
//        int reversedPitch = -1 *(180 - (int(pitch) + 90));
        
        // Determine note.
        int noteIndex = (int(pitch) + 90)/4;
//        int noteIndex = reversedPitch/4;
        note = keyNotes.get(noteIndex);
        
        // Determine if we should play chord.
        /*
        if (roll < 0) {
          playChord = true;
        } else {
          playChord = false;
        }
        */
      }
      
    }
  }
}

// Send MIDI signals and receive accelerometer data.
// Essentially starts/stops everything.
public void power(int theValue) {
  makeSound = !makeSound;
  if (makeSound) {
    powerButton.setColorBackground(color(0,160,100));
  } else {
    powerButton.setColorBackground(color(0,60,100));
  }
  
}

// Activate/deactivate debug mode.
public void debug(int theValue) {
  debugMode = !debugMode;
  if (debugMode) {
    debugButton.setColorBackground(color(0,160,100));
  } else {
    debugButton.setColorBackground(color(0,60,100));
  }
}

// Kill all MIDI signals.
public void kill(int theValue) {
  bus.sendControllerChange(1, 120, 100); // Send a controllerChange
}

void controlEvent(ControlEvent theEvent) {
  // Detect key menu dropdown changes.
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  }
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void killNotes() {
  for(int note : notesOn) {
    bus.sendNoteOff(1, note, 0);
  }
}
