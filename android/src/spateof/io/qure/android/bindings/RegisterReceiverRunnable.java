package spateof.io.qure.android.bindings;

import android.app.Activity;
import android.content.IntentFilter;


/**
 * Created by issam on 9/19/2016.
 */
public class RegisterReceiverRunnable implements Runnable {
    private Activity _activity;

    public RegisterReceiverRunnable(Activity activity) {
        _activity = activity;
    }

    // this method is called on Android Ui Thread
    @Override
    public void run() {
        IntentFilter filter = new IntentFilter();
        filter.addAction("AVAILABLE_ACTION");
        filter.addAction("BUSY_ACTION");
        // this method must be called on Android Ui Thread
        _activity.registerReceiver(QureActivity._notificationService.receiver, filter);
    }
}
