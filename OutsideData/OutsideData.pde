/*  Arielle Bishop
 Creative Coding
 Summer 2 2019    */

import at.mukprojects.imageloader.*;
import at.mukprojects.imageloader.google.*;
import at.mukprojects.imageloader.image.*;
import interfascia.*;
import java.util.Arrays;

GUIController controller;
IFTextField searchField;
IFLabel label;
ImageLoader loader;
ImageList list;
PImage img = null;
static final String API_KEY = System.getenv("CUSTOM_SEARCH_KEY");
String searchTerm = " ";
int modeIndex = 0;
Mode[] modes = new Mode[]{ Mode.ellipse, Mode.rect, Mode.triangle, Mode.line };
int renderDistance = 50;
boolean showGUI = true;

void setup() {
  fullScreen();
  background(255);
  ellipseMode(CORNER);
  loader = new GoogleLoader(this, API_KEY);
  list = new ImageList();

  controller = new GUIController(this);
  searchField = new IFTextField("Text Field", 25, 30, 150);
  label = new IFLabel("Current search term: " + searchTerm, 25, 10);
  controller.add(searchField);
  controller.add(label);
  searchField.addActionListener(this);
}

void draw() {
  if (list.size() > 0) {
    if (img == null) {
      img = list.getRandom().getImg();
      modeIndex = floor(random(1, modes.length));
    } else {
      noLoop();
      background(255);

      img.loadPixels();
      for (int posX = 0; posX < width; posX += renderDistance) {
        for (int posY = 0; posY < height; posY += renderDistance) {
          int imgX = round(map(posX, 0, width, 0, img.width));
          int imgY = round(map(posY, 0, height, 0, img.height));

          color c = color(img.get(imgX, imgY));
          stroke(c);
          color greyscale = round(red(c) * 0.222 + green(c) * 0.707 + blue(c) * 0.071);
          float weight = map(greyscale, 0, 255, 30, 0.1);
          strokeWeight(weight);

          Mode mode = modes[modeIndex];
          switch (mode) {
            case ellipse:
              ellipse(posX, posY, 2 * renderDistance, 2 * renderDistance);
              break;
            case rect:
              rect(posX, posY, posX + renderDistance, posY + renderDistance);
              break;
            case triangle:
              triangle(posX, posY, posX + (2 * renderDistance), posY + (2 * renderDistance), posX + (2 * renderDistance), posY - (2 * renderDistance));
              break;
            case line:
              line(posX, posY, posX + renderDistance, posY + renderDistance);
              break;
            }
        }
      }
    }
  }
}

enum Mode {
  ellipse, rect, triangle, line;
}

void keyReleased() {
  switch (keyCode) {
    case UP:
      renderDistance += 5;
      loop();
      break;
    case DOWN:
      if (renderDistance > 5) {
        renderDistance -= 5;
      }
      loop();
      break;
    case LEFT:
      if (modeIndex == 0) {
        modeIndex = modes.length - 1;
      } else {
        modeIndex--;
      }
      loop();
      break;
    case RIGHT:
      if (modeIndex == modes.length - 1) {
        modeIndex = 0;
      } else {
        modeIndex++;
      }
      loop();
      break;
    case ENTER:
      img = null;
      loop();
      break;
  }
}

void actionPerformed(GUIEvent event) {
  if (event.getSource() == searchField) {
    if (event.getMessage().equals("Completed")) {
      loop();
      img = null;
      searchTerm = searchField.getValue();
      try {
        list = loader.start(searchTerm, false, 60 * 1000);
        searchField.setValue("");
        label.setLabel("Current search term: " + searchTerm);
      } 
      catch (Exception ex) {
        println(ex.getMessage());
        searchField.setValue("");
        label.setLabel("Some error occured.");
      }
    }
  }
}
