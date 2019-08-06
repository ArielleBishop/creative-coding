void setup(){
  fullScreen();
  background(0);
  frameRate(24);
}

void draw(){
  int numLines = mouseX/35;
  stroke(mouseY / 9);
  
  for(int i = 0; i < numLines; i++){
    line(width / 2, height / 2, random(width), random(height));
  }
}
