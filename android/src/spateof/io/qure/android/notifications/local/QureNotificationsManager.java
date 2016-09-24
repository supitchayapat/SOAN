package spateof.io.qure.android.notifications.local;

import android.content.Context;

import java.util.Map;

import br.com.goncalves.pugnotification.notification.Builder;
import br.com.goncalves.pugnotification.notification.Load;
import br.com.goncalves.pugnotification.notification.PugNotification;

/**
 * Created by issam on 9/18/2016.
 */
public class QureNotificationsManager extends PugNotification {

    private static final String TAG = QureNotificationsManager.class.getSimpleName();
    private Builder builder;
    private Load notification;

    public  Map<String,NotificationIntentsReceiver> IntentsToActions;

    public QureNotificationsManager(Context context) {
        super(context);
    }

//    public Load newNotification() {
//        notification = load();
//        return notification;
//    }

//    public enum  BuilderType {
//        SIMPLE,
//        CUSTOM,
//        WEAR
//    }

//    public Builder builder(@NonNull BuilderType type) {
//        switch (type) {
//            case SIMPLE:
//                builder = notification.simple();
//                break;
//            case CUSTOM:
//                builder = notification.custom();
//                break;
//            case WEAR:
//                builder = notification.wear();
//                break;
//            default:
//                throw new  IllegalArgumentException("Unknown Builder type");
//        }
//        return builder;
//    }
//
//    public void fireNotification() { builder.build()}

}
