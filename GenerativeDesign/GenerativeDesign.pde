/*-------------------------------------------------------------------------------------
 Creative Coding
 Summer 2 2019
 Arielle Bishop
 Project 3
 -------------------------------------------------------------------------------------*/
final float THRESHOLD_UPPER_LIMIT = 0.7;
final float THRESHOLD_LOWER_LIMIT = 0.2;
int radius;
float threshold;
float thresholdStep;
float diff = 1;  
int upperCount;
int lowerCount;

void setup() {
  fullScreen();
  frameRate(30);
  colorMode(HSB);
  noStroke();
  threshold = 0.45;
  thresholdStep = 0.001;
  radius = width / 55;
}

void draw() {
  upperCount = 0;
  lowerCount = 0;

  if (threshold > THRESHOLD_UPPER_LIMIT || threshold < THRESHOLD_LOWER_LIMIT) {
    thresholdStep *= -1;
  }
  threshold += thresholdStep;

  diff += 0.001;

  float step = 0.865;
  float initY = 0;
  for (float x = 0; x < width + radius; x += radius * 1.505) {
    initY += (step * radius); 
    initY = initY % ((step * 2) * radius);
    for (float y = initY; y < height + radius; y += radius * 1.73) {
      PShape poly = polygon(x, y, radius, 6);
      float noise = noise(x, y);
      float hue = getHue(noise);
      color fillColor = color(hue, 120, 200, 255);
      poly.setFill(fillColor);
      shape(poly);
    }
  }
  println("lowerCount = " + lowerCount);
  println("upperCount = " + upperCount);
  println("threshold = " + threshold);
  println("diff = " + diff);
}

float getHue(float noise) {
  float hue;
  if (noise <= threshold) {
    lowerCount++;
    hue = noise - sqrt(diff);
    while (hue < 0) {
      hue += threshold;
    }
    hue = hue * (255 * (1 - threshold));
  } else {
    upperCount++;
    hue = noise + sqrt(diff);
    while (hue > 1) {
      hue -= threshold;
    }    
    hue = (hue * (255 * threshold));
  }
  return hue;
}

PShape polygon(float x, float y, float radius, int n) {
  float angle = TWO_PI / n;
  PShape poly = createShape();
  poly.beginShape();
  for (float a = 0; a <= TWO_PI + (TWO_PI / n); a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    poly.vertex(sx, sy);
  }
  poly.endShape();
  return poly;
}

void keyPressed() {
  if (key == ' ') {
    saveFrame("hex_t-" + threshold + "_d-" + diff + ".jpg");
  }
}
