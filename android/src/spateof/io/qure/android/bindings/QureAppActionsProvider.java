package spateof.io.qure.android.bindings;

/**
 * Created by issam on 9/16/2016.
 */
public class QureAppActionsProvider {
    // define the native function
    // these functions are called by the Qt C++ object
    // when it receives a new notification
    public static native void callAction(String action);
}
