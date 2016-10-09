package spateof.io.qure.android.bindings;

/**
 * Created by issam on 9/16/2016.
 */
public class QureAppActionsProvider {
    // define the native function
    // these functions are called by the Qt C++ object
    // when it receives a new notification
    private static final String TAG = QureAppActionsProvider.class.getSimpleName();
    public static final String AVAILABLE_ACTION_NAME = "AVAILABLE_ACTION";
    public static final String BUSY_ACTION_NAME = "BUSY_ACTION";
    public static final String COUNT_DOWN_FINISHED_ACTION_NAME = "AVAILABILITY_COUNTDOWN";

    // ATTENTION  : Android studio warn about this method not being registered in JNI, but it's not the case
    // See bug : https://code.google.com/p/android/issues/detail?id=181918
    // workaround is using   @SuppressWarnings("JniMissingFunction")
    @SuppressWarnings("JniMissingFunction")
    public static native void callAction(String action);
}
