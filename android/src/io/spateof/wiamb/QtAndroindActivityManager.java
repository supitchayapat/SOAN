package io.spateof.wiamb;

import android.app.Activity;
import android.view.KeyEvent;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.bindings.QtApplication;

public class QtAndroindActivityManager extends QtActivity
{
    public void onBackClicked()
    {
        moveTaskToBack (true);
    }
}
