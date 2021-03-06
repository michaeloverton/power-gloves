import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
import themidibus.*;
import controlP5.*;

// Serial vars.
Serial leftPort;
Serial rightPort;
String data="";
float roll, pitch;
int BAUD = 19200;

// Master controls.
boolean makeSound = true;
boolean debugMode = false;

void setup() {
  // List all the available serial ports:
  printArray(Serial.list());

  // Open the ports at given BAUD (BAUD set in Arduino).
//  leftPort = new Serial(this, "/dev/cu.usbserial-AB0L9VBG", BAUD);
//  leftPort.bufferUntil('\n');
//    
//  rightPort = new Serial(this, "/dev/cu.usbserial-AB0L9FSK", BAUD);
//  rightPort.bufferUntil('\n');
    
  // Set up MIDI.
  // MidiBus.list();
  bus = new MidiBus(this, "Bus 1", "Bus 1");
  
  calculateKeyNotes();
  
  setupGUI();
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
      String hand = items[0]; // R or L - which hand this accelerometer corresponds to.
      roll = float(items[1]);
      pitch = float(items[2]);
            
      if (hand.equals("L")) { // Left hand note trigger.
        if (debugMode) {
          println("LEFT PORT: roll:"+roll+", pitch:"+pitch);
        }
        
        if(pitch > 0 && !noteOn) {
          noteOn = true;
          bus.sendNoteOn(1, note, 100);
          notesOn.add(note);
          println("note on");
        } else if (pitch <= 0 && noteOn) {
          killNotes();
          noteOn = false;
          println("note off");
        }
      }
      else { // Right hand note/chord select.
        if (debugMode) {
          println("RIGHT PORT: roll:"+roll+", pitch:"+pitch);
        }
        
        // Determine note.
        // Reverse the pitch so that we choose low notes when pointing down.
        int noteIndex = (180-(int(pitch) + 90))/12;
//        int noteIndex = (int(pitch) + 90)/12;
        note = keyNotes.get(noteIndex);
      }
      
    }
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
