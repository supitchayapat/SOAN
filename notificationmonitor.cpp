#include "notificationmonitor.h"
#include <QtAndroid>
#include <QDebug>

void NotificationMonitor :: startNotificationProcess(){
    qDebug() << "startNotificationProcess :::";
    QtAndroid::androidActivity().callMethod<void>("startNotificationProcess", "()V");
}

void NotificationMonitor :: stopNotificationProcess(){
    qDebug() << "stopNotificationProcess :::";
    QtAndroid::androidActivity().callMethod<void>("stopNotificationProcess", "()V");

}
