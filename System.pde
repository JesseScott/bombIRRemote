
//----------------------------------------------------------------

void onResume() {
  super.onResume();
  gNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
  gNotification = new Notification();
  gNotification.vibrate = gVibrate;
  //println("RESUMED! (Sketch Entered...)");
}

public boolean surfaceTouchEvent(MotionEvent event) {
  //gNotificationManager.notify(1, gNotification);
  return super.surfaceTouchEvent(event);
}

void onPause() {
  //println("PAUSED! (Sketch Exited...)");
  super.onPause();
} 

//----------------------------------------------------------------

