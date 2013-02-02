
// IMPORTS

import apwidgets.*;
import ketai.sensors.*;

import android.content.Context;
import android.app.Activity;
import android.os.Bundle;
import android.os.Environment;

import android.app.Notification;
import android.app.NotificationManager;

// DECLARATIONS

OscP5 osc;
NetAddress computer;

NotificationManager gNotificationManager;  
Notification gNotification; 

APWidgetContainer widgetContainer; 
APEditText tF_IP;
APButton Apply;
APButton Clear;
APButton Save;

KetaiSensor sensor; 


// VARIABLES

PImage logo;
PGraphics pg;

int state; // Menu State

float boxX, boxR, boxG, boxB; // 
float sw, sh, sw1, sw2, sw3;
float sendX, sendY;
boolean touched = false;

String[] fontList;
PFont androidFont;
float text_size;

long[] gVibrate = {0, 50, 0, 50, 0, 50}; // Vibration Pattern

String dirName; // Folder Path

int port = 11000;
String ip = "";

float r = 255;
float g = 255;
float b = 255;

PVector accelerometer = new PVector();  
PVector pAccelerometer = new PVector();

//----------------------------------------------------------------


void setup() {
  // Debug
  println();
  println();
  println(" --- BEGININNG OF SETUP --- ");
  println();
  
  // Screen
  size(displayWidth, displayHeight);
  sw = displayWidth; 
  sh = displayHeight;
  sw1 = sw / 10; // 80
  sw2 = sw / 20; // 40
  sw3 = sw / 40; // 20
  text_size = sw / 40;
  
  // Set this so the sketch won't reset as the phone is rotated:
  orientation(LANDSCAPE);
  
  // Paint it Black, yo
  background(0);
  
  // Image
  logo = loadImage("logo.png");
  
  // Buffer
  //pg = (PGraphicsAndroid2D) createGraphics(displayWidth, displayHeight, P2D);
  
  // Setup Fonts:
  fontList = PFont.list();
  androidFont = createFont(fontList[0], text_size, true);
  textFont(androidFont);
  
  // TextField & Buttons
  widgetContainer = new APWidgetContainer(this);
  
  tF_IP = new APEditText( (int) sw2 + (int) sw1,     (int) sw2, (int) sw1 * 2, (int) sw1);
  Apply = new APButton(   (int) sw2 + (int) sw1 * 3, (int) sw2, (int) sw1 * 2, (int) sw1, "APPLY"); 
  Clear = new APButton(   (int) sw2 + (int) sw1 * 5, (int) sw2, (int) sw1 * 2, (int) sw1, "CLEAR");
  Save  = new APButton(   (int) sw2 + (int) sw1 * 7, (int) sw2, (int) sw1 * 2, (int) sw1, "SAVE");
  
  widgetContainer.addWidget(tF_IP);
  widgetContainer.addWidget(Apply); 
  widgetContainer.addWidget(Clear);
  widgetContainer.addWidget(Save); 
  widgetContainer.hide();

  // Create Directory
  try{
    dirName = "//sdcard//bombIR";
    File newFile = new File(dirName);
    newFile.mkdirs();
    println();
    if(newFile.exists()) {
      if(newFile.isDirectory()) {
        //println("isDirectory = true...");
      } else {
        //println("isDirectory = false...");
      }
    } else {
      //println("Directory Doesn't Exist...");
    }
  }
  catch(Exception e) {
    //e.printStackTrace();
  }
  
  // Read Text File
  try{
    String lines[] = loadStrings("//sdcard//bombIR//settings.txt");
      println("Existing Files...");
      for(int i = 0; i < lines.length; i++) {
        //println(lines[i]);  
      }
    ip = lines[0]; 
  }
  catch(Exception noFile) {
    println("Error Reading File...");
    noFile.printStackTrace(); 
  }
  
  // Accelerometer
  sensor = new KetaiSensor(this); 
  sensor.start(); 
  
  // set OSC
  oscInit();
  
  // Set State
  stateInit();
  
  // Misc
  rectMode(CENTER);
  smooth(0);
  noFill();
  boxX = sw/2;
  boxR = width-sw2;
  boxG = width-sw2;
  boxB = width-sw2;
  
  // Debug
  println();
  println(" --- END OF SETUP --- ");
  println();
  
}

//----------------------------------------------------------------

void draw() {
  
  //int fps = round(frameRate); println("FPS " + fps);

  // INTRO
  if(state == 0) {
    image(logo, 0, 0, sw, sh);
    text("GRL Canada" , sw1 * 2, height - sw1);
    text("GRL Germany", sw1 * 6.5, height - sw1);
    widgetContainer.hide();
  }
  
  // GUI
  else if(state == 1) {
    // Show Text Field
    widgetContainer.show();
    
    // IP
    fill(255);
    text("IP", sw2, (sw1 + sw3)-10);  
    
    background(0);
    strokeWeight(3);
    strokeJoin(ROUND);
    
    // Width
    stroke(255);
    line(sw1+sw2, height-sw1, width-sw2, height-sw1);
    fill(map(boxX, 0, sw, 0, 255));
    rect(boxX, height-sw1, sw3, sw2);
    
    // Red
    stroke(255,0,0);
    line(sw1+sw2, height-(sw1*4), width-sw2, height-(sw1*4));
    fill(r, 0, 0);
    rect(boxR, height-(sw1*4), sw3, sw2);
    
    // Green
    stroke(0,255,0);
    line(sw1+sw2, height-(sw1*3), width-sw2, height-(sw1*3));
    fill(0, g, 0);
    rect(boxG, height-(sw1*3), sw3, sw2);
    
    // Blue
    stroke(0,0,255);
    line(sw1+sw2, height-(sw1*2), width-sw2, height-(sw1*2));
    fill(0, 0, b);
    rect(boxB, height-(sw1*2), sw3, sw2);

    // SWITCH
    strokeWeight(2);
    fill(255);
    stroke(0);
    beginShape(TRIANGLES);
      vertex(50, height);
      vertex(0, height);
      vertex(0, height-50);
    endShape();
    noFill();

  }
  
  // DRAW
  else if(state == 2) {  
    
    // Hide Text Field
    widgetContainer.hide();
    
    // Listen For Shake
    float delta = PVector.angleBetween(accelerometer, pAccelerometer);   
    if (degrees(delta) > 90) {
      shake();
    }
    
    // Store Reference Vector
    pAccelerometer.set(accelerometer);
    
    // Switch State
    strokeWeight(2);
    fill(255);
    stroke(0);
    beginShape(TRIANGLES);
      vertex(50, height);
      vertex(0, height);
      vertex(0, height-50);
    endShape();
    noFill(); 
  }

}

//----------------------------------------------------------------

