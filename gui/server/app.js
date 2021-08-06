const express = require("express");
const midi = require("midi");
var easymidi = require("easymidi");

// Create Express app
const app = express();

// Hacked delay function
const delay = (milliseconds) => {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
};

// A sample route
app.get("/", (req, res) => {
  var output = new easymidi.Output("Mac Internal MIDI Bus 1");

  output.send("noteon", {
    note: 64,
    velocity: 127,
    channel: 1,
  });

  delay(200);

  output.send("noteoff", {
    note: 64,
    velocity: 0,
    channel: 1,
  });
});

// Start the Express server
app.listen(4000, () => console.log("Listening for MIDI updates from "));
