package spateof.io.qure.android.bindings;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Debug;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.appindexing.Thing;
import com.google.android.gms.common.api.GoogleApiClient;

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
    private Timer notificationTimeout_Timer;
    private TimerTask notificationTimeout_TimerTask;


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
    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    public void startNotificationProcess() {

        initializeNotifactionTimerTask();

        Thread notificationTimerThread = new Thread(new Runnable() {

            public void run() {
                try {

                    Log.d(TAG, "We start the notification TIMER!!!");
                    notificationTimer = new Timer();
                    notificationTimer.schedule(notificationTimerTask, 10000, 30000);
                } catch (Throwable t) {
                }
            }
        });

        notificationTimerThread.start();
    }

    public void startCountDownNotificationTImer() {

        initNotificationTimeoutTimerTask();

        Thread notificationTimeoutThread = new Thread(new Runnable() {

            public void run() {
                try {

                    Log.d(TAG, "We start the notification TIMEOUT TIMER !!!");
                    notificationTimeout_Timer = new Timer();
                    notificationTimeout_Timer.schedule(notificationTimeout_TimerTask, 5000, 5000);
                } catch (Throwable t) {

                }
            }
        });

        notificationTimeoutThread.start();
    }

    public void stopNotificationProcess() {
        if (notificationTimer != null) {
            notificationTimerTask.cancel();
            notificationTimer.cancel();
        }
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

    private void initNotificationTimeoutTimerTask() {
        notificationTimeout_TimerTask = new TimerTask() {
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


    @Override
    public void onCreate(Bundle savedInstanceState) {
//        Debug.waitForDebugger();
        _context = getApplicationContext();
        super.onCreate(savedInstanceState);
        _notificationService = new NotificationService(_context);
        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG, "Activity is going  to be destroyed");
        super.onDestroy();
    }

    @Override
    protected void onStop() {
        Log.d(TAG, "Activity is stopping");
        super.onStop();// ATTENTION: This was auto-generated to implement the App Indexing API.
// See https://g.co/AppIndexing/AndroidStudio for more information.
        AppIndex.AppIndexApi.end(client, getIndexApiAction());
        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client.disconnect();
    }

    public static Context appContext() {
        return _context;
    }

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    public Action getIndexApiAction() {
        Thing object = new Thing.Builder()
                .setName("Qure Page") // TODO: Define a title for the content shown.
                // TODO: Make sure this auto-generated URL is correct.
                .setUrl(Uri.parse("http://[ENTER-YOUR-URL-HERE]"))
                .build();
        return new Action.Builder(Action.TYPE_VIEW)
                .setObject(object)
                .setActionStatus(Action.STATUS_TYPE_COMPLETED)
                .build();
    }

    @Override
    public void onStart() {
        super.onStart();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client.connect();
        AppIndex.AppIndexApi.start(client, getIndexApiAction());
    }
}
