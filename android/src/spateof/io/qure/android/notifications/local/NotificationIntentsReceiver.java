package spateof.io.qure.android.notifications.local;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

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

    protected ArrayList<String> _actions;
    private ArrayList<Intent> _intents = new ArrayList<Intent>();
    private ArrayList<PendingIntent> _pendingIntents = new ArrayList<PendingIntent>();

    public void initNotificationsReception() {
        Log.d("NotificationReceiver", "================initNotificationsReception: "+ _actions.size());
        for (int i = 0; i <_actions.size() ; i++) {
            Intent intent = new Intent (QureActivity.getAppContext(),NotificationIntentsReceiver.class);
            intent.setAction(_actions.get(i));
            _intents.add(intent);
            _pendingIntents.add(PendingIntent.getBroadcast(QureActivity.getAppContext()
                    ,123456,intent,PendingIntent.FLAG_UPDATE_CURRENT));
        }
        Log.d("NotificationReceiver", "===============initNotificationsReception: pendingIntents "+ _pendingIntents.size());
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        String action = intent.getAction();
        Log.d("AmbuPlusNotifReceiver","================="+ action);
        QureAppActionsProvider.callAction(action);
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

    public  class IntentGetterNonBlocker  extends AsyncTask<String, Void, PendingIntent> {


        @Override
        protected PendingIntent doInBackground(String...  action) {
           return  _pendingIntents.get(0);
        }
    }

    public PendingIntent  get_pendingIntent(String action) {
        IntentGetterNonBlocker intentget = new IntentGetterNonBlocker();
        try {
            return  intentget.execute(action).get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void set_pendingIntents(ArrayList<PendingIntent> _pendingIntents) {
        this._pendingIntents = _pendingIntents;
    }

//        _available_intent = new Intent(this.getApplicationContext(),NotificationIntentsReceiver.class);
//        _busy_intent      = new Intent(this.getApplicationContext(),NotificationIntentsReceiver.class);
//        _available_intent.setAction(NotificationIntentsReceiver.AVAILABLE_ACTION);
//        _busy_intent     .setAction(NotificationIntentsReceiver.BUSY_ACTION     );
//        _actionOnePendingIntent = PendingIntent.getBroadcast(this, 123456, _available_intent, PendingIntent.FLAG_UPDATE_CURRENT);
//        _actionTwoPendingIntent = PendingIntent.getBroadcast(this, 123456, _busy_intent     , PendingIntent.FLAG_UPDATE_CURRENT);


//        if (AVAILABLE_ACTION.equals(action)) {
//            Log.d("AmbuPlusNotifReceiver","=================AVAILABLE_ACTION =================");
//        }
//        else  if (BUSY_ACTION.equals(action)) {
//            Log.d("AmbuPlusNotifReceiver","=================BUSY_ACTION=================");
//        }

// Specific to wiamb
//    private Intent _available_intent;
//    private Intent _busy_intent;
//    private PendingIntent _actionOnePendingIntent;
//    private PendingIntent _actionTwoPendingIntent;

// end specific to wiamb

    //    public static final String AVAILABLE_ACTION = "AVAILABLE_ACTION";
//    public static final String BUSY_ACTION = "BUSY_ACTION";

}
