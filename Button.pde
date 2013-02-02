
//----------------------------------------------------------------

void onClickWidget(APWidget widget){
  
  if(widget == Apply){ 
    gNotificationManager.notify(1, gNotification);
    oscReInit();
  }
  else if(widget == Clear){ 
    gNotificationManager.notify(1, gNotification);
    osc.send("/clearMSG", new Object[] {new Integer(1)}, computer);
  }
  else if(widget == Save){ 
    gNotificationManager.notify(1, gNotification);
    osc.send("/saveMSG", new Object[] {new Integer(1)}, computer);
  }
  
}

//----------------------------------------------------------------

