package spateof.io.qure.android.bindings;

import android.content.Context;
import android.os.Bundle;
import android.os.Debug;
import android.util.Log;

import spateof.io.qure.android.notifications.local.NotificationService;

public class QureActivity extends org.qtproject.qt5.android.bindings.QtActivity {

    private static final String TAG = QureActivity.class.getSimpleName();
    public static NotificationService _notificationService;

    public QureActivity(){}

    // this method is called by C++ to register the BroadcastReceiver.
    public void registerBroadcastReceiver() {
        // Qt is running on a different thread than Android.
        // In order to register the receiver we need to execute it in the Android UI thread
        _notificationService = new NotificationService();
        _notificationService.loadAndConfigureAlarms(this);
        runOnUiThread(new RegisterReceiverRunnable(this));
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
//        Debug.waitForDebugger();
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        Log.d(TAG,"Activity is going  to be destroyed");
//        if(_notificationService.is_onlyOnMainActivityRunning())
//            _notificationService.cancel(_notificationService._alarmPendingIntent);
        super.onDestroy();
    }

    public static Context getAppContext() {
        return QureActivity.getAppContext();
    }
}