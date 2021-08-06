const express = require("express");
const http = require("http");
const url = require("url");
const midi = require("midi");
var easymidi = require("easymidi");

// Create Express app
const app = express();

const midiOutputName = "Mac Internal MIDI Bus 1";
const output = new easymidi.Output(midiOutputName);

let rootNote = 60;
let octaves = 2;

// Hacked delay function
const delay = (milliseconds) => {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
};

// A sample route
app.get("/play", (req, res) => {
  console.log("playing note");

  for (var i = 0; i < 1000; i++) {
    output.send("noteon", {
      note: 64,
      velocity: 127,
      channel: 1,
    });

    delay(20);

    output.send("noteoff", {
      note: 64,
      velocity: 0,
      channel: 1,
    });
  }
});

app.get("/updateRoot", (req, res) => {
  const queryObject = url.parse(req.url, true).query;
  rootNote = queryObject.root;
  console.log(rootNote);
});

// Start the Express server
app.listen(4000, () => console.log("Listening for MIDI updates from "));
