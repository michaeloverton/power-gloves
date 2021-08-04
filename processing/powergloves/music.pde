// Music-related functions and vars.

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

// Calculate the notes in our key - ?? octaves.
void calculateKeyNotes() {
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
}
