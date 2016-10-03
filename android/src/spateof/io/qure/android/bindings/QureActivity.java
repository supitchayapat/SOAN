package spateof.io.qure.android.bindings;

import android.content.Context;
import android.os.Bundle;
import android.os.Debug;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import java.util.Timer;
import java.util.TimerTask;

import spateof.io.qure.android.notifications.local.NotificationService;
import spateof.io.qure.android.notifications.local.QureNotificationsManager;

public class QureActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    private static final String TAG = QureActivity.class.getSimpleName();
    private static Context _context;
    public static NotificationService _notificationService;
    private TimerTask notificationTimerTask;
    private Timer notificationTimer;


    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if(msg.getData().getString("triggerNotification")!= null){
                QureNotificationsManager.with(_context);
                _notificationService.buildNotification();
                QureAppActionsProvider.callAction("AVAILABILITY_COUNTDOWN");
            }
        }
    };

    public void startNotificationProcess(){

        initializeNotifactionTimerTask();

        Thread notificationTimerThread = new Thread(new Runnable() {

            public void run() {
                try {

                    Log.d(TAG,"We start the notification TIMER!!!");
                    notificationTimer= new Timer();
                    notificationTimer.schedule(notificationTimerTask,10000,60000);
                } catch (Throwable t) {
                }
            }
        });

        notificationTimerThread.start();
    }

    public void stopNotificationProcess(){
        if(notificationTimer != null){
            notificationTimerTask.cancel();
            notificationTimer.cancel();
        }
    }
    private void initializeNotifactionTimerTask() {
        notificationTimerTask = new TimerTask() {
            /**
             * The bundle containing the eventual data to send to the handler
             */
            Bundle messageBundle=new Bundle();
            /**
             * The message to be sent to the Handler
             */
            Message myMessage;

            @Override
            public void run() {
                //send message to build the notification
                myMessage=handler.obtainMessage();
                messageBundle.putString("triggerNotification","yes");
                myMessage.setData(messageBundle);
                handler.sendMessage(myMessage);
            }
        };
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
//        Debug.waitForDebugger();
        _context = getApplicationContext();
        super.onCreate(savedInstanceState);
        _notificationService = new NotificationService(_context);
    }
    @Override
    protected void onDestroy() {
        Log.d(TAG,"Activity is going  to be destroyed");
        super.onDestroy();
    }
    @Override
    protected  void onStop(){
        Log.d(TAG,"Activity is stopping");
        super.onStop();
    }

    public static Context appContext() {
        return _context;
    }
}
