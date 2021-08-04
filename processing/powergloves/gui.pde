// GUI-specific functions.

// Global GUI vars.
ControlP5 cp5;
Button powerButton;
Button debugButton;
Textlabel currentKeyLabel;
ListBox keyList;

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

void setupGUI() {
  // GUI setup.
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
