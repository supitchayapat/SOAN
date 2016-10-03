package spateof.io.qure.android.bindings;

import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import org.qtproject.qt5.android.bindings.QtActivity;

import java.util.Timer;
import java.util.TimerTask;

import spateof.io.qure.android.notifications.local.NotificationService;
import spateof.io.qure.android.notifications.local.QureNotificationsManager;

public class QureActivity extends QtActivity {

    private static final String TAG = QureActivity.class.getSimpleName();
    private static Context _context;
    public static NotificationService _notificationService;
    private TimerTask notificationTimerTask;
    private Timer notificationTimer;
    private static Timer _notificationTimeout_Timer;
    private static TimerTask _notificationTimeout_TimerTask;



    @Override
    public void onCreate(Bundle savedInstanceState) {
        _context = getApplicationContext();
        super.onCreate(savedInstanceState);
        _notificationService = new NotificationService(_context);
    }

    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (msg.getData().getString("triggerNotification") != null) {
                QureNotificationsManager.with(_context);
                _notificationService.buildNotification();
                startCountDownNotificationTImer();
            }

            if (msg.getData().getString("shutdownNotificationAfterTimeout") != null) {
                Log.d(TAG, "===========handleMessage: shutdownNotificationAfterTimeout called==================");
                QureAppActionsProvider.callAction("AVAILABILITY_COUNTDOWN");
            }
        }
    };

    public void startNotificationProcess() {

        initializeNotifactionTimerTask();

        Thread notificationTimerThread = new Thread(new Runnable() {

            public void run() {
                try {

                    Log.d(TAG, "We start the notification TIMER!!!");
                    notificationTimer = new Timer();
                    notificationTimer.schedule(notificationTimerTask, 30000, 30000);
                } catch (Throwable t) {
                }
            }
        });

        notificationTimerThread.start();
    }

    private void initializeNotifactionTimerTask() {
        notificationTimerTask = new TimerTask() {
            /**
             * The bundle containing the eventual data to send to the handler
             */
            Bundle messageBundle = new Bundle();
            /**
             * The message to be sent to the Handler
             */
            Message myMessage;

            @Override
            public void run() {
                //send message to build the notification
                myMessage = handler.obtainMessage();
                messageBundle.putString("triggerNotification", "yes");
                myMessage.setData(messageBundle);
                handler.sendMessage(myMessage);
            }
        };
    }

    public void stopNotificationProcess() {
        if (notificationTimer != null) {
            notificationTimerTask.cancel();
            notificationTimer.cancel();
        }
    }

    public void startCountDownNotificationTImer() {

        initNotificationTimeoutTimerTask();

        Thread notificationTimeoutThread = new Thread(new Runnable() {

            public void run() {
                try {

                    Log.d(TAG, "We start the notification TIMEOUT TIMER !!!");
                    _notificationTimeout_Timer = new Timer();
                    _notificationTimeout_Timer.schedule(_notificationTimeout_TimerTask, 15000);
                } catch (Throwable t) {

                }
            }
        });

        notificationTimeoutThread.start();
    }


    private void initNotificationTimeoutTimerTask() {
        _notificationTimeout_TimerTask = new TimerTask() {
            /**
             * The bundle containing the eventual data to send to the handler
             */
            Bundle messageBundle = new Bundle();
            /**
             * The message to be sent to the Handler
             */
            Message myMessage;

            @Override
            public void run() {
                //send message to build the notification
                myMessage = handler.obtainMessage();
                messageBundle.putString("shutdownNotificationAfterTimeout", "yes");
                myMessage.setData(messageBundle);
                handler.sendMessage(myMessage);
            }
        };
    }

    public static void stopCoundDownNotification(){
        if(_notificationTimeout_Timer != null){
            _notificationTimeout_TimerTask.cancel();
            _notificationTimeout_Timer.cancel();
        }

    }

    public static Context appContext() {
        return _context;
    }
}
