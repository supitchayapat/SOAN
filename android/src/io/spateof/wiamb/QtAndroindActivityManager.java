package io.spateof.wiamb;

import android.app.Activity;
import org.qtproject.qt5.android.bindings.QtActivity;

public class QtAndroindActivityManager extends QtActivity
{
    public void onBackClicked()
    {
        moveTaskToBack (true);
    }
}