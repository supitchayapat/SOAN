package spateof.io.qure.android.notifications.local;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.ArrayList;

import br.com.goncalves.pugnotification.notification.PugNotification;
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
    private ArrayList<Intent> _intents = new ArrayList<Intent>();
    private ArrayList<PendingIntent> _pendingIntents = new ArrayList<PendingIntent>();

    public void initNotificationsReception() {
        Log.d(TAG,  "initNotificationsReception: "+ _actions.size());
        for (int i = 0; i <_actions.size() ; i++) {
            Intent intent = new Intent();
//            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
//                    | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            intent.setAction(_actions.get(i));
            // TODO : here we need to replace the related intent instead of adding it, in case it exists already.
            if(!_intents.contains(intent))
            {
                _intents.add(intent);
            }
            if(! _pendingIntents.contains(PendingIntent.getBroadcast(QureActivity.appContext()
                    ,123456,intent,PendingIntent.FLAG_UPDATE_CURRENT)))
            {
               _pendingIntents.add(PendingIntent.getBroadcast(QureActivity.appContext()
                       ,123456,intent,PendingIntent.FLAG_UPDATE_CURRENT));
            }
        }
        Log.d(TAG, "initNotificationsReception: pendingIntents "+ _pendingIntents.size());
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        String action = intent.getAction();
        Log.d(TAG,"received action :"+ action);
        QureAppActionsProvider.callAction(action);
        QureNotificationsManager.with(context).cancel(1456789);
    }

    public ArrayList<String> get_actions() {
            return _actions;
        }

    public void set_actions(ArrayList<String> actions) {
        this._actions = actions;
        initNotificationsReception();
    }

    public ArrayList<Intent> get_intents() {
        return _intents;
    }

    public void set_intents(ArrayList<Intent> _intents) {
        this._intents = _intents;
    }

    public ArrayList<PendingIntent> get_pendingIntents() {
        return _pendingIntents;
    }

    public void set_pendingIntents(ArrayList<PendingIntent> _pendingIntents) {
        this._pendingIntents = _pendingIntents;
    }

}
