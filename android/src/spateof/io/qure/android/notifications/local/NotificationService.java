package spateof.io.qure.android.notifications.local;

import android.app.IntentService;
import android.app.Notification;
import android.content.Context;
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
public class NotificationService{

    private static final String TAG = NotificationService.class.getSimpleName();


    public static  NotificationIntentsReceiver receiver = new NotificationIntentsReceiver();

    private QureNotificationsManager qureNotificationsManager;

    public NotificationService(Context context) {
        qureNotificationsManager = new QureNotificationsManager(context);
        ArrayList<String> actions = new ArrayList<>();
        actions.add(QureAppActionsProvider.AVAILABLE_ACTION_NAME);
        actions.add(QureAppActionsProvider.BUSY_ACTION_NAME);
        actions.add(QureAppActionsProvider.COUNT_DOWN_FINISHED_ACTION_NAME);
        receiver.set_actions(actions);
    }

    public void  buildNotification(){
        Log.d(TAG, "building notification");
        qureNotificationsManager.load()
                .title("Rappel de mise à jours de disponibilité")
                .identifier(1456789)
                .message("Êtes-vous toujours disponible ?")
                .bigTextStyle("Êtes-vous toujours disponible ?")
                .smallIcon(R.drawable.icon)
                .largeIcon(R.drawable.icon)
                .flags(Notification.DEFAULT_ALL)
                .priority(Notification.PRIORITY_MAX)
                .when(1)
                .button(android.R.drawable.presence_online, "Oui", receiver.get_pendingIntents().get(0))
                .button(android.R.drawable.presence_busy  , "Non", receiver.get_pendingIntents().get(1))
                .simple()
                .build();
    }
}
