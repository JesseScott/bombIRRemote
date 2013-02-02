
//----------------------------------------------------------------

void oscInit() {
  //println();
  println("Initializing OSC");
  println("IP is " + ip);
  osc = new OscP5(this,port);
  computer = new NetAddress(ip, port);
}

void oscReInit() {
  ip = tF_IP.getText();
  println("IP is " + ip);
  computer = new NetAddress(ip, port);  
}

//----------------------------------------------------------------
