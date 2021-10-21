{ writeTextFile, linkFarm }:

linkFarm "index" [
  { name = "index.html"; path = ./index.html; }
]
