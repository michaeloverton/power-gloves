// app.js
const express = require("express");

// Create Express app
const app = express();

// A sample route
app.get("/", (req, res) => res.send("Hello World!"));

// Start the Express server
app.listen(4000, () => console.log("Server running on port 4000!"));
