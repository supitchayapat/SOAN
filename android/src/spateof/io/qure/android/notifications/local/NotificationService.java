package spateof.io.qure.android.notifications.local;

import android.app.AlarmManager;
import android.app.IntentService;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import spateof.io.ambuplus.R;

import java.util.ArrayList;

import spateof.io.qure.android.bindings.QureActivity;

/**
 * An {@link IntentService} subclass for handling asynchronous task requests in
 * a service on a separate handler thread.
 * <p/>
 * TODO: Customize class - update intent actions, extra parameters and static
 * helper methods.
 */
public class NotificationService{

    private static final String TAG = NotificationService.class.getSimpleName();

    //Notification Manager Types
    //TODO : add other types of managers as NotificationManager class
    //TODO : maybe it's better to use android.os.Handler for this purpose
    protected  AlarmManager _alarmManager;
    protected Intent _alarmIntent;
    protected PendingIntent _alarmPendingIntent;
    public static  NotificationIntentsReceiver receiver = new NotificationIntentsReceiver();

    private QureNotificationsManager qureNotificationsManager;

    public NotificationService(Context context) {
        qureNotificationsManager = new QureNotificationsManager(context);
        ArrayList<String> actions = new ArrayList<>();
        actions.add("AVAILABLE_ACTION");
        actions.add("BUSY_ACTION");
        actions.add("AVAILABILITY_COUNTDOWN");
        receiver.set_actions(actions);
    }

    public void     buildNotification(){
        Log.d(TAG, "building notification");
        qureNotificationsManager.load()
                .title("Rappel de mise à jours de disponibilité")
                .identifier(1456789)
                .message("Êtes-vous toujours disponible ?")
                .bigTextStyle("Êtes-vous toujours disponible ?")
                .smallIcon(R.drawable.icon)
                .largeIcon(R.drawable.icon)
                .flags(Notification.DEFAULT_ALL)
                .autoCancel(true)
                .click(QureActivity.class)
                .button(android.R.drawable.presence_online, "Oui", receiver.get_pendingIntents().get(0))
                .button(android.R.drawable.presence_busy  , "Non", receiver.get_pendingIntents().get(1))
                .simple()
                .build();
    }
}
