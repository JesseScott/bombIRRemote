//----------------------------------------------------------------

void mousePressed() {
  // Switch State
  if(mouseX < 50 && mouseY > height-50) {
    gNotificationManager.notify(1, gNotification);
    switchState();
  }
  
  if(state == 0) {
    state = 1; 
  }
  if(state == 1) {

  }
  else if(state == 2) {
    touched = true; 
    osc.send("/stroke", new Object[] {new Integer(1)}, computer);
  }
}

//----------------------------------------------------------------

void mouseDragged() {
    if(state == 1) {
      
      // Width
      if(mouseY > (height-sw1) -sw2 && mouseY < height) {
        boxX = constrain(mouseX, sw1 + sw2, width - sw2);
        float boxN = boxX / (sw*0.95);
        osc.send("/Width", new Object[] {new Float(boxN)}, computer);
      }
      
      // Red
      else if(mouseY > (height-(sw1*4)) -sw3 && mouseY < (height-(sw1*4)) +sw3) {
        boxR = constrain(mouseX, sw1 + sw2, width - sw2);
        float boxR_ = boxR / (sw*0.95);
        r = boxR_ * 255;
        osc.send("/Red", new Object[] {new Float(boxR_)}, computer);
      }
      
      // Green
      else if(mouseY > (height-(sw1*3)) -sw3 && mouseY < (height-(sw1*3)) +sw3) {
        boxG = constrain(mouseX, sw1 + sw2, width - sw2);
        float boxG_ = boxG / (sw*0.95);
        g = boxG_ * 255;
        osc.send("/Green", new Object[] {new Float(boxG_)}, computer);
      }
      
      // Blue
      else if(mouseY > (height-(sw1*2)) -sw3 && mouseY < (height-(sw1*2)) +sw3) {
        boxB = constrain(mouseX, sw1 + sw2, width - sw2);
        float boxB_ = boxB / (sw*0.95);
        b = boxB_ * 255;
        osc.send("/Blue", new Object[] {new Float(boxB_)}, computer);
      }

    }
    
    if(state == 2) {
      touched = true;  
      
      // Drawing
      fill(r, g, b);
      stroke(r, g, b);
      strokeWeight(30-constrain(dist(pmouseX, pmouseY, mouseX, mouseY), 0, 20));
      line(mouseX-1, mouseY-1, mouseX, mouseY);   

      // Coordinates
      if(touched == true) {
        sendX = mouseX / sw;
        sendY = mouseY / sh;
      }
      
      // Send OSC
      osc.send("/xy", new Object[] {new Float(sendX), new Float(sendY)}, computer);
      osc.send("/stroke", new Object[] {new Integer(2)}, computer);

    }
}

//----------------------------------------------------------------

void mouseReleased() {  
  if(state == 2) {
    touched = false;
    sendX = -1;
    sendY = -1;
    osc.send("/stroke", new Object[] {new Integer(0)}, computer);
    osc.send("/xy", new Object[] {new Float(sendX), new Float(sendY)}, computer);
  } 
}

//----------------------------------------------------------------


