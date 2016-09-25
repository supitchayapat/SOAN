package spateof.io.qure.android.bindings;

import android.app.Activity;
import android.content.IntentFilter;
import android.util.Log;

/**
 * Created by issam on 9/19/2016.
 */
public class RegisterReceiverRunnable implements Runnable {

    private static final String TAG = RegisterReceiverRunnable.class.getSimpleName();
    private Activity _activity;

    public RegisterReceiverRunnable(Activity activity) {
        _activity = activity;
    }

    // this method is called on Android Ui Thread
    @Override
    public void run() {
        // TODO : maybe Filters need to managed in the IntentsReceiver Class ?
        IntentFilter filter = new IntentFilter();
        filter.addAction("AVAILABLE_ACTION");
        filter.addAction("BUSY_ACTION");
        // this method must be called on Android Ui Thread
        // TODO : if we register the _notificationService this way we may not need to have it as static member of the QureActivity ?
        // There is certainly a way to get a reference to the registered receivers in the activity
        Log.d(TAG, "Adding actions filters and registering the Intents receiver in the main Activity");
        _activity.registerReceiver(QureActivity._notificationService.receiver, filter);
    }
}
