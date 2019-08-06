/*-------------------------------------------------------------------------------------
Creative Coding
Summer 2 2019
Arielle Bishop
Project 2
-------------------------------------------------------------------------------------*/
import peasy.*;

static final int MAX_NGON = 16;
static final float GROWTH_RATE = 1.2;
static final float RADIUS = 50;
final color strokeColor = color(255);
int hue = 0; 
color fillColor = color(hue, 100, 100, 20);
int frameStep = MAX_NGON;
ArrayList<CompoundPolyShape> shapes = new ArrayList();
boolean pause = false;
PeasyCam cam;

void setup() {
  fullScreen(P2D);
  cam = new PeasyCam(this, 100);
  background(0);
  frameRate(20);
  colorMode(HSB);
}      

void draw() {
  if (frameStep < MAX_NGON) {
    CompoundPolyShape compoundShape = shapes.get(shapes.size() - 1);
    compoundShape.increment();
    ArrayList<PShape> innerShapes = compoundShape.getShapes();
    PShape newShape = innerShapes.get(innerShapes.size() - 1);
    shape(newShape);
    frameStep++;
  } else if (!pause) {
    clear();
    for (CompoundPolyShape compoundShape : shapes) {
        float angle = radians(frameCount % 360);
        compoundShape.rotateChildren(angle);
      for (PShape shape : compoundShape.getShapes()) {
        shape(shape);
      }
    }
  }
}

void mouseClicked() {
  shapes.add(new CompoundPolyShape(mouseX, mouseY, RADIUS, 3));
  frameStep = 0;
}

void keyPressed() {
  switch (keyCode) {
    case LEFT: {
      hue--;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case RIGHT: {
      hue++;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case UP: {
      break;
    }
    case DOWN: {
      break;
    }
  }
  switch (key) {
    case ' ': {
      pause = true;
      break;
    }
    case BACKSPACE: {
      clearAll();
      break;
    }
    case DELETE: {
      clearAll();
      break;
    }
    case '1': {
      hue = 0;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '2': {
      hue = 10;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '3': {
      hue = 20;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '4': {
      hue = 30;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '5': {
      hue = 40;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '6': {
      hue = 50;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '7': {
      hue = 60;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '8': {
      hue = 70;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '9': {
      hue = 80;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
    case '0': {
      hue = 90;
      fillColor = color(hue, 100, 100, 20);
      break;
    }
  }
}

void keyReleased() {
  switch (key) {
    case ' ': {
      pause = false;
      break;
    }
  }
}

void clearAll() {
  clear();
  shapes = new ArrayList();
  frameStep = MAX_NGON;
}

class CompoundPolyShape {
  private final int x;
  private final int y;
  private final float r;
  private int size;
  private ArrayList<PShape> shapes = new ArrayList();
  
  CompoundPolyShape(int x, int y, float r, int size) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.size = size;
    
    for (int i = size; i < GROWTH_RATE; i++) {
      r = r * GROWTH_RATE;
    }
    this.shapes.add(this.build(x, y, r, size));
  }
  
  private PShape build(int x, int y, float r, int n) {
    PShape group = createShape(GROUP);
        
    // EXIT CONDITION
    if (n < 3) {
      println("exiting baseShape");
      return group;
    }
    
    println("beginning baseShape where x=" + x + ", y=" + y + ", r=" + r + ", n=" + n);

    group.addChild(build(x, y, r * GROWTH_RATE, n - 1));
    
    PShape poly = polygon(x, y, r, n);
    poly.setStroke(strokeColor);
    poly.setFill(fillColor);
    group.addChild(poly);
    
    return group;
  }
  
  ArrayList<PShape> getShapes() {
   return this.shapes; 
  }
  
  void increment() {
    this.size++;
    float radius = this.r;
    for (int i = size; i < GROWTH_RATE; i++) {
      radius = radius * GROWTH_RATE;
    }
    this.shapes.add(this.build(x, y, r, size));
  }
  
  void rotateChildren(float angle) {
    for (PShape shape : this.shapes) {
      rotateChild(angle, shape, 0);
    }
  }
  
  private void rotateChild(float angle, PShape shape, int acc) {
    for (int i = 0; i < shape.getChildCount(); i++) {
      PShape child = shape.getChild(i);
      if (child.getChildCount() > 0) {
        rotateChild(angle, child, acc + 1);
      } else {
        child.translate(-r, -r);
        child.rotate((angle * acc) % (TWO_PI / 25));
      }
    }
  }
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
