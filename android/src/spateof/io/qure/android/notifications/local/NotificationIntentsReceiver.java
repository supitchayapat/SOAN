package spateof.io.qure.android.notifications.local;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import java.util.ArrayList;

import spateof.io.qure.android.bindings.QureActivity;
import spateof.io.qure.android.bindings.QureAppActionsProvider;

/**
 * Created by issam on 9/12/2016.
 */

/*TODO : we may want to extends LocalBroadcastManager instead
or to create another version that is aimed to be used only for receiving broadcasts
that belong to this process/app
. for now the intent filter declared in the manifest is set with exported:false
for that purpose.
 */

public class NotificationIntentsReceiver extends BroadcastReceiver{

    private static final String TAG = NotificationIntentsReceiver.class.getSimpleName();

    private ArrayList<String> _actions;
    private ArrayList<PendingIntent> _pendingIntents = new ArrayList<PendingIntent>();

    public void initNotificationsReception() {
        for (int i = 0; i <_actions.size() ; i++) {
            Intent intent = new Intent();
            intent.setAction(_actions.get(i));

            if(! _pendingIntents.contains(PendingIntent.getBroadcast(QureActivity.appContext()
                    ,123456,intent,PendingIntent.FLAG_UPDATE_CURRENT)))
            {
               _pendingIntents.add(PendingIntent.getBroadcast(QureActivity.appContext()
                       ,123456,intent,PendingIntent.FLAG_UPDATE_CURRENT));
            }
        }
    }

    @Override
    public void onReceive(Context context, Intent intent) {

        String action = intent.getAction();
        QureAppActionsProvider.callAction(action);
        if(action.equals(QureAppActionsProvider.AVAILABLE_ACTION_NAME) || action.equals(QureAppActionsProvider.BUSY_ACTION_NAME)){
            QureActivity.stopCoundDownNotification();
        }
        QureNotificationsManager.with(context).cancel(1456789);
    }

    public void set_actions(ArrayList<String> actions) {
        this._actions = actions;
        initNotificationsReception();
    }

    public ArrayList<PendingIntent> get_pendingIntents() {
        return _pendingIntents;
    }

}
