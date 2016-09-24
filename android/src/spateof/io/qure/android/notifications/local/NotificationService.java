package spateof.io.qure.android.notifications.local;

import android.app.AlarmManager;
import android.app.IntentService;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.spateof.ambuplus.R;

import java.util.ArrayList;

import spateof.io.qure.android.bindings.QureActivity;
import spateof.io.qure.android.bindings.QureAppActionsProvider;

/**
 * An {@link IntentService} subclass for handling asynchronous task requests in
 * a service on a separate handler thread.
 * <p/>
 * TODO: Customize class - update intent actions, extra parameters and static
 * helper methods.
 */
public class NotificationService extends IntentService {

    //Notification Manager Types
    //TODO : add other types of managers as NotificationManager class
    //TODO : maybe it's better to use android.os.Handler for this purpose
    protected  AlarmManager _alarmManager;
    protected Intent _alarmIntent;
    protected PendingIntent _alarmPendingIntent;
    public static  NotificationIntentsReceiver receiver = new NotificationIntentsReceiver();
    private ArrayList<PendingIntent> _pendingIntents;

    private QureNotificationsManager qureNotificationsManager = new QureNotificationsManager(this);

    public NotificationService() {
        super("QureNotificationService");
        ArrayList<String> actions = new ArrayList<String>();
        actions.add("AVAILABLE_ACTION");
        actions.add("BUSY_ACTION");
        receiver.set_actions(actions);
        _pendingIntents = receiver.get_pendingIntents();
    }

    public void loadAndConfigureAlarms(Context context) {
        _alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        _alarmIntent = new Intent(context ,this.getClass());
        _alarmPendingIntent = PendingIntent.getService(context, 100, _alarmIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        _alarmManager.setInexactRepeating(AlarmManager.ELAPSED_REALTIME_WAKEUP, 1000, 60000, _alarmPendingIntent);

    }

    @Override
    protected void onHandleIntent(Intent intent) {
        if (intent != null) {
            Log.d("NotificationService","===========onHandelIntent");
            QureNotificationsManager.with(this);
            buildNotification();
        }
    }

    private void buildNotification(){
        qureNotificationsManager.load()
                .title("dispo ?")
                .message("veuillez mettre à jour votre dispo")
                .bigTextStyle("Merci de mettre à jour votre disponibilité")
                .smallIcon(R.drawable.icon)
                .largeIcon(R.drawable.icon)
                .flags(Notification.DEFAULT_ALL)
                .autoCancel(true)
                .click(QureActivity.class)
                .button(R.drawable.pugnotification_ic_launcher, "Disponible", _pendingIntents.get(0))
                .button(R.drawable.pugnotification_ic_launcher, "Indisponible", _pendingIntents.get(1))
                .simple()
                .build();

//        qureNotificationsManager.builder(QureNotificationsManager.BuilderType.SIMPLE);
    }
}
