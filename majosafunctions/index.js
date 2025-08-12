const functions = require("firebase-functions");

exports.helloMajosa = functions.https.onRequest((req, res) => {
  res.send("Hello from Majosa Functions!");
});
