// Methodology for palettes from https://iquilezles.org/www/articles/palettes/palettes.htm

let width = 1080;
let height = 1080;
let subdivisions = 25;
let a, b, c, d;
let xMod = 0;
let yMod = 0;

function setup() {
  createCanvas(width, height);
  colorMode(RGB);
  noFill();
  noStroke();
  noiseDetail(1, 0.1);
  
  a = new p5.Vector(0.5, 0.5, 0.5);
  b = new p5.Vector(0.5, 0.5, 0.5);
  c = new p5.Vector(1.0, 1.0, 1.0);
  d = new p5.Vector(0.0, 0.1, 0.2);
}

function draw() {
  xMod += 0.01;
  yMod += 0.01;
  clear();
  
  for (let i = 0; i < subdivisions; i++) {
    for (let j = 0; j < subdivisions; j++) {
      let x = i / subdivisions * width;
      let y = j / subdivisions * height;
      let w = width / subdivisions;
      let h = height / subdivisions;
      let n = noise(x + xMod, y + yMod);
      n = pow(n+1, 1.5) - 1;

      let from = palette(n);
      let to;
      if (random() > 0.5) {
        to = palette((n + 0.05) % 1);
      } else {
        to = palette((n + 0.05) % 1);
      }
      fillGradient(x, y, w, h, from, to);
    }
  }
}

function palette(t) {   
  // color(t) = a + b • cos[2π(c•t+d)]
  let vectorOut;
  vectorOut = p5.Vector.mult(c, t);
  vectorOut.add(d);
  vectorOut.mult(2 * Math.PI);
  vectorOut.set(cos(vectorOut.x), cos(vectorOut.y), cos(vectorOut.z));
  vectorOut.cross(b);
  vectorOut.add(a);
  
  return color(vectorOut.x * 255, vectorOut.y * 255, vectorOut.z * 255);
}

function fillGradient(x, y, w, h, c1, c2) {
  for (let i = y; i <= y + h; i++) {
    let inter = map(i, y, y + h, 0, 1);
    let c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x + w, i);
  }
}

function keyPressed() {
  // Keys 1-7 provide preset palettes while 8-0 randomly generate new ones
  switch(keyCode) {
    case(49): // 1
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(0.0, 0.33, 0.67);
      break;
    case(50): // 2
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(0.0, 0.1, 0.2);
      break;
    case(51): // 3
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(0.3, 0.2, 0.2);
      break;
    case(52): // 4
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 0.5);
      d = new p5.Vector(0.8, 0.9, 0.3);
      break;
    case(53): // 5
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 0.7, 0.4);
      d = new p5.Vector(0.0, 0.15, 0.2);
      break;
    case(54): // 6
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(2.0, 1.0, 0.0);
      d = new p5.Vector(0.5, 0.2, 0.25);
      break;
    case(55): // 7
      a = new p5.Vector(0.8, 0.5, 0.4);
      b = new p5.Vector(0.2, 0.4, 0.2);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(0.0, 0.25, 0.25);
      break;
    case(56): // 8
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 0.67, 0.33);
      d = new p5.Vector(random(), random(), random());
      break;
    case(57): // 9
      let r = random();
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(pow(3, r), sq(r), r);
      break;
    case(48): // 0
      a = new p5.Vector(0.5, 0.5, 0.5);
      b = new p5.Vector(0.5, 0.5, 0.5);
      c = new p5.Vector(1.0, 1.0, 1.0);
      d = new p5.Vector(random(), random(), random());
      break;
  }
  draw();
}
