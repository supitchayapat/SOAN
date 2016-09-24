package spateof.io.qure.android.notifications.local;

//import android.app.PendingIntent;
//import android.support.annotation.NonNull;

//import br.com.goncalves.pugnotification.notification.Builder;
import br.com.goncalves.pugnotification.notification.Load;
//import spateof.io.qure.android.bindings.QureActivity;

/**
 * Created by issam on 9/17/2016.
 */
public class QureNotification extends Load {

//    private QureNotification _instance;
//    private QureNotificationsManager _notificationsManager;
//    private Builder _builder;
//    public static NotificationIntentsReceiver NotificationIntentsReceiver = null;
//
//    public QureNotification(){
//        super();
//        _instance = this;
//        _notificationsManager = (QureNotificationsManager) _notificationsManager.with(QureActivity._notificationService);
//        new QureNotification(_notificationsManager.load());
//    }
//
//    QureNotification(QureNotification other){
//        this._instance = other.get_instance();
//    }
//
//    QureNotification(Load load){
//        this.
//    }
//
//    public QureNotification get_instance() {
//        return _instance;
//    }
//
//    public enum  BuilderType {
//        SIMPLE,
//        CUSTOM,
//        WEAR
//    }
//
//    public Builder builder(@NonNull BuilderType type) {
//        switch (type) {
//            case SIMPLE:
//                _builder = this.simple();
//                break;
//            case CUSTOM:
//                _builder = this.custom();
//                break;
//            case WEAR:
//                _builder = this.wear();
//                break;
//            default:
//                throw new  IllegalArgumentException("Unknown Builder type");
//        }
//        return _builder;
//    }
//
//    public void fireNotification() {
//        _builder.build();
//    }
//
//    public Load button(@NonNull int icon, @NonNull String title,@NonNull String registeredAction){
//        PendingIntent pendingIntent  = NotificationIntentsReceiver.get_pendingIntents().get(NotificationIntentsReceiver.get_actions().indexOf(registeredAction));
//        return super.button(icon,title,pendingIntent);
//    }
}
